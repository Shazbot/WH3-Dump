




----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--
--	GENERATED BATTLE
--
--- @set_environment battle
---	@c generated_battle Generated Battle
--- @a gb
--- @desc The generated battle system is designed to allow scripters to create battles of moderate complexity relatively cheaply. The central premise of the generated battle system is that events are directed without needing to refer to the individual units, which would be the case with full battle scripts. Instead, orders are given and conditions are detected at army level (or across the battle as a whole). This limits the complexity of what can be done but allows for a much simpler interface. The generated battle system is used to script most/all quest battles.
--- @desc A <code>generated_battle</code> object is created first with @generated_battle:new, and from that multiple @generated_army objects are created using calls to @generated_battle:get_army, one for each conceptual army on the battlefield. A conceptual army may be an entire army in the conventional sense, or it may be a collection of units within an army grouped together by a common script_name. 
--- @desc Commands are given through the use of messages, built on the @script_messager system. Once created, the <code>generated_battle</code> object and @generated_army objects can be instructed to listen for certain messages, and act in some manner when they are received. Additionally, the <code>generated_battle</code> and @generated_army objects can be instructed to trigger messages when certain conditions are met e.g. when under attack. Using these tools, scripted scenarios of surprising complexity may be constructed relatively easily. 
--- @desc The message listeners a <code>generated_battle</code> object provides can be viewed here: @"generated_battle:Message Listeners", and the messages it can generate can be viewed here: @"generated_battle:Message Generation". The message listeners a @generated_army object provides can be viewed here: @"generated_army:Message Listeners", and the messages it can generate can be viewed here: @"generated_army:Message Generation".

--- @new_example
--- @desc A simple generate battle script that sets up two opposing armies. The army in the second alliance is set to defend a position at the start of the battle and then rout when it takes 50% casualties
--- @example load_script_libraries();
--- @example  
--- @example -- declare generated battle object
--- @example gb = generated_battle:new(
--- @example 	false,						-- screen starts black
--- @example 	true,						-- prevent deployment for player
--- @example 	true,						-- prevent deployment for ai
--- @example 	nil,						-- intro cutscene function
--- @example 	false						-- debug mode
--- @example );
--- @example  
--- @example -- declare generated army objects
--- @example ga_player_01 = gb:get_army(gb:get_player_alliance_num());
--- @example ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num());
--- @example  
--- @example -- ai defends position [-100, 400] when the battle starts
--- @example ga_ai_01:defend_on_message("battle_started", -100, 400, 100);
--- @example  
--- @example -- rout the enemy army over 10s when they take 50% casualties
--- @example ga_ai_01:message_on_casualties("rout_ai_army", 0.5);
--- @example ga_ai_01:rout_over_time_on_message("rout_ai_army", 10000);
--- @example  

--
--- @section Self-Generated Messages
--- @desc The generated battle object and other related objects send the following messages during battle automatically:
--- @desc <ul><li><code><strong>"deployment_started"</strong></code> when the deployment phase begins.</li>
--- @desc <li><code><strong>"battle_started"</strong></code> when the playable combat phase begins.</li>
--- @desc <li><code><strong>"battle_ending"</strong></code> when the VictoryCountdown phase begins (someone has won).</li>
--- @desc <li><code><strong>"cutscene_ended"</strong></code> when any @cutscene ends.</li>
--- @desc <li><code><strong>"generated_custscene_ended"</strong></code> when a generated cutscene ends.</li>
--- @desc <li><code><strong>"outro_camera_finished"</strong></code> when the outro camera movement on a generated cutscene intro has finished.</li></ul>
--
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------



__generated_battle = nil;

__GENERATED_ARMY_IS_PLAYER = 0;
__GENERATED_ARMY_IS_ALLY_OF_PLAYER = 1;
__GENERATED_ARMY_IS_ENEMY_OF_PLAYER = 2;


generated_battle = {
	sm = nil,
	generated_armies = {},
	screen_starts_black = false,
	prevent_deployment_for_player = false,
	prevent_deployment_for_ai = false,
	intro_cutscene = nil,
	cutscene_during_deployment = false,
	is_debug = false,
	battle_has_started = false,
	stop_battle_end = false,
	player_alliance_id = false,
	non_player_alliance_id = false,
	current_objectives = {}
};


set_class_custom_type_and_tostring(generated_battle, TYPE_GENERATED_BATTLE);










----------------------------------------------------------------------------
---	@section Creation
----------------------------------------------------------------------------


--- @function new
--- @desc Creates a generated_battle. There should be only one of these per-battle script.
--- @p [opt=false] @boolean screen starts black, The screen starts black. This should match the prepare_for_fade_in flag in the battle setup, which always seems to be true for quest battles. Furthermore, this flag is only considered if no intro cutscene callback is specified.
--- @p [opt=false] @boolean prevent player deployment, Prevents player control during deployment.
--- @p [opt=false] @boolean prevent ai deployment, Prevents deployment for the ai.
--- @p [opt=nil] @function intro cutscene, Intro cutscene callback. This is called when deployment phase ends, unless @generated_battle:set_cutscene_during_deployment is set.
--- @p [opt=false] @boolean debug mode, Turns on debug mode, for more output.
--- @r @generated_battle generated battle
function generated_battle:new(screen_starts_black, prevent_deployment_for_player, prevent_deployment_for_ai, intro_cutscene, is_debug)
	screen_starts_black = screen_starts_black or false;
	prevent_deployment_for_player = prevent_deployment_for_player or false;
	is_debug = is_debug or false;
	
	if not is_nil(intro_cutscene) and not is_function(intro_cutscene) then
		script_error("ERROR: attempt made to create a generated_battle() but the supplied intro cutscene callback is not a function or nil");
		return;
	end;
		
	local gb = {};
	
	set_object_class(gb, self);
	
	local sm = get_messager();

	gb.sm = sm;
	gb.screen_starts_black = screen_starts_black;
	gb.prevent_deployment_for_player = prevent_deployment_for_player;
	gb.prevent_deployment_for_ai = prevent_deployment_for_ai;
	gb.intro_cutscene = intro_cutscene;
	gb.cutscene_during_deployment = false;
	gb.is_debug = is_debug;
	
	bm:out("==============================");
	bm:out("==============================");
	bm:out("== generated_battle created ==");
	bm:out("==============================");
	bm:out("==============================");
	
	-- build all our generated_army objects
	gb:build_armies();
	
	-- make a list of all currently-running objective keys
	gb.current_objectives = {};
	
	-- report on loaded armies
	gb:generated_armies_report();
	
	bm:out("==============================");
	
	-- deployment message
	bm:register_phase_change_callback(
		"Deployment", 
		function() 
			gb:start_deployment();
		end
	);
	
	-- force the screen to be black if the flag is set and we don't have an intro cutscene
	if screen_starts_black and not intro_cutscene then
		bm:camera():fade(true, 0);
	end;
	
	-- ending deployment
	if prevent_deployment_for_player then
		bm:setup_battle(function() gb:start_battle() end);	
	else
		bm:register_phase_change_callback("Deployed", function() gb:start_battle() end);
	end;

	return gb;
end;


-- for internal use
function generated_battle:should_not_deploy_ai()
	return self.prevent_deployment_for_ai;
end;


-- prints a report to the console about loaded armies. For internal use.
function generated_battle:generated_armies_report()
	local generated_armies = self.generated_armies;

	bm:out("Armies report:");
	for i = 1, #generated_armies do
		local current_alliance = generated_armies[i];
		
		bm:out("\tAlliance " .. i .. " of " .. #self.generated_armies);
		
		for j = 1, #current_alliance do
			local current_armies = current_alliance[j];
			
			bm:out("\t\tArmy " .. j .. " of " .. #current_alliance);
			
			for k = 1, #current_armies do
				local current_army = current_armies[k];			
				local total_units = current_army.sunits:count();
				local army_id = current_army.id;
				local army_script_name = current_army.script_name;
				local append_str = "";
				
				if army_script_name ~= "" then
					append_str = ", script name is " .. tostring(army_script_name);
				end;
				
				if total_units == 1 then
					bm:out("\t\t\t" .. army_id .. " contains 1 unit" .. append_str);
				else
					bm:out("\t\t\t" .. army_id .. " contains " .. total_units .. " units" .. append_str);
				end;
				
				for m = 1, current_army.sunits:count() do
					local current_sunit = current_army.sunits:item(m);
					bm:out("\t\t\t\t" .. m .. ": [" .. current_sunit.unit:unique_ui_id() .. "] " .. current_sunit.unit:type() .. " at position " .. v_to_s(current_sunit.unit:position()));
				end;
				
			end;
		end;
	end;
end;


-- build the collection of generated armies for this battle
function generated_battle:build_armies()
	self.generated_armies = {};

	local alliances = bm:alliances();
	
	for i = 1, alliances:count() do
		local armies = alliances:item(i):armies();
		
		self.generated_armies[i] = {};
		
		if self.is_debug then
			bm:out("\tadding alliance " .. tostring(i) .. ":");
		end;
				
		for j = 1, armies:count() do
			local current_army = armies:item(j);

			-- if this army is player-controlled then make a note of the alliance id so we can find it later
			if not self.player_alliance_id and current_army:is_player_controlled() then
				
				if i == 1 then
					self.player_alliance_id = 1;
					self.non_player_alliance_id = 2;
				else
					self.player_alliance_id = 2;
					self.non_player_alliance_id = 1;
				end;
			end;
			
			self.generated_armies[i][j] = {};
			
			-- this table will contain a list of generated_armies that we have to create for the current logical army
			local generated_armies_to_create = {};
			
			-- count the number of units that we have
			local num_units = current_army:units():count();
			
			-- include reinforcing armies
			for k = 1, current_army:num_reinforcement_units() do
				local r_units = current_army:get_reinforcement_units(k);
				
				if is_units(r_units) then
					num_units = num_units + r_units:count();
				end;
			end;
			
			-- inspect the names of all the units in the army to determine how many different ga's we need to create
			for k = 1, num_units do
				local new_sunit = script_unit:new_by_reference(current_army, k);
				
				if not is_scriptunit(new_sunit) then
					script_error("ERROR: generated_battle:build_armies() failed to create unit " .. k .. " in army " .. j .. ", alliance " .. i);
					return false;
				else
					-- we are currently using the scriptunit name to determine the army script name - this might change in future
					local army_script_name = new_sunit.unit:name();
					
					-- if the name is just a number then no custom name was actually set, so we reset it to ""
					if tonumber(army_script_name) then
						army_script_name = "";
					end;
					
					-- attempt to add this scriptunit to the army that matches its name
					local sunit_added = false;
					for l = 1, #generated_armies_to_create do
						if generated_armies_to_create[l].script_name == army_script_name then				
							generated_armies_to_create[l].sunits:add_sunits(new_sunit);
							sunit_added = true;
							break;
						end;
					end;
					
					-- if the sunit was not added anywhere, then create a new army record and add this sunit
					if not sunit_added then
						ga_record = {};
						ga_record.script_name = army_script_name;
						ga_record.sunits = script_units:new(army_script_name);
						ga_record.sunits:add_sunits(new_sunit);
						table.insert(generated_armies_to_create, ga_record);
					end;
				end;
			end;
			
			-- go through our list and build generated_army objects out of all the records we find
			for k = 1, #generated_armies_to_create do
				local current_army_rec = generated_armies_to_create[k];
			
				local ga = generated_army:new(current_army_rec.script_name, k, current_army_rec.sunits, self, self.is_debug);
				
				if self.is_debug then
					if current_army_rec.script_name == "" then
						bm:out("\t\tadding army " .. tostring(j) .. " containing " .. tostring(ga.sunits:count()) .. " units");
					else
						bm:out("\t\tadding army " .. tostring(j) .. " containing " .. tostring(ga.sunits:count()) .. " units with name " .. current_army_rec.script_name);
					end;			
				end;
				
				table.insert(self.generated_armies[i][j], ga);
			end;
		end;	
	end;
	
	bm:out(" ");
end;


-- called internally when deployment starts
function generated_battle:start_deployment()
	bm:out("Starting deployment.");
	self.sm:trigger_message("deployment_started");
	
	
	if self.intro_cutscene then
		if self.cutscene_during_deployment then
			-- we have a cutscene and we should show it during deployment - hide the "Start Battle" button, show the cutscene, and then re-enable the button when the cutscene is completed
		
			-- toggle the start battle UI during the cutscene
			local uic_deployment = bm:ui_component("finish_deployment");
			
			--bm:out("Disabling finish_deployment UI for Cutscene.");
			uic_deployment:SetVisible(false);
			self.sm:add_listener(
				"cutscene_ended",
				function()
					--bm:out("Re-enabling finish_deployment UI.");
					uic_deployment:SetVisible(true);
				end
			);
				
			self.intro_cutscene();
			return;
		end;
	else
		-- if we have no intro cutscene and the player should be able to deploy then enable the ui
		if not self.prevent_deployment_for_player then
			bm:enable_cinematic_ui(false, true, false);
	
			-- also fade in the camera if the screen starts black
			if self.screen_starts_black then
				bm:camera():fade(false, 0.5);
			end;
		end;
	end;
end;


-- called internally when the playable battle starts
function generated_battle:start_battle()
	self.battle_has_started = true;

	bm:out("Starting generated battle");
	self.sm:trigger_message("battle_started");
	
	bm:setup_victory_callback(function() self:battle_ending() end);
		
	if self.cutscene_during_deployment and self.intro_cutscene then
		return;
	end;
	
	if self.intro_cutscene then
		self.intro_cutscene();
	elseif self.prevent_deployment_for_player then
		-- enable the ui at this time if there was no intro cutscene and the player was not able to deploy
		bm:enable_cinematic_ui(false, true, false);
		
		-- fade the camera in if it was faded
		if self.screen_starts_black then
			bm:camera():fade(false, 0.5);
		end;
	end;
end;











----------------------------------------------------------------------------
---	@section Configuration
----------------------------------------------------------------------------


--- @function set_cutscene_during_deployment
--- @desc Sets the supplied intro cutscene callback specified in @generated_battle:new to play at the start of deployment, rather than at the end.
--- @p [opt=true] @boolean play in deployment
function generated_battle:set_cutscene_during_deployment(value)
	if value == false then
		self.cutscene_during_deployment = false;
	else
		self.cutscene_during_deployment = true;
	end;
end;

--- @function stop_end_battle
--- @desc Stops @battle_manager:end_battle() from being called at the end of the battle. Use this if you want to stop the battle from leaving the VictoryCoundown phase.
--- @p [opt=true] @boolean stop battle end
function generated_battle:stop_end_battle(value)
	if value == false then
		self.stop_battle_end = false;
	else
		self.stop_battle_end = true;
	end;
end;








----------------------------------------------------------------------------
---	@section Querying
----------------------------------------------------------------------------


--- @function has_battle_started
--- @desc Returns <code>true</code> if the combat phase of the battle has started, <code>false</code> otherwise.
--- @r @boolean battle has started
function generated_battle:has_battle_started()
	return self.battle_has_started;
end;


--- @function get_player_alliance_num
--- @desc Returns the index of the alliance the player is a part of.
--- @r @number index
function generated_battle:get_player_alliance_num()
	return self.player_alliance_id;
end


--- @function get_non_player_alliance_num
--- @desc Returns the index of the enemy alliance to the player.
--- @r @number index
function generated_battle:get_non_player_alliance_num()
	return self.non_player_alliance_id;
end







----------------------------------------------------------------------------
---	@section Fetching Generated Armies
--- @desc When the generated battle object is created with @generated_battle:new it automatically creates all @generated_army objects internally. The @generated_battle:get_player_army and @generated_battle:get_army functions can be called by client scripts to get handles to to fetch @generated_army objects.
----------------------------------------------------------------------------


--- @function get_player_army
--- @desc Returns the player-controlled @generated_army with the supplied script name.
--- @p [opt=""] @string script name
--- @r generated_army generated army
function generated_battle:get_player_army(script_name)
	return self:get_army(self.player_alliance_id, script_name);
end;


--- @function get_army
--- @desc Returns a @generated_army corresponding to the supplied arguments. Use in one of two modes:
--- @desc &emsp;- Supply an alliance number, an army number, and (optionally) a script name. This is the original way armies were specified in quest battle scripts. Returns a @generated_army corresponding to the supplied alliance/army numbers, containing all units where the name matches the supplied script name (or all of them if one was not supplied). WARNING: at time of writing the ordering of armies in an alliance beyond the first cannot be guaranteed if loading from campaign, so specifying an army index in this case may not be a good idea.
--- @desc &emsp;- Supply an alliance number and a script name. This supports the randomised ordering of armies in an alliance that we see from campaign.
--- @p @number alliance index
--- @p [opt=""] @string script name
--- @r generated_army generated army
function generated_battle:get_army(alliance_index, second_param, third_param)

	if not is_number(alliance_index) then
		script_error("ERROR: get_army() called but supplied alliance index [" .. tostring(alliance_index) .. "] is not a number");
		return false;
	end;
	
	-- if no second_param or third_param has been passed in, then set second_param to be a blank string
	if not second_param and not third_param then
		second_param = "";
	end;
	
	if is_number(second_param) then
		-- the user is specifying an alliance number, an army number, and (optionally) a script name
		return self:get_army_by_alliance_army_and_script_name(alliance_index, second_param, third_param);
	
	elseif is_string(second_param) then
		-- the user is specifying an alliance number and a script name

		-- try and determine the army_index ourselves, by looking through all armies in this alliance for an army with a matching script name
		-- if more than one army has a matching script name, throw an error
		local alliance = self.generated_armies[alliance_index];
		local army_index = false;
		
		for i = 1, #alliance do
			local current_army = alliance[i];
			
			for j = 1, #current_army do
				local current_sub_army = current_army[j];
				
				if current_sub_army.script_name == second_param then
					if army_index then
						script_error("ERROR: get_army() called but more than one army in specified alliance index [" .. alliance_index .. "] was found with the supplied name [" .. second_param .. "]");
						return false;
					else
						army_index = i;
					end;
				end;
			end;
		end;
		
		if not army_index then
			script_error("ERROR: get_army() called but no army in supplied alliance index [" .. alliance_index .. "] was found with the supplied name [" .. second_param .. "]");
			return false;
		end;
		
		return self:get_army_by_alliance_army_and_script_name(alliance_index, army_index, second_param);
		
	else
		script_error("ERROR: get_army() called but supplied second parameter [" .. second_param .. "] was not an integer army index or a string script name");
	end;	
end;


-- internal function to return a generated army when it has been specified by alliance number, army number, and (opt) a script name
function generated_battle:get_army_by_alliance_army_and_script_name(alliance_index, army_index, army_script_name)
	
	local armies = self.generated_armies[alliance_index][army_index];
	
	if not is_table(armies) then
		script_error("ERROR: get_army_by_alliance_army_and_script_name() called but no army was found with alliance index [" .. alliance_index .. "] and army index [" .. army_index .. "], check your battle definition");
		return false;
	end;
	
	army_script_name = army_script_name or "";
	
	if army_script_name == "" and #armies >= 1 then
		return armies[1];	
	end;
	
	for i = 1, #armies do
		local current_army = armies[i];
		
		if current_army.script_name == army_script_name then
			return current_army;
		end;
	end;
	
	if army_script_name == "" then
		script_error("ERROR: get_army() called but couldn't find a generated_army with no name matching supplied army number [" .. tostring(army_index) .. "], though the alliance was valid");
	else
		script_error("ERROR: get_army() called but couldn't find a generated_army with script name [" .. army_script_name .. "] matching supplied army number [" .. tostring(army_index) .. "], though the alliance was valid");
	end;
end;


--
--	Takes an alliance and army number, and returns a table of all sunits that are allied to this army.
--	Used internally by generated_army objects to build a list of all their allies.
function generated_battle:get_allied_force(alliance_num, army_num)
	local sunits_table = {};

	for i = 1, #self.generated_armies do
		if i == alliance_num then
			for j = 1, #self.generated_armies[i] do
				if j ~= army_num then
					for k = 1, #self.generated_armies[i][j] do
					
						-- add this force to the sunits_table force
						local generated_army_sunits = self.generated_armies[i][j][k].sunits;
						
						for l = 1, generated_army_sunits:count() do
							table.insert(sunits_table, generated_army_sunits:item(l));
						end;
					end;
				end;
			end;
		end;
	end;
	
	local sunits_allied = script_units:new("allied_sunits", sunits_table);
	return sunits_allied;
end;


--
--	Takes an alliance and army number, and returns a table of all sunits that are the enemy of this army.
--	Used internally by generated_army objects to build a list of all their enemies.
function generated_battle:get_enemy_force(alliance_num, army_num)
	local sunits_table = {};

	for i = 1, #self.generated_armies do
		if i ~= alliance_num then
			for j = 1, #self.generated_armies[i] do
				for k = 1, #self.generated_armies[i][j] do
					-- add this force to the sunits_table force
					local generated_army_sunits = self.generated_armies[i][j][k].sunits;
					
					for l = 1, generated_army_sunits:count() do					
						table.insert(sunits_table, generated_army_sunits:item(l));
					end;
				end;
			end;
		end;
	end;
	
	local sunits_enemy = script_units:new("enemy_sunits", sunits_table);
	return sunits_enemy;
end;








----------------------------------------------------------------------------
---	@section Script Message Listeners
----------------------------------------------------------------------------


---	@function add_listener
---	@desc Allows the generated_battle object to listen for a message and trigger an arbitrary callback. The call gets passed to the underlying @script_messager - see @script_messager:add_listener.
--- @p @string message name
--- @p @function callback to call
--- @p [opt=false] @boolean persistent
function generated_battle:add_listener(...)
	return self.sm:add_listener(...);
end;


--- @function remove_listener
--- @desc Removes any listener listening for a particular message. This call gets passed through to @script_messager:remove_listener_by_message.
--- @p @string message name
function generated_battle:remove_listener(message)
	return self.sm:remove_listener_by_message(message);
end;








----------------------------------------------------------------------------
---	@section Message Listeners
----------------------------------------------------------------------------


---	@function advice_on_message
---	@desc Takes a string message, a string advice key, and an optional time offset in ms. Instruct the generated_battle to play a piece of advice on receipt of a message, with the optional time offset so that it doesn't happen robotically at the same moment as the message.
--- @p @string message
--- @p @string advice key
--- @p [opt=0] @number wait offset in ms
function generated_battle:advice_on_message(message, advice_key, wait_offset)
	if not is_string(advice_key) then
		script_error("generated_battle ERROR: advice_on_message() called but supplied advice key [" .. tostring(advice_key) .. "] is not a string");
		return false;
	end;

	if not is_string(message) then
		script_error("generated_battle ERROR: advice_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	if is_nil(wait_offset) then
		wait_offset = 0;
	elseif not is_number(wait_offset) or wait_offset < 0 then
		script_error("generated_battle ERROR: advice_on_message() called but supplied wait_offset [" .. tostring(wait_offset) .. "] is not a positive number");
		return false;
	end;
	
	self.sm:add_listener(
		message,
		function()
			bm:callback(
				function()
					bm:out("generated_battle:advice_on_message() now queueing advice " .. advice_key);
					bm:queue_advisor(advice_key);
				end,
				wait_offset
			);
		end
	);
end;


---	@function play_sound_on_message
---	@desc Instruct the generated_battle to play a sound on receipt of a message.
--- @p @string message, Play the sound on receipt of this message.
--- @p @battle_sound_effect sound, Sound file to play.
--- @p [opt=nil] @battle_vector position, Position at which to play the sound. Supply <code>nil</code> to play the sound at the camera.
--- @p [opt=0] @number wait offset, Delay between receipt of the message and the supplied sound starting to play, in ms.
--- @p [opt=nil] @string end message, Message to send when the sound has finished playing.
--- @p [opt=500] @number minimum duration, Minimum duration of the sound in ms. This is only used if an end message is supplied, and is handy during development for when the sound has not been recorded.
function generated_battle:play_sound_on_message(message, sound, position, wait_offset, message_on_finished, minimum_sound_duration)

	position = position or v(0, 0);
	wait_offset = wait_offset or 0;
	message_on_finished = message_on_finished or nil;
	minimum_sound_duration = minimum_sound_duration or 500;
	
	if not is_string(message) then
		script_error("generated_battle ERROR: play_sound_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	if not is_nil(message_on_finished) and not is_string(message_on_finished) then
		script_error("generated_battle ERROR: play_sound_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	if not is_number(wait_offset) or wait_offset < 0 then
		script_error("generated_battle ERROR: play_sound_on_message() called but supplied wait_offset [" .. tostring(wait_offset) .. "] is not a positive number");
		return false;
	end;
	
	if not is_battlesoundeffect(sound) then
		script_error("generated_battle ERROR: play_sound_on_message() called but supplied object [" .. tostring(sound) .. "] is not a battle_sound_effect");
		return false;
	end;

	self.sm:add_listener(
		message,
		function()
			bm:callback(
				function()
				
					bm:out("generated_battle:play_sound_on_message() now playing sound " .. tostring(sound));
					play_sound(position, sound);
					
					if not is_nil(message_on_finished) then
						-- Running through a callback so we can delay the test. If we test straight away is_playing() will always return false.
						bm:callback(
							-- Return when the sound is no longer playing. This covers for the case where a null sound has been passed in so we don't have any watches hanging around.
							function()
								bm:out("generated_battle:play_sound_on_message() Sound " .. tostring(sound) .. " is playing: " .. tostring(sound:is_playing()));
								bm:watch(
									function()
										return not sound:is_playing();
									end,
									0,
									function()
										bm:out("generated_battle:play_sound_on_message() Sound " .. tostring(sound) .. " finished. Firing message " .. message_on_finished);
										self.sm:trigger_message(message_on_finished);
									end
								);
							end,
							minimum_sound_duration
						);
					end;
					
				end,
				wait_offset
			);
		end
	);
end;


---	@function stop_sound_on_message
---	@desc Instructs the generated_battle to stop a sound on receipt of a message.
--- @p @string message, Stop the sound on receipt of this message.
--- @p @battle_sound_effect sound, Sound file to stop.
--- @p [opt=0] @number wait offset, Delay between receipt of the message and the supplied sound being stopped, in ms.
function generated_battle:stop_sound_on_message(message, sound, wait_offset)
	wait_offset = wait_offset or 0;
	
	if not is_string(message) then
		script_error("generated_battle ERROR: stop_sound_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	if not is_number(wait_offset) or wait_offset < 0 then
		script_error("generated_battle ERROR: stop_sound_on_message() called but supplied wait_offset [" .. tostring(wait_offset) .. "] is not a positive number");
		return false;
	end;
	
	if not is_battlesoundeffect(sound) then
		script_error("generated_battle ERROR: stop_sound_on_message() called but supplied object [" .. tostring(sound) .. "] is not a battle_sound_effect");
		return false;
	end;
	
	self.sm:add_listener(
		message,
		function()
			bm:callback(
				function()
					bm:out("generated_battle:stop_sound_on_message() now stopping sound " .. tostring(sound));
					stop_sound(sound);
				end,
				wait_offset
			);
		end
	);
end;


---	@function start_terrain_composite_scene_on_message
---	@desc Instructs the generated_battle to start a terrain composite scene on receipt of a message. Terrain composite scenes are general-purpose scene containers, capable of playing animations, sounds, vfx and more.
--- @p @string message, Play the composite scene on receipt of this message.
--- @p @string scene key, Composite scene key.
--- @p [opt=0] @number wait offset, Delay between receipt of the message and the scene being started, in ms.
--- @p [opt=false] @string group name, Composite scene group name. If supplied, this prevents this composite scene being played at the same time as any other in the same group. See documentation for the underlying @battle_manager:start_terrain_composite_scene function for more information.
--- @p [opt=false] @number delay if queued, Delay before playing in ms if queued. This only applies if a group name is set. See @battle_manager:start_terrain_composite_scene for more information.
function generated_battle:start_terrain_composite_scene_on_message(message, comp_scene_key, wait_offset, group_name, delay_if_queued)

	if not is_string(message) then
		script_error("generated_battle ERROR: start_terrain_composite_scene_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	if not is_string(comp_scene_key) then
		script_error("generated_battle ERROR: start_terrain_composite_scene_on_message() called but supplied composite scene key [" .. tostring(comp_scene_key) .. "] is not a string");
		return false;
	end;
	
	if is_nil(wait_offset) then
		wait_offset = 0;
	elseif not is_number(wait_offset) or wait_offset < 0 then
		script_error("generated_battle ERROR: start_terrain_composite_scene_on_message() called but supplied wait offset [" .. tostring(wait_offset) .. "] is not a positive number");
		return false;
	end;
	
	if group_name and not is_string(group_name) then
		script_error("generated_battle ERROR: start_terrain_composite_scene_on_message() called but supplied group name [" .. tostring(group_name) .. "] is not a string or nil");
		return false;
	end;
	
	if delay_if_queued and not is_number(delay_if_queued) then
		script_error("generated_battle ERROR: start_terrain_composite_scene_on_message() called but supplied delay-if-queued [" .. tostring(delay_if_queued) .. "] is not a number or nil");
		return false;
	end;
	
	self.sm:add_listener(
		message,
		function()
			local wait_offset_str = "";
			if wait_offset > 0 then
				wait_offset_str = " after waiting " .. wait_offset .. "ms";
			end;
			bm:callback(
				function()
					if group_name then
						bm:out("generated_battle:start_terrain_composite_scene_on_message() is responding to message " .. message .. " and is now enqueuing composite scene with key " .. comp_scene_key .. " from group " .. tostring(group_name) .. wait_offset_str);
					else
						bm:out("generated_battle:start_terrain_composite_scene_on_message() is responding to message " .. message .. " and is now playing composite scene with key " .. comp_scene_key .. wait_offset_str);
					end;
					bm:start_terrain_composite_scene(comp_scene_key, group_name, delay_if_queued);
				end,
				wait_offset
			);
		end
	);
end;


---	@function stop_terrain_composite_scene_on_message
---	@desc Instructs the generated_battle to stop a terrain composite scene on receipt of a message.
--- @p @string message, Stop the composite scene on receipt of this message.
--- @p @string scene key, Composite scene key.
--- @p [opt=0] @number wait offset, Delay between receipt of the message and the scene being stopped, in ms.
function generated_battle:stop_terrain_composite_scene_on_message(message, comp_scene_key, wait_offset)

	if not is_string(comp_scene_key) then
		script_error("generated_battle ERROR: stop_terrain_composite_scene_on_message() called but supplied composite scene key [" .. tostring(comp_scene_key) .. "] is not a string");
		return false;
	end;

	if not is_string(message) then
		script_error("generated_battle ERROR: stop_terrain_composite_scene_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	if is_nil(wait_offset) then
		wait_offset = 0;
	elseif not is_number(wait_offset) or wait_offset < 0 then
		script_error("generated_battle ERROR: stop_terrain_composite_scene_on_message() called but supplied wait_offset [" .. tostring(wait_offset) .. "] is not a positive number");
		return false;
	end;
	
	self.sm:add_listener(
		message,
		function()
			local wait_offset_str = "";
			if wait_offset > 0 then
				wait_offset_str = " after waiting " .. wait_offset .. "ms";
			end;
			bm:callback(
				function()
					bm:out("generated_battle:stop_terrain_composite_scene_on_message() is responding to message " .. message .. " and is now stopping composite scene with key " .. comp_scene_key .. wait_offset_str);
					bm:stop_terrain_composite_scene(comp_scene_key)
				end,
				wait_offset
			);
		end
	);
end;


---	@function set_objective_on_message
---	@desc Instructs the generated_battle to add a scripted obective to the objectives panel, or update an existing scripted objective, on receipt of a message. The scripted objective is automatically completed or failed when the battle ends, based on the winner of the battle.
--- @p @string message, Add/update the objective on receipt of this message.
--- @p @string objective key, Objective key to add or update.
--- @p [opt=0] @number wait offset, Delay between receipt of the message and the objective being added/updated, in ms.
--- @p [opt=nil] @number objective param a, First numeric objective parameter, if required. See documentation for @objectives_manager:set_objective.
--- @p [opt=nil] @number objective param b, Second numeric objective parameter, if required. See documentation for @objectives_manager:set_objective.
function generated_battle:set_objective_on_message(message, objective_key, wait_offset, param1, param2)

	wait_offset = wait_offset or 0;
	
	if not is_number(wait_offset) or wait_offset < 0 then
		script_error("generated_battle ERROR: set_objective_on_message() called but supplied wait_offset [" .. tostring(wait_offset) .. "] is not a positive number or nil");
		return false;
	end;

	if not is_string(message) then
		script_error("generated_battle ERROR: set_objective_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	if not is_string(objective_key) then
		script_error("generated_battle ERROR: set_objective_on_message() called but supplied objective key [" .. tostring(objective_key) .. "] is not a string");
		return false;
	end;
	
	self.sm:add_listener(
		message,
		function()
			bm:callback(
				function()					
					bm:out("generated_battle:set_objective_on_message() now adding objective " .. objective_key);
					bm:set_objective(objective_key, param1, param2);
					self.current_objectives[objective_key] = true;
					-- bm:callback(function() self:pulse_objective(objective_key) end, 200);
				end,
				wait_offset
			);
		end
	);
end;


---	@function set_objective_with_leader_on_message
---	@desc Instructs the generated_battle to add a scripted obective to the objectives panel with a @topic_leader, or to update an existing scripted objective, on receipt of a message. The scripted objective is automatically completed or failed when the battle ends, based on the winner of the battle.
--- @p @string message, Add/update the objective on receipt of this message.
--- @p @string objective key, Objective key to add or update.
--- @p [opt=0] @number wait offset, Delay between receipt of the message and the objective being added/updated, in ms.
--- @p [opt=nil] @number objective param a, First numeric objective parameter, if required. See documentation for @objectives_manager:set_objective.
--- @p [opt=nil] @number objective param b, Second numeric objective parameter, if required. See documentation for @objectives_manager:set_objective.
function generated_battle:set_objective_with_leader_on_message(message, objective_key, wait_offset, param1, param2)

	wait_offset = wait_offset or 0;
	
	if not is_number(wait_offset) or wait_offset < 0 then
		script_error("generated_battle ERROR: set_objective_with_leader_on_message() called but supplied wait_offset [" .. tostring(wait_offset) .. "] is not a positive number or nil");
		return false;
	end;

	if not is_string(message) then
		script_error("generated_battle ERROR: set_objective_with_leader_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	if not is_string(objective_key) then
		script_error("generated_battle ERROR: set_objective_with_leader_on_message() called but supplied objective key [" .. tostring(objective_key) .. "] is not a string");
		return false;
	end;
	
	self.sm:add_listener(
		message,
		function()
			bm:callback(
				function()					
					bm:out("generated_battle:set_objective_with_leader_on_message() now adding objective " .. objective_key);
					bm:set_objective_with_leader(objective_key, param1, param2);
					self.current_objectives[objective_key] = true;
				end,
				wait_offset
			);
		end
	);
end;


---	@function complete_objective_on_message
---	@desc Instructs the generated_battle to mark a specified objective as complete, on receipt of a message. Note that objectives issued to the player are automatically completed if they win the battle.
--- @p @string message, Complete the objective on receipt of this message.
--- @p @string objective key, Objective key to complete.
--- @p [opt=0] @number wait offset, Delay between receipt of the message and the objective being completed, in ms.
function generated_battle:complete_objective_on_message(message, objective_key, wait_offset)

	wait_offset = wait_offset or 0;
	
	if not is_number(wait_offset) or wait_offset < 0 then
		script_error("generated_battle ERROR: complete_objective_on_message() called but supplied wait_offset [" .. tostring(wait_offset) .. "] is not a positive number or nil");
		return false;
	end;
	
	if not is_string(message) then
		script_error("generated_battle ERROR: complete_objective_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	if not is_string(objective_key) then
		script_error("generated_battle ERROR: complete_objective_on_message() called but supplied objective key [" .. tostring(objective_key) .. "] is not a string");
		return false;
	end;
	
	self.sm:add_listener(
		message,
		function()
			bm:callback(
				function()
					bm:out("generated_battle:complete_objective_on_message() responding to message " .. message .. ", completing objective " .. objective_key);
					bm:complete_objective(objective_key);
					self.current_objectives[objective_key] = false;
				end,
				wait_offset
			);
		end
	);
end;


---	@function fail_objective_on_message
---	@desc Instructs the generated_battle to mark a specified objective as failed, on receipt of a message. Note that objectives issued to the player are automatically failed if they lose the battle.
--- @p @string message, Fail the objective on receipt of this message.
--- @p @string objective key, Objective key to fail.
--- @p [opt=0] @number wait offset, Delay between receipt of the message and the objective being failed, in ms.
function generated_battle:fail_objective_on_message(message, objective_key, wait_offset)

	wait_offset = wait_offset or 0;
	
	if not is_number(wait_offset) or wait_offset < 0 then
		script_error("generated_battle ERROR: set_objective_on_message() called but supplied wait_offset [" .. tostring(wait_offset) .. "] is not a positive number or nil");
		return false;
	end;
	
	if not is_string(message) then
		script_error("generated_battle ERROR: fail_objective_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	if not is_string(objective_key) then
		script_error("generated_battle ERROR: fail_objective_on_message() called but supplied objective key [" .. tostring(objective_key) .. "] is not a string");
		return false;
	end;
	
	self.sm:add_listener(
		message,
		function()
			bm:callback(
				function()
					bm:out("generated_battle:fail_objective_on_message() responding to message " .. message .. ", failing objective " .. objective_key);
					bm:fail_objective(objective_key);
					self.current_objectives[objective_key] = false;
				end,
				wait_offset
			);
		end
	);
end;


---	@function remove_objective_on_message
---	@desc Instructs the generated_battle to remove a specified objective from the UI on receipt of a message.
--- @p @string message, Remove the objective on receipt of this message.
--- @p @string objective key, Objective key to remove.
--- @p [opt=0] @number wait offset, Delay between receipt of the message and the objective being removed, in ms.
function generated_battle:remove_objective_on_message(message, objective_key, wait_offset)

	wait_offset = wait_offset or 0;
	
	if not is_number(wait_offset) or wait_offset < 0 then
		script_error("generated_battle ERROR: set_objective_on_message() called but supplied wait_offset [" .. tostring(wait_offset) .. "] is not a positive number or nil");
		return false;
	end;
	
	if not is_string(message) then
		script_error("generated_battle ERROR: remove_objective_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	if not is_string(objective_key) then
		script_error("generated_battle ERROR: remove_objective_on_message() called but supplied objective key [" .. tostring(objective_key) .. "] is not a string");
		return false;
	end;
	
	self.sm:add_listener(
		message,
		function()
			bm:callback(
				function()
					bm:out("generated_battle:remove_objective_on_message(): Removing objective " .. objective_key);
					bm:remove_objective(objective_key);
					self.current_objectives[objective_key] = false;
				end,
				wait_offset
			);
		end
	);
end;


---	@function set_locatable_objective_on_message
---	@desc Instructs the generated_battle to set a locatable objective on receipt of a message. See @battle_manager:set_locatable_objective for more details.
--- @p @string message, Add/update the locatable objective on receipt of this message.
--- @p @string objective key, Objective key to add or update.
--- @p [opt=0] @number wait offset, Delay between receipt of the message and the objective being added/updated, in ms.
--- @p @battle_vector camera position, Camera position to zoom camera to when objective button is clicked.
--- @p @battle_vector camera target, Camera target to zoom camera to when objective button is clicked.
--- @p @number camera move time, Time the camera takes to pan to the objective when the objective button is clicked, in seconds.
function generated_battle:set_locatable_objective_on_message(message, objective_key, wait_offset, cam_pos, cam_targ, duration)

	wait_offset = wait_offset or 0;
	
	if not is_number(wait_offset) or wait_offset < 0 then
		script_error("generated_battle ERROR: set_locatable_objective_on_message() called but supplied wait_offset [" .. tostring(wait_offset) .. "] is not a positive number or nil");
		return false;
	end;

	if not is_string(message) then
		script_error("generated_battle ERROR: set_locatable_objective_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	if not is_string(objective_key) then
		script_error("generated_battle ERROR: set_locatable_objective_on_message() called but supplied objective key [" .. tostring(objective_key) .. "] is not a string");
		return false;
	end;
	
	if not is_vector(cam_pos) then
		script_error("generated_battle ERROR: set_locatable_objective_on_message() called but supplied camera position [" .. tostring(cam_pos) .. "] is not a vector");
		return false;
	end;
	
	if not is_vector(cam_targ) then
		script_error("generated_battle ERROR: set_locatable_objective_on_message() called but supplied camera target [" .. tostring(cam_targ) .. "] is not a vector");
		return false;
	end;
	
	if not is_number(duration) or duration <= 0 then
		script_error("generated_battle ERROR: set_locatable_objective_on_message() called but supplied duration [" .. tostring(duration) .. "] is not a number > 0");
		return false;
	end;
	
	self.sm:add_listener(
		message,
		function()
			bm:callback(
				function()					
					bm:out("generated_battle:set_locatable_objective_on_message() now adding objective " .. objective_key);
					bm:set_locatable_objective(objective_key, cam_pos, cam_targ, duration);
					self.current_objectives[objective_key] = true;
					-- bm:callback(function() self:pulse_objective(objective_key) end, 200);
				end,
				wait_offset
			);
		end
	);
end;


---	@function set_locatable_objective_callback_on_message
---	@desc Instructs the generated_battle to set a locatable objective using a callback on receipt of a message. The callback function should return two @battle_vector objects that specify the camera position and target to zoom to - see @battle_manager:set_locatable_objective_callback for more details.
--- @p @string message, Add/update the locatable objective on receipt of this message.
--- @p @string objective key, Objective key to add or update.
--- @p [opt=0] @number wait offset, Delay between receipt of the message and the objective being added/updated, in ms.
--- @p @function camera position generator, Camera position generator function. When called, this should return two @battle_vector values that specify the camera position and target to move to.
--- @p @number camera move time, Time the camera takes to pan to the objective when the objective button is clicked, in seconds.
function generated_battle:set_locatable_objective_callback_on_message(message, objective_key, wait_offset, cam_pos_generator, duration)

	wait_offset = wait_offset or 0;
	
	if not is_number(wait_offset) or wait_offset < 0 then
		script_error("generated_battle ERROR: set_locatable_objective_callback_on_message() called but supplied wait_offset [" .. tostring(wait_offset) .. "] is not a positive number or nil");
		return false;
	end;

	if not is_string(message) then
		script_error("generated_battle ERROR: set_locatable_objective_callback_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	if not is_string(objective_key) then
		script_error("generated_battle ERROR: set_locatable_objective_callback_on_message() called but supplied objective key [" .. tostring(objective_key) .. "] is not a string");
		return false;
	end;
	
	if not is_function(cam_pos_generator) then
		script_error("generated_battle ERROR: set_locatable_objective_callback_on_message() called but supplied camera position generator callback [" .. tostring(cam_pos_generator) .. "] is not a function");
		return false;
	end;
	
	if not is_number(duration) or duration <= 0 then
		script_error("generated_battle ERROR: set_locatable_objective_callback_on_message() called but supplied duration [" .. tostring(duration) .. "] is not a number > 0");
		return false;
	end;
	
	self.sm:add_listener(
		message,
		function()
			bm:callback(
				function()					
					bm:out("generated_battle:set_locatable_objective_callback_on_message() now adding objective " .. objective_key);
					bm:set_locatable_objective_callback(objective_key, cam_pos_generator, duration);
					self.current_objectives[objective_key] = true;
				end,
				wait_offset
			);
		end
	);
end;


---	@function add_ping_icon_on_message
---	@desc Instructs the generated_battle to add a battlefield ping icon on receipt of a message. This is a marker that appears in 3D space and can be used to point out the location of objectives to the player.
--- @p @string message, Add the ping icon on receipt of this message.
--- @p @battle_vector marker position, Marker position.
--- @p @number marker type, Marker type. These have to be looked up from code. See the documentation for @battle:add_ping_icon for a list of valid values.
--- @p [opt=0] @number wait offset, Delay between receipt of the message and the marker being added, in ms.
--- @p [opt=nil] @number duration, Duration that the marker should stay visible for, in ms. If not set then the marker stays on-screen until it is removed with @generated_battle:remove_ping_icon_on_message.
function generated_battle:add_ping_icon_on_message(message, position, marker_type, wait_offset, duration)
	wait_offset = wait_offset or 0;
	marker_type = marker_type or 8;		-- default type
	
	if not is_number(wait_offset) or wait_offset < 0 then
		script_error("generated_battle ERROR: add_ping_icon_on_message() called but supplied wait_offset [" .. tostring(wait_offset) .. "] is not a positive number or nil");
		return false;
	end;

	if not is_string(message) then
		script_error("generated_battle ERROR: add_ping_icon_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	if not is_vector(position) then
		script_error("generated_battle ERROR: add_ping_icon_on_message() called but supplied position [" .. tostring(position) .. "] is not a vector");
		return false;
	end;
	
	if not is_number(marker_type) then
		script_error("generated_battle ERROR: add_ping_icon_on_message() called but supplied marker type [" .. tostring(marker_type) .. "] is not a numeric type or nil");
		return false;
	end;
	
	if duration and not (is_number(duration) and duration > 0) then
		script_error("generated_battle ERROR: add_ping_icon_on_message() called but supplied duration [" .. tostring(duration) .. "] is not a positive number or nil");
		return false;
	end;
	
	self.sm:add_listener(
		message,
		function()
			bm:callback(
				function()
					bm:out("generated_battle:add_ping_icon_on_message() responding to message " .. message .. ", adding ping marker at " .. v_to_s(position) .. " of type " .. marker_type);
					
					bm:add_ping_icon(position:get_x(), position:get_y(), position:get_z(), marker_type, false);
					
					if duration then
						bm:callback(
							function()
								bm:remove_ping_icon(position:get_x(), position:get_y(), position:get_z());
							end,
							duration
						);
					end;
				end,
				wait_offset
			);
		end
	);
end;


---	@function remove_ping_icon_on_message
---	@desc Instructs the generated_battle to remove a battlefield ping icon on receipt of a message. The marker is specified by its position.
--- @p @string message, Remove the ping icon on receipt of this message.
--- @p @battle_vector marker position, Marker position.
--- @p [opt=0] @number wait offset, Delay between receipt of the message and the marker being removed, in ms.
function generated_battle:remove_ping_icon_on_message(message, position, wait_offset)
	wait_offset = wait_offset or 0;
	
	if not is_number(wait_offset) or wait_offset < 0 then
		script_error("generated_battle ERROR: remove_ping_icon_on_message() called but supplied wait_offset [" .. tostring(wait_offset) .. "] is not a positive number or nil");
		return false;
	end;

	if not is_string(message) then
		script_error("generated_battle ERROR: remove_ping_icon_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	if not is_vector(position) then
		script_error("generated_battle ERROR: remove_ping_icon_on_message() called but supplied position [" .. tostring(position) .. "] is not a vector");
		return false;
	end;
	
	self.sm:add_listener(
		message,
		function()
			bm:callback(
				function()
					bm:out("generated_battle:remove_ping_icon_on_message() responding to message " .. message .. ", removing ping marker at " .. v_to_s(position));
					bm:remove_ping_icon(position:get_x(), position:get_y(), position:get_z());
				end,
				wait_offset
			);
		end
	);
end;


-- internal function to pulse an objective as it's being added. Not currently in use.
function generated_battle:pulse_objective(objective_key)
	local uic_objectives = find_uicomponent(bm.ui_root, "scripted_objectives_panel");
	
	if not uic_objectives then
		script_error("ERROR: pulse_objective() couldn't find scripted objectives panel");
		return;
	end;
	
	local uic_objective = find_uicomponent(uic_objectives, objective_key);
	
	if not uic_objective then
		script_error("ERROR: pulse_objective() couldn't find objective key " .. objective_key);
		return;
	end;
	
	uic_objective:TextShaderTechniqueSet("glow_pulse_t0");
	uic_objective:TextShaderVarsSet(0, 3, 1.5, 0);
	
	bm:callback(
		function()
			self:stop_pulse_objective(objective_key);
		end,
		1500
	);
end;


-- internal function to stop pulsing an objective, after it's been added. Not currently in use.
function generated_battle:stop_pulse_objective(objective_key)
	local uic_objectives = find_uicomponent(bm.ui_root, "scripted_objectives_panel");
	
	if not uic_objectives then
		return;
	end;
	
	local uic_objective = find_uicomponent(uic_objectives, objective_key);
	
	if not uic_objective then
		return;
	end;
	
	uic_objective:TextShaderTechniqueSet("normal_t0");
	uic_objective:TextShaderVarsSet(0, 0, 0, 0);
end;


---	@function fade_in_on_message
---	@desc Takes a string message, and a fade duration in seconds. Fades the scene from black to picture over the supplied duration when the supplied message is received.
--- @p @string message
--- @p @number duration
function generated_battle:fade_in_on_message(message, duration)
	if not is_string(message) then
		script_error("generated_battle ERROR: fade_in_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	if not is_number(duration) or duration < 0 then
		script_error("generated_battle ERROR: fade_in_on_message() called but supplied duration [" .. tostring(duration) .. "] is not a positive number, it needs to be a time in seconds");
		return false;
	end;
	
	self.sm:add_listener(
		message,
		function()
			bm:out("generated_battle responding to message " .. message .. ", fading scene in over " .. duration .. "s");
			bm:camera():fade(false, duration);
		end
	);
end;


---	@function set_custom_loading_screen_on_message
---	@desc Takes a string message and a string custom loading screen key. Sets that loading screen key to be used as the loading screen on receipt of the string message. This is used to set a custom outro loading screen.
--- @p @string message
--- @p @number duration
function generated_battle:set_custom_loading_screen_on_message(message, loading_screen_key)
	if not is_string(message) then
		script_error("generated_battle ERROR: set_custom_loading_screen_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	if not is_string(message) then
		script_error("generated_battle ERROR: set_custom_loading_screen_on_message() called but supplied loading screen key [" .. tostring(loading_screen_key) .. "] is not a string");
		return false;
	end;
	
	self.sm:add_listener(
		message,
		function()
			bm:out("generated_battle responding to message " .. message .. ", setting loading screen to " .. loading_screen_key);
			common.set_custom_loading_screen_key(loading_screen_key);
		end
	);
end;


---	@function start_terrain_effect_on_message
---	@desc Instructs the generated_battle to start a terrain effect on receipt of a message.
--- @p @string message, Start the terrain effect on receipt of this message.
--- @p @string effect name, Effect name to start.
--- @p [opt=0] @number wait offset, Delay between receipt of the message and the effect being started, in ms.
function generated_battle:start_terrain_effect_on_message(message, effect_name, wait_offset)
	if not is_string(message) then
		script_error("generated_battle ERROR: start_terrain_effect_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	if not is_string(effect_name) then
		script_error("generated_battle ERROR: start_terrain_effect_on_message() called but supplied effect name [" .. tostring(effect_name) .. "] is not a string");
		return false;
	end;
	
	wait_offset = wait_offset or 0;
	
	if not is_number(wait_offset) or wait_offset < 0 then
		script_error("generated_battle ERROR: start_terrain_effect_on_message() called but supplied wait offset [" .. tostring(wait_offset) .. "] is not a positive number or nil");
		return false;
	end;
	
	self.sm:add_listener(
		message,
		function()
			bm:callback(
				function()
					bm:out("generated_battle responding to message " .. message .. ", starting terrain effect " .. effect_name);
					bm:start_terrain_effect(effect_name);
				end,
				wait_offset
			);
		end
	);
end;


---	@function stop_terrain_effect_on_message
---	@desc Instructs the generated_battle to stop a terrain effect on receipt of a message.
--- @p @string message, Stop the terrain effect on receipt of this message.
--- @p @string effect name, Effect name to stop.
--- @p [opt=0] @number wait offset, Delay between receipt of the message and the effect being stopped, in ms.
function generated_battle:stop_terrain_effect_on_message(message, effect_name, wait_offset)
	if not is_string(message) then
		script_error("generated_battle ERROR: stop_terrain_effect_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	if not is_string(effect_name) then
		script_error("generated_battle ERROR: stop_terrain_effect_on_message() called but supplied effect name [" .. tostring(effect_name) .. "] is not a string");
		return false;
	end;
	
	wait_offset = wait_offset or 0;
	
	if not is_number(wait_offset) or wait_offset < 0 then
		script_error("generated_battle ERROR: stop_terrain_effect_on_message() called but supplied wait offset [" .. tostring(wait_offset) .. "] is not a positive number or nil");
		return false;
	end;
	
	self.sm:add_listener(
		message,
		function()
			bm:callback(
				function()
					bm:out("generated_battle responding to message " .. message .. ", stopping terrain effect " .. effect_name);
					bm:stop_terrain_effect(effect_name);
				end,
				wait_offset
			);
		end
	);
end;


---	@function queue_help_on_message
---	@desc Enqueues a help message for display on-screen on receipt of a message. The message appears above the army panel with a black background. See @"battle_manager:Help Message Queue" for more information. Note that if the battle is ending, this message will not display.
--- @p @string message, Enqueue the help message for display on receipt of this message.
--- @p @string objective key, Message key, from the scripted_objectives table.
--- @p [opt=10000] @number display time, Time for which the help message should be displayed on-screen, in ms.
--- @p [opt=2000] @number display time, Time for which the help message should be displayed on-screen, in ms.
--- @p [opt=0] @number wait offset, Delay between receipt of the message and the help message being enqueued, in ms.
--- @p [opt=false] @boolean high priority, High priority advice gets added to the front of the help queue rather than the back.
--- @p [opt=nil] @string message on trigger, Specifies a message to be sent when this help message is actually triggered for display.
function generated_battle:queue_help_on_message(message, objective_key, display_time, fade_time, offset_time, is_high_priority, message_on_trigger)
	if not is_string(message) then
		script_error("generated_battle ERROR: queue_help_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	if not is_string(objective_key) then
		script_error("generated_battle ERROR: queue_help_on_message() called but supplied objective key [" .. tostring(objective_key) .. "] is not a string");
		return false;
	end;
	
	display_time = display_time or 10000;
		
	if not is_number(display_time) or display_time < 0 then
		script_error("generated_battle ERROR: queue_help_on_message() called but supplied display time [" .. tostring(display_time) .. "] is not a positive number or nil");
		return false;
	end;
	
	fade_time = fade_time or 2000;
	
	if not is_number(fade_time) or fade_time < 0 then
		script_error("generated_battle ERROR: queue_help_on_message() called but supplied fade time [" .. tostring(fade_time) .. "] is not a positive number or nil");
		return false;
	end;
	
	offset_time = offset_time or 0;
	
	if not is_number(offset_time) or offset_time < 0 then
		script_error("generated_battle ERROR: queue_help_on_message() called but supplied offset time [" .. tostring(offset_time) .. "] is not a positive number or nil");
		return false;
	end;
	
	if message_on_trigger and not is_string(message_on_trigger) then
		script_error("generated_battle ERROR: queue_help_on_message() called but supplied on-trigger message [" .. tostring(message_on_trigger) .. "] is not a string or nil");
		return false;
	end;
	
	self.sm:add_listener(
		message,
		function()
			bm:callback(
				function()
					bm:out("generated_battle:queue_help_on_message() responding to message " .. message .. ", enqueueing help message " .. objective_key);
					bm:queue_help_message(
						objective_key, 
						display_time, 
						fade_time, 
						is_high_priority,
						false,
						function()
							if message_on_trigger then
								self.sm:trigger_message(message_on_trigger);
							end;
						end
					);
				end,
				offset_time
			);
		end
	);
end;


--- @function set_victory_countdown_on_message
--- @desc Sets the victory countdown time for the battle to the specified value when the specified message is received. The victory countdown time is the grace period after the battle is deemed to have a victor, and before the battle formally ends, in which celebratory/commiseratory advice often plays. Set this to a negative number for the battle to never end after entering victory countdown phase, or 0 for it to end immediately. 
--- @desc Note that it's possible to set a negative victory countdown period, then enter the phase, then set a victory countdown period of zero to end the battle immediately.
--- @p @string message, Set victory countdown on receipt of this message.
--- @p @number countdown time, Victory countdown time in ms.
function generated_battle:set_victory_countdown_on_message(message, countdown_time)
	
	if not is_string(message) then
		script_error("generated_battle ERROR: set_victory_countdown_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;

	if not is_number(countdown_time) then
		script_error("generated_battle ERROR: set_victory_countdown_on_message() called but supplied countdown_time [" .. tostring(countdown_time) .. "] is not a number, it needs to be a time in ms");
		return false;
	end;
	
	if countdown_time > 0 then
		countdown_time = countdown_time / 1000;
	end
	bm:out("generated_battle:set_victory_countdown_on_message(): for message " .. message);
	
	self.sm:add_listener(
		message,
		function()
			bm:out("generated_battle:set_victory_countdown_on_message() setting victory countdown to " .. countdown_time .. "ms");
			bm:change_victory_countdown_limit(countdown_time);		-- function needs it in seconds
		end
	);
end;


--- @function block_message_on_message
--- @desc Blocks or unblocks a message from being triggered, on receipt of a message. Scripts listening for a blocked message will not be notified when that message is triggered. See @script_messager:block_message for more information.
--- @p @string message, Perform the blocking or unblocking on receipt of this message.
--- @p @string message to block, Message to block or unblock.
--- @p [opt=true] @boolean should block, Should block the message. Set this to <code>false</code> to unblock a previously-blocked message.
function generated_battle:block_message_on_message(message, message_to_block, should_block)
	
	if not is_string(message) then
		script_error("generated_battle ERROR: block_message_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	if not is_string(message_to_block) then
		script_error("generated_battle ERROR: block_message_on_message() called but supplied message to block [" .. tostring(message_to_block) .. "] is not a string");
		return false;
	end;
	
	if should_block ~= false then
		should_block = true;
	end;
	
	self.sm:add_listener(
		message,
		function()
			if should_block then
				bm:out("generated_battle:block_message_on_message() responding to message " .. message .. " and is blocking message " .. message_to_block .. " from being triggered in the future");
			else
				bm:out("generated_battle:block_message_on_message() responding to message " .. message .. " and is unblocking message " .. message_to_block);
			end;
			self.sm:block_message(message_to_block, should_block);
		end
	);
end;


function generated_battle:battle_ending()
	bm:out("generated_battle is ending");
	self.sm:trigger_message("battle_ending");
	
	-- end the battle in ten seconds, unless stopped
	if self.stop_battle_end == false then
		bm:callback(function() bm:end_battle() end, 10000);
	end
	
	-- attempt to work out which alliance has won
	-- this script should be rewritten when the script has the proper ability to determine who has won
	local alliances = bm:alliances();
	local winning_alliance_num = false;
	
	-- go backwards through our alliances - if the enemy alliance still has troops left, assume that it's won
	for i = alliances:count(), 1, -1 do
		local alliance = alliances:item(i);
		
		if not is_routing_or_dead(alliance) then
			winning_alliance_num = i;
			break;
		end;
	end;
	
	if not winning_alliance_num then
		bm:out("\twarning: could not determine the winning alliance");
		return;
	end;
	
	-- we have a winning alliance, notify the relevant armies
	for i = 1, #self.generated_armies do
		for j = 1, #self.generated_armies[i] do
			for k = 1, #self.generated_armies[i][j] do
				local current_ga = self.generated_armies[i][j][k];
				
				if current_ga.alliance_index == winning_alliance_num then
					current_ga:notify_of_victory();
				else
					current_ga:notify_of_defeat();
				end;
			end;
		end;
	end;
	
	-- complete or fail all currently-active objectives
	for objective_name, objective_value in pairs(self.current_objectives) do
		if objective_value == true then
			if winning_alliance_num == self:get_player_alliance_num() then
				bm:complete_objective(objective_name);
			else
				bm:fail_objective(objective_name);
			end;
		end;
	end;
end;





----------------------------------------------------------------------------
---	@section Message Generation
----------------------------------------------------------------------------


---	@function message_on_all_messages_received
---	@desc Takes a subject message, and then one or more other messages. When all of these other messages are received, the subject message is sent.
--- @p @string message, Subject message to send.
--- @p ... messages, One or more string messages to receive.
function generated_battle:message_on_all_messages_received(message, ...)
	if not is_string(message) then
		script_error("generated_battle ERROR: message_on_all_messages_received() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	if arg.n == 0 then
		script_error("generated_battle ERROR: message_on_all_messages_received() called but no messages to listen to were specified");
		return false;
	end;
	
	for i = 1, arg.n do
		if not is_string(arg[i]) then
			script_error("generated_battle ERROR: message_on_all_messages_received() called but message to listen to [" .. i .. "] is not a string, it's value is [" .. tostring(arg[i]) .. "]");
			return false;
		end;
	end;
	
	local num_messages_received = 0;
	local messages_received = {};
	
	for i = 1, arg.n do
		local current_message = arg[i];
		self.sm:add_listener(
			current_message,
			function()
				if not messages_received[current_message] then
					messages_received[current_message] = true;

					num_messages_received = num_messages_received + 1;
					
					if num_messages_received == arg.n then
						bm:out("generated_battle:message_on_all_messages_received() is sending message [" .. message .. "] having received all the following messages [" .. table.concat(arg, ", ") .. "], last message received was [" .. current_message .. "]");
						self.sm:trigger_message(message);
					end;
				end;
			end
		);
	end;
end;


---	@function message_on_any_message_received
---	@desc Takes a subject message, and then one or more other messages. When any of these other messages are received, the subject message is sent.
--- @p @string message, Subject message to send.
--- @p ... messages, One or more string messages to receive.
function generated_battle:message_on_any_message_received(message, ...)
	if not is_string(message) then
		script_error("generated_battle ERROR: message_on_any_message_received() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	if arg.n == 0 then
		script_error("generated_battle ERROR: message_on_any_message_received() called but no messages to listen to were specified");
		return false;
	end;
	
	for i = 1, arg.n do
		if not is_string(arg[i]) then
			script_error("generated_battle ERROR: message_on_any_message_received() called but message to listen to [" .. i .. "] is not a string, it's value is [" .. tostring(arg[i]) .. "]");
			return false;
		end;
	end;
	
	local message_sent = false;
	
	for i = 1, arg.n do
		self.sm:add_listener(
			arg[i],
			function()
				if not message_sent then
					message_sent = true;					
					bm:out("generated_battle:message_on_any_message_received() is sending message [" .. message .. "] having received the message [" .. arg[i] .. "]");
					self.sm:trigger_message(message);
				end;
			end
		);
	end;
end;


---	@function message_on_time_offset
---	@desc Takes a string message and a wait time in ms. Waits for the specified interval and then triggers the message. If an optional start message is supplied as a third parameter then the timer will start when this message is received, otherwise it starts when the battle is started.
--- @desc A cancellation message may be supplied as a fourth parameter - this will cancel the timer if the message is received (whether the timer has been started or not).
--- @p @string message, Message to send.
--- @p @number wait time, Wait time in ms before sending the message.
--- @p [opt="battle_started"] @string start message, Start message which begins the wait time countdown. If a value of <code>true</code> is supplied then the countdown starts as soon as this function is called.
--- @p [opt=false] @string cancel message, Cancellation message.
function generated_battle:message_on_time_offset(message, wait_time, start_message, cancel_message)
	if not is_string(message) then
		script_error("generated_battle ERROR: message_on_time_offset() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;

	if not is_number(wait_time) then
		script_error("generated_battle ERROR: message_on_time_offset() called but supplied wait_time [" .. tostring(wait_time) .. "] is not a number, it needs to be a time in ms");
		return false;
	end;
	
	if not start_message then
		start_message = "battle_started";
	end;
	
	if not is_string(start_message) and start_message ~= true then
		script_error("generated_battle ERROR: message_on_time_offset() called but supplied start message [" .. tostring(start_message) .. "] is not a string or true");
		return false;
	end;
	
	if not is_nil(cancel_message) and not is_string(cancel_message) then
		script_error("generated_battle ERROR: message_on_time_offset() called but supplied cancellation message [" .. tostring(cancel_message) .. "] is not a string");
		return false;
	end;
	
	local message_cancelled = false;
	local process_name = "gb_message_on_time_offset_" .. message;
	
	-- function block to start the timer countdown
	local function start_countdown()
		if not message_cancelled then
			if start_message == true then
				bm:out("generated_battle:message_on_time_offset() is starting timer immediately, will trigger message " .. message .. " in " .. wait_time .. "ms");
			else
				bm:out("generated_battle:message_on_time_offset() is starting timer having received start message " .. start_message .. ", will trigger message " .. message .. " in " .. wait_time .. "ms");
			end;
		
			bm:callback(
				function()
					bm:out("generated_battle:message_on_time_offset() triggering message " .. message);
					if cancel_message then
						self.sm:remove_listener_by_message(cancel_message);
					end
					self.sm:trigger_message(message);
				end,
				wait_time,
				process_name
			);
		end;
	end;
	
	-- if the start_message argument was "true" then proceed immediately, otherwise proceed when the start message is received
	if start_message == true then
		start_countdown();
	else
		self.sm:add_listener(
			start_message, 
			function()
				start_countdown();
			end
		);
	end;
	
	if cancel_message then
		self.sm:add_listener(
			cancel_message,
			function()
				bm:out("generated_battle:message_on_time_offset() has received cancellation message " .. cancel_message .. " so won't be triggering message " .. message);
				bm:remove_process(process_name);
				message_cancelled = true;
			end
		);
	end
end;









--- @section Messages on Capture Location Events

-- internal function, used by message_on_capture_location_capture_commenced and message_on_capture_location_capture_completed - do not call this directly
function generated_battle:message_on_capture_location_capture_event(event_specifier, message, start_message, script_id_filter, type_filter, holding_alliance_filter, contesting_alliance_filter)

	local event_specifier_lower = string.lower(event_specifier);
	local function_name = "message_on_capture_location_capture_" .. event_specifier_lower;

	if not is_string(message) then
		script_error("generated_battle ERROR: " .. function_name .. "() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;

	if start_message then
		if not is_string(start_message) and start_message ~= true then
			script_error("generated_battle ERROR: " .. function_name .. "() called but supplied start message [" .. tostring(start_message) .. "] is not a string, nil, or true");
			return false;
		end;
	else
		start_message = "battle_started";
	end;

	if script_id_filter and not is_string(script_id_filter) then
		script_error("generated_battle ERROR: " .. function_name .. "() called but supplied script id filter [" .. tostring(script_id_filter) .. "] is not a string or nil");
		return false;
	end;

	if type_filter and not is_string(type_filter) then
		script_error("generated_battle ERROR: " .. function_name .. "() called but supplied type filter [" .. tostring(type_filter) .. "] is not a string or nil");
		return false;
	end;

	if holding_alliance_filter then
		if is_generatedarmy(holding_alliance_filter) then
			holding_alliance_filter = holding_alliance_filter.alliance_index;
		elseif not is_number(holding_alliance_filter) then
			script_error("generated_battle ERROR: " .. function_name .. "() called but supplied holding alliance id [" .. tostring(holding_alliance_filter) .. "] is not a number, generated_army, or nil");
			return false;
		end;
	end;

	if contesting_alliance_filter then
		if is_generatedarmy(contesting_alliance_filter) then
			contesting_alliance_filter = contesting_alliance_filter.alliance_index;
		elseif not is_number(contesting_alliance_filter) then
			script_error("generated_battle ERROR: " .. function_name .. "() called but supplied contesting alliance id [" .. tostring(contesting_alliance_filter) .. "] is not a number, generated_army, or nil");
			return false;
		end;
	end;


	local process_name = "message_on_capture_location_capture_" .. core:get_unique_counter();

	local function start_monitor()
		core:add_listener(
			process_name,
			"BattleCaptureLocationCapture" .. event_specifier,			-- BattleCaptureLocationCaptureCommenced, BattleCaptureLocationCaptureCompleted
			true,
			function(context)
				-- Contesting unit will be nil if a unit didn't complete the capture (e.g. a unit started a capture but didn't follow through with it - a 
				-- BattleCaptureLocationCaptureCompleted will be triggered when the capture location is fully returned to the holder)
				local contesting_unit = context:battle_unit();
				local capture_location = context:battle_capture_location();
				
				-- check the holding alliance filter if we have one
				if is_number(holding_alliance_filter) then
					local holding_alliance_id = context:battle_holding_alliance_id();
					if holding_alliance_filter ~= holding_alliance_id then
						return false;
					end;
				end;

				-- check the contesting alliance filter if we have one
				if contesting_alliance_filter then
					local contesting_unit_alliance_id = contesting_unit and contesting_unit:alliance_index();
					if contesting_unit_alliance_id ~= contesting_alliance_filter then
						return false;
					end;
				end;

				-- check script id filter if we have one
				if is_string(script_id_filter) then
					local capture_location_script_id = capture_location:script_id();
					if not string.find(capture_location_script_id, script_id_filter) then
						return false;
					end;
				end;

				-- check type filter if we have one
				if is_string(type_filter) then
					local capture_location_type = capture_location:type();
					if not string.find(capture_location_type, type_filter) then
						return false;
					end;
				end;

				if contesting_unit then
					bm:out("generated_battle:" .. function_name .. " is triggering message " .. message .. " as capture of capture location at " .. v_to_s(capture_location:position()) .. " of type " .. capture_location:type() .. " with script id " .. tostring(capture_location:script_id()) .. " has " .. event_specifier_lower .. ", capturing unit is " .. contesting_unit:unique_ui_id() .. " of type " .. contesting_unit:type() .. " at position " .. v_to_s(contesting_unit:position()));
				else
					bm:out("generated_battle:" .. function_name .. " is triggering message " .. message .. " as capture of capture location at " .. v_to_s(capture_location:position()) .. " of type " .. capture_location:type() .. " with script id " .. tostring(capture_location:script_id()) .. " has " .. event_specifier_lower);
				end;
				core:remove_listener(process_name);
				self.sm:trigger_message(message);
			end,
			true
		);
	end;

	-- if the start_message argument was "true" then proceed immediately, otherwise proceed when the start message is received
	if start_message == true then
		start_monitor();
	else
		self.sm:add_listener(
			start_message, 
			function()
				start_monitor();
			end
		);
	end;
end;


--- @function message_on_capture_location_capture_commenced
--- @desc Generates the supplied script message when the capture of a @battle_capture_location begins. A number of filters may optionally be specified, for the holding alliance, the contesting alliance, and the script id and the type of the capture location. When a script event indicating the capture of a capture location has begun the supplied filters are checked and, should they all match, the supplied message is generated. Filters that are omitted are not checked.
--- @desc The script id and type filters perform a string compare, so a supplied script id filter <code>"section_1"</code> would pass for capture locations with ids <code>"section_1"</code>, <code>"section_1a"</code>, <code>"end_section_1"</code> but would not match <code>"section_2"</code>, for example. Similarly a supplied type filter of <code>"minor_key_building"</code> would match <code>"minor_key_building_defence"</code> but not <code>"major_key_building"</code>. Capture location types may be looked up in the <code>capture_location_types</code> database table.
--- @desc A start message may optionally be specified. If this is left blank then the listener will start when deployment ends. If the boolean value <code>true</code> is supplied as a start message the listener will start immediately, but this is highly situational.
--- @p @string message, Message to send.
--- @p [opt="battle_started"] @string start message, Start message which begins the listening process. If a value of <code>true</code> is supplied then the process starts as soon as this function is called.
--- @p [opt=nil] @string script id filter, Capture location script id filter. If supplied, a string match of this filter is performed against the capture location script id as described above.
--- @p [opt=nil] @string type filter, Capture location type filter. If supplied, a string match of this filter is performed against the capture location type as described above.
--- @p [opt=nil] @number holding alliance filter, Holding alliance filter. This may be an alliance index (1 or 2), a @generated_army (the alliance of the army is used), or @nil may be supplied to bypass this filter.
--- @p [opt=nil] @number contesting alliance filter, Contesting alliance filter. This may be an alliance index (1 or 2), a @generated_army (the alliance of the army is used), or @nil may be supplied to bypass this filter.
function generated_battle:message_on_capture_location_capture_commenced(message, start_message, script_id_filter, type_filter, holding_alliance_filter, contesting_alliance_filter)
	self:message_on_capture_location_capture_event("Commenced", message, start_message, script_id_filter, type_filter, holding_alliance_filter, contesting_alliance_filter);
end;


--- @function message_on_capture_location_capture_completed
--- @desc Generates the supplied script message when the capture of a @battle_capture_location completes. A number of filters may optionally be specified, for the (previous) holding alliance, the contesting alliance, and the script id and the type of the capture location. When a script event indicating the capture of a capture location has completed the supplied filters are checked and, should they all match, the supplied message is generated. Filters that are omitted are not checked.
--- @desc The script id and type filters perform a string compare, so a supplied script id filter <code>"section_1"</code> would pass for capture locations with ids <code>"section_1"</code>, <code>"section_1a"</code>, <code>"end_section_1"</code> but would not match <code>"section_2"</code>, for example. Similarly a supplied type filter of <code>"minor_key_building"</code> would match <code>"minor_key_building_defence"</code> but not <code>"major_key_building"</code>. Capture location types may be looked up in the <code>capture_location_types</code> database table.
--- @desc A start message may optionally be specified. If this is left blank then the listener will start when deployment ends. If the boolean value <code>true</code> is supplied as a start message the listener will start immediately, but this is highly situational.
--- @p @string message, Message to send.
--- @p [opt="battle_started"] @string start message, Start message which begins the listening process. If a value of <code>true</code> is supplied then the process starts as soon as this function is called.
--- @p [opt=nil] @string script id filter, Capture location script id filter. If supplied, a string match of this filter is performed against the capture location script id as described above.
--- @p [opt=nil] @string type filter, Capture location type filter. If supplied, a string match of this filter is performed against the capture location type as described above.
--- @p [opt=nil] @number holding alliance filter, Holding alliance filter. This may be an alliance index (1 or 2), a @generated_army (the alliance of the army is used), or @nil may be supplied to bypass this filter.
--- @p [opt=nil] @number contesting alliance filter, Contesting alliance filter. This may be an alliance index (1 or 2), a @generated_army (the alliance of the army is used), or @nil may be supplied to bypass this filter.
function generated_battle:message_on_capture_location_capture_completed(message, start_message, script_id_filter, type_filter, holding_alliance_filter, contesting_alliance_filter)
	self:message_on_capture_location_capture_event("Completed", message, start_message, script_id_filter, type_filter, holding_alliance_filter, contesting_alliance_filter);
end;


































----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--
--	GENERATED ARMY
--
---	@c generated_army Generated Army
--- @a ga
--- @page generated_battle
--- @desc A generated army object represents a conceptual army in a generated battle. This can mean an entire army in the conventional sense, or a collection of units within a conventional army, grouped together by the same script_name. A generated_army object can be created by calling @generated_battle:get_army.
--- @desc Each generated army object can be instructed to respond to trigger script messages when certain in-battle conditions are met (e.g. when a certain proportion of casualties has been taken, or the enemy is within a certain distance), or to respond to script messages triggered by other parts of the script by attacking/defending/moving and more. Using these tools, the actions that determine the course of events in a generated/quest battle can be laid out.
--
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------


generated_army = {
	sm = nil,
	id = "",
	uc = nil,
	alliance_index = 0,
	army_index = 0,
	army = false,
	reinforcement_source_army = false,
	sunits = {},
	script_name = "",
	script_ai_planner = nil,
	last_sai_behaviour_callback = false,
	total_units = 0,
	generated_battle = nil,
	is_allied_to_player = false,
	enemy_force = false,
	allied_force = false,
	victory_message = false,
	defeat_message = false,
	enemies_and_allies_known = false,
	represents_full_logical_army = false,
	is_debug = false
};


set_class_custom_type(generated_army, TYPE_GENERATED_ARMY);
set_class_tostring(
	generated_army, 
	function(obj)
		return TYPE_GENERATED_ARMY .. "_" .. obj.id
	end
);



-- creator, not to be called externally - use generated_battle:get_army instead
function generated_army:new(script_name, sub_army_num, sunits, generated_battle, is_debug)
	if not is_string(script_name) then
		script_error("ERROR: tried to created generated_army but supplied script_name [" .. tostring(script_name) .. "] is not a string");
		return false;
	end;
	
	if not is_number(sub_army_num) then
		script_error("ERROR: tried to created generated_army but supplied sub army number [" .. tostring(sub_army_num) .. "] is not a number");
		return false;
	end;

	if not is_scriptunits(sunits) then
		script_error("ERROR: tried to created generated_army but supplied sunits collection [" .. tostring(sunits) .. "] is not a scriptunits object");
		return false;
	end;
	
	if sunits:count() == 0 then
		script_error("ERROR: tried to created generated_army but supplied sunits collection is empty");
		return false;
	end;
	
	if not is_generatedbattle(generated_battle) then
		script_error("ERROR: tried to created generated_army but supplied generated battle [" .. tostring(generated_battle) .. "] is not a generated_battle");
		return false;
	end;

	local ga = {};
	
	local sm = get_messager();
	
	-- get a handle to the first sunit, as we can ask it for other important info
	local first_sunit = sunits:item(1);
	
	ga.sm = sm;
	
	local alliance_index = first_sunit.unit:alliance_index();
	local army_index = first_sunit.unit:army_index();
	local army = first_sunit.unit:army();

	if army:units():count() == sunits:count() then
		ga.represents_full_logical_army = true;
	end;
	
	ga.alliance_index = alliance_index;
	ga.army_index = army_index;
	
	-- unique id for this ga. This is not the name that can be used to get a handle to it - that's the script_name
	ga.id = "generated_army_" .. tostring(alliance_index) .. ":" .. tostring(army_index) .. ":" .. sub_army_num;

	set_object_class(ga, self);
	
	if script_name ~= "" then
		ga.id = ga.id .. ":" .. script_name;
	end;
	
	ga.script_name = tostring(script_name);
	
	-- create unitcontroller
	ga.uc = sunits:get_unitcontroller(army);

	ga.sunits = sunits;
	ga.total_units = sunits:count();

	-- Work out what army configuration we have. If this is a reinforcement army then our units will move from this army to a completely different target army.
	local army = first_sunit.unit:army();
	local target_army = army:get_reinforcement_target_army();

	if target_army then
		-- This army is reinforcing into a target army, so store the target army (which is the real army) as ga.army and the source army (which is a temporary container) as ga.reinforcement_source_army
		ga.army = target_army;
		ga.reinforcement_source_army = army;
	else
		-- This army is not reinforcing into a target army, so store the source army as ga.army
		ga.army = army;
	end;
	
	ga.generated_battle = generated_battle;
	ga.is_debug = is_debug;
	
	-- take script control of these sunits if the generated battle wishes us to (so they can't deploy)
	if not (alliance_index == bm:local_alliance() and army_index == bm:local_army()) and generated_battle:should_not_deploy_ai() and has_deployed(first_sunit.unit) then
		ga.sunits:take_control();
	end;
	
	return ga;
end;

--	called internally to ensure the script planner is set up
function generated_army:set_up_script_planner()
	if not self.script_ai_planner then
		self.script_ai_planner = script_ai_planner:new(self.id, self.sunits:get_sunit_table(), self.is_debug);	
	end;
end;


--	Builds the enemy_force and allied_force lists, which are tables of scriptunits of all enemies and allies.
--	These are sourced from the generated_battle parent object
--	For internal use
function generated_army:get_allied_and_enemy_forces()
	if self.enemies_and_allies_known then
		return;
	end;
	
	self.enemies_and_allies_known = true;
	
	self.enemy_force = self.generated_battle:get_enemy_force(self.alliance_index, self.army_index);
	self.allied_force = self.generated_battle:get_allied_force(self.alliance_index, self.army_index);
end;


--	Releases all sunits in this generated_army from the script_ai_planner
--	For internal use
function generated_army:release_control_of_all_sunits()
	if not is_nil(self.script_ai_planner) then
		self.script_ai_planner:remove_sunits(self.sunits:get_sunit_table());
		self.script_ai_planner = nil;
	end
	
	-- go through list of sunits and explicitly release them
	self.sunits:release_control();
end;










----------------------------------------------------------------------------
---	@section Querying
----------------------------------------------------------------------------


--- @function get_script_name
--- @desc Gets the script_name of the generated army.
--- @r @string script_name
function generated_army:get_script_name()
	return self.script_name;
end;


--- @function get_unitcontroller
--- @desc Gets a unitcontroller with control over all units in the generated army. This can be useful for the intro cutscene which needs this to restrict player control.
--- @r @battle_unitcontroller unitcontroller
function generated_army:get_unitcontroller()
	return self.uc;	
end;


--- @function get_alliance
--- @desc Returns the @battle_alliance object that contains the units in this generated army.
--- @r @battle_alliance alliance
function generated_army:get_alliance()
	return bm:alliances():item(self.alliance_index);
end;


--- @function get_army
--- @desc Returns the @battle_army object that contains the units in this generated army. If the units are reinforcing then they may instead belong to a dummy army before they enter the battlefield - use @generated_army:get_reinforcement_source_army instead to access that army object.
--- @r @battle_army army
function generated_army:get_army()
	return self.army;
end;


--- @function get_reinforcement_source_army
--- @desc Returns the temporary @battle_army object that contains reinforcing units in this generated army, before they enter the battlefield. As they enter the battlefield they will be transferred to the proper army object which may be accessed with @generated_army:get_army.
--- @desc If the units in this generated army are not reinforcing then there will be no source army and this function will return <code>false</code>.
--- @r @battle_army source army
function generated_army:get_reinforcement_source_army()
	return self.reinforcement_source_army;
end;



--- @function get_handicap
--- @desc Returns the battle difficulty. See the documentation for @battle_army:army_handicap for possible return values.
--- @r @number army handicap
function generated_army:get_handicap()
	return self:get_army():army_handicap();
end;


--- @function get_first_scriptunit
--- @desc Returns the first scriptunit of the generated army.
--- @r @script_unit scriptunit
function generated_army:get_first_scriptunit()
	return self.sunits:item(1);
end;


--- @function get_most_westerly_scriptunit
--- @desc Returns the @script_unit within the generated army positioned furthest to the west.
--- @r @script_unit scriptunit
function generated_army:get_most_westerly_scriptunit()
	local sunits = self.sunits;
	local furthest_pos = 5000;
	
	for i = 1, sunits:count() do
		current_sunit = sunits:item(i);
		
		current_pos = current_sunit.unit:position():get_x();
		
		if current_pos < furthest_pos then
			furthest_pos = current_pos;
			furthest_unit = current_sunit;
		end;
	end;

	return furthest_unit;
end;


--- @function get_most_easterly_scriptunit
--- @desc Returns the @script_unit within the generated army positioned furthest to the east.
--- @r @script_unit scriptunit
function generated_army:get_most_easterly_scriptunit()
	local sunits = self.sunits;
	local furthest_pos = -5000;
	
	for i = 1, sunits:count() do
		current_sunit = sunits:item(i);
		
		current_pos = current_sunit.unit:position():get_x();
		
		if current_pos > furthest_pos then
			furthest_pos = current_pos;
			furthest_unit = current_sunit;
		end;
	end;
	
	return furthest_unit;
end;


--- @function get_most_northerly_scriptunit
--- @desc Returns the @script_unit within the generated army positioned furthest to the north.
--- @r @script_unit scriptunit
function generated_army:get_most_northerly_scriptunit()
	local sunits = self.sunits;
	local furthest_pos = -5000;
	
	for i = 1, sunits:count() do
		current_sunit = sunits:item(i);
		
		current_pos = current_sunit.unit:position():get_z();
		
		if current_pos > furthest_pos then
			furthest_pos = current_pos;
			furthest_unit = current_sunit;
		end;
	end;
	
	return furthest_unit;
end;


--- @function get_most_southerly_scriptunit
--- @desc Returns the @script_unit within the generated army positioned furthest to the south.
--- @r @script_unit scriptunit
function generated_army:get_most_southerly_scriptunit()
	local sunits = self.sunits;
	local furthest_pos = 5000;
	
	for i = 1, sunits:count() do
		current_sunit = sunits:item(i);
		
		current_pos = current_sunit.unit:position():get_z();
		
		if current_pos < furthest_pos then
			furthest_pos = current_pos;
			furthest_unit = current_sunit;
		end;
	end;

	return furthest_unit;
end;


--- @function get_casualty_rate
--- @desc Returns the amount of casualties this generated army has taken as a unary value e.g. 0.2 = 20% casualties.
--- @r @number casualties
function generated_army:get_casualty_rate()
	return 1 - self.sunits:unary_hitpoints();
end;


--- @function get_rout_proportion
--- @desc Returns the unary proportion (0 - 1) of the units in this generated army that are routing e.g. 0.2 = 20% routing.
--- @p [opt=false] @boolean permit rampaging, Permit rampaging, so that rampaging units are considered to be still controllable/not-routing. By default, rampaging units are considered to be routing.
--- @r @number rout proportion
function generated_army:get_rout_proportion(permit_rampaging)
	local total_units = self.sunits:count();
	
	-- divide-by-zero guard
	if total_units == 0 then
		return 0;
	end;
	
	local units_routing = num_units_routing(self.sunits, false, permit_rampaging);
	
	return units_routing / total_units;	
end;


--- @function get_shattered_proportion
--- @desc Returns the unary proportion (0 - 1) of the units in this generated army that are shattered e.g. 0.2 = 20% routing.
--- @p [opt=false] @boolean permit rampaging, Permit rampaging, so that rampaging units are considered to be still controllable/not-routing. By default, rampaging units are considered to be routing.
--- @r @number shattered proportion
function generated_army:get_shattered_proportion(permit_rampaging)
	local total_units = self.sunits:count();
	
	-- divide-by-zero guard
	if total_units == 0 then
		return 0;
	end;

	local units_shattered = num_units_shattered(self.sunits, permit_rampaging);
	
	return units_shattered / total_units;
end;


--- @function are_unit_types_in_army
--- @desc Returns true if any of the supplied unit types are present in the army, false otherwise.
--- @r @boolean army contains types
function generated_army:are_unit_types_in_army(...)
	for i = 1, arg.n do
		if not is_string(arg[i]) then
			script_error(self.id .. " ERROR: are_unit_types_in_army() called but supplied argument [" .. i .. "] is [" .. tostring(arg[i]) .. "] and not a string");
			return false;
		end;		
	
		if self.sunits:get_sunit_by_type(arg[i]) then
			bm:out(self.id .. ": are_unit_types_in_army() found matching type " .. arg[i]);
			return true;
		end
	end;
	
	bm:out(self.id .. ": are_unit_types_in_army() found no matching types");
	return false;
end;













----------------------------------------------------------------------------
---	@section Direct Commands
--- @desc These commands directly call some function or give some instruction to the generated army without listening for a script message. They are mostly for use within intro cutscenes, or they may be used internally by the functions that listen for messages.
----------------------------------------------------------------------------


--- @function set_visible_to_all
--- @desc Sets the visibility on a @generated_army, so that they are visible in an intro cutscene.
--- @p [opt=true] @boolean visible
function generated_army:set_visible_to_all(value)
	if value == false then
		self.uc:set_always_visible_to_all(false);
	else
		self.uc:set_always_visible_to_all(true);
	end;
end;


--- @function set_enabled
--- @desc Sets whether a generated_army is enabled - when disabled, they will be invisible and effectively not exist. See @script_unit:set_enabled.
--- @p [opt=true] @boolean enabled
function generated_army:set_enabled(value)
	self.sunits:set_enabled(value);
end;


--- @function halt
--- @desc Halts the generated_army.
function generated_army:halt()	
	self.sunits:halt();
end;


--- @function celebrate
--- @desc Orders the generated_army to celebrate.
function generated_army:celebrate()
	self.sunits:celebrate();
end;


--- @function taunt
--- @desc Orders the generated_army to taunt.
function generated_army:taunt()
	self.sunits:taunt();
end;


--- @function play_sound_charge
--- @desc Orders the generated_army to trigger the charge sound.
function generated_army:play_sound_charge()
	bm:out("generated_army:play_sound_charge() - Playing Charge Sound");
	self.sunits:play_sound_charge();
end;


--- @function play_sound_taunt
--- @desc Orders the generated_army to trigger the taunt sound.
function generated_army:play_sound_taunt()
	bm:out("generated_army:play_sound_taunt() - Playing Taunt Sound");
	self.sunits:play_sound_taunt();
end;


--- @function add_ping_icon
--- @desc Adds a ping icon to a unit within the generated army. See @script_unit:add_ping_icon.
--- @p [opt=8] @number icon type, Icon type. This is a numeric index defined in code.
--- @p [opt=1] @number unit index, Index of unit within the army to add the ping icon to.
--- @p [opt=nil] @number duration, Duration to show the ping icon, in ms. Leave blank to show the icon indefinitely.
function generated_army:add_ping_icon(icon_type, unit_index, duration)
	unit_index = unit_index or 1;
	
	if unit_index and not (is_number(unit_index) and unit_index > 0) then
		script_error(self.id .. " ERROR: add_ping_icon() called but supplied unit index [" .. tostring(unit_index) .. "] is not a number > 0 or nil");
		return false;
	end;

	if unit_index > self.sunits:count() then
		script_error(self.id .. " ERROR: add_ping_icon() called with unit index [" .. tostring(unit_index) .. "] but this is greater than the number of units in this army [" .. self.sunits:count() .. "]");
		return false;
	end;
	
	self.sunits:item(unit_index):add_ping_icon(icon_type, duration);
end;


--- @function remove_ping_icon
--- @desc Removes a ping icon from a unit within the generated army.
--- @p [opt=1] @number unit index, Index of unit within the army to remove the ping icon from.
function generated_army:remove_ping_icon(unit_index)
	unit_index = unit_index or 1;
	
	if unit_index and not (is_number(unit_index) and unit_index > 0) then
		script_error(self.id .. " ERROR: remove_ping_icon() called but supplied unit index [" .. tostring(unit_index) .. "] is not a number > 0 or nil");
		return false;
	end;

	if unit_index > self.sunits:count() then
		script_error(self.id .. " ERROR: remove_ping_icon() called with unit index [" .. tostring(unit_index) .. "] but this is greater than the number of units in this army [" .. self.sunits:count() .. "]");
		return false;
	end;
	
	self.sunits:item(unit_index):remove_ping_icon();
end;


--- @function teleport_to_start_location_offset
--- @desc Teleports the generated army to a position offset from its start location. Supply no offset to teleport it directly to its start location.
--- @p [opt=0] @number x offset
--- @p [opt=0] @number z offset
function generated_army:teleport_to_start_location_offset(x_offset, z_offset)
	x_offset = x_offset or 0;
	z_offset = z_offset or 0;

	if not is_number(x_offset) then
		script_error(self.id .. " ERROR: teleport_to_start_location_offset() called but supplied x_offset [" .. tostring(x_offset) .. "] is not a number");
		return false;
	end;
	
	if not is_number(z_offset) then
		script_error(self.id .. " ERROR: teleport_to_start_location_offset() called but supplied z_offset [" .. tostring(z_offset) .. "] is not a number");
		return false;
	end;
	
	local sunits = self.sunits;
	
	if x_offset == 0 and z_offset == 0 then
		-- there is no offset, teleport to start location
		sunits:teleport_to_start_location();
	else
		-- there is an offset so teleport to there
		sunits:teleport_to_start_location_offset(x_offset, z_offset);
	end;
end;


--- @function goto_start_location
--- @desc Instructs all the units in a generated army to move to the position/angle/width at which they started the battle.
--- @p [opt=false] @boolean move fast
function generated_army:goto_start_location(should_run)
	self.sunits:goto_start_location(should_run);
end;


--- @function goto_location_offset
--- @desc Instructs all units in a generated army to go to a location offset from their current position. Supply a numeric x/z offset and a boolean argument specifying whether they should run.
--- @p @number x offset, x offset in m
--- @p @number x offset, z offset in m
--- @p [opt=false] @boolean move fast
function generated_army:goto_location_offset(x_offset, z_offset, should_run)
	should_run = not not should_run;
	
	self.sunits:goto_location_offset(x_offset, z_offset, should_run);
end;


-- Start some behaviour related to the internal scripted_ai_planner, and cache the callback so that it can be called again internally
function generated_army:start_sai_behaviour(callback)
	self.last_sai_behaviour_callback = callback;
	callback();
end;


-- Perform the last cached sai callback again, in order to re-issue the last scripted ai order
function generated_army:restart_last_sai_behaviour()
	if not self.last_sai_behaviour_callback then
		script_error("WARNING: restart_last_sai_behaviour() called but no sai behaviour has been cached. Nothing will happen");
		return false;
	end;

	self.last_sai_behaviour_callback();
end;


--- @function move_to_position
--- @desc Instructs all units in a generated army to move to a position under control of a @script_ai_planner. See @script_ai_planner:move_to_position.
--- @p @battle_vector position
function generated_army:move_to_position(position, no_debug_output)
	-- ensure we have built our allied and enemy forces
	self:get_allied_and_enemy_forces();
	
	if self.is_debug and not no_debug_output then
		bm:out(self.id .. ":move_to_position(" .. v_to_s(position) .. ") called");
	end;
	
	-- Ensure script planner is set up
	self:set_up_script_planner();
	
	-- issue the order
	self:start_sai_behaviour(function() self.script_ai_planner:move_to_position(position) end);
end;


--- @function advance
--- @desc Instructs all units in a generated army to advance upon the enemy.
function generated_army:advance(no_debug_output)
	-- ensure we have built our allied and enemy forces
	self:get_allied_and_enemy_forces();
	
	if self.is_debug and not no_debug_output then
		bm:out(self.id .. ":advance() called");
	end;
	
	-- Ensure script planner is set up
	self:set_up_script_planner();
	
	-- issue the order
	self:start_sai_behaviour(function() self.script_ai_planner:move_to_force(self.enemy_force) end);
end;


--- @function attack
--- @desc Instructs all units in a generated army to attack the enemy.
function generated_army:attack(no_debug_output)
	-- ensure we have built our allied and enemy forces
	self:get_allied_and_enemy_forces();
	
	if self.is_debug and not no_debug_output then
		bm:out(self.id .. ":attack() called");
	end;
	
	-- Ensure script planner is set up
	self:set_up_script_planner();
	
	self:start_sai_behaviour(function() self.script_ai_planner:attack_force(self.enemy_force) end);
end;


--- @function attack_force
--- @desc Instructs all units in a generated army to attack a specific enemy force.
--- @p @script_units enemy force
function generated_army:attack_force(enemy_force)
	-- ensure we have built our allied and enemy forces
	self:get_allied_and_enemy_forces();
	
	if self.is_debug then
		bm:out(self.id .. ":attack_force() called, target is " .. enemy_force.script_name);
	end;
	
	-- Ensure script planner is set up
	self:set_up_script_planner();
	
	-- use move_to_force instead of attack_force, as the latter gets tripped-up by visibility
	-- self:start_sai_behaviour(function() self.script_ai_planner:attack_force(enemy_force) end);
	self:start_sai_behaviour(function() self.script_ai_planner:move_to_force(enemy_force) end);
end;


--- @function rush
--- @desc Instructs all units in a generated army to rush the enemy, ie move fast, attack without forming up
function generated_army:rush(no_debug_output)
	-- ensure we have built our allied and enemy forces
	self:get_allied_and_enemy_forces();
	
	if self.is_debug and not no_debug_output then
		bm:out(self.id .. ":rush() called");
	end;
	
	-- Ensure script planner is set up
	self:set_up_script_planner();
	
	self:start_sai_behaviour(function() self.script_ai_planner:rush_force(self.enemy_force) end);
end;


--- @function defend
--- @desc Instructs all units in a generated army to defend a position.
--- @p @number x co-ordinate, x co-ordinate in m
--- @p @number y co-ordinate, y co-ordinate in m
--- @p @number radius
function generated_army:defend(x, y, radius, no_debug_output)
	if self.is_debug and not no_debug_output then
		bm:out(self.id .. ":defend() called, defending position [" .. x .. ", " .. y .. "] with radius " .. radius .. "m");
	end;
	
	-- Ensure script planner is set up
	self:set_up_script_planner();
	
	self:start_sai_behaviour(function() self.script_ai_planner:defend_position(v(x, y), radius) end);
end;


--- @function release
--- @desc Instructs the generated army to release control of all its units to the player/general ai.
function generated_army:release(no_debug_output)
	if self.is_debug and not no_debug_output then
		bm:out(self.id .. ":release() called, releasing controlled units to the AI");
	end;

	-- release control of our sunits to the AI
	self:release_control_of_all_sunits();
end;











----------------------------------------------------------------------------
---	@section Message Listeners
--- @desc These functions listen for messages and issue commands to the generated army on their receipt. They are intended to be the primary method of causing armies to follow orders on the battlefield during open gameplay - use these instead of issuing direct orders where possible.
----------------------------------------------------------------------------


--- @function teleport_to_start_location_offset_on_message
--- @desc Teleports the units in the army to their start position with the supplied offset when the supplied message is received.
--- @p @string message
--- @p @number x offset, x offset in m
--- @p @number y offset y offset in m
function generated_army:teleport_to_start_location_offset_on_message(message, x_offset, z_offset)
	if not is_string(message) then
		script_error(self.id .. " ERROR: teleport_to_start_location_offset_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	-- set up a listener for this message
	self.sm:add_listener(
		message, 
		function() 
			bm:out(self.id .. " responding to message " .. message .. ", teleporting to start location (offset: [" .. x_offset .. ", " .. z_offset .. "]");
			self:teleport_to_start_location_offset(x_offset, z_offset);
		end
	)
end;


--- @function goto_start_location_on_message
--- @desc Instructs the units in the army to move to the locations they started the battle at when the supplied message is received.
--- @p @string message
--- @p [opt=false] @boolean move fast
function generated_army:goto_start_location_on_message(message, should_run)
	if not is_string(message) then
		script_error(self.id .. " ERROR: goto_start_location_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	-- set up a listener for this message
	self.sm:add_listener(
		message, 
		function() 
			bm:out(self.id .. " responding to message " .. message .. ", moving to start location");
			self:goto_start_location(should_run)
		end
	)
end;


--- @function goto_location_offset_on_message
--- @desc Instructs the units in the army to move relative to their current locations when the supplied message is received.
--- @p @string message
--- @p @number x offset, x offset in m
--- @p @number z offset, z offset in m
--- @p @boolean move fast
function generated_army:goto_location_offset_on_message(message, x_offset, z_offset, should_run)
	if not is_string(message) then
		script_error(self.id .. " ERROR: goto_location_offset_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	-- set up a listener for this message
	self.sm:add_listener(
		message, 
		function() 
			bm:out(self.id .. " responding to message " .. message .. ", moving to location offset [" .. x_offset .. ", " .. z_offset .. "]");
			self:goto_location_offset(x_offset, z_offset, should_run);
		end
	)
end;


--- @function set_enabled_on_message
--- @desc Sets the enabled status of a generated army on receipt of a message.
--- @p @string message
--- @p @boolean enabled
function generated_army:set_enabled_on_message(message, value)
	value = not not value;
	
	-- set up a listener for this message
	self.sm:add_listener(
		message, 
		function() 
			bm:out(self.id .. " responding to message " .. message .. ", setting enabled: " .. tostring(value));
			self:set_enabled(value);
		end
	)
end;


--- @function set_formation_on_message
--- @desc Sets the formation of the units in the generated army to the supplied formation on receipt of a message. For valid formation strings, see documentation for @script_units:change_formation.
--- @p @string message, Message.
--- @p @string formation, Formation name.
--- @p @boolean release, set to <code>true</code> to release script control after issuing the command. Set this if the command is happening to the player's army.
function generated_army:set_formation_on_message(message, formation, release_afterwards)
	if not is_string(message) then
		script_error(self.id .. " ERROR: set_formation_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	if not is_string(formation) then
		script_error(self.id .. " ERROR: set_formation_on_message() called but supplied formation name [" .. tostring(formation) .. "] is not a string");
		return false;
	end;
	
	release_afterwards = not not release_afterwards;
	
	self.sm:add_listener(
		message,
		function()
			bm:out(self.id .. " responding to message " .. message .. ", changing unit formation to " .. formation);
			self.uc:change_group_formation(formation);
			
			if release_afterwards then
				self.uc:release_control();
			end;
		end
	);	
end;


--- @function move_to_position_on_message
--- @desc Instructs all units in a generated army to move to a position under control of a @script_ai_planner on receipt of a message. See @generated_army:move_to_position.
--- @p @string message
--- @p @battle_vector position
function generated_army:move_to_position_on_message(message, position)
	if not is_string(message) then
		script_error(self.id .. " ERROR: move_to_position_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	if not is_vector(position) then
		script_error(self.id .. " ERROR: move_to_position_on_message() called but supplied position [" .. tostring(position) .. "] is not a vector");
		return false;
	end;
		
	-- set up a listener for this message
	self.sm:add_listener(
		message, 
		function() 
			bm:out(self.id .. " responding to message " .. message .. ", being told to move to position " .. v_to_s(position));
			self:move_to_position(position);
		end
	)
end;


--- @function advance_on_message
--- @desc Orders the units in the generated army to advance on the enemy upon receipt of a supplied message.
--- @p @string message, Message.
--- @p [opt=0] @number wait offset, Time to wait in ms after receipt of the message before issuing the advance order.
function generated_army:advance_on_message(message, wait_offset)
	if not is_string(message) then
		script_error(self.id .. " ERROR: advance_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	if is_nil(wait_offset) then
		wait_offset = 0;
	elseif not is_number(wait_offset) or wait_offset < 0 then
		script_error(self.id .. " ERROR: advance_on_message() called but supplied wait_offset [" .. tostring(wait_offset) .. "] is not a positive number");
		return false;
	end;
		
	-- set up a listener for this message
	self.sm:add_listener(
		message, 
		function()
			if wait_offset == 0 then
				bm:out(self.id .. " responding to message " .. message .. ", being told to advance");
				self:advance(true);
			else
				bm:out(self.id .. " responding to message " .. message .. ", being told to advance - will wait " .. wait_offset .. "ms before issuing order");
				bm:callback(
					function()
						self:advance(true);
					end,
					wait_offset
				);
			end;
		end
	);
end;


--- @function attack_on_message
--- @desc Orders the units in the generated army to attack the enemy upon receipt of a supplied message.
--- @p @string message, Message.
--- @p [opt=0] @number wait offset, Time to wait after receipt of the message before issuing the attack order.
function generated_army:attack_on_message(message, wait_offset)
	if not is_string(message) then
		script_error(self.id .. " ERROR: attack_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	if is_nil(wait_offset) then
		wait_offset = 0;
	elseif not is_number(wait_offset) or wait_offset < 0 then
		script_error(self.id .. " ERROR: attack_on_message() called but supplied wait_offset [" .. tostring(wait_offset) .. "] is not a positive number");
		return false;
	end;
		
	-- set up a listener for this message
	self.sm:add_listener(
		message, 
		function()
			if wait_offset == 0 then
				bm:out(self.id .. " responding to message " .. message .. ", being told to attack");
				self:attack(true);
			else
				bm:out(self.id .. " responding to message " .. message .. ", being told to attack - will wait " .. wait_offset .. "ms before issuing order");
				bm:callback(
					function()
						self:attack(true);
					end,
					wait_offset
				);
			end;
		end
	);
end;


--- @function rush_on_message
--- @desc Orders the units in the generated army to rush the enemy upon receipt of a supplied message.
--- @p @string message, Message.
--- @p [opt=0] @number wait offset, Time to wait after receipt of the message before issuing the rush order.
function generated_army:rush_on_message(message, wait_offset)
	if not is_string(message) then
		script_error(self.id .. " ERROR: rush_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	if is_nil(wait_offset) then
		wait_offset = 0;
	elseif not is_number(wait_offset) or wait_offset < 0 then
		script_error(self.id .. " ERROR: rush_on_message() called but supplied wait_offset [" .. tostring(wait_offset) .. "] is not a positive number");
		return false;
	end;
		
	-- set up a listener for this message
	self.sm:add_listener(
		message, 
		function()
			if wait_offset == 0 then
				bm:out(self.id .. " responding to message " .. message .. ", being told to rush");
				self:rush(true);
			else
				bm:out(self.id .. " responding to message " .. message .. ", being told to rush - will wait " .. wait_offset .. "ms before issuing order");
				bm:callback(
					function()
						self:rush(true);
					end,
					wait_offset
				);
			end;
		end
	);
end;


--- @function attack_force_on_message
--- @desc Orders the units in the generated army to attack a specified enemy force upon receipt of a supplied message.
--- @p @string message, Message.
--- @p @generated_army target, Target force.
--- @p [opt=0] @number wait offset, Time to wait after receipt of the message before issuing the attack order.
function generated_army:attack_force_on_message(message, enemy_force, wait_offset)
	if not is_string(message) then
		script_error(self.id .. " ERROR: attack_force_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	if not is_generatedarmy(enemy_force) then
		script_error(self.id .. " ERROR: attack_force_on_message() called but supplied enemy force [" .. tostring(enemy_force) .. "] is not a generated army");
		return false;
	end;
	
	if enemy_force.alliance_index == self.alliance_index then
		script_error(self.id .. " ERROR: attack_force_on_message() called but supplied enemy force [" .. tostring(enemy_force) .. "] is an ally");
		return false;
	end;
	
	if is_nil(wait_offset) then
		wait_offset = 0;
	elseif not is_number(wait_offset) or wait_offset < 0 then
		script_error(self.id .. " ERROR: attack_force_on_message() called but supplied wait_offset [" .. tostring(wait_offset) .. "] is not a positive number or nil");
		return false;
	end;
	
	self.sm:add_listener(
		message,
		function()
			bm:callback(
				function()
					bm:out(self.id .. " responding to message " .. message .. ", being told to attack enemy force with script name " .. enemy_force.script_name);
					
					self:attack_force(enemy_force.sunits);
				end,
				wait_offset
			);
		end
	);
end;


--- @function defend_on_message
--- @desc Orders the units in the generated army to defend a specified position upon receipt of a supplied message.
--- @p @string message, Message.
--- @p @number x co-ordinate, x co-ordinate in m.
--- @p @number x co-ordinate, y co-ordinate in m.
--- @p @number radius, Defence radius.
--- @p [opt=0] @number wait offset, Time to wait after receipt of the message before issuing the defend order.
function generated_army:defend_on_message(message, x, y, radius, wait_offset)
	if not is_string(message) then
		script_error(self.id .. " ERROR: defend_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	if not is_number(x) then
		script_error(self.id .. " ERROR: defend_on_message() called but supplied x co-ordinate [" .. tostring(x) .. "] is not a number");
		return false;
	end;
	
	if not is_number(y) then
		script_error(self.id .. " ERROR: defend_on_message() called but supplied y co-ordinate [" .. tostring(y) .. "] is not a number");
		return false;
	end;
	
	if not is_number(radius) then
		script_error(self.id .. " ERROR: defend_on_message() called but supplied radius [" .. tostring(radius) .. "] is not a number");
		return false;
	end;
	
	if is_nil(wait_offset) then
		wait_offset = 0;
	elseif not is_number(wait_offset) or wait_offset < 0 then
		script_error(self.id .. " ERROR: defend_on_message() called but supplied wait_offset [" .. tostring(wait_offset) .. "] is not a positive number or nil");
		return false;
	end;
	
	-- set up a listener for this message
	self.sm:add_listener(
		message, 
		function() 
			bm:callback(
				function()
					bm:out(self.id .. " responding to message message " .. message .. ", being told to defend [" .. tostring(x) .. ", " .. tostring(y) .. "] with radius " .. tostring(radius));
					self:defend(x, y, radius, true);
				end,
				wait_offset
			);
		end
	)
end;


--- @function release_on_message
--- @desc Releases script control of the units in the generated army to the player/general AI upon receipt of a supplied message.
--- @p @string message, Message.
--- @p [opt=0] @number wait offset, Time to wait after receipt of the message before the units are released.
function generated_army:release_on_message(message, wait_offset)
	if not is_string(message) then
		script_error(self.id .. " ERROR: release_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	if is_nil(wait_offset) then
		wait_offset = 0;
	elseif not is_number(wait_offset) or wait_offset < 0 then
		script_error(self.id .. " ERROR: defend_on_message() called but supplied wait_offset [" .. tostring(wait_offset) .. "] is not a positive number or nil");
		return false;
	end;
	
	-- set up a listener for this message
	self.sm:add_listener(
		message, 
		function() 
			bm:callback(
				function()
					bm:out(self.id .. " responding to message " .. message .. ", being released to AI");
					self:release(true);
				end,
				wait_offset
			);
		end
	)
end;


--- @function reinforce_on_message
--- @desc Prevents the units in the generated army from entering the battlefield as reinforcements until the specified message is received, at which point they are deployed.
--- @p @string message, Message.
--- @p [opt=0] @number wait offset, Time to wait after receipt of the message before issuing the reinforce order.
--- @p [opt=nil] @number wave index, Set an integer value to notify the game that this is a new wave in a survival battle.
--- @p [opt=false] @boolean is final wave, Set this to <code>true</code> to notify the game that this is the final wave in a survival battle. This value is disregarded if no wave index is specified.
function generated_army:reinforce_on_message(message, wait_offset, survival_battle_wave_index, is_final_survival_battle_wave)
	if not is_string(message) then
		script_error(self.id .. " ERROR: reinforce_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	if is_nil(wait_offset) then
		wait_offset = 0;
	elseif not is_number(wait_offset) or wait_offset < 0 then
		script_error(self.id .. " ERROR: reinforce_on_message() called but supplied wait offset [" .. tostring(wait_offset) .. "] is not a positive number");
		return false;
	end;

	if survival_battle_wave_index and (not is_number(survival_battle_wave_index) or survival_battle_wave_index < 0) then
		script_error(self.id .. " ERROR: reinforce_on_message() called but supplied survival battle wave index [" .. tostring(survival_battle_wave_index) .. "] is not a positive number or nil");
		return false;
	end;
	
	bm:out(self.id .. " is being prevented from reinforcing");
	
	self.sunits:deploy_reinforcement(false);
		
	self.sm:add_listener(
		message,
		function()
			bm:callback(
				function()
					if survival_battle_wave_index then
						bm:out(self.id .. " responding to message " .. message .. ", being told to reinforce as a new enemy wave with index " .. tostring(survival_battle_wave_index) .. is_final_survival_battle_wave and ", this is the final wave" or ", this is not the final wave");
						bm:notify_wave_state_changed(survival_battle_wave_index, "incoming", not not is_final_survival_battle_wave);
					else
						bm:out(self.id .. " responding to message " .. message .. ", being told to reinforce");
					end;
					self.sunits:deploy_reinforcement(true);
				end,
				wait_offset
			);
		end
	);
end;


--- @function rout_over_time_on_message
--- @desc Routs the units in the generated army over the specified time period upon receipt of a supplied message. See @script_units:rout_over_time.
--- @p @string message, Message.
--- @p @number period in ms, Period over which the units in the generated army should rout, in ms.
function generated_army:rout_over_time_on_message(message, period)
	if not is_string(message) then
		script_error(self.id .. " ERROR: rout_over_time_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	if not is_number(period) then
		script_error(self.id .. " ERROR: rout_over_time_on_message() called but supplied period [" .. tostring(period) .. "] is not a number");
		return false;
	end;
	
	if period < 0 then
		script_error(self.id .. " ERROR: rout_over_time_on_message() called but supplied period [" .. tostring(period) .. "] is not a positive number");
		return false;
	end;
		
	self.sm:add_listener(
		message,
		function()
			bm:out(self.id .. " responding to message " .. message .. ", routing all units over a period of " .. period .. "ms");
			self.sunits:rout_over_time(period);
		end
	);
end;


--- @function prevent_rallying_if_routing_on_message
--- @desc Prevents the units in the generated army from rallying if they ever rout upon receipt of a supplied message. See @script_unit:prevent_rallying_if_routing.
--- @p @string message, Message.
function generated_army:prevent_rallying_if_routing_on_message(message)
	if not is_string(message) then
		script_error(self.id .. " ERROR: prevent_rallying_if_routing_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
		
	self.sm:add_listener(
		message,
		function()
			bm:out(self.id .. " responding to message " .. message .. ", preventing rallying if routing");
			self.sunits:prevent_rallying_if_routing(true);
		end
	);
end;


--- @function withdraw_on_message
--- @desc Withdraw the units in the generated army upon receipt of a supplied message.
--- @p @string message, Message.
function generated_army:withdraw_on_message(message)
	if not is_string(message) then
		script_error(self.id .. " ERROR: withdraw_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	self.sm:add_listener(
		message,
		function()
			bm:out(self.id .. " responding to message " .. message .. ", withdrawing units");
			self.sunits:withdraw(true);
		end
	);
end;


--- @function set_melee_mode_on_message
--- @desc Activates or deactivates melee mode on units within the generated army on receipt of a supplied message. An additional flag specifies whether script control of the units should be released afterwards - set this to true if the player is controlling this army.
--- @p @string message, Message.
--- @p [opt=true] @boolean activate, Should activate melee mode.
--- @p [opt=false] @boolean release, Release script control afterwards.
function generated_army:set_melee_mode_on_message(message, activate, should_release)
	if not is_string(message) then
		script_error(self.id .. " ERROR: set_melee_mode_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	self.sm:add_listener(
		message,
		function()
			bm:out(self.id .. " responding to message " .. message .. ", setting melee mode for all units to " .. tostring(activate));
			self.sunits:set_melee_mode(activate, should_release);
			if should_release then
				bm:out("\talso releasing script control");
				self.sunits:release_control();
			end;
		end
	);
end;


--- @function use_army_special_ability_on_message
--- @desc Instructs the logical @battle_army associated with the first unit in this <code>generated_army</code> to use the supplied special ability, upon receipt of the supplied message. An optional position, orientation and width may be specified for the army special ability. A delay may also be specified, in which case an interval in ms will be waited between the message being received and the ability being used.
--- @p @string message, Message.
--- @p @string special ability key, Special ability key, from the <code>army_special_abilities</code> table.
--- @p [opt=nil] @battle_vector position, Position to trigger special ability with, if applicable.
--- @p [opt=nil] @number orientation, Orientation to trigger special ability with, if applicable. This is specified in radians.
--- @p [opt=nil] @number width, Width in m to trigger special ability with, if applicable.
--- @p [opt=0] @number delay, Delay in ms to wait after receiving the message before triggering the ability.
function generated_army:use_army_special_ability_on_message(message, special_ability_key, position, orientation, width, wait_period)
	if not is_string(message) then
		script_error(self.name .. " ERROR: use_army_special_ability_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;

	if not is_string(special_ability_key) then
		script_error(self.name .. " ERROR: use_army_special_ability_on_message() called but supplied special ability key [" .. tostring(special_ability_key) .. "] is not a string");
		return false;
	end;

	if position and not is_vector(position) then
		script_error(self.name .. " ERROR: use_army_special_ability_on_message() called but supplied position [" .. tostring(position) .. "] is not a vector or nil");
		return false;
	end;

	if orientation and not is_number(orientation) then
		script_error(self.name .. " ERROR: use_army_special_ability_on_message() called but supplied orientation [" .. tostring(orientation) .. "] is not a number or nil");
		return false;
	end;

	if width and not is_number(width) then
		script_error(self.name .. " ERROR: use_army_special_ability_on_message() called but supplied width [" .. tostring(width) .. "] is not a number or nil");
		return false;
	end;

	if wait_period and (not is_number(wait_period) or wait_period < 0) then
		script_error(self.name .. " ERROR: use_army_special_ability_on_message() called but supplied wait period [" .. tostring(wait_period) .. "] is not a positive number or nil");
		return false;
	end;

	self.sm:add_listener(
		message,
		function()
			local function callback()
				local out_str = false;
				local army = self.sunits:item(1):army();

				if wait_period and wait_period > 0 then
					out_str = self.id .. " has waited " .. wait_period .. "ms after message " .. message .. " received";
				else
					out_str = self.id .. " responding to message " .. message;
				end;

				out_str = out_str .. ", triggering special ability with key " .. special_ability_key;
				
				if position then
					out_str = out_str .. " at position " .. v_to_s(position); 
					if orientation then
						if width then
							out_str = out_str .. ", orientation " .. orientation .. ", and width " ..  width;
							army:use_special_ability(special_ability_key, position, orientation, width);
						else
							out_str = out_str .. ", orientation " .. orientation;
							army:use_special_ability(special_ability_key, position, orientation);
						end;
					else
						army:use_special_ability(special_ability_key, position);
					end;

				else
					army:use_special_ability(special_ability_key);
				end;

				bm:out(out_str);
			end;

			if wait_period and wait_period > 0 then
				bm:callback(callback, wait_period);
			else
				callback();
			end;
		end
	);
end;


--- @function change_behaviour_active_on_message
--- @desc Activates or deactivates a supplied behaviour on units within the generated army on receipt of a supplied message. An additional flag specifies whether script control of the units should be released afterwards - set this to true if the player is controlling this army.
--- @p @string message, Message.
--- @p @string behaviour, Behaviour to activate or deactivate. See documentation on @script_unit:change_behaviour_active for a list of valid values.
--- @p [opt=true] @boolean activate, Should activate behaviour.
--- @p [opt=false] @boolean release, Release script control afterwards.
function generated_army:change_behaviour_active_on_message(message, behaviour, activate, should_release)
	if not is_string(message) then
		script_error(self.id .. " ERROR: change_behaviour_active_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	if not is_string(behaviour) then
		script_error(self.id .. " ERROR: change_behaviour_active_on_message() called but supplied behaviour [" .. tostring(behaviour) .. "] is not a string");
		return false;
	end;
	
	self.sm:add_listener(
		message,
		function()
			bm:out(self.id .. " responding to message " .. message .. ", setting behaviour " .. behaviour .. " for all units to " .. tostring(activate));
			self.sunits:change_behaviour_active(behaviour, activate, should_release);
		end
	);
end;


--- @function set_invincible_on_message
--- @desc Sets the units in the generated army to be invincible and fearless upon receipt of a supplied message. If the enable flag is set to false then the effect is undone, removing invincibility and setting morale behaviour to default.
--- @p @string message
--- @p [opt=true] @boolean enable effect
function generated_army:set_invincible_on_message(message, value)
	if not is_string(message) then
		script_error(self.id .. " ERROR: set_invincible_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;

	if value ~= false then
		value = true;
	end;
	
	self.sm:add_listener(
		message,
		function()
			if value then
				bm:out(self.id .. " responding to message " .. message .. ", making all currently-standing units invincible and fearless");
				self.sunits:invincible_if_standing();
			else
				bm:out(self.id .. " responding to message " .. message .. ", making all currently-standing units not-invincible and setting their morale to default");
				self.sunits:set_invincible(false);
				self.sunits:morale_behavior_default();
			end;
		end
	);
end;


--- @function refresh_on_message
--- @desc Refreshes the ammunition and fatigue of units in the generated army upon receipt of a supplied message.
--- @p @string message
function generated_army:refresh_on_message(message)
	if not is_string(message) then
		script_error(self.id .. " ERROR: refresh_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	self.sm:add_listener(
		message,
		function()
			bm:out(self.id .. " responding to message " .. message .. ", refreshing units");
			self.sunits:refresh(true);
		end
	);
end;


--- @function deploy_at_random_intervals_on_message
--- @desc Prevents the units in the generated army from deploying as reinforcements when called, and instructs them to enter the battlefield in random chunks upon receipt of a supplied message. Supply min/max values for the number of units to be deployed at one time, and a min/max period between deployment chunks. Each chunk will be of a random size between the supplied min/max, and will deploy onto the battlefield at a random interval between the supplied min/max period after the previous chunk. This process will repeat until all units in the generated army are deployed, or until the cancel message is received. See @script_units:deploy_at_random_intervals for more information.
--- @desc A cancel message may also be supplied, which will stop the reinforcement process either before or after the trigger message is received.
--- @p @string message, Trigger message.
--- @p @number min units, Minimum number of units to deploy in chunk.
--- @p @number max units, Maximum number of units to deploy in chunk.
--- @p @string min period, Minimum duration between chunks.
--- @p @string max period, Maximum duration between chunks.
--- @p [opt=nil] @string cancel message, Cancel message. If specified, this stops the deployment once received.
--- @p [opt=false] @boolean spawn immediately, Spawns the first wave immediately.
--- @p [opt=false] @boolean allow respawning, Allow units to respawn that have previously been deployed.
--- @p [opt=nil] @number wave index, Set an integer value to notify the game that this is a new wave in a survival battle.
--- @p [opt=false] @boolean is final wave, Set this to <code>true</code> to notify the game that this is the final wave in a survival battle. This value is disregarded if no wave index is specified.
--- @p [opt=false] @boolean ongoing output, Generate ongoing debug output as units are deployed.
function generated_army:deploy_at_random_intervals_on_message(message, min_units, max_units, min_period, max_period, cancel_message, spawn_first_wave_immediately, allow_respawning, survival_battle_wave_index, is_final_battle_survival_wave, show_debug_output)
	if not is_string(message) then
		script_error(self.id .. " ERROR: deploy_at_random_intervals_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	if not is_nil(cancel_message) and not is_string(cancel_message) then
		script_error("generated_battle ERROR: deploy_at_random_intervals_on_message() called but supplied cancellation message [" .. tostring(cancel_message) .. "] is not a string");
		return false;
	end;
	
	--[[
	bm:out(self.id .. " is being prevented from reinforcing");
	self.sunits:deploy_reinforcement(false);
	]]
	
	local cancel_message_received = false;
	
	self.sm:add_listener(
		message,
		function()
			if not cancel_message_received then
				if survival_battle_wave_index then
					bm:out(self.id .. " responding to message " .. message .. ", starting to deploy reinforcements at random intervals as a new survival battle wave with index " .. tostring(survival_battle_wave_index) .. (is_final_battle_survival_wave and ", this is the final wave" or ", this is not the final wave") .. (allow_respawning and ", respawning is enabled" or ""));
					bm:notify_wave_state_changed(survival_battle_wave_index, "incoming", not not is_final_battle_survival_wave);
				else
					bm:out(self.id .. " responding to message " .. message .. ", starting to deploy reinforcements at random intervals" .. (allow_respawning and ", respawning is enabled" or ""));
				end;
				self.sunits:deploy_at_random_intervals(
					min_units, 
					max_units,
					min_period,
					max_period, 
					show_debug_output, 
					spawn_first_wave_immediately,
					allow_respawning,
					function(sunits)
						-- Once each unit has deployed, remove it from and re-add it to the internal script ai planner, as it doesn't seem to like respawned units otherwise
						for i = 1, #sunits do
							local current_sunit = sunits[i];
							bm:watch(
								function()
									return has_deployed(current_sunit.unit);
								end,
								0,
								function()
									if self.script_ai_planner then
										self.script_ai_planner:remove_sunits(current_sunit);
										self.script_ai_planner:add_sunits(current_sunit);

										-- Reinitiate the last ai behaviour
										self:restart_last_sai_behaviour();
									end;
								end,
								self.id .. "_deploy_at_random_intervals_on_message"
							);
						end;
					end
				);
			end;
		end,
		0
	);
	
	if cancel_message then
		self.sm:add_listener(
			cancel_message,
			function()
				bm:out("generated_battle:deploy_at_random_intervals_on_message() has received cancellation message " .. cancel_message .. " so will stop trickling reinforcements");
				self.sunits:cancel_deploy_at_random_intervals();
				bm:remove_process(self.id .. "_deploy_at_random_intervals_on_message");
				cancel_message_received = true;
			end
		);
	end
end;


--- @function assign_to_spawn_zone_from_collection_on_message
--- @desc Assigns this army to a random spawn zone from the supplied collection on receipt of the supplied message. This will make units that deploy onto the battlefield from this army come on from the position of the spawn zone that is chosen. The spawn zone collection is a bespoke table data type - see the functions listed in the @"battle_manager:Spawn Zone Collections" section of this documentation for more information.
--- @desc It is valid to call this function while the army is partially deployed. In this case, units that subsequently deploy will enter the battlefield from the position of the new spawn zone. This functiom may be used in conjuction with other functions such as @generated_army:message_on_number_deployed, which broadcasts script messages when a certain number of units have deployed from the army. This function switches spawn zones in response to these messages, so that the enemy force appears from multiple directions. To facilitate this behaviour, this function persists in listening for its message after the message is first received, which is uncommon behaviour amongst generated battle message listeners.
--- @desc Note that this function breaks the generated battle system paradigm that generated army objects can represent a subset of a logical army. Units are assigned to spawn zones on a per-logical-army basis, so if this generated army shares a logical army with another generated army, then changing the spawn zone on this generated army will also change the spawn zone for the other. To increase visibility of this issue the function will throw a script error if called on a generated army that does not control all units for its associated logical army, unless the suppress warning flag is enabled.
--- @p @string message
--- @p @table spawn zone collection
--- @p [opt=false] @boolean suppress warning
function generated_army:assign_to_spawn_zone_from_collection_on_message(message, spawn_zone_collection, suppress_warning)
	if not is_string(message) then
		script_error(self.id .. " ERROR: assign_to_spawn_zone_from_collection_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false; 
	end;

	-- we assume that if the collection is a table then it checks out...
	if not is_table(spawn_zone_collection) then
		script_error(self.id .. " ERROR: assign_to_spawn_zone_from_collection_on_message() called but supplied spawn zone collection [" .. tostring(spawn_zone_collection) .. "] is not a table");
		return false; 
	end;

	-- check that this generated army represents all units in the logical army, if we should
	if not suppress_warning and not self.represents_full_logical_army then
		script_error(self.id .. " WARNING: assign_to_spawn_zone_from_collection_on_message() called but this generated army does not represent the full logical army. As spawn zones are set per-logical army, this means that the spawn zone for units outside of this generated army will also be changed.");
	end;

	self.sm:add_listener(
		message,
		function()
			bm:out(self.id .. " responding to message " .. message .. ", assigning army to spawn zone from collection");
			out.inc_tab();
			bm:assign_army_to_spawn_zone_from_collection(self:get_reinforcement_source_army(), spawn_zone_collection, self.id);
			out.dec_tab();
		end,
		0,
		true
	);
end;


--- @function add_to_survival_battle_wave_on_message
--- @desc Adds the scriptunits in this generated army to a survival battle wave on receipt of the supplied message. This will call @battle_manager:add_survival_battle_wave and start a process which monitors these units and updates the UI as if they were a survival battle wave. Calling this has no effect on the actual behaviour of the units.
--- @desc The survival battle wave is specified by numeric index. Additional waves can be introduced by ascending index.
--- @p @string message
--- @p @number wave index
--- @p [opt=false] @boolean final wave
function generated_army:add_to_survival_battle_wave_on_message(message, wave_index, is_final_wave)
	if not is_string(message) then
		script_error(self.id .. " ERROR: add_to_survival_battle_wave_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false; 
	end;

	if not is_number(wave_index) or wave_index < 0 then
		script_error(self.id .. " ERROR: add_to_survival_battle_wave_on_message() called but supplied wave index [" .. tostring(wave_index) .. "] is not a positive number");
		return false; 
	end;

	is_final_wave = not not is_final_wave;

	self.sm:add_listener(
		message,
		function()
			if is_final_wave then
				bm:out(self.id .. " responding to message " .. message .. ", adding units to survival battle wave with index [" .. wave_index .. "]. This is the final battle wave - its defeat will end the battle.");
			else
				bm:out(self.id .. " responding to message " .. message .. ", adding units to survival battle wave with index [" .. wave_index .. "]");
			end;
			bm:add_survival_battle_wave(wave_index, self.sunits, is_final_wave);
		end,
		0
	);
end;


--- @function grant_infinite_ammo_on_message
--- @desc Continually refills the ammunition of all units in the generated army upon receipt of the supplied message.
--- @p @string message
function generated_army:grant_infinite_ammo_on_message(message)
	if not is_string(message) then
		script_error(self.id .. " ERROR: grant_infinite_ammo_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	self.sm:add_listener(
		message,
		function()
			bm:out(self.id .. " responding to message " .. message .. ", granting infinite ammo");
			self.sunits:grant_infinite_ammo();
		end,
		0
	);
end;


--- @function play_general_vo_on_message
--- @desc Plays a @battle_sound_effect associated with the army general on receipt of the supplied message. The sound will appear to come from the general unit in 3D (unless overridden in sound data), and the unit's standard VO will be suppressed while the sound is playing.
--- @p @string message, Play the sound on receipt of this message.
--- @p @battle_sound_effect sound, Sound file to play.
--- @p [opt=0] @number wait interval, Delay between receipt of the message and the supplied sound starting to play, in ms.
--- @p [opt=nil] @string end message, Message to send when the sound has finished playing.
--- @p [opt=500] @number minimum duration, Minimum duration of the sound in ms. This is only used if an end message is supplied, and is handy during development for when the sound has not yet been recorded.
function generated_army:play_general_vo_on_message(message, sound, wait_interval, message_on_finished, minimum_sound_duration)
	if not is_string(message) then
		script_error(self.id .. " ERROR: grant_infinite_ammo_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;

	if not is_battlesoundeffect(sound) then
		script_error("generated_battle ERROR: play_general_vo_on_message() called but supplied object [" .. tostring(sound) .. "] is not a battle sound effect");
		return false;
	end;

	wait_interval = wait_interval or 0;

	if message_on_finished and not is_string(message_on_finished) then
		script_error("generated_battle ERROR: play_sound_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;

	minimum_sound_duration = minimum_sound_duration or 500;
	
	self.sm:add_listener(
		message,
		function()
			bm:callback(
				function()
					bm:out(self.id .. ":play_general_vo_on_message() is responding to message " .. message .. ", playing general vo " .. tostring(sound));

					-- Play VO at the general unit if we can, or at the first unit in the army, otherwise play it behind the camera
					local sunit = self.sunits:get_general_sunit();
					if not sunit then
						sunit = self:get_first_scriptunit();
					end;

					if sunit then
						sunit:play_vo(sound);
					else
						play_sound(bm:get_origin(), sound);
					end;
					
					if not is_nil(message_on_finished) then
						-- Running through a callback so we can delay the test. If we test straight away is_playing() will always return false.
						bm:callback(
							-- Return when the sound is no longer playing. This covers for the case where a null sound has been passed in so we don't have any watches hanging around.
							function()
								bm:watch(
									function()
										return not sound:is_playing();
									end,
									0,
									function()
										bm:out(self.id .. ":play_general_vo_on_message() sound " .. tostring(sound) .. " finished. Firing message " .. message_on_finished);
										self.sm:trigger_message(message_on_finished);
									end
								);
							end,
							minimum_sound_duration
						);
					end;
				end,
				wait_interval
			);
		end
	);
end;


-- [ARMY]
--- @function add_ping_icon_on_message
--- @desc Adds a ping marker to a specified unit within the generated army upon receipt of a supplied message.
--- @p @string message, Trigger message
--- @p [opt=8] @number icon type, Icon type. This is a numeric index defined in code.
--- @p [opt=1] @number unit index, The unit to apply the ping marker to is specified by their index value within the generated army, so 1 would be the first unit (usually the general).
--- @p [opt=nil] @number duration, Duration to display the ping icon for, in ms
function generated_army:add_ping_icon_on_message(message, icon_type, unit_index, duration)
	if not is_string(message) then
		script_error(self.id .. " ERROR: add_ping_icon_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	unit_index = unit_index or 1;
	icon_type = icon_type or 8;

	if unit_index and not (is_number(unit_index) and unit_index > 0) then
		script_error(self.id .. " ERROR: add_ping_icon_on_message() called but supplied unit index [" .. tostring(unit_index) .. "] is not a number > 0 or nil");
		return false;
	end;

	if unit_index > self.sunits:count() then
		script_error(self.id .. " ERROR: add_ping_icon_on_message() called with unit index [" .. tostring(unit_index) .. "] but this is greater than the number of units in this army [" .. self.sunits:count() .. "]");
		return false;
	end;
	
	if duration and not (is_number(duration) and duration > 0) then
		script_error(self.id .. " ERROR: add_ping_icon_on_message() called but supplied duration [" .. tostring(duration) .. "] is not a positive number or nil");
		return false;
	end;
	
	if icon_type and not is_number(icon_type) then
		script_error(self.id .. " ERROR: add_ping_icon_on_message() called but supplied icon type [" .. tostring(icon_type) .. "] is not a number or nil");
		return false;
	end;
	
	-- set up a listener for this message
	self.sm:add_listener(
		message, 
		function() 
			bm:out(self.id .. " responding to message " .. message .. ", adding ping icon to unit (index: " .. unit_index .. ")");
			self:add_ping_icon(icon_type, unit_index, duration);
		end
	);
end;


-- [ARMY]
--- @function remove_ping_icon_on_message
--- @desc Removes a ping marker from a specified unit within the generated army upon receipt of a supplied message.
--- @p @string message, Trigger message
--- @p [opt=1] @number unit index, The unit to remove the ping marker from is specified by their index value within the generated army, so 1 would be the first unit (usually the general).
function generated_army:remove_ping_icon_on_message(message, unit_index)
	if not is_string(message) then
		script_error(self.id .. " ERROR: remove_ping_icon_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	unit_index = unit_index or 1;

	if unit_index and not (is_number(unit_index) and unit_index > 0) then
		script_error(self.id .. " ERROR: remove_ping_icon_on_message() called but supplied unit index [" .. tostring(unit_index) .. "] is not a number > 0 or nil");
		return false;
	end;

	if unit_index > self.sunits:count() then
		script_error(self.id .. " ERROR: remove_ping_icon_on_message() called with unit index [" .. tostring(unit_index) .. "] but this is greater than the number of units in this army [" .. self.sunits:count() .. "]");
		return false;
	end;
	
	-- set up a listener for this message
	self.sm:add_listener(
		message, 
		function() 
			bm:out(self.id .. " responding to message " .. message .. ", removing ping icon from unit (index: " .. unit_index .. ")");
			self:remove_ping_icon(unit_index);
		end
	);
end;


--- @function add_winds_of_magic_reserve_on_message
--- @desc Adds an amount to the winds of magic reserve for the generated army upon receipt of a supplied message.
--- @p @string message, Trigger message.
--- @p @number modification value, Winds of Magic modification value.
function generated_army:add_winds_of_magic_reserve_on_message(message, value)
	if not is_string(message) then
		script_error(self.id .. " ERROR: add_winds_of_magic_reserve_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	if not is_number(value) then
		script_error(self.id .. " ERROR: add_winds_of_magic_reserve_on_message() called but supplied value [" .. tostring(value) .. "] is not a number");
		return false;
	end;
	
	self.sm:add_listener(
		message,
		function()
			bm:out(self.id .. " responding to message " .. message .. ", adding [" .. value .. "] to winds of magic reserve");
			self:get_army():modify_winds_of_magic_reserve(value);
		end,
		0
	);
end;


--- @function add_winds_of_magic_on_message
--- @desc Adds an amount to the current winds of magic level for the generated army upon receipt of a supplied message.
--- @p @string message, Trigger message.
--- @p @number modification value, Winds of Magic modification value.
function generated_army:add_winds_of_magic_on_message(message, value)
	if not is_string(message) then
		script_error(self.id .. " ERROR: add_winds_of_magic_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	if not is_number(value) then
		script_error(self.id .. " ERROR: add_winds_of_magic_on_message() called but supplied value [" .. tostring(value) .. "] is not a number");
		return false;
	end;
	
	self.sm:add_listener(
		message,
		function()
			bm:out(self.id .. " responding to message " .. message .. ", adding [" .. value .. "] to winds of magic level");
			self:get_army():modify_winds_of_magic_current(value);
		end,
		0
	);
end;


--- @function set_always_visible_on_message
--- @desc On receipt of the supplied message, sets the army's visibility status to the supplied true or false value. True = the army will not be hidden by terrain LOS, false = the army can be (i.e. normal behaviour). Note that the target units will still be able to hide in forests or long grass. Also note that they may perform a fade in from the point this function is called, so may not be fully visible until several seconds later.
--- @desc If the release_control flag is set to true, control of the sunits is released after the operation is performed. Do this if the army belongs to the player, otherwise they won't be able to control them.
--- @p @string message
--- @p [opt=false] @boolean always visible
--- @p [opt=false] @boolean release control
function generated_army:set_always_visible_on_message(message, value, release_control)
	if not is_string(message) then
		script_error(self.id .. " ERROR: set_always_visible_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	value = not not value;
	release_control = not not release_control;
	
	self.sm:add_listener(
		message,
		function()
			local output_str = self.id .. ":set_always_visible_on_message() has received message " .. message .. " and is now forcing always-visible status to " .. tostring(value);
			
			if release_control then
				bm:out(output_str .. ", also releasing control");
			else
				bm:out(output_str);
			end;
			
			-- ensure we have built our allied and enemy forces
			self:get_allied_and_enemy_forces();
			
			-- set this army's visibility status
			self.sunits:set_always_visible(true);
			
			if release_control then
				self.sunits:release_control();
			end;
		end
	);
end;


--- @function enable_map_barrier_on_message
--- @desc Instructs this generated army to enable or disable a @battle_map_barrier when the specified message is received. The map barrier is specified by toggle slot script id. If no toggle slot with the supplied script id is found on the map, or the toggle slot found is not linked to a map barrier, then a script error is produced.
--- @p @string message, Change state of map barrier on receipt of this message.
--- @p @string script id, Script id specifiying the togggle slot the map barrier is linked to.
--- @p [opt=true] @boolean enable, Enable the map barrier. Specify <code>false</code> here to disable the barrier instead.
function generated_army:enable_map_barrier_on_message(message, script_id, enable)

	if not is_string(message) then
		script_error(self.id .. " ERROR: enable_map_barrier_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;

	if not is_string(script_id) then
		script_error(self.id .. " ERROR: enable_map_barrier_on_message() called but supplied script id [" .. tostring(script_id) .. "] is not a string");
		return false;
	end;

	local toggle_slot = bm:get_toggle_slot_by_script_id(script_id);

	if not toggle_slot then
		script_error(self.id .. " ERROR: enable_map_barrier_on_message() called but no toggle slot with supplied script id [" .. script_id .. "] could be found");
		return false;
	end;

	if not toggle_slot:has_map_barrier() then
		script_error(self.id .. " ERROR: enable_map_barrier_on_message() called but toggle slot with supplied script id [" .. script_id .. "] is not linked to a map barrier");
		return false;
	end;

	self.sm:add_listener(
		message,
		function()
			if enable == false then
				bm:out(self.id .. ":enable_map_barrier_on_message() is disabling the map barrier associated with toggle slot with script id [" .. script_id .. "] on receipt of message [" .. message .. "]");
				toggle_slot:map_barrier():disable(self:get_army());
			else
				bm:out(self.id .. ":enable_map_barrier_on_message() is enabling the map barrier associated with toggle slot with script id [" .. script_id .. "] on receipt of message [" .. message .. "]");
				toggle_slot:map_barrier():enable(self:get_army());
			end;
		end
	);
end;


--- @function force_victory_on_message
--- @desc Forces the enemies of the generated army to rout over time upon receipt of the supplied message. After the enemies have all routed, this generated army will win the battle.
--- @p @string message, Trigger message.
--- @p [opt=10000] @number duration, Duration over which to rout the enemy in ms.
function generated_army:force_victory_on_message(message, duration)
	if not is_string(message) then
		script_error(self.id .. " ERROR: force_victory_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	duration = duration or 10000;
	
	if not is_number(duration) or duration < 0 then
		script_error(self.id .. " ERROR: force_victory_on_message() called but supplied duration [" .. tostring(duration) .. "] is not a positive number");
		return false;
	end;
	
	self.sm:add_listener(
		message,
		function()
			bm:out(self.id .. ":force_victory_on_message() now forcing victory over " .. duration .. "ms after receiving message " .. message);
			
			-- ensure we have built our allied and enemy forces
			self:get_allied_and_enemy_forces();
			
			-- prevent the battle from ending once the enemy commander dies
			bm:change_victory_countdown_limit(-1);		-- function needs it in seconds

			-- start the enemy army routing over the duration
			self.enemy_force:rout_over_time(duration);

			-- prevent this army from routing in this time
			self.sunits:invincible_if_standing(true);

			-- allow battle to end after the duration
			bm:callback(
				function()
					bm:end_battle()
				end,
				duration
			);
		end
	);
end;


--- @function remove_on_message
--- @desc Immediately kills and removes the units in the generated army upon receipt of the supplied message.
--- @p @string message, Trigger message.
function generated_army:remove_on_message(message)
	if not is_string(message) then
		script_error(self.id .. " ERROR: remove_on_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	self.sm:add_listener(
		message,
		function()
			bm:out("generated_battle:remove_on_message() is killing and removing army after receiving message " .. message);
			
			self.sunits:kill_proportion(1, false, true);
		end
	);
end;

















----------------------------------------------------------------------------
---	@section Message Generation
--- @desc These functions listen for conditions and generate messages when they are met.
----------------------------------------------------------------------------


--- @function message_on_casualties
--- @desc Fires the supplied message when the casualty rate of this generated army equals or exceeds the supplied threshold.
--- @p @string message, Message to trigger.
--- @p @number unary threshold, Unary threshold (between 0 and 1).
function generated_army:message_on_casualties(message, threshold)
	if not is_string(message) then
		script_error(self.id .. " ERROR: message_on_casualties() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	if not is_number(threshold) then
		script_error(self.id .. " ERROR: message_on_casualties() called but supplied threshold [" .. tostring(threshold) .. "] is not a number");
		return false;
	end;
	
	-- if the battle hasn't started then put this off until it has
	if not self.generated_battle:has_battle_started() then
		self.sm:add_listener("battle_started", function() self:message_on_casualties(message, threshold) end);
		return;
	end;
	
	bm:watch(
		function()
			local current_casualty_rate = self:get_casualty_rate();
			-- bm:out(self.id .. " is checking casualty rate and found it to be " .. tostring(current_casualty_rate));
			return current_casualty_rate > threshold;
		end,
		0,
		function()
			bm:out(self.id .. " casualty rate has exceeded threshold of " .. threshold .. ", triggering script message " .. message);		
			self.sm:trigger_message(message)
		end,
		self.id
	);
end;


--- @function message_on_proximity_to_enemy
--- @desc Triggers the supplied message when this generated army finds itself with the supplied distance of its enemy.
--- @p @string message, Message to trigger.
--- @p @number threshold distance, Threshold distance in m.
function generated_army:message_on_proximity_to_enemy(message, distance)
	if not is_string(message) then
		script_error(self.id .. " ERROR: message_on_proximity_to_enemy() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	if not is_number(distance) then
		script_error(self.id .. " ERROR: message_on_proximity_to_enemy() called but supplied distance [" .. tostring(distance) .. "] is not a number");
		return false;
	end;
	
	-- if the battle hasn't started then put this off until it has
	if not self.generated_battle:has_battle_started() then
		self.sm:add_listener("battle_started", function() self:message_on_proximity_to_enemy(message, distance) end);
		return;
	end;
	
	-- ensure we have built our allied and enemy forces
	self:get_allied_and_enemy_forces();
	
	bm:watch(
		function()
			local current_distance = distance_between_forces(self.sunits, self.enemy_force, true);
			-- bm:out(self.id .. " is checking current distance to enemy and found it to be " .. tostring(current_distance) .. "m");
			return current_distance < distance;
		end,
		0,
		function()
			bm:out(self.id .. " enemy have moved within " .. distance .. "m, triggering script message " .. message);		
			self.sm:trigger_message(message);
		end,
		self.id
	);
end;


--- @function message_on_proximity_to_ally
--- @desc Triggers the supplied message when this generated army finds itself with the supplied distance of any allied generated armies.
--- @p @string message, Message to trigger.
--- @p @number threshold distance, Threshold distance in m.
function generated_army:message_on_proximity_to_ally(message, distance)
	if not is_string(message) then
		script_error(self.id .. " ERROR: message_on_proximity_to_ally() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	if not is_number(distance) then
		script_error(self.id .. " ERROR: message_on_proximity_to_ally() called but supplied distance [" .. tostring(distance) .. "] is not a number");
		return false;
	end;
	
	-- if the battle hasn't started then put this off until it has
	if not self.generated_battle:has_battle_started() then
		self.sm:add_listener("battle_started", function() self:message_on_proximity_to_ally(message, distance) end);
		return;
	end;
	
	-- ensure we have built our allied and enemy forces
	self:get_allied_and_enemy_forces();
	
	if is_nil(self.allied_force) then
		script_error(self.id .. " ERROR: message_on_proximity_to_ally() called but there is no allied force in the battle.");
		return false;
	end
	
	bm:watch(
		function()
			local current_distance = distance_between_forces(self.sunits, self.allied_force, true);
			-- bm:out(self.id .. " is checking current distance to enemy and found it to be " .. tostring(current_distance) .. "m");
			return current_distance < distance;
		end,
		0,
		function()
			bm:out(self.id .. " enemy have moved within " .. distance .. "m, triggering script message " .. message);		
			self.sm:trigger_message(message);
		end,
		self.id
	);
end;


--- @function message_on_proximity_to_position
--- @desc Triggers the supplied message when this generated army finds itself with the supplied distance of the supplied position.
--- @p @string message, Message to trigger.
--- @p @battle_vector position, Test position.
--- @p @number threshold distance, Threshold distance in m.
function generated_army:message_on_proximity_to_position(message, position, distance)
	if not is_string(message) then
		script_error(self.id .. " ERROR: message_on_proximity_to_position() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	if not is_vector(position) then
		script_error(self.id .. " ERROR: message_on_proximity_to_position() called but supplied position [" .. tostring(position) .. "] is not a vector");
		return false;
	end;
	
	if not is_number(distance) or distance <= 0 then
		script_error(self.id .. " ERROR: message_on_proximity_to_position() called but supplied distance [" .. tostring(distance) .. "] is not a positive number");
		return false;
	end;
	
	-- if the battle hasn't started then put this off until it has
	if not self.generated_battle:has_battle_started() then
		self.sm:add_listener("battle_started", function() self:message_on_proximity_to_position(message, position, distance) end);
		return;
	end;
	
	-- ensure we have built our allied and enemy forces
	self:get_allied_and_enemy_forces();
	
	bm:watch(
		function()
			return standing_is_close_to_position(self.sunits, position, distance)
		end,
		0,
		function()
			bm:out(self.id .. " has moved within " .. distance .. "m of " .. v_to_s(position) .. ", triggering script message " .. message);		
			self.sm:trigger_message(message);
		end,
		self.id
	);
end;


--- @function message_on_rout_proportion
--- @desc Triggers the supplied message when the proportion of units routing or dead in this generated army exceeds the supplied unary threshold.
--- @p @string message, Message to trigger.
--- @p @number threshold, Unary threshold (0 - 1).
--- @p [opt=false] @boolean permit rampaging, Permit rampaging, so that rampaging units are considered to be still controllable/not-routing. By default, rampaging units are considered to be routing.
function generated_army:message_on_rout_proportion(message, threshold, permit_rampaging)
	if not is_string(message) then
		script_error(self.id .. " ERROR: message_on_rout_proportion() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	if not is_number(threshold) then
		script_error(self.id .. " ERROR: message_on_rout_proportion() called but supplied threshold [" .. tostring(threshold) .. "] is not a number");
		return false;
	end;
	
	-- if the battle hasn't started then put this off until it has
	if not self.generated_battle:has_battle_started() then
		self.sm:add_listener("battle_started", function() self:message_on_rout_proportion(message, threshold, permit_rampaging) end);
		return;
	end;
	
	bm:watch(
		function()
			local current_rout_proportion = self:get_rout_proportion(permit_rampaging);
			-- bm:out(self.id .. " is checking rout proportion and found it to be " .. tostring(current_rout_proportion));		
			return current_rout_proportion >= threshold;
		end,
		0,
		function()
			bm:out(self.id .. " rout proportion has exceeded threshold of " .. threshold .. ", triggering script message " .. message);
			self.sm:trigger_message(message)
		end,
		self.id
	);
end;


--- @function message_on_shattered_proportion
--- @desc Triggers the supplied message when the proportion of units that are shattered in this generated army exceeds the supplied unary threshold.
--- @p @string message, Message to trigger.
--- @p @number threshold, Unary threshold (0 - 1).
--- @p [opt=false] @boolean permit rampaging, Permit rampaging, so that rampaging units are considered to be still controllable/not-routing. By default, rampaging units are considered to be routing.
function generated_army:message_on_shattered_proportion(message, threshold, permit_rampaging)
	if not is_string(message) then
		script_error(self.id .. " ERROR: message_on_shattered_proportion() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	if not is_number(threshold) then
		script_error(self.id .. " ERROR: message_on_shattered_proportion() called but supplied threshold [" .. tostring(threshold) .. "] is not a number");
		return false;
	end;
	
	-- if the battle hasn't started then put this off until it has
	if not self.generated_battle:has_battle_started() then
		self.sm:add_listener("battle_started", function() self:message_on_shattered_proportion(message, threshold, permit_rampaging) end);
		return;
	end;
	
	bm:watch(
		function()
			local current_shattered_proportion = self:get_shattered_proportion(permit_rampaging);
			-- bm:out(self.id .. " is checking rout proportion and found it to be " .. tostring(current_rout_proportion));		
			return current_shattered_proportion >= threshold;
		end,
		0,
		function()
			bm:out(self.id .. " shattered proportion has exceeded threshold of " .. threshold .. ", triggering script message " .. message);
			self.sm:trigger_message(message)
		end,
		self.id
	);
end;


--- @function message_on_deployed
--- @desc Triggers the supplied message when the units in the generated army are all fully deployed.
--- @p @string message, Message to trigger.
function generated_army:message_on_deployed(message)
	if not is_string(message) then
		script_error(self.id .. " ERROR: message_on_deployed() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	-- if the battle hasn't started then put this off until it has
	if not self.generated_battle:has_battle_started() then
		self.sm:add_listener("battle_started", function() self:message_on_deployed(message) end);
		return;
	end;
	
	bm:watch(
		function()
			return has_deployed(self.sunits);
		end,
		0,
		function()
			bm:out(self.id .. " has deployed, triggering script message " .. message);
			self.sm:trigger_message(message)
		end,
		self.id
	);
end;


--- @function message_on_any_deployed
--- @desc Triggers the supplied message when any of the units in the generated army have deployed.
--- @p @string message, Message to trigger.
function generated_army:message_on_any_deployed(message)
	if not is_string(message) then
		script_error(self.id .. " ERROR: message_on_any_deployed() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	-- if the battle hasn't started then put this off until it has
	if not self.generated_battle:has_battle_started() then
		self.sm:add_listener("battle_started", function() self:message_on_any_deployed(message) end);
		return;
	end;
	
	bm:watch(
		function()
			return self.sunits:have_any_deployed();
		end,
		0,
		function()
			bm:out(self.id .. " has partially deployed, triggering script message " .. message);
			self.sm:trigger_message(message);
		end,
		self.id
	);
end;


--- @function message_on_number_deployed
--- @desc Triggers the supplied message, potentially repeatedly, when a certain number of units in the generated army have been deployed. The function takes one or more number arguments and will count through those numbers in order each time a unit from the army deploys onto the battlefield. The supplied message will be triggered each time a supplied number in the sequence is counted down to 0.
--- @desc For example, if the generated army contains 10 units, and the message <code>example_message</code> is specified along with numerical arguments <code>2, 1, 3</code>, the function will trigger that message after the second unit has been deployed (the first supplied number <code>2</code> is counted down), the third unit has been deployed (the second supplied number <code>1</code> is counted down, after the first) and the sixth unit has been deployed (the third number <code>3</code>, after the first and second).
--- @desc If the <code>repeat_pattern</code> flag is set then the supplied list of numbers is read repeatedly until all units in the generated army are accounted for. Setting this flag and supplying numerical arguments <code>1, 2</code> would be the same as not setting this flag and supplying arguments <code>1, 2, 1, 2, 1, 2, 1, 2</code> etc.
--- @desc If the last unit being deployed does not complete the sequence (e.g <code>2, 2, 2</code> for an army that only contains five units) then no final message will be issued.
--- @p @string message, Message to trigger.
--- @p @boolean read repeatedly, Read back to the start of the supplied list of numbers if there are still units in the generated army that are unassigned.
--- @p vararg numbers, Sequence of numbers on which to trigger the message, when counting number of units deployed.
--- @new_example Send message <code>reinforcements_arriving</code> after the 3rd, 5th and 8th unit in the army are deployed
--- @example ga_enemy_01:message_on_number_deployed("reinforcements_arriving", 3, 2, 3);
function generated_army:message_on_number_deployed(message, repeat_pattern, ...)
	if not is_string(message) then
		script_error(self.id .. " ERROR: message_on_number_deployed() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;

	if not is_boolean(repeat_pattern) then
		script_error(self.id .. " ERROR: message_on_number_deployed() called but supplied repeat-pattern flag [" .. tostring(repeat_pattern) .. "] is not a boolean");
		return false;
	end;

	if arg.n == 0 then
		script_error(self.id .. " ERROR: message_on_number_deployed() called but no numbers(s) specified");
		return false;
	end;

	for i = 1, arg.n do
		if not is_number(arg[i]) or arg[i] < 0 then
			script_error(self.id .. " ERROR: message_on_number_deployed() called but arg [" .. i .. "] is not a positive number, its value is [" .. tostring(arg[i]) .. "]");
			return false;
		end;
	end;

	local total_num_units = self.sunits:count();

	-- Make a reverse table of absolute count values at which we should trigger messages, so arg values of [1, 2, 3] will convert to [6, 3, 1] for example
	local trigger_values = {};
	local sum = 0;
	repeat
		for i = 1, arg.n do
			sum = sum + arg[i];
			if sum > total_num_units then
				repeat_pattern = false;
				break;
			end;
			table.insert(trigger_values, 1, sum);
		end;
	until not repeat_pattern;

	local process_name = self.id .. "_message_on_number_deployed_" .. tostring(core:get_unique_counter());

	bm:repeat_callback(
		function()
			local num_deployed = self.sunits:num_deployed();

			if num_deployed == 0 then
				return;
			end;

			-- Check the trigger values table backwards, and remove 
			for i = #trigger_values, 1, -1 do
				if trigger_values[i] <= num_deployed then
					bm:out(self.id .. " has deployed " .. num_deployed .. " units which is more than the next threshold value [" .. tostring(trigger_values[i]) .. "] so message_on_number_deployed() is triggering script message " .. message);
					self.sm:trigger_message(message);
					table.remove(trigger_values, i);
				else
					break;
				end;
			end;

			-- stop the polling process when we've triggered all the messages we were supposed to
			if #trigger_values == 0 then
				bm:remove_process(process_name);
			end;
		end,
		200,
		process_name
	);
end;


--- @function message_on_seen_by_enemy
--- @desc Triggers the supplied message when any of the units in the generated army have become visible to the enemy.
--- @p @string message, Message to trigger.
function generated_army:message_on_seen_by_enemy(message)
	if not is_string(message) then
		script_error(self.id .. " ERROR: message_on_seen_by_enemy() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	-- if the battle hasn't started then put this off until it has
	if not self.generated_battle:has_battle_started() then
		self.sm:add_listener("battle_started", function() self:message_on_seen_by_enemy(message) end);
		return;
	end;
	
	-- get a handle to the enemy alliance (bit inelegant, this)
	local enemy_alliance = nil;
	if self.alliance_index == 1 then
		enemy_alliance = bm:alliances():item(2);
	else
		enemy_alliance = bm:alliances():item(1);
	end;
	
		
	bm:watch(
		function()
			return is_visible(self.sunits, enemy_alliance);
		end,
		0,
		function()
			bm:out(self.id .. " is visible to its enemy, triggering script message " .. message);
			self.sm:trigger_message(message)
		end,
		self.id
	);
end;


--- @function message_on_commander_death
--- @desc Triggers the supplied message when the commander of the army corresponding to this generated army has died. Note that the commander of the army may not be in this generated army.
--- @p @string message, Message to trigger.
function generated_army:message_on_commander_death(message)
	if not is_string(message) then
		script_error(self.id .. " ERROR: message_on_commander_death() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	-- if the battle hasn't started then put this off until it has
	if not self.generated_battle:has_battle_started() then
		self.sm:add_listener("battle_started", function() self:message_on_commander_death(message) end);
		return;
	end;

	local first_scriptunit = self:get_first_scriptunit()
	
	bm:watch(
		function()
			return not first_scriptunit.unit:army():is_commander_alive()
		end,
		0,
		function()
			bm:out(self.id .. " has lost its commander, triggering script message " .. message);
			self.sm:trigger_message(message)
		end,
		self.id
	);
end;


--- @function message_on_commander_dead_or_routing
--- @desc Triggers the supplied message when the commanding unit within this generated army is either dead or routing. If no commanding unit exists in the generated army, this function will throw a script error.
--- @p @string message, Message to trigger.
function generated_army:message_on_commander_dead_or_routing(message)
	
	if not is_string(message) then
		script_error(self.id .. " ERROR: message_on_commander_dead_or_routing() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;

	-- if the battle hasn't started then put this off until it has
	if not self.generated_battle:has_battle_started() then
		self.sm:add_listener("battle_started", function() self:message_on_commander_dead_or_routing(message) end);
		return;
	end;

	local general_sunit = self.sunits:get_general_sunit();

	if not general_sunit then
		script_error("ERROR: message_on_commander_dead_or_routing() couldn't find a general in this army?");
		return false;
	end;

	local unit = general_sunit.unit;
	
	bm:watch(
		function()
			return unit:is_routing() or unit:is_shattered() or unit:number_of_men_alive() < 1;
		end,
		0,
		function()
			bm:out(self.id .. " commander with id [" .. unit:unique_ui_id() .. "] at position [" .. v_to_s(unit:position()) .. "] is dead or routing, triggering script message " .. message);
			self.sm:trigger_message(message);
		end,
		self.id
	);
end


--- @function message_on_commander_dead_or_shattered
--- @desc Triggers the supplied message when the commanding unit within this generated army is either dead or shattered. If no commanding unit is present, this function will throw a script error.
--- @p @string message, Message to trigger.
function generated_army:message_on_commander_dead_or_shattered(message)

	if not is_string(message) then
		script_error(self.id .. " ERROR: message_on_commander_dead_or_shattered() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;

	-- if the battle hasn't started then put this off until it has
	if not self.generated_battle:has_battle_started() then
		self.sm:add_listener("battle_started", function() self:message_on_commander_dead_or_shattered(message) end);
		return;
	end;

	local general_sunit = self.sunits:get_general_sunit();

	if not general_sunit then
		script_error("ERROR: message_on_commander_dead_or_shattered() couldn't find a general in this army?");
		return false;
	end;

	local unit = general_sunit.unit;
	
	bm:watch(
		function()
			return unit:is_shattered() or unit:number_of_men_alive() < 1;
		end,
		0,
		function()
			bm:out(self.id .. " commander with id [" .. unit:unique_ui_id() .. "] at position [" .. v_to_s(unit:position()) .. "] is dead or shattered, triggering script message " .. message);
			self.sm:trigger_message(message);
		end,
		self.id
	);
end


--- @function message_on_under_attack
--- @desc Triggers the supplied message when any of the units in this generated army come under attack.
--- @p @string message, Message to trigger.
function generated_army:message_on_under_attack(message)
	if not is_string(message) then
		script_error(self.id .. " ERROR: message_on_under_attack() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	-- if the battle hasn't started then put this off until it has
	if not self.generated_battle:has_battle_started() then
		self.sm:add_listener("battle_started", function() self:message_on_under_attack(message) end);
		return;
	end;
	
	-- cache the current health of all these units
	self.sunits:cache_health(true);
	
	bm:watch(
		function()
			return self.sunits:is_under_attack();
		end,
		0,
		function()
			bm:out(self.id .. " is under attack, triggering script message " .. message);
			self.sm:trigger_message(message)
		end,
		self.id
	);
end;


--- @function message_on_alliance_not_active_on_battlefield
--- @desc Triggers the supplied message if none of the units in the alliance to which this generated army belongs are a) deployed and b) not routing, shattered or dead
--- @p @string message, Message to trigger.
function generated_army:message_on_alliance_not_active_on_battlefield(message)
	if not is_string(message) then
		script_error(self.id .. " ERROR: message_on_alliance_not_active_on_battlefield() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	-- if the battle hasn't started then put this off until it has
	if not self.generated_battle:has_battle_started() then
		self.sm:add_listener("battle_started", function() self:message_on_alliance_not_active_on_battlefield(message) end);
		return;
	end;
	
	local alliance_sunits = self.generated_battle:get_allied_force(self.alliance_index, -1);
	
	-- wait a moment for the units to enter the battlefield after deployment properly before beginning the monitor
	bm:callback(
		function()
			bm:watch(
				function()
					return not alliance_sunits:are_any_active_on_battlefield();
				end,
				0,
				function()
					bm:out(self.id .. " is triggering message " .. message .. " as no units from this alliance are active on the battlefield");
					self.sm:trigger_message(message)
				end,
				self.id
			);
		end,
		5000,
		self.id
	);
end;


-- called internally by the generated_battle object
function generated_army:notify_of_victory()
	if self.victory_message then
		local message = self.victory_message;
		
		bm:out(self.id .. " has won the battle, triggering script message " .. message);
		self.sm:trigger_message(message)
	end;
end;


-- called internally by the generated_battle object
function generated_army:notify_of_defeat()
	if self.defeat_message then
		local message = self.defeat_message;
		
		bm:out(self.id .. " has lost the battle, triggering script message " .. message);
		self.sm:trigger_message(message)
	end;
end;


--- @function message_on_victory
--- @desc Triggers the supplied message if this generated army wins the battle.
--- @p @string message, Message to trigger.
function generated_army:message_on_victory(message)
	if not is_string(message) then
		script_error(self.id .. " ERROR: message_on_victory() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	-- if the battle hasn't started then put this off until it has
	if not self.generated_battle:has_battle_started() then
		self.sm:add_listener("battle_started", function() self:message_on_victory(message) end);
		return;
	end;
	
	self.victory_message = message;
end;


--- @function message_on_defeat
--- @desc Triggers the supplied message if this generated army loses the battle.
--- @p @string message, Message to trigger.
function generated_army:message_on_defeat(message)
	if not is_string(message) then
		script_error(self.id .. " ERROR: message_on_defeat() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	-- if the battle hasn't started then put this off until it has
	if not self.generated_battle:has_battle_started() then
		self.sm:add_listener("battle_started", function() self:message_on_defeat(message) end);
		return;
	end;
	
	self.defeat_message = message;
end;
























----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--
--	GENERATED CUTSCENE
--
-- @c generated_cutscene generated_cutscene Generated Cutscene
-- @page generated_battle
-- @desc Generated cutscenes provide a method of partially automating the camera movements and other events that occur in the intro cutscene of a @generated_battle.
--
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------



--[[ Plays an autogenerated cutscene based on objects passed in. Expects the format:
{
	{[opt]sfx_name, subtitle, [opt]camera, [opt]loop_camera, [opt]min_length, [opt] wait_for_vo, [opt] wait_for_camera},
	{[opt]sfx_name, subtitle, [opt]camera, [opt]loop_camera, [opt]min_length, [opt] wait_for_vo, [opt] wait_for_camera}
}
]]--
generated_cutscene =
{
	is_debug = false, -- Should output debug values.
	iterated_time = 0,
	elapsed_time = 0,
	has_played_outro = false,
	has_skipped_cameras = false,
	has_skipped_vo = false,
	disable_outro_camera = false,
	outro_camera_key = "_end_cutscene_outro_camera",
	outro_camera_time = 4000,
	elements = {},
	use_wh2_subtitles = false,
	force_display_subtitles = false
}


set_class_custom_type_and_tostring(generated_cutscene, TYPE_GENERATED_CUTSCENE);





----------------------------------------------------------------------------
-- @section Creation
----------------------------------------------------------------------------


-- @function new
-- @p [opt=false] boolean is debug
-- @p [opt=false] boolean disable outro camera
-- @p [opt=false] boolean ignore final camera index
-- @return generated_cutscene
function generated_cutscene:new(is_debug, disable_outro_camera, ignore_last_camera_index)
	is_debug = is_debug or false;
	disable_outro_camera = disable_outro_camera or false;
	ignore_last_camera_index = ignore_last_camera_index or false;
	
	local gc = {};

	set_object_class(gc, self);
	
	gc.elements = {};
	gc.is_debug = is_debug;
	gc.disable_outro_camera = disable_outro_camera;
	gc.ignore_last_camera_index = ignore_last_camera_index;
	
	return gc;
end


function generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, play_taunt_at_start, message_on_start)
	-- add a new table element.
	local ne = {};
	
	ne.id = "element_" .. #self.elements;

	ne.has_speech = false;
	if is_string(sfx_name) and sfx_name:len() > 0 then

		-- Test if it has PLAY_ at the start.
		local find_play = string.find(sfx_name, "Play_", 1);
		if is_nil(find_play) or find_play ~= 1 then
			sfx_name = "Play_" .. sfx_name
		end

		-- Passing speech in here as an empty string causes this to error.
		ne.speech = new_sfx(sfx_name);
		ne.has_speech = true;
	end
	
	ne.has_subtitle = false;
	if is_string(subtitle) and subtitle:len() > 0 then
		ne.subtitle = subtitle;
		ne.has_subtitle = true;
	end
	
	ne.has_camera = false;
	if is_string(camera) and camera:len() > 0 then
		ne.camera = camera;
		ne.loop_camera = false; -- Forcing to false as the actual camera files give better results.
		ne.has_camera = true;
	end
	
	ne.min_length = min_length;
	ne.wait_for_vo = wait_for_vo;
	ne.wait_for_camera = wait_for_camera;
	ne.play_taunt_at_start = play_taunt_at_start;
	
	if is_string(message_on_start) then
		ne.message_on_start = message_on_start;
	end
	
	table.insert(self.elements, ne);
end

function generated_cutscene:iterate_timer(amount)
	local iterate_amount = amount or 50
	if is_nil(self) then
		script_error("Trying to call function on nil self.");
		return 0;
	end
	
	self.elapsed_time = self.elapsed_time + iterate_amount;
	self.iterated_time = self.iterated_time + iterate_amount;

	return self.elapsed_time;
end

function generated_cutscene:set_wh2_subtitles()
	self.use_wh2_subtitles = true;
end;

function generated_cutscene:force_on_subtitles()
	self.force_display_subtitles = true;
end;

function generated_battle:start_generated_cutscene(gc)
	bm:out("generated_battle: start_generated_cutscene(): Beginning cutscene generation.");
	
	if not is_generatedcutscene(gc) then
		script_error("generated_battle ERROR: start_generated_cutscene() called but supplied cutscene is not a cutscene");
		return false;
	end

	if #gc.elements < 1 then
		script_error("generated_battle ERROR: start_generated_cutscene() called but supplied elements is nil. Have you added any?");
		return false;
	end;
	
	
	-- Start our new cutscene
	local cutscene_intro = cutscene:new(
		"generated_cutscene_intro",
		self:get_army(self:get_player_alliance_num(), 1):get_unitcontroller() -- We assume the player's army is always the first.
	);	
		
	
	--Initial Settings
	cutscene_intro:set_show_cinematic_bars(true);
	cutscene_intro:subtitles():set_alignment("bottom_centre");
	cutscene_intro:subtitles():clear();
	cutscene_intro:set_skippable(false);
		
	--Use our own skip cutscene function as the cutscene skip ends the cutscene! Currently runs through and plays an outro which queues up the skip.
	bm:steal_escape_key_with_callback(
		"generated_battle_cutscene", 
		function() self:skip_generated_cutscene_cameras(cutscene_intro, gc, true)  end
	);
	
	self:enqueue_cutscene_elements(cutscene_intro, gc);
	
		
	-- Once we've loaded everything start the cutscene
	cutscene_intro:start();
end

function generated_battle:play_outro_camera(cutscene_intro, gc)
	if gc.has_played_outro then
		bm:out("generated_battle:play_outro_camera(): Already played an outro, skipping.");
		return;
	end

	-- Add in our outro camera here which will always play at the end.
	bm:out("generated_battle:play_outro_camera(): Playing Outro Camera");
	cutscene_intro:camera():play(gc.outro_camera_key .. ".battle_speech_camera", false);
	
	cutscene_intro:subtitles():clear();
	cutscene_intro:hide_custom_cutscene_subtitles();
	
	-- play a charge sound.
	bm:callback(
		function()
			gb:get_army(gb:get_player_alliance_num(), 1):play_sound_charge();
		end,
		1000
	);
	
	gc.has_played_outro = true;
	
	-- Add a listener to trigger the function afyer the camera has finished.
	bm:callback(
		function()
			get_messager():trigger_message("outro_camera_finished");
		end,
		gc.outro_camera_time
	);
	
end

-- When Esc is pressed.
-- Skips just the cameras for the generated cutscene.
function generated_battle:skip_generated_cutscene_cameras(cutscene_intro, gc, esc_key_pressed)
	
	if gc.has_skipped_cameras then
		bm:out("generated_battle: skip_generated_cutscene_cameras(): We've alrerady skipped cameras, skipping.");
		return;
	end
	
	bm:out("generated_battle: skip_generated_cutscene_cameras(): Skipping Cameras");

	-- Remove esc key functionality.
	bm:release_escape_key_with_callback("generated_battle_cutscene");
	
	gc.has_skipped_cameras = true;
	
	--If we skip the outro just end all the cameras.
	if not gc.disable_outro_camera or esc_key_pressed then
		-- Play the outro
		self:play_outro_camera(cutscene_intro, gc);
		
		--Wait for outro to finish before tidying up.
		gb:add_listener(
			"outro_camera_finished", 
			function() 
				self:clear_cameras(cutscene_intro, gc);
			end
		);
	else
		bm:out("generated_battle:skip_generated_cutscene_cameras(): Skipping Outro Camera");
		self:clear_cameras(cutscene_intro, gc);
	end;
	

	
end

function generated_battle:clear_cameras(cutscene_intro, gc)
	-- Tidy up.
	cutscene_intro:camera():stop(true);
	cutscene_intro:set_show_cinematic_bars(false);
	cutscene_intro:subtitles():clear();
	cutscene_intro:hide_custom_cutscene_subtitles();
	bm:release_input_focus();
	bm:enable_cinematic_ui(false, true, false);
	cutscene_intro.cam:enable_anchor_to_army();
	cutscene_intro.cam:change_height_range(-1, -1);
	bm:change_conflict_time_update_overridden(false);
	cutscene_intro.cam:enable_shake();
	bm:enable_cinematic_camera(false);
	
	self:end_cutscene(cutscene_intro, gc);
	
	-- release the player's army
	if cutscene_intro.should_release_players_army then
		cutscene_intro.players_army:release_control();
	end;

	-- send a script message that a cutscene has finished (useful for generated battles)
	get_messager():trigger_message("generated_custscene_cameras_skipped");

	-- allow battle time to start elapsing
	bm:change_conflict_time_update_overridden(false);
end

-- When the cutscene naturally times out.
function generated_battle:finish_cutscene(cutscene_intro, gc)
	bm:out("generated_battle: end_cutscene(): Finishing Cutscene as it's played all elements.");
	
	self:skip_generated_cutscene_cameras(cutscene_intro, gc)
	
	gb:add_listener(
		"generated_custscene_cameras_skipped", 
		function() 
			self:end_cutscene(cutscene_intro, gc);
		end
	);
end

-- When Start Battle pressed after skipping cameras.
-- kills everything. 
function generated_battle:end_cutscene(cutscene_intro, gc)
	if gc.has_skipped_vo then
		bm:out("generated_battle: end_cutscene(): We've alrerady ended cutscene, skipping.");
		return;
	end
	
	bm:out("generated_battle: end_cutscene(): Ending Cutscene");
	
	self.sm:trigger_message("generated_custscene_ended");
	
	gc.has_skipped_vo = true;
	
	--cutscene_intro:skip();
	cutscene_intro:finish();
end

function generated_battle:enqueue_cutscene_elements(cutscene_intro, gc)
	-- Get the player commander as the source of the VO.
	local player_army = gb:get_army(gb:get_player_alliance_num(), 1);
	local player_commander = player_army:get_first_scriptunit();
	
	if not is_scriptunit(player_commander) then
		bm:out("No Commander found for player's army, VO will play in world");
	end
	
	--Loop through our fragments and queue up the actions.
	local last_camera_index = 0;
	for i,v in ipairs(gc.elements) do	
		if v.has_camera or v.wait_for_camera then
			last_camera_index = i;
		end
	end

	--Loop through our fragments and queue up the actions.
	for i,element in ipairs(gc.elements) do	
	-- SETUP --
		local speech = element.speech;
		local subtitle = element.subtitle;
		local camera = element.camera;
		local min_length = element.min_length;
		local wait_for_vo = element.wait_for_vo;
		local wait_for_camera = element.wait_for_camera;
		local loop_camera = element.loop_camera;
		local play_taunt_at_start = element.play_taunt_at_start;
		local message_on_start = element.message_on_start;
		
		if gc.is_debug then
			bm:out(element.id .. "= " .. tostring(speech) .. "," .. tostring(subtitle) .. "," .. tostring(camera) .. "," .. tostring(min_length) .. "," .. tostring(loop_camera));
		end
		
		
	-- ERROR CHECKING --
	
		-- Make sure we don't have a wait for camera and a looping camera as this could go on forever.
		if wait_for_camera and loop_camera then
			script_error("Adding a looping camera and a wait for camera on element " .. element.id .. ". This is not allowed, exiting cutscene.");
			return;
		end;
		
			
		
	-- EARLY EXIT --
		--If this was the last camera exit back into regular deployment.		
		if not gc.ignore_last_camera_index and i > last_camera_index then	
			cutscene_intro:action(
				function() 
					if gc.is_debug then
						bm:out("generated_battle: enqueue_cutscene_elements(): Last camera ended, restoring control.");
					end
					self:skip_generated_cutscene_cameras(cutscene_intro, gc);
				end, 
				gc:iterate_timer()
			);
		end

		
	-- MESSAGE ON START --
		if not is_nil(message_on_start) and is_string(message_on_start) then
			cutscene_intro:action(
				function()
					if not gc.has_skipped_vo then
						if gc.is_debug then
							bm:out("generated_battle: enqueue_cutscene_elements(): " .. element.id .."- Playing speechfile: " .. tostring(speech));
						end
						self.sm:trigger_message(message_on_start);
					end
				end, 
				gc.elapsed_time
			);
		end
	
	
	-- AUDIO  & SUBTITLES --
		
		--If we haven't skipped the VO - This occurs when the battle starts.
		if not gc.has_skipped_vo then
		
			-- If we have an audio file then play audio
			if element.has_speech then
				cutscene_intro:action(
					function()
						if not gc.has_skipped_vo then
							-- If we have a player commander he should be speaking. If not we play the sound in 2D space.
							if is_scriptunit(player_commander) then
								cutscene_intro:play_vo(speech, player_commander);
								if gc.is_debug then
									bm:out("generated_battle: enqueue_cutscene_elements(): " .. element.id .."- Playing Speech as VO : " .. tostring(speech));
								end
							else
								cutscene_intro:play_sound(speech);
								if gc.is_debug then
									bm:out("generated_battle: enqueue_cutscene_elements(): " .. element.id .."- Playing Speech as Sound: " .. tostring(speech));
								end
							end
						end
					end, 
					gc:iterate_timer()
				);
			end
			
			-- Show Subtitles
			if element.has_subtitle then
				cutscene_intro:action(
					function() 
						if not gc.has_skipped_vo and (common.subtitles_enabled() or gc.force_display_subtitles) then
							if gc.is_debug then
								bm:out("generated_battle: enqueue_cutscene_elements(): " .. element.id .."- Showing subtitle: " .. subtitle);
							end
							if gc.use_wh2_subtitles then
								cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_" .. subtitle, "subtitle_with_frame", 5, true);
							else
								cutscene_intro:subtitles():set_text(subtitle);
							end;
						end
					end, 
					gc:iterate_timer()
				);
			end
		else
			if gc.is_debug then
				bm:out("generated_battle: enqueue_cutscene_elements(): " .. element.id .."- No vo or subtitles");
			end
		end
		
		
	-- CAMERAS --
		
		-- Check is the player has skipped the intro with the ESC key. We only want to skip cameras at that point.
		if not gc.has_skipped_cameras and not gc.has_played_outro then
			if play_taunt_at_start then
				cutscene_intro:action(
					function() 
						if not gc.has_skipped_cameras and not gc.has_played_outro then
							if gc.is_debug then
								bm:out("generated_battle: enqueue_cutscene_elements(): " .. element.id .."- Playing Taunt");
							end
							
							player_army:taunt();
							player_army:play_sound_taunt();
						end
					end, 
					gc:iterate_timer()
				); 
			end
			
			-- Play Camera
			if element.has_camera then
				cutscene_intro:action(
					function() 
						if not gc.has_skipped_cameras and not gc.has_played_outro then
							if gc.is_debug then
								bm:out("generated_battle: enqueue_cutscene_elements(): " .. element.id .."- Playing Camera: " .. camera .. ".battle_speech_camera");
							end
							
							--cutscene_intro:camera():stop();--Stop the previous camera.
							cutscene_intro:camera():play(camera .. ".battle_speech_camera", loop_camera)
						end
					end, 
					gc:iterate_timer()
				); 
			end
		else
			if gc.is_debug then
				bm:out("generated_battle: enqueue_cutscene_elements(): " .. element.id .."- No cameras or skipped.");
			end
		end
		
		
	-- WAITS --

		-- Wait for the vo to finish before we move on. should auto return false if we don't have VO playing
		--Iterate to allow for audio to play.
		gc:iterate_timer(500);

		if wait_for_vo then
			cutscene_intro:action(
				function()
					if gc.is_debug then
						bm:out("generated_battle: enqueue_cutscene_elements(): " .. element.id .."- Setting Wait for VO");
					end
					cutscene_intro:wait_for_vo() 
				end, 
				gc:iterate_timer()
			);
		else
			if gc.is_debug then
				bm:out("generated_battle: enqueue_cutscene_elements(): " .. element.id .."- Will not Wait for VO");
			end
		end
		
		
		-- Wait for the camera to end before advancing.
		if cutscene_intro:is_playing_camera() then
			if wait_for_camera then
				cutscene_intro:action(
					function() 
						if gc.has_skipped_cameras or gc.has_played_outro then
							bm:out("generated_battle: enqueue_cutscene_elements(): " .. element.id .."- Skipping wait for camera as we've skipped them.");
							return;
						end
						
						if gc.is_debug then
							bm:out("generated_battle: enqueue_cutscene_elements(): " .. element.id .."- Setting Wait for camera.");
						end
						
						cutscene_intro:wait_for_camera() 
					end, 
					gc:iterate_timer()
				);
			else
				if gc.is_debug then
					bm:out("generated_battle: start_generated_cutscene(): " .. element.id .."- Will not Wait for Camera");
				end
			end
		end		
		
		--Iterate the cutscene by the min_time so that it always plays for at least x seconds.
		--Since we use a lot of time between elements, we store how much we've used and subtract it from the min time so we can never add too much.
		gc.elapsed_time = gc.elapsed_time + (min_length - gc.iterated_time);
		gc.iterated_time = 0;
	end;
	
	-- FINISHING --	
	
	-- When we finish naturally we play outro, skip and end the cutscene.
	cutscene_intro:action(
		function() 
			if gc.is_debug then
				bm:out("generated_battle: enqueue_cutscene_elements(): No more fragments to play. Ending cutscene.");
			end
			cutscene_intro:hide_custom_cutscene_subtitles();
			self:finish_cutscene(cutscene_intro, gc);
			
		end, 
		gc:iterate_timer()
	);
	
	
-- SKIPPING --	

	-- Kill the cutscene when start battle is pressed. This means the playert has already skipped cameras, so just end.
	self.sm:add_listener(
		"battle_started",
		function()
			bm:callback(
				function()
					bm:out("generated_battle:enqueue_cutscene_elements() Battle Started - Stopping VO");
					self:end_cutscene(cutscene_intro, gc)
				end,
				0
			);
		end
	);
	
	
	if gc.is_debug then
		bm:out("generated_battle: enqueue_cutscene_elements(): Queued up all actions. Starting cutscene.");
	end
end

