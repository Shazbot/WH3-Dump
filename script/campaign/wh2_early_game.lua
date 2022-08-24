-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	EARLY GAME SCRIPT LIBRARIES
--	Helper scripts for the early game missions
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

EARLY_GAME_ADVICE_VOICED_BY_LEGENDARY_LORD = 0;
EARLY_GAME_ADVICE_SPECIFIC_TO_FACTION = 1;
EARLY_GAME_ADVICE_SHARED = 2;

EARLY_GAME_SHOW_MISSION_ONLY = 0;
EARLY_GAME_SHOW_ADVICE_WITH_MISSION = 1;
EARLY_GAME_SCROLL_CAMERA_WITH_ADVICE_AND_MISSION = 2;


-- try to determine the mode of delivery for a given early-game mission, based on who's voicing the mission advice, the
-- player's desired advice level and how many times the specified advice has been listened-to by the player
function early_game_decide_content_delivery_mode(advice_mode, advice_key)

	if not advice_key then
		return EARLY_GAME_SHOW_MISSION_ONLY, "no advice specified, showing mission only";
	end;

	local advice_key_score = common.get_advice_thread_score(advice_key);

	if core:is_advice_level_minimal() then
		
		return EARLY_GAME_SHOW_MISSION_ONLY, "advice level is minimal, showing mission only";
		
	elseif core:is_advice_level_low() then
	
		if advice_mode == EARLY_GAME_ADVICE_VOICED_BY_LEGENDARY_LORD then
			return EARLY_GAME_SHOW_ADVICE_WITH_MISSION, "advice level is low and is voiced by LL, showing advice with mission";
			
		elseif advice_mode == EARLY_GAME_ADVICE_SPECIFIC_TO_FACTION then
		
			if advice_key_score == 0 then
				return EARLY_GAME_SHOW_ADVICE_WITH_MISSION, "advice level is low, advice is faction-specific and advice score is " .. tostring(advice_key_score) .. ", showing advice with mission";
				
			else
				return EARLY_GAME_SHOW_MISSION_ONLY, "advice level is low, advice is faction-specific and advice score is " .. tostring(advice_key_score) .. ", showing mission only";
			end;
			
		else
			-- advice_mode == EARLY_GAME_ADVICE_SHARED
			
			if advice_key_score < 2 then
				return EARLY_GAME_SHOW_ADVICE_WITH_MISSION, "advice level is low, advice is general and advice score is " .. tostring(advice_key_score) .. ", showing advice with mission";
			else
				return EARLY_GAME_SHOW_MISSION_ONLY, "advice level is low, advice is general and advice score is " .. tostring(advice_key_score) .. ", showing mission only";
			end;
		end;
	
	else
		-- core:advice_level_high() == true
		
		if advice_mode == EARLY_GAME_ADVICE_VOICED_BY_LEGENDARY_LORD then
			return EARLY_GAME_SCROLL_CAMERA_WITH_ADVICE_AND_MISSION, "advice level is high and is voiced by LL, scrolling camera with advice with mission";
			
		elseif advice_mode == EARLY_GAME_ADVICE_SPECIFIC_TO_FACTION then
		
			if advice_key_score == 0 then
				return EARLY_GAME_SCROLL_CAMERA_WITH_ADVICE_AND_MISSION, "advice level is high, advice is faction-specific and advice score is " .. tostring(advice_key_score) .. ", scrolling camera with advice with mission";
				
			elseif advice_key_score == 1 then
				return EARLY_GAME_SHOW_ADVICE_WITH_MISSION, "advice level is high, advice is faction-specific and advice score is " .. tostring(advice_key_score) .. ", showing advice with mission";
				
			else
				return EARLY_GAME_SHOW_MISSION_ONLY, "advice level is high, advice is faction-specific and advice score is " .. tostring(advice_key_score) .. ", showing mission only";
			end;
		
		else
			-- advice_mode == EARLY_GAME_ADVICE_SHARED
			
			if advice_key_score == 0 then
				return EARLY_GAME_SCROLL_CAMERA_WITH_ADVICE_AND_MISSION, "advice level is high, advice is general and advice score is " .. tostring(advice_key_score) .. ", scrolling camera with advice with mission";
				
			elseif advice_key_score == 1 or advice_key_score == 2 then
				return EARLY_GAME_SHOW_ADVICE_WITH_MISSION, "advice level is high, advice is general and advice score is " .. tostring(advice_key_score) .. ", showing advice with mission";
				
			else
				return EARLY_GAME_SHOW_MISSION_ONLY, "advice level is high, advice is general and advice score is " .. tostring(advice_key_score) .. ", showing mission only";
			end;
		end;
	end;
	
	script_error("WARNING: early_game_decide_content_delivery_mode() couldn't decide a content delivery mode, advice_mode is [" .. tostring(advice_mode) .. "], advice_key is [" .. tostring(advice_key) .. "] and advice score is [" .. tostring(advice_key_score) .. "]");
	return EARLY_GAME_SHOW_MISSION_ONLY, "default";
end;


function early_game_should_show_infotext(advice_mode, advice_key, event_name)
	if core:is_advice_level_minimal() then
		return false;
	elseif core:is_advice_level_low() then
	
		if advice_mode == EARLY_GAME_ADVICE_VOICED_BY_LEGENDARY_LORD or advice_mode == EARLY_GAME_ADVICE_SPECIFIC_TO_FACTION then
			-- on low advice, if the advice is voiced by the LL or is specific to the faction, show the infotext only the advice has never been seen before
			return common.get_advice_thread_score(advice_key) == 0;
			
		else
			-- advice_mode == EARLY_GAME_ADVICE_SHARED
			
			-- on low advice, if the advice is general across all factions, show the infotext if the event has not been experienced before
			return not get_early_game_event_experienced(event_name);
		end;
	else
		-- core:is_advice_level_high() == true
		
		-- on high advice, show the infotext if the advice has been seen less than twice
		return common.get_advice_thread_score(advice_key) < 2;
	end;
	
	script_error("WARNING: early_game_should_show_infotext() couldn't determine whether to show infotext, advice_mode is [" .. tostring(advice_mode) .. "], advice_key is [" .. tostring(advice_key) .. "], advice score is [" .. tostring(common.get_advice_thread_score(advice_key)) .. "], event_name is [" .. tostring(event_name) .. "] and event experienced is [" .. tostring(get_early_game_event_experienced(event_name)) .. "]");
	return true;
end;


-- returns whether this string early-game event has been experienced
function get_early_game_event_experienced(event_name, savegame_only)

	if not is_string(event_name) then
		script_error("ERROR: get_early_game_event_experienced() called but supplied event name [" .. tostring(event_name) .. "] is not a string");
		return false;
	end;

	-- if a value corresponding to this string is true in the savegame, then always return true
	if cm:get_saved_value(event_name) then
		return true;
	end;
	
	-- if the savegame_only flag is set then we disregard advice history, and as such we return false
	if savegame_only then
		return false;
	end;
	
	-- otherwise return the advice history value (or the BOOL disregard-history override)
	return common.get_advice_history_string_seen(event_name);
end;


-- sets whether an early-game event has been experienced in the savegame, and optionally in the advice history
function set_early_game_event_experienced(event_name, savegame_only)

	cm:set_saved_value(event_name, true);
	
	if not savegame_only then
		common.set_advice_history_string_seen(event_name);
	end;
end;



-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	starts early game missions
--
--	called by the faction scripts to kick off the initial early-game missions
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

function start_early_game_missions(from_intro_first_turn, starting_settlement_level_two)

	if core:is_tweaker_set("DISABLE_PRELUDE_CAMPAIGN_SCRIPTS") then
		out("start_early_game_missions() called but DISABLE_PRELUDE_CAMPAIGN_SCRIPTS tweaker is set so not starting early-game missions");
		out.design("[EG] start_early_game_missions() called but DISABLE_PRELUDE_CAMPAIGN_SCRIPTS tweaker is set so not starting early-game missions");
		return false;
	end;

	if from_intro_first_turn then
		out.design("[EG] start_early_game_missions() is triggering event ScriptEventPlayerStartsOpenCampaignFromFirstTurn");
		core:trigger_event("ScriptEventPlayerStartsOpenCampaignFromFirstTurn");
	else
		out.design("[EG] start_early_game_missions() is triggering event ScriptEventPlayerStartsOpenCampaignFromNormal");
		core:trigger_event("ScriptEventPlayerStartsOpenCampaignFromNormal");
	end;
	
	core:trigger_event("ScriptEventPlayerStartsOpenCampaign");
	
	-- if the player's starting settlement is at level two (all the secondary lords) then listen for the capture enemy settlement mission
	-- (start of turn one) and then trigger an event like the player's settlement has been upgraded - this will induce the tech building
	-- mission to fire
	if starting_settlement_level_two then
		core:add_listener(
			"start_early_game_missions",
			"ScriptEventEGCaptureEnemySettlementMissionIssued",
			true,
			function() core:trigger_event("ScriptEventEGSettlementUpgraded") end,
			false
		);
	end;
end;




-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	character lockdown
--
--	locks an army in place for a number of turns
--	allows us to lock an army in place for the player to
--	attack at the start of the game
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

function start_early_game_character_lockdown_listener(lord_cqi, ...)
	
	if not is_number(lord_cqi) then
		script_error("ERROR: start_early_game_character_lockdown_listener() called but supplied cqi [" .. tostring(lord_cqi) .. "] is not a number");
		return false;
	end;
	
	local faction_name = false;
	
	do
		local character = cm:get_character_by_cqi(lord_cqi)
		if not character then
			if cm:model():turn_number() - cm:get_saved_value("first_turn_count_modifier") == 1 and cm:whose_turn_is_it_single():name() == cm:get_local_faction_name() then
				-- assert if the character could not be found and it's the player's first turn
				script_error("ERROR: start_early_game_character_lockdown_listener() called but no character with supplied cqi [" .. tostring(lord_cqi) .. "] could be found");
			else
				out.design("[EG] start_early_game_character_lockdown_listener() is not initiating any listeners as no character with cqi [" .. lord_cqi .. "] could be found - presumably he or she has died");
			end;
			return false;
		end;
		faction_name = character:faction():name();
	end;
	
	-- establish a listener for each turn we have an effect bundle for
	out.design("[EG] start_early_game_character_lockdown_listener() is establishing FactionTurnStart listeners for character with cqi [" .. lord_cqi .. "] from faction [" .. faction_name .. "]");
	
	for i = 1, arg.n do
		local effect_bundle_str = arg[i];
	
		if not is_string(effect_bundle_str) then
			script_error("ERROR: start_early_game_character_lockdown_listener() called but supplied effect bundle key [" .. tostring(arg[i]) .. "] is not a string");
			return false;
		end;
		
		out.design("\testablishing listener to apply effect bundle [" .. effect_bundle_str .. "] on turn [" .. i .. "]");
		
		core:add_listener(
			"early_game_character_lockdown_listener_" .. lord_cqi,
			"FactionTurnStart",
			function(context)
				-- this won't be the player (probably), but will be the enemy faction
				return context:faction():name() == faction_name and cm:model():turn_number() - cm:get_saved_value("first_turn_count_modifier") == i;
			end,
			function(context)
				out.design("[EG] early game character lockdown listener for character with cqi [" .. lord_cqi .. "] has triggered on turn [" .. cm:model():turn_number() .. "], first turn count modifier is [" .. cm:get_saved_value("first_turn_count_modifier") .. "]");
				
				local character = cm:get_character_by_cqi(lord_cqi);
				
				if not character then
					-- character has presumably died
					out.design("\tcharacter cannot be found - presumably he or she is dead, stopping all related listeners");
					core:remove_listener("early_game_character_lockdown_listener_" .. lord_cqi);
					return;
				end;
				
				-- apply the specified effect bundle for a turn
				out.design("\tapplying effect bundle [" .. effect_bundle_str .. "] to force of character with cqi [" .. lord_cqi .. "]");
				cm:apply_effect_bundle_to_characters_force(effect_bundle_str, lord_cqi, 1);
			end,
			false
		);
	end;
end;



-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	how they play
--
--  triggered at the start of a normal campaign
--	capture enemy settlement mission triggers afterwards
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

function start_early_game_how_they_play_listener()
	
	local in_eg_how_they_play = intervention:new(
		"eg_how_they_play", 													-- string name
		0,	 																	-- cost
		function() in_eg_how_they_play_trigger() end,							-- trigger callback
		BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
	);
	
	in_eg_how_they_play:add_trigger_condition(
		"ScriptEventPlayerStartsOpenCampaignFromNormal",
		true
	);
	
	in_eg_how_they_play:add_precondition(
		function() 
			return not cm:get_saved_value("how_they_play_shown");
		end
	);

	function in_eg_how_they_play_trigger()
		out.design("[EG] start_early_game_how_they_play_listener() is triggering how to play event for local faction");
	
		show_how_to_play_event(
			cm:get_local_faction_name(),
			function()
				cm:set_saved_value("how_they_play_shown", true);
				core:trigger_event("ScriptEventHowTheyPlayEventDismissed");
				in_eg_how_they_play:complete();
			end
		);
	end;
	
	in_eg_how_they_play:start();
end;









-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	diplomacy setup listener
--
--  prevents the supplied principal enemy faction from being able to request peace, 
--	sets them into the supplied personality, and prevents anyone from arranging 
--	a NAP or a trade agreement with the player until a message is received
--	also prevents anyone declaring war with the player for the specified number 
--	of turns from the start of the game
--	enemy_faction_key, enemy_personality_key, num_turns_before_war
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

function start_early_game_diplomacy_setup_listener(enemy_faction_key, enemy_personality_key, num_turns_before_war)
	
	if not is_string(enemy_faction_key) then
		script_error("ERROR: start_early_game_diplomacy_setup_listener() called but supplied enemy faction key [" .. tostring(enemy_faction_key) .. "] is not a string");
		return false;
	end;
	
	if not cm:get_faction(enemy_faction_key) then
		script_error("ERROR: start_early_game_diplomacy_setup_listener() called but no faction with supplied key [" .. enemy_faction_key .. "] could be found");
		return false;
	end;
	
	if not is_string(enemy_personality_key) then
		script_error("ERROR: start_early_game_diplomacy_setup_listener() called but supplied enemy personality key [" .. tostring(enemy_personality_key) .. "] is not a string");
		return false;
	end;
	
	num_turns_before_war = num_turns_before_war or 3;
	
	if not is_number(num_turns_before_war) or num_turns_before_war < 0 then
		script_error("ERROR: start_early_game_diplomacy_setup_listener() called but supplied number of turns before war can be declared [" .. tostring(num_turns_before_war) .. "] is not a positive");
		return false;
	end;
	
	local local_faction = cm:get_local_faction_name();
	
	-- if the initial diplomacy state has not been set up, establish a listener to do so
	if not cm:get_saved_value("early_game_diplomacy_set_up") then
		core:add_listener(
			"early_game_diplomacy_setup_listener",
			"ScriptEventPlayerStartsOpenCampaign",
			true,
			function()				
				out.design("[EG] start_early_game_diplomacy_setup_listener() is modifying diplomacy setup, changing personality for faction " .. enemy_faction_key .. " to " .. enemy_personality_key);
			
				-- change the enemy faction's personality
				cm:force_change_cai_faction_personality(enemy_faction_key, enemy_personality_key);
				
				-- prevent the enemy faction from being able to request peace from the player (and vice-versa)
				cm:force_diplomacy("faction:" .. enemy_faction_key, "faction:" .. local_faction, "peace", false, false, true);
				
				-- prevent all factions from being able to propose a NAP with the player
				cm:force_diplomacy("all", "faction:" .. local_faction, "non aggression pact", false, true, false);
				
				-- prevent all factions from being able to propose trade with the player
				cm:force_diplomacy("all", "faction:" .. local_faction, "trade agreement", false, true, false);
				
				-- prevent all factions from being able to declare war on the player
				cm:force_diplomacy("all", "faction:" .. local_faction, "war", false, true, false);
				
				-- establish a countdown to when other factions can declare war
				cm:add_turn_countdown_event(
					local_faction, 
					num_turns_before_war, 
					"ScriptEventEGAllowAIToDeclareWar"
				);
				
				cm:set_saved_value("early_game_diplomacy_set_up", true);
			end,
			false
		);
	end;
	
	-- if not all factions may declare war, then establish a listener so that they may
	if not cm:get_saved_value("early_game_diplomacy_ai_may_declare_war") then
		out.design("[EG] start_early_game_diplomacy_setup_listener() has established listener for ScriptEventEGAllowAIToDeclareWar");
		
		local listener_name = "early_game_diplomacy_ai_war_listener";
		
		local function allow_war()
			core:remove_listener(listener_name);
		
			-- allow all factions to be able to declare war on the player
			cm:force_diplomacy("all", "faction:" .. local_faction, "war", true, true, false);
			
			cm:set_saved_value("early_game_diplomacy_ai_may_declare_war", true);
			
			core:trigger_event("ScriptEventAllFactionsCanDeclareWarOnPlayer");
		end;		
		
		core:add_listener(
			listener_name,
			"ScriptEventEGAllowAIToDeclareWar",
			true,
			function()
				out.design("[EG] start_early_game_diplomacy_setup_listener() listener for ScriptEventEGAllowAIToDeclareWar has triggered, allowing all factions to declare war on player");
				allow_war();
			end,
			false
		);
		
		core:add_listener(
			listener_name,
			"FactionLeaderDeclaresWar",
			function(context) return context:character():faction():name() == local_faction end,
			function(context)
				out.design("[EG] start_early_game_diplomacy_setup_listener() listener for the player declaring war has triggered, allowing all factions to declare war on player");
				allow_war();
			end,
			true
		);
	end;
	
	if not cm:get_saved_value("early_game_diplomacy_ai_may_request_nap") then
		out.design("[EG] start_early_game_diplomacy_setup_listener() has established listener for ScriptEventEGAllowAIToRequestNAP");
		core:add_listener(
			"early_game_diplomacy_nap_listener",
			"ScriptEventEGAllowAIToRequestNAP",
			true,
			function()
				out.design("[EG] start_early_game_diplomacy_setup_listener() listener for ScriptEventEGAllowAIToRequestNAP has triggered, allowing all factions to request NAP or trade agreement with player");
			
				-- allow all factions to be able to request NAP or trade agreement with the player
				cm:force_diplomacy("all", "faction:" .. local_faction, "non aggression pact", true, true, false);
				cm:force_diplomacy("all", "faction:" .. local_faction, "trade agreement", true, true, false);
				
				cm:set_saved_value("early_game_diplomacy_ai_may_request_nap", true);
			end,
			false
		);
	end;
end;




-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	books of nagash holder diplomacy listener
--
--  listens for an event triggered by the start_early_game_diplomacy_setup_listener()
--	function (above) when that function allows all factions to declare war on the
--	player. This function then resets the diplomacy state of the supplied list of
--	factions so that the only diplomatic actions between them and the player is that
--	the player can declare war on them
--	This only needs to be set up for Tomb Kings factions
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

function start_early_game_books_of_nagash_holder_diplomacy_listener(faction_list)
	
	if not is_table(faction_list) then
		script_error("ERROR: start_early_game_diplomacy_setup_listener() called but supplied exception faction list [" .. tostring(faction_list) .. "] is not a table");
		return false;
	end;
	
	for i = 1, #faction_list do
		if not is_string(faction_list[i]) then
			script_error("ERROR: start_early_game_diplomacy_setup_listener() called but element [" .. i .. "] in supplied exception faction list is not a string, its value is [" .. tostring(exception_factions_list[i]) .. "]");
			return false;
		end;
	end;
	
	local local_faction = cm:get_local_faction_name();
	
	-- if the initial diplomacy state has not been set up, establish a listener to do so
	if not cm:get_saved_value("early_game_books_of_nagash_holder_diplomacy_set_up") then
		core:add_listener(
			"early_game_books_of_nagash_holder_diplomacy_set_up",
			"ScriptEventAllFactionsCanDeclareWarOnPlayer",
			true,
			function()
				local faction_str = "";
				
				for i = 1, #faction_list do
					local current_faction = faction_list[i];
					-- disable all diplomacy between player and current faction
					cm:force_diplomacy("faction:" .. current_faction, "faction:" .. local_faction, "all", false, false, true);
					
					-- allow current faction to accept war from the player
					cm:force_diplomacy("faction:" .. current_faction, "faction:" .. local_faction, "war", false, true, false, true);
					
					-- allow player to declare war on the current faction
					cm:force_diplomacy("faction:" .. local_faction, "faction:" .. current_faction, "war", true, false, false, true);
					
					if i == 1 then
						faction_str = current_faction;
					else
						faction_str = faction_str .. ", " .. current_faction;
					end;
				end;
				
				out.design("[EG] start_early_game_books_of_nagash_holder_diplomacy_listener() has received event ScriptEventAllFactionsCanDeclareWarOnPlayer and has diplomatically restricted the following factions to just being able to receive a declaration of war from the player: " .. faction_str);
				
				cm:set_saved_value("early_game_books_of_nagash_holder_diplomacy_set_up", true);
			end,
			false
		);
	end;
end;






-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	capture enemy settlement mission
--
--  triggered after how they-play-event in a normal campaign, or at the start of
--	the first open turn if the first turn intro was played through
--	complete-province mission is triggered on completion of this mission
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

function start_early_game_capture_enemy_settlement_mission_listener(advice_key, infotext, mission_key, mission_issuer, target_id, enemy_faction_name, mission_rewards, start_from_how_they_play_event_dismissed, start_from_books_of_nagash_mission_issued, start_from_turn_two)

	if not is_string(advice_key) then
		script_error("ERROR: start_early_game_capture_enemy_settlement_mission_listener() called but supplied advice key [" .. tostring(advice_key) .. "] is not a string");
		return false;
	end;
	
	-- default infotext value
	if not infotext then
		infotext = {
			"wh2.camp.advice.attacking.info_001",
			"wh2.camp.advice.attacking.info_002",
			"wh2.camp.advice.attacking.info_003"
		};
	elseif not is_table(infotext) then
		script_error("ERROR: start_early_game_capture_enemy_settlement_mission_listener() called but supplied infotext [" .. tostring(infotext) .. "] is not a table or nil");
		return false;
	end;	
	
	if not is_string(mission_key) then
		script_error("ERROR: start_early_game_capture_enemy_settlement_mission_listener() called but supplied mission key [" .. tostring(mission_key) .. "] is not a string");
		return false;
	end;
	
	if mission_issuer and not is_string(mission_issuer) then
		script_error("ERROR: start_early_game_capture_enemy_settlement_mission_listener() called but supplied mission issuer [" .. tostring(mission_issuer) .. "] is not a string or nil");
		return false;
	end;
	
	local bool_target_is_region = true;
	
	if is_string(target_id) then
		if not cm:get_region(target_id) then
			script_error("ERROR: start_early_game_capture_enemy_settlement_mission_listener() called but no region with supplied name [" .. target_id .. "] could be found");
			return false;
		end;
		
	elseif is_number(target_id) then	
		bool_target_is_region = false;
	else
		script_error("ERROR: start_early_game_capture_enemy_settlement_mission_listener() called but supplied enemy target [" .. tostring(target_id) .. "] is not a string or a number");
		return false;
	end;
	
	if not is_string(enemy_faction_name) then
		script_error("ERROR: start_early_game_capture_enemy_settlement_mission_listener() called but supplied enemy region name [" .. tostring(enemy_faction_name) .. "] is not a string");
		return false;
	end;
	
	if not cm:get_faction(enemy_faction_name) then
		script_error("ERROR: start_early_game_capture_enemy_settlement_mission_listener() called but no faction with supplied name [" .. enemy_faction_name .. "] could be found");
		return false;
	end;
	
	if not mission_rewards then
		mission_rewards = {"money 1000"};
	end;
	
	if not is_table(mission_rewards) then
		script_error("ERROR: start_early_game_capture_enemy_settlement_mission_listener() called but supplied mission rewards [" .. mission_rewards .. "] is not a table");
		return false;
	end;
	
	if #mission_rewards == 0 then
		script_error("ERROR: start_early_game_capture_enemy_settlement_mission_listener() called but supplied mission rewards table is empty");
		return false;
	end;
	
	for i = 1, #mission_rewards do
		if not is_string(mission_rewards[i]) then
			script_error("ERROR: start_early_game_capture_enemy_settlement_mission_listener() called but supplied mission reward [" .. i .. "] is [" .. tostring(mission_rewards[i]) .. "] and not a string");
			return false;
		end;
	end;
	
	-- affects how prominently this advice will be delivered based on advice level/history
	-- possible values:
	-- EARLY_GAME_ADVICE_VOICED_BY_LEGENDARY_LORD		| advice voiced by LL, relax criteria for showing it
	-- EARLY_GAME_ADVICE_SPECIFIC_TO_FACTION			| advice voiced by advisor, string is different for different factions
	-- EARLY_GAME_ADVICE_SHARED							| advice voiced by advisor, but string is shared between factions
	local advice_mode = EARLY_GAME_ADVICE_VOICED_BY_LEGENDARY_LORD;
	
	-- set up mission
	local mm = mission_manager:new(
		cm:get_local_faction_name(), 
		mission_key, 
		function() core:trigger_event("ScriptEventEGCaptureEnemySettlementMissionSucceeded") end, 			-- success
		function() 
			script_error("WARNING: player has failed first capture enemy settlement mission, how can this be?");
			core:trigger_event("ScriptEventEGCaptureEnemySettlementMissionSucceeded") 
		end,
		function()
			script_error("WARNING: first capture enemy settlement mission has been cancelled, how can this be?");
			core:trigger_event("ScriptEventEGCaptureEnemySettlementMissionSucceeded") 
		end
	);
	
	mm:add_new_objective("CAPTURE_REGIONS");
	mm:add_condition("faction " .. enemy_faction_name);
	
	if mission_issuer then
		mm:set_mission_issuer(mission_issuer);
	end;
	
	for i = 1, #mission_rewards do
		mm:add_payload(mission_rewards[i]);
	end
	
	local event_name = "early_game_capture_enemy_settlement_mission_issued";
	
	-- pre-declare the intervention variable, so that it exists as a local for the subsequent function
	local in_eg_capture_enemy_settlement_mission = false;
	
	-- intervention trigger function
	local function in_eg_capture_enemy_settlement_mission_trigger()	
		out.design("[EG] start_early_game_capture_enemy_settlement_mission_listener() is triggering mission, advice level is " .. core:get_advice_level());
		
		core:trigger_event("ScriptEventEGCaptureEnemySettlementMissionIssued")
		
		local delivery_mode, delivery_mode_str = early_game_decide_content_delivery_mode(advice_mode, advice_key);
		out.design("\t" .. delivery_mode_str);
		
		if delivery_mode == EARLY_GAME_SHOW_MISSION_ONLY then
			out.design("\tjust issuing mission");
		
			set_early_game_event_experienced(event_name, true);
			mm:trigger();
			cm:callback(function() in_eg_capture_enemy_settlement_mission:complete() end, 1);
			
		else
			if not early_game_should_show_infotext(advice_mode, advice_key, event_name) then
				out.design("\tnot showing infotext");
				infotext = {};
			end;
			
			set_early_game_event_experienced(event_name);
			
			local content_delivered = false;
		
			if delivery_mode == EARLY_GAME_SCROLL_CAMERA_WITH_ADVICE_AND_MISSION then
			
				if bool_target_is_region then
					if cm:get_region(target_id):owning_faction():name() == enemy_faction_name then
						out.design("\tscrolling camera to settlement with advice and mission");
						
						content_delivered = true;
						
						in_eg_capture_enemy_settlement_mission:scroll_camera_to_settlement_for_intervention(
							target_id,
							advice_key,
							infotext,
							mm
						);
					end;
				else
					if cm:get_character_by_cqi(target_id) then
						out.design("\tscrolling camera to character with advice and mission");
						
						content_delivered = true;
					
						in_eg_capture_enemy_settlement_mission:scroll_camera_to_character_for_intervention(
							target_id,
							advice_key,
							infotext,
							mm
						);
					end;
				end;
			end;
			
			if not content_delivered then
				out.design("\tplaying advice with mission");
				in_eg_capture_enemy_settlement_mission:play_advice_for_intervention(
					advice_key,
					infotext,
					mm
				);
			end;
		end;
	end;
	
	-- set up intervention	
	in_eg_capture_enemy_settlement_mission = intervention:new(
		"eg_capture_enemy_settlement_mission", 									-- string name
		0,	 																	-- cost
		function() in_eg_capture_enemy_settlement_mission_trigger() end,		-- trigger callback
		BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
	);
	
	in_eg_capture_enemy_settlement_mission:add_precondition(
		function()
			return not get_early_game_event_experienced(event_name, true);
		end
	);
	
	in_eg_capture_enemy_settlement_mission:add_trigger_condition(
		"ScriptEventPlayerStartsOpenCampaignFromFirstTurn",
		true
	);
	
	-- if start_from_how_they_play_event_dismissed flag is set, start after the HTP event (secondary lords)
	if start_from_how_they_play_event_dismissed then
		in_eg_capture_enemy_settlement_mission:add_trigger_condition(
			"ScriptEventHowTheyPlayEventDismissed",
			true
		);
		out.design("[EG] start_early_game_missions() is triggering event ScriptEventEGHTPDismissedAlready");
		core:trigger_event("ScriptEventEGHTPDismissedAlready");
	-- if start_from_books_of_nagash_mission_issued is set, start after the startup books of nagash mission is issued
	elseif start_from_books_of_nagash_mission_issued then
		in_eg_capture_enemy_settlement_mission:add_trigger_condition(
			"ScriptEventBooksOfNagashMissionIssued",
			true
		);
	
	elseif start_from_turn_two then
		in_eg_capture_enemy_settlement_mission:add_trigger_condition(
			"ScriptEventPlayerFactionTurnStart",
			function() 
				return cm:turn_number() >= 2 
			end
		);
	end;
	
	in_eg_capture_enemy_settlement_mission:start();
end;











-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	first turn gifted units
--
--	gifts the player some units at the start of the first open turn
--	only triggers if the player played through the first-turn intro
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

function start_early_game_gifted_units_listener(char_cqi, message_title, message_primary_detail, message_secondary_detail, message_picture, ...)
	if not is_number(char_cqi) then
		script_error("ERROR: start_early_game_gifted_units_listener() called but supplied character cqi [" .. tostring(char_cqi) .. "] is not a number");
		return false;
	end;
	
	if not is_string(message_title) then
		script_error("ERROR: start_early_game_gifted_units_listener() called but supplied message title key [" .. tostring(message_title) .. "] is not a string");
		return false;
	end;
	
	if not is_string(message_primary_detail) then
		script_error("ERROR: start_early_game_gifted_units_listener() called but supplied message primary detail key [" .. tostring(message_primary_detail) .. "] is not a string");
		return false;
	end;
	
	if not is_string(message_secondary_detail) then
		script_error("ERROR: start_early_game_gifted_units_listener() called but supplied message primary detail key [" .. tostring(message_secondary_detail) .. "] is not a string");
		return false;
	end;
	
	if not is_number(message_picture) then
		script_error("ERROR: start_early_game_gifted_units_listener() called but supplied message picture key [" .. tostring(message_picture) .. "] is not a number");
		return false;
	end;
	
	for i = 1, arg.n do
		if not is_string(arg[i]) then
			script_error("ERROR: start_early_game_gifted_units_listener() called but supplied parameter [" .. i .. "] is not a string, value is [" .. tostring(arg[i]) .. "]");
			return false;
		end;
	end;
	
	
	-- pre-declare the intervention variable, so that it exists as a local for the subsequent function
	local in_eg_gifted_units = false;
	
	-- intervention trigger function
	local function in_eg_gifted_units_trigger()
		-- show message event / progress on dismiss
		cm:show_message_event(
			cm:get_local_faction_name(),
			message_title,
			message_primary_detail,
			message_secondary_detail,
			true,
			message_picture
		);
		
		cm:progress_on_events_dismissed(
			"early_game_gifted_units", 
			function()
				in_eg_gifted_units:complete();
			end
		);
		
		out.design("[EG] start_early_game_gifted_units_listener() is gifting units to player force with cqi " .. char_cqi);
		
		-- find faction leader, and grant them units
		local faction_leader_str = cm:char_lookup_str(char_cqi);
		for i = 1, arg.n do
			local current_unit = arg[i];
			out.design("\tgifting unit " .. current_unit);
			cm:grant_unit_to_character(faction_leader_str, current_unit);
		end;		
	end;
	
	-- set up intervention	
	in_eg_gifted_units = intervention:new(
		"eg_gifted_units", 														-- string name
		0,	 																	-- cost
		function() in_eg_gifted_units_trigger() end,							-- trigger callback
		BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
	);
	
	-- only start the listener if we've played the first turn and the early-game units have not already been issued
	in_eg_gifted_units:add_precondition(
		function()
			return cm:get_saved_value("bool_prelude_first_turn_was_loaded") and not cm:get_saved_value("early_game_gifted_units_issued");
		end
	);
	
	in_eg_gifted_units:add_trigger_condition(
		"ScriptEventEGCaptureEnemySettlementMissionIssued",
		true
	);
	
	in_eg_gifted_units:start();
end;











-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	generic mission listener
--
--	triggers a specified mission in an intervention when a specified event is
--	received
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

function start_early_game_generic_mission_listener(listener_name, trigger_event, mission_key, advice_key, infotext, mission_conditions_defined_in_db, event_on_success, event_on_issue)

	if not is_string(listener_name) then
		script_error("ERROR: start_early_game_generic_mission_listener() called but supplied listener name [" .. tostring(listener_name) .. "] is not a string");
		return false;
	end;

	if not is_string(trigger_event) then
		script_error("ERROR: start_early_game_generic_mission_listener() called but supplied trigger event [" .. tostring(trigger_event) .. "] is not a string");
		return false;
	end;
	
	if not is_string(mission_key) then
		script_error("ERROR: start_early_game_generic_mission_listener() called but supplied mission key [" .. tostring(mission_key) .. "] is not a string");
		return false;
	end;
	
	if advice_key and not is_string(advice_key) then
		script_error("ERROR: start_early_game_generic_mission_listener() called but supplied advice key [" .. tostring(advice_key) .. "] is not a string or nil");
		return false;
	end;
	
	if infotext and not is_table(infotext) then
		script_error("ERROR: start_early_game_generic_mission_listener() called but supplied infotext [" .. tostring(infotext) .. "] is not a table or nil");
		return false;
	end;
	
	mission_conditions_defined_in_db = not not mission_conditions_defined_in_db;
	
	if event_on_success and not is_string(event_on_success) then
		script_error("ERROR: start_early_game_generic_mission_listener() called but supplied success event [" .. tostring(event_on_success) .. "] is not a string or nil");
		return false;
	end;
	
	if event_on_issue and not is_string(event_on_issue) then
		script_error("ERROR: start_early_game_generic_mission_listener() called but supplied issuing event [" .. tostring(event_on_issue) .. "] is not a string or nil");
		return false;
	end;

	-- affects how prominently this advice will be delivered based on advice level/history
	-- possible values:
	-- EARLY_GAME_ADVICE_VOICED_BY_LEGENDARY_LORD		| advice voiced by LL, relax criteria for showing it
	-- EARLY_GAME_ADVICE_SPECIFIC_TO_FACTION			| advice voiced by advisor, string is different for different factions
	-- EARLY_GAME_ADVICE_SHARED							| advice voiced by advisor, but string is shared between factions
	local advice_mode = EARLY_GAME_ADVICE_SHARED;
	
	local mm = mission_manager:new(
		cm:get_local_faction_name(), 
		mission_key, 
		function()
			if event_on_success then
				out.design("[EG] start_early_game_generic_mission_listener() with listener name [" .. listener_name .. "] is triggering event [" .. event_on_success .. "] after mission [" .. mission_key .. "] has been succeeded");
				core:trigger_event(event_on_success);		-- success
			end;
		end	
	);
	
	if mission_conditions_defined_in_db then
		-- the options for this mission are set up in the database (the alternative is that the mission + conditions are defined in the missions.txt file)
		mm:set_is_mission_in_db();
	end;
	
	
	-- pre-declare the intervention variable, so that it exists as a local for the subsequent function
	local in_eg_generic_mission = false;
	
	-- intervention trigger function
	local function in_eg_generic_mission_trigger()
		out.design("[EG] start_early_game_generic_mission_listener() with listener name [" .. listener_name .. "] is triggering mission [" .. mission_key .. "], advice level is " .. core:get_advice_level());
		
		local delivery_mode = EARLY_GAME_SHOW_MISSION_ONLY;
		
		if advice_key then
			delivery_mode = early_game_decide_content_delivery_mode(advice_mode, advice_key);
		end;
		
		if delivery_mode == EARLY_GAME_SHOW_MISSION_ONLY then
			out.design("\tjust issuing mission");
			
			set_early_game_event_experienced(listener_name, true);
			mm:trigger();
			cm:callback(function() in_eg_generic_mission:complete() end, 1);
		
		else
			if not early_game_should_show_infotext(advice_mode, advice_key, listener_name) then
				out.design("\tnot showing infotext");
				infotext = {};
			end;
			
			out.design("\tplaying advice with mission");
		
			set_early_game_event_experienced(listener_name);
			in_eg_generic_mission:play_advice_for_intervention(
				advice_key,
				infotext,
				mm
			);
		end;
		
		if event_on_issue then
			out.design("[EG] start_early_game_generic_mission_listener() with listener name [" .. listener_name .. "] is triggering event [" .. event_on_issue .. "] after issuing mission [" .. mission_key .. "]");
			core:trigger_event(event_on_issue);
		end;
	end;
	
	-- set up intervention	
	in_eg_generic_mission = intervention:new(
		"eg_generic_mission_" .. listener_name,						-- string name
		65,	 														-- cost
		function() in_eg_generic_mission_trigger() end,				-- trigger callback
		BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
	);
	
	in_eg_generic_mission:set_must_trigger(true);
	
	in_eg_generic_mission:add_precondition(
		function()
			return not cm:get_saved_value(listener_name, true);
		end
	);
		
	-- triggers when the supplied event is received
	in_eg_generic_mission:add_trigger_condition(
		trigger_event,
		true
	);
	
	in_eg_generic_mission:start();

end;








-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	capture province mission
--
--	triggers upon completion of the capture-settlement mission, or if
--	the player captures a settlement anyhow
--	completion of this mission leads to the enact commandment mission
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

function start_early_game_capture_province_mission_listener(advice_key, infotext, mission_key, mission_issuer, mission_rewards, optional_province_number)
	
	if not is_string(advice_key) then
		script_error("ERROR: start_early_game_capture_province_mission_listener() called but supplied advice key [" .. tostring(advice_key) .. "] is not a string");
		return false;
	end;
	
	-- default infotext value
	if not infotext then
		infotext = {
			"wh2.camp.advice.provinces.info_001",		-- create default infotext
			"wh2.camp.advice.provinces.info_002",
			"wh2.camp.advice.provinces.info_003"
			
		};
	end;
	
	if not is_table(infotext) then
		script_error("ERROR: start_early_game_capture_province_mission_listener() called but supplied infotext [" .. tostring(infotext) .. "] is not a table or nil");
		return false;
	end;
	
	if not is_string(mission_key) then
		script_error("ERROR: start_early_game_capture_province_mission_listener() called but supplied mission key [" .. tostring(mission_key) .. "] is not a string");
		return false;
	end;
	
	if mission_issuer and not is_string(mission_issuer) then
		script_error("ERROR: start_early_game_capture_province_mission_listener() called but supplied mission issuer [" .. tostring(mission_issuer) .. "] is not a string or nil");
		return false;
	end;
	
	if not mission_rewards then
		mission_rewards = {"money 1000"};
	end;
	
	if not is_table(mission_rewards) then
		script_error("ERROR: start_early_game_capture_province_mission_listener() called but supplied mission rewards [" .. mission_rewards .. "] is not a table");
		return false;
	end;
	
	if #mission_rewards == 0 then
		script_error("ERROR: start_early_game_capture_province_mission_listener() called but supplied mission rewards table is empty");
		return false;
	end;
	
	for i = 1, #mission_rewards do
		if not is_string(mission_rewards[i]) then
			script_error("ERROR: start_early_game_capture_province_mission_listener() called but supplied mission reward [" .. i .. "] is [" .. tostring(mission_rewards[i]) .. "] and not a string");
			return false;
		end;
	end;
	
	if not is_string(optional_province_number) and (optional_province_number ~= nil) then
		script_error("ERROR: start_early_game_capture_province_mission_listener() called but supplied province number [" .. tostring(optional_province_number) .. "] is not a string");
		return false;
	end;
	
	-- affects how prominently this advice will be delivered based on advice level/history
	-- possible values:
	-- EARLY_GAME_ADVICE_VOICED_BY_LEGENDARY_LORD		| advice voiced by LL, relax criteria for showing it
	-- EARLY_GAME_ADVICE_SPECIFIC_TO_FACTION			| advice voiced by advisor, string is different for different factions
	-- EARLY_GAME_ADVICE_SHARED							| advice voiced by advisor, but string is shared between factions
	local advice_mode = EARLY_GAME_ADVICE_SHARED;
	
	-- set up mission
	local mm = mission_manager:new(
		cm:get_local_faction_name(), 
		mission_key, 
		function() core:trigger_event("ScriptEventPlayerCompletesProvince") end 			-- success
	);
	
	mm:add_new_objective("CONTROL_N_PROVINCES_INCLUDING");
	if (optional_province_number ~= nil) then
		mm:add_condition("total "..optional_province_number);
	else
		mm:add_condition("total 1");
	end;
	if mission_issuer then
		mm:set_mission_issuer(mission_issuer);
	end;
	
	for i = 1, #mission_rewards do
		mm:add_payload(mission_rewards[i]);
	end
	
	local event_name = "early_game_capture_province_mission_issued";
	
	-- pre-declare the intervention variable, so that it exists as a local for the subsequent function
	local in_eg_capture_province_mission = false;
	
	-- intervention trigger function
	local function in_eg_capture_province_mission_trigger()
		out.design("[EG] start_early_game_capture_province_mission_listener() is triggering mission, advice level is " .. core:get_advice_level());
		
		local delivery_mode, delivery_mode_str = early_game_decide_content_delivery_mode(advice_mode, advice_key);
		out.design("\t" .. delivery_mode_str);
	
		if delivery_mode == EARLY_GAME_SHOW_MISSION_ONLY then
			out.design("\tjust issuing mission");
			
			set_early_game_event_experienced(event_name, true);
			mm:trigger();
			cm:callback(function() in_eg_capture_province_mission:complete() end, 1);
		
		else
			if not early_game_should_show_infotext(advice_mode, advice_key, event_name) then
				out.design("\tnot showing infotext");
				infotext = {};
			end;
			
			out.design("\tplaying advice with mission");
		
			set_early_game_event_experienced(event_name);
			in_eg_capture_province_mission:play_advice_for_intervention(
				advice_key,
				infotext,
				mm
			);
		end;
	end;
	
	-- set up intervention	
	in_eg_capture_province_mission = intervention:new(
		"eg_capture_province_mission", 											-- string name
		65,	 																	-- cost
		function() in_eg_capture_province_mission_trigger() end,				-- trigger callback
		BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
	);
	
	in_eg_capture_province_mission:set_must_trigger(true);
	
	in_eg_capture_province_mission:add_precondition(
		function()
			return not cm:get_saved_value(event_name, true);
		end
	);
		
	-- triggers when the player captures a settlement
	in_eg_capture_province_mission:add_trigger_condition(
		"ScriptEventPlayerCaptureSettlement",
		true
	);
	
	-- triggers when the player completes the capture-settlement mission (this covers the possibility that the enemy lost the target settlement of that mission a different way)
	in_eg_capture_province_mission:add_trigger_condition(
		"ScriptEventEGCaptureEnemySettlementMissionSucceeded",
		true
	);
	
	in_eg_capture_province_mission:start();
end;










-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	enact commandment mission
--
--	triggers upon completion of the complete-province mission
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

function start_early_game_enact_commandment_mission_listener(advice_key, infotext, mission_key, mission_issuer, mission_rewards)
	
	if not is_string(advice_key) then
		script_error("ERROR: start_early_game_enact_commandment_mission_listener() called but supplied advice key [" .. tostring(advice_key) .. "] is not a string");
		return false;
	end;
	
	-- default infotext value
	if not infotext then
		infotext = {
			"wh2.camp.advice.commandments.info_001",		-- create default infotext
			"wh2.camp.advice.commandments.info_002",
			"wh2.camp.advice.commandments.info_003"
		};
	end;
	
	if not is_table(infotext) then
		script_error("ERROR: start_early_game_enact_commandment_mission_listener() called but supplied infotext [" .. tostring(infotext) .. "] is not a table or nil");
		return false;
	end;
	
	if not is_string(mission_key) then
		script_error("ERROR: start_early_game_enact_commandment_mission_listener() called but supplied mission key [" .. tostring(mission_key) .. "] is not a string");
		return false;
	end;
	
	if mission_issuer and not is_string(mission_issuer) then
		script_error("ERROR: start_early_game_enact_commandment_mission_listener() called but supplied mission issuer [" .. tostring(mission_issuer) .. "] is not a string or nil");
		return false;
	end;
	
	if not mission_rewards then
		mission_rewards = {"money 1000"};
	end;
	
	if not is_table(mission_rewards) then
		script_error("ERROR: start_early_game_enact_commandment_mission_listener() called but supplied mission rewards [" .. mission_rewards .. "] is not a table");
		return false;
	end;
	
	if #mission_rewards == 0 then
		script_error("ERROR: start_early_game_enact_commandment_mission_listener() called but supplied mission rewards table is empty");
		return false;
	end;
	
	for i = 1, #mission_rewards do
		if not is_string(mission_rewards[i]) then
			script_error("ERROR: start_early_game_enact_commandment_mission_listener() called but supplied mission reward [" .. i .. "] is [" .. tostring(mission_rewards[i]) .. "] and not a string");
			return false;
		end;
	end;
	
	-- affects how prominently this advice will be delivered based on advice level/history
	-- possible values:
	-- EARLY_GAME_ADVICE_VOICED_BY_LEGENDARY_LORD		| advice voiced by LL, relax criteria for showing it
	-- EARLY_GAME_ADVICE_SPECIFIC_TO_FACTION			| advice voiced by advisor, string is different for different factions
	-- EARLY_GAME_ADVICE_SHARED							| advice voiced by advisor, but string is shared between factions
	local advice_mode = EARLY_GAME_ADVICE_SHARED;
	
	-- set up mission
	local mm = mission_manager:new(
		cm:get_local_faction_name(), 
		mission_key
	);
	
	mm:add_new_objective("ISSUE_PROVINCE_INITIATIVE");
	mm:add_condition("total 1");
	
	if mission_issuer then
		mm:set_mission_issuer(mission_issuer);
	end;
	
	for i = 1, #mission_rewards do
		mm:add_payload(mission_rewards[i]);
	end
	
	local event_name = "early_game_enact_commandment_mission_issued";
	
	-- pre-declare the intervention variable, so that it exists as a local for the subsequent function
	local in_eg_enact_commandment_mission = false;
	
	-- intervention trigger function
	local function in_eg_enact_commandment_mission_trigger()
		out.design("[EG] start_early_game_capture_province_mission_listener() is triggering mission, advice level is " .. core:get_advice_level());
		
		local delivery_mode, delivery_mode_str = early_game_decide_content_delivery_mode(advice_mode, advice_key);
		out.design("\t" .. delivery_mode_str);
	
		if delivery_mode == EARLY_GAME_SHOW_MISSION_ONLY then
			out.design("\tjust issuing mission");
		
			set_early_game_event_experienced(event_name, true);
			mm:trigger();
			cm:callback(function() in_eg_enact_commandment_mission:complete() end, 1);
		
		else
			if not early_game_should_show_infotext(advice_mode, advice_key, event_name) then
				out.design("\tnot showing infotext");
				infotext = {};
			end;
		
			out.design("\tplaying advice with mission");
		
			set_early_game_event_experienced(event_name);
			in_eg_enact_commandment_mission:play_advice_for_intervention(
				advice_key,
				infotext,
				mm
			);
		end;
	end;
	
	-- set up intervention	
	in_eg_enact_commandment_mission = intervention:new(
		"eg_enact_commandment_mission", 										-- string name
		60,	 																	-- cost
		function() in_eg_enact_commandment_mission_trigger() end,				-- trigger callback
		BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
	);
	
	in_eg_enact_commandment_mission:set_must_trigger(true);
	in_eg_enact_commandment_mission:add_whitelist_event_type("conquest_province_securedevent_feed_target_province_faction");
	
	in_eg_enact_commandment_mission:add_precondition(
		function()
			return not get_early_game_event_experienced(event_name, true);
		end
	);
	
	in_eg_enact_commandment_mission:add_trigger_condition(
		"ScriptEventPlayerCompletesProvince",
		true
	);
	
	in_eg_enact_commandment_mission:start();
end;











-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	search ruins mission
--
--	triggers when the player starts the second turn
--	completion of this mission leads to a rogue army spawning and subsequent
--	mission
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

function start_early_game_search_ruins_mission_listener(advice_key, infotext, region_key, trigger_turn, mission_key, mission_issuer, mission_rewards, factions_personalities_mapping)
	
	if not is_string(advice_key) then
		script_error("ERROR: start_early_game_search_ruins_mission_listener() called but supplied advice key [" .. tostring(advice_key) .. "] is not a string");
		return false;
	end;
	
	-- default infotext value
	if not infotext then
		infotext = {
			"wh2.camp.advice.ruins.info_001",		-- create default infotext
			"wh2.camp.advice.ruins.info_002",
			"wh2.camp.advice.ruins.info_003"
		};
	end;
	
	if not is_table(infotext) then
		script_error("ERROR: start_early_game_search_ruins_mission_listener() called but supplied infotext [" .. tostring(infotext) .. "] is not a table or nil");
		return false;
	end;
	
	if not is_string(region_key) then
		script_error("ERROR: start_early_game_search_ruins_mission_listener() called but supplied region key [" .. tostring(region_key) .. "] is not a string");
		return false;
	end;
	
	trigger_turn = trigger_turn or 2;
	
	if not is_number(trigger_turn) or trigger_turn < 1 then
		script_error("ERROR: start_early_game_search_ruins_mission_listener() called but supplied trigger turn [" .. tostring(trigger_turn) .. "] is not a positive number or nil");
		return false;
	end;
	
	local region = cm:get_region(region_key);
	
	if not region then
		script_error("ERROR: start_early_game_search_ruins_mission_listener() called but no region with supplied name [" .. region_key .. "] could be found");
		return false;
	end;
	
	if not region:is_abandoned() and not cm:get_saved_value("early_game_search_ruins_mission_issued") then
		script_error("ERROR: start_early_game_search_ruins_mission_listener() called but region with supplied name [" .. region_key .. "] is currently owned by faction [" .. region:owning_faction():name() .. "] .. and the search-ruins mission has not been issued");
		return false;
	end;
	
	if not is_string(mission_key) then
		script_error("ERROR: start_early_game_search_ruins_mission_listener() called but supplied mission key [" .. tostring(mission_key) .. "] is not a string");
		return false;
	end;
	
	if mission_issuer and not is_string(mission_issuer) then
		script_error("ERROR: start_early_game_search_ruins_mission_listener() called but supplied mission issuer [" .. tostring(mission_issuer) .. "] is not a string or nil");
		return false;
	end;
	
	if not mission_rewards then
		mission_rewards = {"money 1000"};
	end;
	
	if not is_table(mission_rewards) then
		script_error("ERROR: start_early_game_search_ruins_mission_listener() called but supplied mission rewards [" .. mission_rewards .. "] is not a table");
		return false;
	end;
	
	if #mission_rewards == 0 then
		script_error("ERROR: start_early_game_search_ruins_mission_listener() called but supplied mission rewards table is empty");
		return false;
	end;
	
	for i = 1, #mission_rewards do
		if not is_string(mission_rewards[i]) then
			script_error("ERROR: start_early_game_search_ruins_mission_listener() called but supplied mission reward [" .. i .. "] is [" .. tostring(mission_rewards[i]) .. "] and not a string");
			return false;
		end;
	end;
	
	factions_personalities_mapping = factions_personalities_mapping or {};
	
	for i = 1, #factions_personalities_mapping do
		local current_faction_mapping = factions_personalities_mapping[i];
		
		if not is_table(current_faction_mapping) then
			script_error("ERROR: start_early_game_search_ruins_mission_listener() called but mapping [" .. i .. "] of supplied factions to personalities mapping [" .. tostring(current_faction_mapping) .. "] is not a table");
			return false;
		end;
		
		if not cm:get_faction(current_faction_mapping.faction_key) then
			script_error("ERROR: start_early_game_search_ruins_mission_listener() called but faction key [" .. tostring(current_faction_mapping.faction_key) .. "] within mapping [" .. i .. "] of supplied factions to personalities mapping is not a valid faction key");
			return false;
		end;
		
		if not is_string(current_faction_mapping.start_personality_easy) then
			script_error("ERROR: start_early_game_search_ruins_mission_listener() called but starting personality (easy) [" .. tostring(current_faction_mapping.start_personality_easy) .. "] within mapping [" .. i .. "] of supplied factions to personalities mapping is not a string");
			return false;
		end;
		
		if not is_string(current_faction_mapping.start_personality_normal) then
			script_error("ERROR: start_early_game_search_ruins_mission_listener() called but starting personality (normal) [" .. tostring(current_faction_mapping.start_personality_normal) .. "] within mapping [" .. i .. "] of supplied factions to personalities mapping is not a string");
			return false;
		end;
		
		if not is_string(current_faction_mapping.start_personality_hard) then
			script_error("ERROR: start_early_game_search_ruins_mission_listener() called but starting personality (hard) [" .. tostring(current_faction_mapping.start_personality_hard) .. "] within mapping [" .. i .. "] of supplied factions to personalities mapping is not a string");
			return false;
		end;
		
		if not is_string(current_faction_mapping.complete_personality_easy) then
			script_error("ERROR: start_early_game_search_ruins_mission_listener() called but completion personality (easy) [" .. tostring(current_faction_mapping.complete_personality_easy) .. "] within mapping [" .. i .. "] of supplied factions to personalities mapping is not a string");
			return false;
		end;
		
		if not is_string(current_faction_mapping.complete_personality_normal) then
			script_error("ERROR: start_early_game_search_ruins_mission_listener() called but completion personality (normal) [" .. tostring(current_faction_mapping.complete_personality_normal) .. "] within mapping [" .. i .. "] of supplied factions to personalities mapping is not a string");
			return false;
		end;
		
		if not is_string(current_faction_mapping.complete_personality_hard) then
			script_error("ERROR: start_early_game_search_ruins_mission_listener() called but completion personality (hard) [" .. tostring(current_faction_mapping.complete_personality_hard) .. "] within mapping [" .. i .. "] of supplied factions to personalities mapping is not a string");
			return false;
		end;
	end;


	
	-- affects how prominently this advice will be delivered based on advice level/history
	-- possible values:
	-- EARLY_GAME_ADVICE_VOICED_BY_LEGENDARY_LORD		| advice voiced by LL, relax criteria for showing it
	-- EARLY_GAME_ADVICE_SPECIFIC_TO_FACTION			| advice voiced by advisor, string is different for different factions
	-- EARLY_GAME_ADVICE_SHARED							| advice voiced by advisor, but string is shared between factions
	local advice_mode = EARLY_GAME_ADVICE_VOICED_BY_LEGENDARY_LORD;
	
	-- set up mission
	local mm = mission_manager:new(
		cm:get_local_faction_name(), 
		mission_key,
		function() core:trigger_event("ScriptEventEGSearchRuinsMissionSucceeded") end 			-- success
	);
		
	mm:add_new_objective("SEARCH_RUINS");
	mm:add_condition("total 1");
	
	if mission_issuer then
		mm:set_mission_issuer(mission_issuer);
	end;
	
	-- mm:add_condition("region " .. region_key);			-- don't specify a target region, so the mission succeeds no matter which ruins are searched
	for i = 1, #mission_rewards do
		mm:add_payload(mission_rewards[i]);
	end
	
	local event_name = "early_game_search_ruins_mission_issued";
	
	-- pre-declare the intervention variable, so that it exists as a local for the subsequent function
	local in_eg_search_ruins_mission = false;
	
	-- intervention trigger function
	local function in_eg_search_ruins_mission_trigger()
		out.design("[EG] start_early_game_search_ruins_mission_listener() is triggering mission, advice level is " .. core:get_advice_level());
		
		local delivery_mode, delivery_mode_str = early_game_decide_content_delivery_mode(advice_mode, advice_key);
		out.design("\t" .. delivery_mode_str);
		
		if delivery_mode == EARLY_GAME_SHOW_MISSION_ONLY then
			out.design("\tjust issuing mission");
			
			set_early_game_event_experienced(event_name, true);
			mm:trigger();
			cm:callback(function() in_eg_search_ruins_mission:complete() end, 1);
			
		else
			if not early_game_should_show_infotext(advice_mode, advice_key, event_name) then
				out.design("\tnot showing infotext");
				infotext = {};
			end;
		
			set_early_game_event_experienced(event_name);		
			if delivery_mode == EARLY_GAME_SCROLL_CAMERA_WITH_ADVICE_AND_MISSION and cm:get_region(region_key):is_abandoned() then
				out.design("\tscrolling camera to settlement with advice and mission");
			
				in_eg_search_ruins_mission:scroll_camera_to_settlement_for_intervention(
					region_key,
					advice_key,
					infotext,
					mm
				);
			else
				out.design("\tplaying advice with mission");
			
				in_eg_search_ruins_mission:play_advice_for_intervention(
					advice_key,
					infotext,
					mm
				);
			end;
		end;
	end;
	
	-- set up intervention	
	in_eg_search_ruins_mission = intervention:new(
		"eg_search_ruins_mission", 												-- string name
		70,	 																	-- cost
		function() in_eg_search_ruins_mission_trigger() end,					-- trigger callback
		BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
	);
	
	in_eg_search_ruins_mission:set_must_trigger(true);
	
	in_eg_search_ruins_mission:add_precondition(
		function()
			return not get_early_game_event_experienced(event_name, true);
		end
	);
	
	-- triggers if any of the player's armies can get to a ruin this turn
	in_eg_search_ruins_mission:add_trigger_condition(
		"ScriptEventPlayerFactionTurnStart",
		function()
			local faction = cm:get_faction(cm:get_local_faction_name());
			local character_list = faction:character_list();
			
			for i = 0, character_list:num_items() - 1 do
				local current_char = character_list:item_at(i);
				
				if cm:char_is_general_with_army(current_char) and current_char:has_region() then
					if current_char:region():is_abandoned() and cm:character_can_reach_settlement(current_char, current_char:region():settlement()) then
						return true;
					end;
					
					-- also check adjacent regions
					local adjacent_region_list = current_char:region():adjacent_region_list();
					for j = 0, adjacent_region_list:num_items() - 1 do
						local current_region = adjacent_region_list:item_at(j);
						
						if current_region:is_abandoned() and cm:character_can_reach_settlement(current_char, current_region:settlement()) then
							return true;
						end;
					end;
				end;
			end;
		end
	);	
	
	-- trigger at the start of the specified turn if it's not been triggered already
	in_eg_search_ruins_mission:add_trigger_condition(
		"ScriptEventPlayerFactionTurnStart",
		function()
			return cm:model():turn_number() >= trigger_turn + cm:get_saved_value("first_turn_count_modifier");
		end
	);
	
	in_eg_search_ruins_mission:start();
	
	-- establish listener for this mission succeeding, at which point we need to remove the hidden effect bundle and reset the faction personalities
	if not cm:get_saved_value("early_game_search_ruins_mission_completed") then
		core:add_listener(
			"early_game_search_ruins_mission",
			"ScriptEventEGSearchRuinsMissionSucceeded",
			true,
			function()
				cm:set_saved_value("early_game_search_ruins_mission_completed", true);
				
				-- modify supplied faction personalities so that they can colonise ruins
				local difficulty_level = cm:model():difficulty_level();
				for i = 1, #factions_personalities_mapping do
					local current_faction_mapping = factions_personalities_mapping[i];
					local current_personality_key = false;
					
					if difficulty_level == 1 then
						-- easy difficulty
						current_personality_key = current_faction_mapping.complete_personality_easy;
					elseif difficulty_level == 0 or difficulty_level == -1 then
						-- normal/hard difficulty
						current_personality_key = current_faction_mapping.complete_personality_normal;
					else
						-- v.hard/legendary difficulty
						current_personality_key = current_faction_mapping.complete_personality_hard;
					end;
					
					out.design("[EG] start_early_game_search_ruins_mission_listener() is setting personality of faction [" .. current_faction_mapping.faction_key .. "] to [" .. current_personality_key .. "], current difficulty level is [" .. difficulty_level .. "]");
					cm:force_change_cai_faction_personality(current_faction_mapping.faction_key, current_personality_key);
				end;
			end,
			false
		);
	end;
	
	-- modify supplied faction personalities, once
	if not cm:get_saved_value("early_game_search_ruins_personalities_set_up") then
		cm:set_saved_value("early_game_search_ruins_personalities_set_up", true);
	
		local difficulty_level = cm:model():difficulty_level();
		for i = 1, #factions_personalities_mapping do
			local current_faction_mapping = factions_personalities_mapping[i];
			local current_personality_key = false;
			
			if difficulty_level == 1 then
				-- easy difficulty
				current_personality_key = current_faction_mapping.start_personality_easy;
			elseif difficulty_level == 0 or difficulty_level == -1 then
				-- normal/hard difficulty
				current_personality_key = current_faction_mapping.start_personality_normal;
			else
				-- v.hard/legendary difficulty
				current_personality_key = current_faction_mapping.start_personality_hard;
			end;
			
			out.design("[EG] start_early_game_search_ruins_mission_listener() is setting personality of faction [" .. current_faction_mapping.faction_key .. "] to [" .. current_personality_key .. "], current difficulty level is [" .. difficulty_level .. "]");
			cm:force_change_cai_faction_personality(current_faction_mapping.faction_key, current_personality_key);
		end;
	end;
end;












-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	rogue army mission
--
--	triggers a turn after the search ruins mission is completed
--	player is tasked to engage the rogue army
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

function start_early_game_rogue_army_mission_listener(advice_key, infotext, mission_key, mission_issuer, rogue_army_faction_name, rogue_army_position_list, rogue_army_unit_list, rogue_army_home_region, mission_rewards)
	
	if not is_string(advice_key) then
		script_error("ERROR: start_early_game_rogue_army_mission_listener() called but supplied advice key [" .. tostring(advice_key) .. "] is not a string");
		return false;
	end;
	
	-- default infotext value
	if not infotext then
		infotext = {
			"wh2.camp.advice.rogue_armies.info_001",		-- create default infotext
			"wh2.camp.advice.rogue_armies.info_002",
			"wh2.camp.advice.rogue_armies.info_003"
		};
	end;
	
	if not is_table(infotext) then
		script_error("ERROR: start_early_game_rogue_army_mission_listener() called but supplied infotext [" .. tostring(infotext) .. "] is not a table or nil");
		return false;
	end;
	
	if not is_string(mission_key) then
		script_error("ERROR: start_early_game_rogue_army_mission_listener() called but supplied mission key [" .. tostring(mission_key) .. "] is not a string");
		return false;
	end;
	
	if mission_issuer and not is_string(mission_issuer) then
		script_error("ERROR: start_early_game_rogue_army_mission_listener() called but supplied mission issuer [" .. tostring(mission_issuer) .. "] is not a string or nil");
		return false;
	end;
	
	if not is_string(rogue_army_faction_name) then
		script_error("ERROR: start_early_game_rogue_army_mission_listener() called but supplied rogue army faction name [" .. tostring(rogue_army_faction_name) .. "] is not a string");
		return false;
	end;
	
	if not is_table(rogue_army_position_list) then
		script_error("ERROR: start_early_game_rogue_army_mission_listener() called but supplied position list [" .. tostring(rogue_army_position_list) .. "] is not a table");
		return false;
	end;
	
	if #rogue_army_position_list == 0 then
		script_error("ERROR: start_early_game_rogue_army_mission_listener() called but supplied position list [" .. tostring(rogue_army_position_list) .. "] is empty");
		return false;
	end;
	
	for i = 1, #rogue_army_position_list do	
		local current_entry = rogue_army_position_list[i];
		if not is_table(current_entry) then
			script_error("ERROR: start_early_game_rogue_army_mission_listener() called but element [" .. i .. "] in supplied position list is not a table");
			return false;
		end;
		
		if not is_vector(current_entry[1]) then
			script_error("ERROR: start_early_game_rogue_army_mission_listener() called but first sub-element of element [" .. i .. "] in supplied list is not a vector but a [" .. tostring(current_entry[1]) .. "]");
			return false;
		end;
		
		if not is_string(current_entry[2]) then
			script_error("ERROR: start_early_game_rogue_army_mission_listener() called but second sub-element of element [" .. i .. "] in supplied list is not a string but a [" .. tostring(current_entry[2]) .. "]");
			return false;
		end;
		
		if not cm:get_region(current_entry[2]) then
			script_error("ERROR: start_early_game_rogue_army_mission_listener() called but no region could be found with supplied name [" .. current_entry[2] .. "] (in element [" .. i .."] of supplied position list)");
			return false;
		end;
	end;
	
	if not is_string(rogue_army_unit_list) then
		script_error("ERROR: start_early_game_rogue_army_mission_listener() called but supplied unit list [" .. tostring(rogue_army_unit_list) .. "] is not a string");
		return false;
	end;
	
	if not is_string(rogue_army_home_region) then
		script_error("ERROR: start_early_game_rogue_army_mission_listener() called but supplied home region [" .. tostring(rogue_army_home_region) .. "] is not a string");
		return false;
	end;
	
	if not mission_rewards then
		mission_rewards = {"money 1000"};
	end;
	
	if not is_table(mission_rewards) then
		script_error("ERROR: start_early_game_rogue_army_mission_listener() called but supplied mission rewards [" .. mission_rewards .. "] is not a table");
		return false;
	end;
	
	if #mission_rewards == 0 then
		script_error("ERROR: start_early_game_rogue_army_mission_listener() called but supplied mission rewards table is empty");
		return false;
	end;
	
	for i = 1, #mission_rewards do
		if not is_string(mission_rewards[i]) then
			script_error("ERROR: start_early_game_rogue_army_mission_listener() called but supplied mission reward [" .. i .. "] is [" .. tostring(mission_rewards[i]) .. "] and not a string");
			return false;
		end;
	end;
	
	local local_faction = cm:get_local_faction_name();
	
	local event_name = "early_game_rogue_armies_mission_issued";
	
	if not get_early_game_event_experienced(event_name, true) then
		-- listen for the player searching ruins, and spawn a rogue army some turns after
		out.design("[EG] start_early_game_rogue_army_mission_listener() is establishing a listener for ScriptEventEGSearchRuinsMissionSucceeded");
		core:add_listener(
			"start_early_game_rogue_army_mission_listener",
			"ScriptEventEGSearchRuinsMissionSucceeded",
			true,
			function() 
				cm:add_turn_countdown_event(
					local_faction, 
					3, 
					"ScriptEventEGSpawnRogueArmy"
				);
			end,
			false
		);
	end;
	
	-- affects how prominently this advice will be delivered based on advice level/history
	-- possible values:
	-- EARLY_GAME_ADVICE_VOICED_BY_LEGENDARY_LORD		| advice voiced by LL, relax criteria for showing it
	-- EARLY_GAME_ADVICE_SPECIFIC_TO_FACTION			| advice voiced by advisor, string is different for different factions
	-- EARLY_GAME_ADVICE_SHARED							| advice voiced by advisor, but string is shared between factions
	local advice_mode = EARLY_GAME_ADVICE_SHARED;
	
	-- set up mission
	local mm = mission_manager:new(
		local_faction, 
		mission_key,
		function() core:trigger_event("ScriptEventEGRogueArmiesMissionSucceeded") end 			-- success
	);
		
	mm:add_new_objective("ENGAGE_FORCE");
	mm:add_condition("faction " .. rogue_army_faction_name);
	
	if mission_issuer then
		mm:set_mission_issuer(mission_issuer);
	end;
	
	for i = 1, #mission_rewards do
		mm:add_payload(mission_rewards[i]);
	end
	
	-- pre-declare the intervention variable, so that it exists as a local for the subsequent function
	local in_eg_rogue_armies_mission = false;
	
	-- intervention trigger function
	local function in_eg_rogue_armies_mission_trigger()
	
		-- set the can_spawn save bool value back to false so the listener will never be re-established
		cm:set_saved_value("early_game_rogue_army_may_spawn", false);
	
		-- randomly sort position list
		local random_position_list = cm:random_sort_copy(rogue_army_position_list);
		
		local spawn_position = false;
		local spawn_region = false;
		
		-- find position that is not close to a player army (within 6 hexes)
		for i = 1, #random_position_list do
			local current_position = random_position_list[i][1];
		
			local closest_player_char, closest_player_char_distance =  cm:get_closest_character_to_position_from_faction(local_faction, current_position:get_x(), current_position:get_y(), false, true);
			
			if closest_player_char_distance >= 6 then
				spawn_position = current_position;
				spawn_region = random_position_list[i][2];
				break;
			end;
		end;
		
		if not spawn_position then
			script_error("WARNING: in_eg_rogue_armies_mission is trying to spawn a rogue army, but couldn't find a position that's not close to the player - choosing random position");
			spawn_position = random_position_list[1];
		end;
		
		out.design("[EG] start_early_game_rogue_army_mission_listener() is triggering, spawning rogue army of faction " .. rogue_army_faction_name .. " at position [" .. spawn_position:get_x() .. ", " .. spawn_position:get_z() .. "] in region [" .. spawn_region .. "], advice level is " .. core:get_advice_level());
	
		-- create our rogue army
		local function spawn_rogue_army()
			cm:spawn_rogue_army(rogue_army_faction_name, spawn_position:get_x(), spawn_position:get_z());
		end;
		
		local delivery_mode, delivery_mode_str = early_game_decide_content_delivery_mode(advice_mode, advice_key);
		out.design("\t" .. delivery_mode_str);
		
		if delivery_mode == EARLY_GAME_SHOW_MISSION_ONLY then
			out.design("\tjust issuing mission");
		
			spawn_rogue_army();
			set_early_game_event_experienced(event_name, true);
			mm:trigger();
			cm:callback(function() in_eg_rogue_armies_mission:complete() end, 1);
		
		else
			if not early_game_should_show_infotext(advice_mode, advice_key, event_name) then
				out.design("\tnot showing infotext");
				infotext = {};
			end;
			
			set_early_game_event_experienced(event_name);
			
			out.design("\tscrolling camera to army with advice and mission");
		
			local dis_x, dis_y = cm:log_to_dis(spawn_position:get_x(), spawn_position:get_z());
		
			in_eg_rogue_armies_mission:scroll_camera_for_intervention(
				spawn_region,
				dis_x,
				dis_y,
				advice_key,
				infotext,
				mm,
				3,
				function() spawn_rogue_army() end
			);
		end;
	end;
	
	
	-- set up intervention	
	in_eg_rogue_armies_mission = intervention:new(
		"eg_rogue_armies_mission", 												-- string name
		25,	 																	-- cost
		function() in_eg_rogue_armies_mission_trigger() end,					-- trigger callback
		BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
	);
	
	-- in_eg_rogue_armies_mission:set_must_trigger(true);
	
	in_eg_rogue_armies_mission:add_precondition(
		function()
			return not get_early_game_event_experienced(event_name, true);
		end
	);
	
	-- trigger the turn after the player searches ruins
	in_eg_rogue_armies_mission:add_trigger_condition(
		"ScriptEventPlayerFactionTurnStart",
		function()
			return cm:get_saved_value("early_game_rogue_army_may_spawn");
		end
	);
	
	in_eg_rogue_armies_mission:start();
	
	-- set up a listener for the ScriptEventEGSpawnRogueArmy event, upon which we set a savegame value which the intervention queries to determine whether it can trigger
	-- Uniquely, this mission won't trigger if it's present in the player's advice history, so they will only see one rogue army early-game mission until the advice history is reset
	if not cm:get_saved_value("early_game_rogue_army_may_spawn") and not get_early_game_event_experienced(event_name) then
		out.design("[EG] start_early_game_rogue_army_mission_listener() is establishing a listener for ScriptEventEGSpawnRogueArmy");
		core:add_listener(
			"start_early_game_rogue_army_mission_listener",
			"ScriptEventEGSpawnRogueArmy",
			true,
			function()
				out.design("[EG] start_early_game_rogue_army_mission_listener() is responding to ScriptEventEGSpawnRogueArmy event, scripted rogue army will now be allowed to spawn on turn start");
				cm:set_saved_value("early_game_rogue_army_may_spawn", true);
			end,
			false
		);
	end;
end;










-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	upgrade settlement mission
--
--	triggers at the start of a normal campaign, and if the player cancels their
--	building construction from the campaign first-turn
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

function start_early_game_upgrade_settlement_mission_listener(mission_key, mission_issuer, building_keys, target_region_key, mission_rewards, ignore_how_they_play, use_construct_building_in_provinces_mission_type)
	
	if not is_string(mission_key) then
		script_error("ERROR: start_early_game_upgrade_settlement_mission_listener() called but supplied mission key [" .. tostring(mission_key) .. "] is not a string");
		return false;
	end;
	
	if mission_issuer and not is_string(mission_issuer) then
		script_error("ERROR: start_early_game_upgrade_settlement_mission_listener() called but supplied mission issuer [" .. tostring(mission_issuer) .. "] is not a string or nil");
		return false;
	end;
	
	-- if only a single building key has been supplied, as a string, then wrap it in a table
	if is_string(building_keys) then
		building_keys = {building_keys};
	end;
	
	if not is_table(building_keys) then
		script_error("ERROR: start_early_game_upgrade_settlement_mission_listener() called but supplied list of building keys [" .. tostring(building_keys) .. "] is not a table");
		return false;
	end;
	
	for i = 1, #building_keys do
		if not is_string(building_keys[i]) then
			script_error("ERROR: start_early_game_upgrade_settlement_mission_listener() called but item [" .. i .. "] in supplied list of building keys is not a string, its value is [" .. tostring(building_keys[i]) .. "]");
			return false;
		end;
	end;
	
	if not is_string(target_region_key) then
		script_error("ERROR: start_early_game_upgrade_settlement_mission_listener() called but supplied target region key [" .. tostring(target_region_key) .. "] is not a string");
		return false;
	end;
	
	if not cm:get_region(target_region_key) then
		script_error("ERROR: start_early_game_upgrade_settlement_mission_listener() called but no region with supplied region key [" .. target_region_key .. "] could be found");
		return false;
	end;
	
	if not mission_rewards then
		mission_rewards = {"money 1000"};
	end;
	
	if not is_table(mission_rewards) then
		script_error("ERROR: start_early_game_upgrade_settlement_mission_listener() called but supplied mission rewards [" .. mission_rewards .. "] is not a table");
		return false;
	end;
	
	if #mission_rewards == 0 then
		script_error("ERROR: start_early_game_upgrade_settlement_mission_listener() called but supplied mission rewards table is empty");
		return false;
	end;
	
	for i = 1, #mission_rewards do
		if not is_string(mission_rewards[i]) then
			script_error("ERROR: start_early_game_upgrade_settlement_mission_listener() called but supplied mission reward [" .. i .. "] is [" .. tostring(mission_rewards[i]) .. "] and not a string");
			return false;
		end;
	end;
	
	ignore_how_they_play = not not ignore_how_they_play;
	use_construct_building_in_provinces_mission_type = not not use_construct_building_in_provinces_mission_type;
	
	-- construct_building_in_provinces mission type only supports one building
	if use_construct_building_in_provinces_mission_type and #building_keys > 1 then
		script_error("ERROR: start_early_game_upgrade_settlement_mission_listener() called, it has been set to use CONSTRUCT_BUILDING_IN_PROVINCES mission type and more than one building key has been specified - this is not permitted");
		return false;
	end;
	
	local province_key = cm:get_region(target_region_key):province_name();
	
	local local_faction = cm:get_local_faction_name();
	local event_name = "early_game_upgrade_settlement_mission_issued";
	
	-- set up mission
	local mm = mission_manager:new(
		local_faction, 
		mission_key,
		function() core:trigger_event("ScriptEventEGSettlementUpgraded") end 			-- success
	);
	
	if use_construct_building_in_provinces_mission_type then
		mm:add_new_objective("CONSTRUCT_BUILDING_IN_PROVINCES");
		mm:add_condition("province " .. province_key);
	else
		mm:add_new_objective("CONSTRUCT_N_BUILDINGS_FROM");
		mm:add_condition("total 1");
	end;
	
	for i = 1, #building_keys do
		mm:add_condition("building_level " .. building_keys[i]);
	end;
	
	mm:add_condition("faction " .. local_faction);
	
	if mission_issuer then
		mm:set_mission_issuer(mission_issuer);
	end;
	
	for i = 1, #mission_rewards do
		mm:add_payload(mission_rewards[i]);
	end;
	
	
	-- pre-declare the intervention variable, so that it exists as a local for the subsequent function
	local in_eg_upgrade_settlement_mission = false;
	
	-- intervention trigger function
	local function in_eg_upgrade_settlement_mission_trigger()
		out.design("[EG] start_early_game_upgrade_settlement_mission_listener() is triggering mission, advice level is " .. core:get_advice_level());
		
		core:remove_listener(listener_name);
		
		core:trigger_event("ScriptEventEGSettlementUpgradeMissionIssued");
		
		set_early_game_event_experienced(event_name, true);
		if core:is_advice_level_minimal() then
			out.design("\tjust issuing mission");
			
			mm:trigger();
			cm:callback(function() in_eg_upgrade_settlement_mission:complete() end, 1);
		else
			
			-- work out if we should return the camera
			-- if the target region is currently held by the player, and it's more than a certain distance away from where the camera is currently, scroll the camera there
			-- otherwise, don't scroll the camera
			local target_region = cm:get_region(target_region_key);
			local targ_x = false;
			local targ_y = false;
			local cam_x, cam_y, cam_d, cam_b, cam_h = cm:get_camera_position();
			
			if target_region:owning_faction() == cm:get_faction(cm:get_local_faction_name()) then
				targ_x = target_region:settlement():display_position_x();
				targ_y = target_region:settlement():display_position_y();
			end;
			
			if targ_x and distance_squared(targ_x, targ_y, cam_x, cam_y) > 144 then
				out.design("\tscrolling camera with mission");
				cm:scroll_camera_with_cutscene(
					1, 
					function()
						mm:trigger(function() in_eg_upgrade_settlement_mission:complete() end);	
					end, 
					{targ_x, targ_y, cam_d, cam_b, cam_h}
				);
			else
				out.design("\tjust issuing mission, camera is close to target region [" .. target_region_key .. "] or this region is no longer held by the player");
				mm:trigger(function() in_eg_upgrade_settlement_mission:complete() end);
			end;
		end;
	end;
	
	-- set up intervention	
	in_eg_upgrade_settlement_mission = intervention:new(
		"eg_upgrade_settlement_mission", 										-- string name
		0,	 																	-- cost
		function() in_eg_upgrade_settlement_mission_trigger() end,				-- trigger callback
		BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
	);
	
	in_eg_upgrade_settlement_mission:add_precondition(
		function()
			return not get_early_game_event_experienced(event_name, true);
		end
	);
	
	-- if the intro first turn was not played through, issue this mission after the how-they-play mission
	if not cm:get_saved_value("bool_first_turn_intro_completed") and not ignore_how_they_play then
		in_eg_upgrade_settlement_mission:add_trigger_condition(
			-- "ScriptEventEGCaptureEnemySettlementMissionIssued",
			"ScriptEventHowTheyPlayEventDismissed",
			function()
				out.design("[EG] start_early_game_upgrade_settlement_mission_listener() has received event ScriptEventHowTheyPlayEventDismissed, attempting to trigger");
				return true;
			end
		);
	else
		-- otherwise, attempt to issue it if the player earns a development point in this region
		-- (this would happen if the player cancels the upgrade already happening)
		in_eg_upgrade_settlement_mission:add_trigger_condition(
			"ScriptEventPlayerRegionGainedDevelopmentPoint",
			function(context)
				if context:region():province_name() == province_key then
					out.design("[EG] start_early_game_upgrade_settlement_mission_listener() is attempting to trigger as the player has earned a development point in province " .. province_key);
					core:remove_listener(event_name)
					return true;
				end;
			end
		);
	end;
	
	-- Also listen for the building being built without the mission having ever been triggered
	-- This happens if the player plays through the first turn and doesn't cancel the upgrade that was started there
	if not get_early_game_event_experienced(event_name, true) then
		local building_key = "";
		core:add_listener(
			event_name,
			"ScriptEventPlayerBuildingCompleted",
			function(context)
				local region = context:garrison_residence():region();
				
				if region:province_name() ~= province_key then
					return false;
				end;
				
				for i = 1, #building_keys do
					if region:building_exists(building_keys[i]) then
						building_key = building_keys[i];
						return true;
					end;
				end;
			end,
			function()
				out.design("[EG] start_early_game_upgrade_settlement_mission_listener() is terminating as the player has constructed building " .. building_key .. " in province " .. province_key);
			
				-- act as if the mission has been issued
				set_early_game_event_experienced(event_name, true);
				core:remove_listener(event_name);
				
				core:trigger_event("ScriptEventEGSettlementUpgraded")
			end,
			false
		);
	end;
	
	in_eg_upgrade_settlement_mission:start();
end;









-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	construct tech building mission
--
--	triggers after settlement-upgrade mission is completed
--	leads to research tech mission
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

function start_early_game_tech_building_mission_listener(advice_key, infotext, mission_key, mission_issuer, buildings, mission_rewards, start_from_how_they_play_event_dismissed, building_override_list)

	if not is_string(advice_key) then
		script_error("ERROR: start_early_game_tech_building_mission_listener() called but supplied advice key [" .. tostring(advice_key) .. "] is not a string");
		return false;
	end;
	
	-- default infotext value
	if not infotext then
		infotext = {
			"wh2.camp.eg.technology_buildings.info_001",		-- create default infotext
			"wh2.camp.eg.technology_buildings.info_002",
			"wh2.camp.eg.technology_buildings.info_003"
		};
	end;
	
	if not is_table(infotext) then
		script_error("ERROR: start_early_game_tech_building_mission_listener() called but supplied infotext [" .. tostring(infotext) .. "] is not a table or nil");
		return false;
	end;
	
	if not is_string(mission_key) then
		script_error("ERROR: start_early_game_tech_building_mission_listener() called but supplied mission key [" .. tostring(mission_key) .. "] is not a string");
		return false;
	end;
	
	if mission_issuer and not is_string(mission_issuer) then
		script_error("ERROR: start_early_game_tech_building_mission_listener() called but supplied mission key [" .. tostring(mission_issuer) .. "] is not a string or nil");
		return false;
	end;
	
	for i = 1, #mission_rewards do
		if not is_string(mission_rewards[i]) then
			script_error("ERROR: start_early_game_tech_building_mission_listener() called but supplied mission reward [" .. i .. "] is [" .. tostring(mission_rewards[i]) .. "] and not a string");
			return false;
		end;
	end;
	
	if #buildings == 0 then
		script_error("ERROR: start_early_game_tech_building_mission_listener() called but no building keys supplied");
		return false;
	end;	
	
	for i = 1, #buildings do
		if not is_string(buildings[i]) then
			script_error("ERROR: start_early_game_tech_building_mission_listener() called but item [" .. i .. "] in supplied building key list [" .. tostring(buildings[i]) .. "] is not a string");
			return false;
		end;
	end;
	
	if not mission_rewards then
		mission_rewards = {"money 1000"};
	end;
	
	if not is_table(mission_rewards) then
		script_error("ERROR: start_early_game_tech_building_mission_listener() called but supplied mission rewards [" .. mission_rewards .. "] is not a table");
		return false;
	end;
	
	if #mission_rewards == 0 then
		script_error("ERROR: start_early_game_tech_building_mission_listener() called but supplied mission rewards table is empty");
		return false;
	end;
	
	start_from_how_they_play_event_dismissed = not not start_from_how_they_play_event_dismissed;
	
	if building_override_list then
		if not is_table(building_override_list) then
			script_error("ERROR: start_early_game_tech_building_mission_listener() called but supplied settlement override list is not a table");
			return false;
		end;
		
		if #building_override_list == 0 then
			script_error("ERROR: start_early_game_tech_building_mission_listener() called but supplied settlement override list is empty");
			return false;
		end;
		
		for i = 1, #building_override_list do
			if not is_string(building_override_list[i]) then
				script_error("ERROR: start_early_game_tech_building_mission_listener() called but element [" .. i .. "] in supplied settlement override list is not a table, its value is [" .. building_override_list[i] .. "]");
				return false;
			end;
		end;		
	end;
	
	local local_faction = cm:get_local_faction_name();
	local event_name = "early_game_construct_tech_building_mission_issued";
	
	-- affects how prominently this advice will be delivered based on advice level/history
	-- possible values:
	-- EARLY_GAME_ADVICE_VOICED_BY_LEGENDARY_LORD		| advice voiced by LL, relax criteria for showing it
	-- EARLY_GAME_ADVICE_SPECIFIC_TO_FACTION			| advice voiced by advisor, string is different for different factions
	-- EARLY_GAME_ADVICE_SHARED							| advice voiced by advisor, but string is shared between factions
	local advice_mode = EARLY_GAME_ADVICE_SPECIFIC_TO_FACTION;
	
	-- set up mission
	local mm = mission_manager:new(
		local_faction, 
		mission_key,
		function() core:trigger_event("ScriptEventEGTechsAvailable") end 			-- success
	);
	
	mm:add_new_objective("CONSTRUCT_N_BUILDINGS_FROM");
	mm:add_condition("faction " .. local_faction);
	mm:add_condition("total 1");
	
	if mission_issuer then
		mm:set_mission_issuer(mission_issuer);
	end;
	
	for i = 1, #buildings do
		mm:add_condition("building_level " .. buildings[i]);
	end;
	for i = 1, #mission_rewards do
		mm:add_payload(mission_rewards[i]);
	end
	
	-- pre-declare the intervention variable, so that it exists as a local for the subsequent function
	local in_eg_construct_tech_building_mission = false;
	
	-- intervention trigger function
	local function in_eg_construct_tech_building_mission_trigger()
		out.design("[EG] start_early_game_tech_building_mission_listener() is triggering mission, advice level is " .. core:get_advice_level());
		
		local delivery_mode, delivery_mode_str = early_game_decide_content_delivery_mode(advice_mode, advice_key);
		out.design("\t" .. delivery_mode_str);
		
		if delivery_mode == EARLY_GAME_SHOW_MISSION_ONLY then
			out.design("\tjust issuing mission");
			
			set_early_game_event_experienced(event_name, true);
			--mm:trigger(function() in_eg_construct_tech_building_mission:complete() end);	
			mm:trigger();
			cm:callback(function() in_eg_construct_tech_building_mission:complete() end, 1);
		else
			if not early_game_should_show_infotext(advice_mode, advice_key, event_name) then
				out.design("\tnot showing infotext");
				infotext = {};
			end;
			
			out.design("\tplaying advice with mission");
		
			set_early_game_event_experienced(event_name);
			in_eg_construct_tech_building_mission:play_advice_for_intervention(
				advice_key,
				infotext,
				mm
			);
		end;
	end;
	
	-- set up intervention	
	in_eg_construct_tech_building_mission = intervention:new(
		"eg_construct_tech_building_mission", 									-- string name
		60,	 																	-- cost
		function() in_eg_construct_tech_building_mission_trigger() end,			-- trigger callback
		BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
	);
	
	in_eg_construct_tech_building_mission:set_must_trigger(true);
	
	in_eg_construct_tech_building_mission:add_precondition(
		function()
			return not get_early_game_event_experienced(event_name, true);
		end
	);
	
	-- if start_from_how_they_play_event_dismissed is set then listen for the how-they-play event being dismissed
	if start_from_how_they_play_event_dismissed then
		in_eg_construct_tech_building_mission:add_trigger_condition(
			"ScriptEventHowTheyPlayEventDismissed",
			true
		);
	
	-- if we have a settlement override list then don't listen for the completion of the settlement upgraded mission, but listen for the player starting a turn
	-- with any one of those buildings completed
	elseif building_override_list then
		in_eg_construct_tech_building_mission:add_trigger_condition(
			"ScriptEventPlayerFactionTurnStart",
			function(context)
				local faction = cm:get_faction(local_faction);
				for i = 1, #building_override_list do
					local current_building = building_override_list[i];
					if cm:faction_contains_building(faction, current_building) then
						out.design("[EG] start_early_game_tech_building_mission_listener() is triggering as player faction has building with key " .. current_building);
						return true;
					end;
				end;
				return false;
			end
		);	
	else
		-- trigger once the player has upgraded their settlement to level two
		in_eg_construct_tech_building_mission:add_trigger_condition(
			"ScriptEventEGSettlementUpgraded",
			true
		);
	end;
	
	in_eg_construct_tech_building_mission:start();
end;






-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	research tech mission
--
--	issued after construct-tech-building mission is issued
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

function start_early_game_research_tech_mission_listener(advice_key, infotext, mission_key, mission_issuer, mission_rewards, trigger_on_capture_settlement_mission_issued, should_delay_initial_firing, fire_on_turn)

	if not is_string(advice_key) then
		script_error("ERROR: start_early_game_research_tech_mission_listener() called but supplied advice key [" .. tostring(advice_key) .. "] is not a string");
		return false;
	end;
	
	-- default infotext value
	if not infotext then
		infotext = {
			"war.camp.advice.technology.info_001",			-- create default infotext
			"war.camp.advice.technology.info_002",
			"war.camp.advice.technology.info_003"
		};
	end;
	
	if not is_table(infotext) then
		script_error("ERROR: start_early_game_research_tech_mission_listener() called but supplied infotext [" .. tostring(infotext) .. "] is not a table or nil");
		return false;
	end;
	
	if not is_string(mission_key) then
		script_error("ERROR: start_early_game_research_tech_mission_listener() called but supplied mission key [" .. tostring(mission_key) .. "] is not a string");
		return false;
	end;
	
	if mission_issuer and not is_string(mission_issuer) then
		script_error("ERROR: start_early_game_research_tech_mission_listener() called but supplied mission issuer [" .. tostring(mission_issuer) .. "] is not a string or nil");
		return false;
	end;
	
	if not mission_rewards then
		mission_rewards = {"money 1000"};
	end;
	
	if not is_table(mission_rewards) then
		script_error("ERROR: start_early_game_research_tech_mission_listener() called but supplied mission rewards [" .. mission_rewards .. "] is not a table");
		return false;
	end;
	
	if #mission_rewards == 0 then
		script_error("ERROR: start_early_game_research_tech_mission_listener() called but supplied mission rewards table is empty");
		return false;
	end;
	
	for i = 1, #mission_rewards do
		if not is_string(mission_rewards[i]) then
			script_error("ERROR: start_early_game_research_tech_mission_listener() called but supplied mission reward [" .. i .. "] is [" .. tostring(mission_rewards[i]) .. "] and not a string");
			return false;
		end;
	end;
	
	if should_delay_initial_firing and not is_number(fire_on_turn) then
		script_error("ERROR: start_early_game_research_tech_mission_listener() called but supplied message picture key [" .. tostring(fire_on_turn) .. "] is not a number");
		return false;
	end;
	
	-- affects how prominently this advice will be delivered based on advice level/history
	-- possible values:
	-- EARLY_GAME_ADVICE_VOICED_BY_LEGENDARY_LORD		| advice voiced by LL, relax criteria for showing it
	-- EARLY_GAME_ADVICE_SPECIFIC_TO_FACTION			| advice voiced by advisor, string is different for different factions
	-- EARLY_GAME_ADVICE_SHARED							| advice voiced by advisor, but string is shared between factions
	local advice_mode = EARLY_GAME_ADVICE_SHARED;
	
	local local_faction = cm:get_local_faction_name();
	
	-- set up mission
	local mm = mission_manager:new(
		local_faction, 
		mission_key,
		function() core:trigger_event("ScriptEventEarlyGameTechResearched") end
	);
	
	mm:add_new_objective("RESEARCH_N_TECHS_INCLUDING");
	mm:add_condition("total 1");
	
	if mission_issuer then
		mm:set_mission_issuer(mission_issuer);
	end;
	
	for i = 1, #mission_rewards do
		mm:add_payload(mission_rewards[i]);
	end
	
	local event_name = "early_game_research_tech_mission_issued";
	
	-- pre-declare the intervention variable, so that it exists as a local for the subsequent function
	local in_eg_research_tech_mission = false;
	
	-- intervention trigger function
	local function in_eg_research_tech_mission_trigger()
		out.design("[EG] start_early_game_research_tech_mission_listener() is triggering mission, advice level is " .. core:get_advice_level());
		
		local delivery_mode, delivery_mode_str = early_game_decide_content_delivery_mode(advice_mode, advice_key);
		out.design("\t" .. delivery_mode_str);
		
		if delivery_mode == EARLY_GAME_SHOW_MISSION_ONLY then
			out.design("\tjust issuing mission");
			
			set_early_game_event_experienced(event_name, true);
			mm:trigger();
			cm:callback(function() in_eg_research_tech_mission:complete() end, 1);
		
		else
			if not early_game_should_show_infotext(advice_mode, advice_key, event_name) then
				out.design("\tnot showing infotext");
				infotext = {};
			end;
		
			out.design("\tplaying advice with mission");
		
			set_early_game_event_experienced(event_name);
			
			in_eg_research_tech_mission:play_advice_for_intervention(
				advice_key,
				infotext,
				mm
			);
		end;
	end;
	
	-- set up intervention	
	in_eg_research_tech_mission = intervention:new(
		"eg_research_tech_mission", 											-- string name
		60,	 																	-- cost
		function() in_eg_research_tech_mission_trigger() end,					-- trigger callback
		BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
	);
	
	in_eg_research_tech_mission:set_must_trigger(true);
	
	in_eg_research_tech_mission:add_precondition(
		function()
			return not get_early_game_event_experienced(event_name, true);
		end
	);
	
	-- trigger once the player has upgraded their settlement
	in_eg_research_tech_mission:add_trigger_condition(
		"ScriptEventEGTechsAvailable",
		true
	);
	
	
	-- if this flag was passed in establish a listener for the capture settlement mission being issued
	if trigger_on_capture_settlement_mission_issued then		
		in_eg_research_tech_mission:add_trigger_condition(
			"ScriptEventEGCaptureEnemySettlementMissionIssued",
			true
		);
	elseif should_delay_initial_firing then 
		-- failsafe: trigger if the player starts a turn with the ability to research tech
		in_eg_research_tech_mission:add_trigger_condition(
			"ScriptEventPlayerFactionTurnStart",
			function()
				return cm:turn_number() >= fire_on_turn;
			end
		);
	else
		-- failsafe: trigger if the player starts a turn with the ability to research tech
		in_eg_research_tech_mission:add_trigger_condition(
			"ScriptEventPlayerFactionTurnStart",
			function()
				return cm:get_faction(cm:get_local_faction_name()):research_queue_idle();
			end
		);
	end;
	
	in_eg_research_tech_mission:start();
end;










-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	public order mission
--
--	issued on turn three if the player has a public order in their capital
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

function start_early_game_public_order_mission_listener(advice_key, infotext, mission_key, mission_issuer, region_key, mission_rewards)

	if not is_string(advice_key) then
		script_error("ERROR: start_early_game_research_tech_mission_listener() called but supplied advice key [" .. tostring(advice_key) .. "] is not a string");
		return false;
	end;
	
	-- default infotext value
	if not infotext then
		infotext = {
			"war.camp.advice.public_order.info_001",			-- create default infotext
			"war.camp.advice.public_order.info_002",
			"war.camp.advice.public_order.info_003"
		};
	end;
	
	if not is_table(infotext) then
		script_error("ERROR: start_early_game_research_tech_mission_listener() called but supplied infotext [" .. tostring(infotext) .. "] is not a table or nil");
		return false;
	end;
	
	if not is_string(mission_key) then
		script_error("ERROR: start_early_game_research_tech_mission_listener() called but supplied mission key [" .. tostring(mission_key) .. "] is not a string");
		return false;
	end;
	
	if mission_issuer and not is_string(mission_issuer) then
		script_error("ERROR: start_early_game_research_tech_mission_listener() called but supplied mission issuer [" .. tostring(mission_issuer) .. "] is not a string");
		return false;
	end;
	
	if not is_string(region_key) then
		script_error("ERROR: start_early_game_research_tech_mission_listener() called but supplied region key [" .. tostring(region_key) .. "] is not a string");
		return false;
	end;
	
	local province_key = false;
	
	do
		local region = cm:get_region(region_key);

		if not region then
			script_error("ERROR: start_early_game_research_tech_mission_listener() called but no region with supplied key [" .. region_key .. "] could be found");
			return false;
		end;
		
		province_key = region:province_name();
	end;
	
	if not mission_rewards then
		mission_rewards = {"money 1000"};
	end;
	
	if not is_table(mission_rewards) then
		script_error("ERROR: start_early_game_research_tech_mission_listener() called but supplied mission rewards [" .. mission_rewards .. "] is not a table");
		return false;
	end;
	
	if #mission_rewards == 0 then
		script_error("ERROR: start_early_game_research_tech_mission_listener() called but supplied mission rewards table is empty");
		return false;
	end;
	
	for i = 1, #mission_rewards do
		if not is_string(mission_rewards[i]) then
			script_error("ERROR: start_early_game_research_tech_mission_listener() called but supplied mission reward [" .. i .. "] is [" .. tostring(mission_rewards[i]) .. "] and not a string");
			return false;
		end;
	end;
	
	
	-- affects how prominently this advice will be delivered based on advice level/history
	-- possible values:
	-- EARLY_GAME_ADVICE_VOICED_BY_LEGENDARY_LORD		| advice voiced by LL, relax criteria for showing it
	-- EARLY_GAME_ADVICE_SPECIFIC_TO_FACTION			| advice voiced by advisor, string is different for different factions
	-- EARLY_GAME_ADVICE_SHARED							| advice voiced by advisor, but string is shared between factions
	local advice_mode = EARLY_GAME_ADVICE_SPECIFIC_TO_FACTION;
	
	local local_faction = cm:get_local_faction_name();
	
	-- set up mission
	local mm = mission_manager:new(
		local_faction, 
		mission_key
	);
	
	mm:add_new_objective("AT_LEAST_X_PUBLIC_ORDER_IN_PROVINCES");
	mm:add_condition("total 10");
	mm:add_condition("province " .. province_key);
	
	if mission_issuer then
		mm:set_mission_issuer(mission_issuer);
	end;
	
	for i = 1, #mission_rewards do
		mm:add_payload(mission_rewards[i]);
	end
	
	local event_name = "early_game_public_order_mission_issued";
	
	-- pre-declare the intervention variable, so that it exists as a local for the subsequent function
	local in_eg_public_order_mission = false;
	
	-- intervention trigger function
	local function in_eg_public_order_mission_trigger()
		out.design("[EG] start_early_game_public_order_mission_listener() is triggering mission, advice level is " .. core:get_advice_level());
		
		local delivery_mode, delivery_mode_str = early_game_decide_content_delivery_mode(advice_mode, advice_key);
		out.design("\t" .. delivery_mode_str);
		
		if delivery_mode == EARLY_GAME_SHOW_MISSION_ONLY then
			out.design("\tjust issuing mission");
			set_early_game_event_experienced(event_name, true);
			--mm:trigger(function() in_eg_public_order_mission:complete() end);
			mm:trigger();
			cm:callback(function() in_eg_public_order_mission:complete() end, 1);
		else
			if not early_game_should_show_infotext(advice_mode, advice_key, event_name) then
				out.design("\tnot showing infotext");
				infotext = {};
			end;
		
			set_early_game_event_experienced(event_name);
			if delivery_mode == EARLY_GAME_SCROLL_CAMERA_WITH_ADVICE_AND_MISSION then
				out.design("\tscrolling camera to settlement with advice and mission");
				in_eg_public_order_mission:scroll_camera_to_settlement_for_intervention(
					region_key,
					advice_key,
					infotext,
					mm
				);
				
			else
				out.design("\tplaying advice with mission");
				in_eg_public_order_mission:play_advice_for_intervention(
					advice_key,
					infotext,
					mm
				);
			end;
		end;
	end;
	
	local turn_threshold = 3 + cm:get_saved_value("first_turn_count_modifier");
	
	-- set up intervention	
	in_eg_public_order_mission = intervention:new(
		"eg_public_order_mission", 												-- string name
		60,	 																	-- cost
		function() in_eg_public_order_mission_trigger() end,					-- trigger callback
		BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
	);
	
	in_eg_public_order_mission:set_must_trigger(true);
	
	-- make this intervention suppress the standard public order intervention
	in_eg_public_order_mission:take_priority_over_intervention("public_order");
	
	in_eg_public_order_mission:add_precondition(
		function()
			return cm:get_saved_value("bool_prelude_first_turn_was_loaded") and not get_early_game_event_experienced(event_name, true) and cm:model():turn_number() < turn_threshold + 5;
		end
	);
	
	-- return true on turn three - eight (see precondition) if the specified region has a negative public order
	in_eg_public_order_mission:add_trigger_condition(
		"ScriptEventPlayerFactionTurnStart",
		function()
			if cm:model():turn_number() < turn_threshold then
				return false;
			end;
			local region = cm:get_region(region_key);
			if region:public_order() < 0 then
				return true;
			end;
			return false;
		end
	);
	
	in_eg_public_order_mission:start();
end;









-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	faction elimination mission
--
--	issued once the supplied enemy faction only holds the supplied number of
--	settlements (or less), if this happens within the optional supplied number
--	of turns
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

function start_early_game_eliminate_faction_mission_listener(advice_key, infotext, mission_key, mission_issuer, faction_key, number_settlements_threshold, max_turn_threshold, mission_rewards)
	
	if advice_key and not is_string(advice_key) then
		script_error("ERROR: start_early_game_eliminate_faction_mission_listener() called but supplied advice key [" .. tostring(advice_key) .. "] is not a string");
		return false;
	end;
	
	-- default infotext value
	if not infotext then
		infotext = {
			"wh2.camp.advice.faction_elimination.info_001",			-- create default infotext
			"wh2.camp.advice.faction_elimination.info_002",
			"wh2.camp.advice.faction_elimination.info_003"
		};
	end;
	
	if not is_table(infotext) then
		script_error("ERROR: start_early_game_eliminate_faction_mission_listener() called but supplied infotext [" .. tostring(infotext) .. "] is not a table or nil");
		return false;
	end;
	
	if not is_string(mission_key) then
		script_error("ERROR: start_early_game_eliminate_faction_mission_listener() called but supplied mission key [" .. tostring(mission_key) .. "] is not a string");
		return false;
	end;
	
	if mission_issuer and not is_string(mission_issuer) then
		script_error("ERROR: start_early_game_eliminate_faction_mission_listener() called but supplied mission issuer [" .. tostring(mission_issuer) .. "] is not a string or nil");
		return false;
	end;
	
	if not is_string(faction_key) then
		script_error("ERROR: start_early_game_eliminate_faction_mission_listener() called but supplied faction key [" .. tostring(faction_key) .. "] is not a string");
		return false;
	end;
	
	if not cm:get_faction(faction_key) then
		script_error("ERROR: start_early_game_eliminate_faction_mission_listener() called but no faction with supplied key [" .. faction_key .. "] could be found");
		return false;
	end;
	
	number_settlements_threshold = number_settlements_threshold or 1;
	
	if not is_number(number_settlements_threshold) or number_settlements_threshold <= 0 then
		script_error("ERROR: start_early_game_eliminate_faction_mission_listener() called but supplied settlements threshold [" .. tostring(number_settlements_threshold) .. "] is not a number > 0");
		return false;
	end;
		
	if max_turn_threshold and (not is_number(max_turn_threshold) or max_turn_threshold <= 0) then
		script_error("ERROR: start_early_game_eliminate_faction_mission_listener() called but supplied max turn threshold [" .. tostring(max_turn_threshold) .. "] is not a number > 0 or nil");
		return false;
	end;
	
	if not mission_rewards then
		mission_rewards = {"money 1000"};
	end;
	
	if not is_table(mission_rewards) then
		script_error("ERROR: start_early_game_eliminate_faction_mission_listener() called but supplied mission rewards [" .. mission_rewards .. "] is not a table");
		return false;
	end;
	
	if #mission_rewards == 0 then
		script_error("ERROR: start_early_game_eliminate_faction_mission_listener() called but supplied mission rewards table is empty");
		return false;
	end;
	
	for i = 1, #mission_rewards do
		if not is_string(mission_rewards[i]) then
			script_error("ERROR: start_early_game_eliminate_faction_mission_listener() called but supplied mission reward [" .. i .. "] is [" .. tostring(mission_rewards[i]) .. "] and not a string");
			return false;
		end;
	end;
	
	-- affects how prominently this advice will be delivered based on advice level/history
	-- possible values:
	-- EARLY_GAME_ADVICE_VOICED_BY_LEGENDARY_LORD		| advice voiced by LL, relax criteria for showing it
	-- EARLY_GAME_ADVICE_SPECIFIC_TO_FACTION			| advice voiced by advisor, string is different for different factions
	-- EARLY_GAME_ADVICE_SHARED							| advice voiced by advisor, but string is shared between factions
	local advice_mode = EARLY_GAME_ADVICE_SPECIFIC_TO_FACTION;
	
	local local_faction = cm:get_local_faction_name();
	
	-- set up mission
	local mm = mission_manager:new(
		local_faction, 
		mission_key
	);
	
	mm:add_new_objective("DESTROY_FACTION");
	mm:add_condition("faction " .. faction_key);
	mm:add_condition("confederation_valid false");
	
	if mission_issuer then
		mm:set_mission_issuer(mission_issuer);
	end;
	
	mm:set_turn_limit(12);
	for i = 1, #mission_rewards do
		mm:add_payload(mission_rewards[i]);
	end
	
	local event_name = "early_game_eliminate_faction_mission_issued";
	
	-- pre-declare the intervention variable, so that it exists as a local for the subsequent function
	local in_eg_eliminate_faction_mission = false;
	
	-- intervention trigger function
	local function in_eg_eliminate_faction_mission_trigger()
		out.design("[EG] start_early_game_eliminate_faction_mission_listener() is triggering mission, advice level is " .. core:get_advice_level());
		
		local delivery_mode, delivery_mode_str = early_game_decide_content_delivery_mode(advice_mode, advice_key);
		out.design("\t" .. delivery_mode_str);
		
		if delivery_mode == EARLY_GAME_SHOW_MISSION_ONLY then
			out.design("\tjust issuing mission");
			set_early_game_event_experienced(event_name, true);
			--mm:trigger(function() in_eg_eliminate_faction_mission:complete() end);
			mm:trigger();
			cm:callback(function() in_eg_eliminate_faction_mission:complete() end, 1);
		else
			set_early_game_event_experienced(event_name);
		
			-- find enemy capital
			local faction = cm:get_faction(faction_key);
			
			if delivery_mode == EARLY_GAME_SCROLL_CAMERA_WITH_ADVICE_AND_MISSION and faction:has_home_region() then
				out.design("\tscrolling camera to settlement with advice and mission");
				in_eg_eliminate_faction_mission:scroll_camera_to_settlement_for_intervention(
					faction:home_region():name(),
					advice_key,
					infotext,
					mm
				);
			else
				out.design("\tplaying advice with mission");
				in_eg_eliminate_faction_mission:play_advice_for_intervention(
					advice_key,
					infotext,
					mm
				);
			end;
		end;
		
		-- one turn from now, allow the enemy faction and the player to finally agree peace
		cm:add_turn_countdown_event(
			local_faction,
			1,
			"ScriptEventPermitPrimaryEnemyPeaceWithPlayer"
		);
	end;
	
	-- set up intervention	
	in_eg_eliminate_faction_mission = intervention:new(
		"eg_eliminate_faction_mission", 										-- string name
		60,	 																	-- cost
		function() in_eg_eliminate_faction_mission_trigger() end,				-- trigger callback
		BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
	);
	
	-- intervention stops monitoring if a max_turn_threshold was supplied and the turn number exceeds it
	in_eg_eliminate_faction_mission:add_precondition(
		function()
			local faction = cm:get_faction(faction_key);
			return faction and not get_early_game_event_experienced(event_name, true) and cm:faction_is_alive(faction) and (not max_turn_threshold or cm:model():turn_number() <= max_turn_threshold + cm:get_saved_value("first_turn_count_modifier"));
		end
	);
	
	-- return true if the number of settlements the enemy faction controls is equal to or less than the supplied threshold
	in_eg_eliminate_faction_mission:add_trigger_condition(
		"ScriptEventPlayerFactionTurnStart",
		function()
			local faction = cm:get_faction(faction_key);
			return faction and faction:region_list():num_items() <= number_settlements_threshold;
		end
	);
	
	in_eg_eliminate_faction_mission:start();
	
	-- establish a listener that allows the primary enemy to eventually request peace
	if not cm:get_saved_value("early_game_primary_enemy_can_request_peace") then
		core:add_listener(
			"early_game_eliminate_faction_mission",
			"ScriptEventPermitPrimaryEnemyPeaceWithPlayer",
			true,
			function()
				out.design("[EG] start_early_game_eliminate_faction_mission_listener() is allowing primary enemy [" .. faction_key .. "] to request peace with player, and vice-versa");
			
				-- allow the primary enemy faction to request peace with the player (and vice-versa)
				cm:force_diplomacy("faction:" .. faction_key, "faction:" .. local_faction, "peace", true, true, true);
				
				cm:set_saved_value("early_game_primary_enemy_can_request_peace", true);
			end,
			false
		);
	end;
end;











-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	growth mission
--
--	this is a mission for the player to upgrade their settlement (again)
--	this triggers once the player receives their first growth point in a region 
--	with the supplied building, informs the player about growth points, and tasks 
--	them to upgrade their settlement further
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

function start_early_game_growth_point_mission_listener(advice_key, infotext, mission_key, mission_issuer, region_key, required_building_keys, upgrade_building_keys, mission_rewards)

	if not is_string(advice_key) then
		script_error("ERROR: start_early_game_growth_point_mission_listener() called but supplied advice key [" .. tostring(advice_key) .. "] is not a string");
		return false;
	end;
	
	-- default infotext value
	if not infotext then
		infotext = {
			"wh2.camp.advice.growth.info_001",					-- create default infotext
			"wh2.camp.advice.growth.info_002",
			"wh2.camp.advice.growth.info_003",
			"wh2.camp.advice.growth.info_004",
			"wh2.camp.advice.growth.info_005"
		};
	end;
	
	if not is_table(infotext) then
		script_error("ERROR: start_early_game_growth_point_mission_listener() called but supplied infotext [" .. tostring(infotext) .. "] is not a table or nil");
		return false;
	end;
	
	if not is_string(mission_key) then
		script_error("ERROR: start_early_game_growth_point_mission_listener() called but supplied mission key [" .. tostring(mission_key) .. "] is not a string");
		return false;
	end;
	
	if mission_issuer and not is_string(mission_issuer) then
		script_error("ERROR: start_early_game_growth_point_mission_listener() called but supplied mission issuer [" .. tostring(mission_issuer) .. "] is not a string or nil");
		return false;
	end;

	if not is_string(region_key) then
		script_error("ERROR: start_early_game_growth_point_mission_listener() called but supplied mission key [" .. tostring(mission_key) .. "] is not a string");
		return false;
	end;
	
	if not cm:get_region(region_key) then
		script_error("ERROR: start_early_game_growth_point_mission_listener() called but no region with supplied key [" .. region_key .. "] could be found");
		return false;
	end;	
	
	-- if only a single required_building_key was passed in, convert it to a table with one string entry
	if is_string(required_building_keys) then
		required_building_keys = {required_building_keys};
	end;
	
	if not is_table(required_building_keys) then
		script_error("ERROR: start_early_game_growth_point_mission_listener() called but supplied required building key list [" .. tostring(upgrade_building_keys) .. "] is not a table (or a single string)");
		return false;
	end;
	
	if #required_building_keys == 0 then
		script_error("ERROR: start_early_game_growth_point_mission_listener() called but supplied required building key list is empty");
		return false;
	end;
	
	for i = 1, #required_building_keys do
		if not is_string(required_building_keys[i]) then
			script_error("ERROR: start_early_game_growth_point_mission_listener() called but entry [" .. i .. "] in supplied required building key list is not a string, its value is [" .. tostring(required_building_keys[i]) .. "]");
			return false;
		end;
	end;
	
	-- if only a single upgrade_building_key was passed in, convert it to a table with one string entry
	if is_string(upgrade_building_keys) then
		upgrade_building_keys = {upgrade_building_keys};
	end;
	
	if not is_table(upgrade_building_keys) then	
		script_error("ERROR: start_early_game_growth_point_mission_listener() called but supplied upgrade building key list [" .. tostring(upgrade_building_keys) .. "] is not a table (or a single string)");
		return false;
	end;
	
	if #upgrade_building_keys == 0 then
		script_error("ERROR: start_early_game_growth_point_mission_listener() called but supplied upgrade building key list is empty");
		return false;
	end;
	
	for i = 1, #upgrade_building_keys do
		if not is_string(upgrade_building_keys[i]) then
			script_error("ERROR: start_early_game_growth_point_mission_listener() called but entry [" .. i .. "] in supplied upgrade building key list is not a string, its value is [" .. tostring(upgrade_building_keys[i]) .. "]");
			return false;
		end;
	end;
	
	if not mission_rewards then
		mission_rewards = {"money 1000"};
	end;
	
	if not is_table(mission_rewards) then
		script_error("ERROR: start_early_game_growth_point_mission_listener() called but supplied mission rewards [" .. mission_rewards .. "] is not a table");
		return false;
	end;
	
	if #mission_rewards == 0 then
		script_error("ERROR: start_early_game_growth_point_mission_listener() called but supplied mission rewards table is empty");
		return false;
	end;
	
	for i = 1, #mission_rewards do
		if not is_string(mission_rewards[i]) then
			script_error("ERROR: start_early_game_growth_point_mission_listener() called but supplied mission reward [" .. i .. "] is [" .. tostring(mission_rewards[i]) .. "] and not a string");
			return false;
		end;
	end;
	
	local local_faction = cm:get_local_faction_name();
	local province_key = cm:get_region(region_key):province_name();
	
	-- affects how prominently this advice will be delivered based on advice level/history
	-- possible values:
	-- EARLY_GAME_ADVICE_VOICED_BY_LEGENDARY_LORD		| advice voiced by LL, relax criteria for showing it
	-- EARLY_GAME_ADVICE_SPECIFIC_TO_FACTION			| advice voiced by advisor, string is different for different factions
	-- EARLY_GAME_ADVICE_SHARED							| advice voiced by advisor, but string is shared between factions
	local advice_mode = EARLY_GAME_ADVICE_SHARED;
	
	-- set up mission
	local mm = mission_manager:new(
		local_faction, 
		mission_key,
		function() core:trigger_event("ScriptEventGrowthPointMissionSucceeded"); end
	);
	
	mm:add_new_objective("CONSTRUCT_N_BUILDINGS_FROM");
	
	for i = 1, #upgrade_building_keys do
		mm:add_condition("building_level " .. upgrade_building_keys[i]);
	end;
	mm:add_condition("total 1");
	mm:add_condition("faction " .. local_faction);
	
	if mission_issuer then
		mm:set_mission_issuer(mission_issuer);
	end;
	
	for i = 1, #mission_rewards do
		mm:add_payload(mission_rewards[i]);
	end
	
	local event_name = "early_game_growth_point_mission_issued";
	
	-- pre-declare the intervention variable, so that it exists as a local for the subsequent function
	local in_eg_growth_point_mission = false;
	
	-- intervention trigger function
	local function in_eg_growth_point_mission_trigger()
		out.design("[EG] start_early_game_growth_point_mission_listener() is triggering mission, advice level is " .. core:get_advice_level());
		
		local delivery_mode, delivery_mode_str = early_game_decide_content_delivery_mode(advice_mode, advice_key);
		out.design("\t" .. delivery_mode_str);
		
		if delivery_mode == EARLY_GAME_SHOW_MISSION_ONLY then
			out.design("\tjust issuing mission");
			set_early_game_event_experienced(event_name, true);
			--mm:trigger(function() in_eg_growth_point_mission:complete() end);
			mm:trigger();
			cm:callback(function() in_eg_growth_point_mission:complete() end, 1);
		else
			if not early_game_should_show_infotext(advice_mode, advice_key, event_name) then
				out.design("\tnot showing infotext");
				infotext = {};
			end;
			
			set_early_game_event_experienced(event_name);
			
			if delivery_mode == EARLY_GAME_SCROLL_CAMERA_WITH_ADVICE_AND_MISSION and in_eg_growth_point_mission.region_key then
				out.design("\tscrolling camera to settlement with advice and mission");
				in_eg_growth_point_mission:scroll_camera_to_settlement_for_intervention(
					in_eg_growth_point_mission.region_key,
					advice_key,
					infotext,
					mm
				);
			
			else
				out.design("\tplaying advice with mission");
				in_eg_growth_point_mission:play_advice_for_intervention(
					advice_key,
					infotext,
					mm
				);
			end;
		end;
	end;
	
	
	
	-- set up intervention	
	in_eg_growth_point_mission = intervention:new(
		"eg_growth_point_mission", 												-- string name
		60,	 																	-- cost
		function() in_eg_growth_point_mission_trigger() end,					-- trigger callback
		BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
	);
	
	in_eg_growth_point_mission:set_must_trigger(true);
	
	in_eg_growth_point_mission:add_precondition(
		function()
			return not get_early_game_event_experienced(event_name, true)
		end
	);
	
	in_eg_growth_point_mission:add_trigger_condition(
		"ScriptEventPlayerRegionGainedDevelopmentPoint",
		function(context)
			local region = context:region();
			
			if region:province_name() == province_key then
				for i = 1, #required_building_keys do
					if region:building_exists(required_building_keys[i]) then
						in_eg_growth_point_mission.region_key = region_key;
						return true;
					end;
				end;
			end;
			
			return false;
		end
	);
	
	in_eg_growth_point_mission:start();
end;
















-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	hero building
--
--	directs the player to construct a building which grants access to a hero
--	triggers once such a building is available
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

function start_early_game_hero_building_mission_listener(advice_key, infotext, mission_key, mission_issuer, trigger_building_list, turn_delay, target_building_list, mission_rewards, start_from_growth_mission_succeeded)

	if not is_string(advice_key) then
		script_error("ERROR: start_early_game_hero_building_mission_listener() called but supplied advice key [" .. tostring(advice_key) .. "] is not a string");
		return false;
	end;
	
	-- default infotext value
	if not infotext then
		infotext = {
			"war.camp.advice.heroes.info_001",					-- create default infotext
			"war.camp.advice.heroes.info_002",
			"war.camp.advice.heroes.info_003",
			"war.camp.advice.heroes.info_004"
		};
	end;
	
	if not is_table(infotext) then
		script_error("ERROR: start_early_game_hero_building_mission_listener() called but supplied infotext [" .. tostring(infotext) .. "] is not a table or nil");
		return false;
	end;
	
	if not is_string(mission_key) then
		script_error("ERROR: start_early_game_hero_building_mission_listener() called but supplied mission key [" .. tostring(mission_key) .. "] is not a string");
		return false;
	end;
	
	if mission_issuer and not is_string(mission_issuer) then
		script_error("ERROR: start_early_game_hero_building_mission_listener() called but supplied mission issuer [" .. tostring(mission_issuer) .. "] is not a string or nil");
		return false;
	end;
	
	if not is_table(trigger_building_list) then
		script_error("ERROR: start_early_game_hero_building_mission_listener() called but supplied trigger building list [" .. tostring(trigger_building_list) .. "] is not a table");
		return false;
	end;
	
	if #trigger_building_list == 0 then
		script_error("ERROR: start_early_game_hero_building_mission_listener() called but supplied trigger building list is empty");
		return false;
	end;
	
	for i = 1, #trigger_building_list do
		if not is_string(trigger_building_list[i]) then
			script_error("ERROR: start_early_game_hero_building_mission_listener() called but item [" .. i .. "] in supplied trigger building list [" .. tostring(trigger_building_list[i]) .. "] is not a string");
			return false;
		end;
	end;
	
	turn_delay = turn_delay or 0;
	
	if not is_number(turn_delay) or turn_delay < 0 then
		script_error("ERROR: start_early_game_hero_building_mission_listener() called but supplied turn delay [" .. tostring(turn_delay) .. "] is not a positive number or nil");
		return false;
	end;
	
	if not is_table(target_building_list) then
		script_error("ERROR: start_early_game_hero_building_mission_listener() called but supplied target building list [" .. tostring(target_building_list) .. "] is not a table");
		return false;
	end;
	
	if #target_building_list == 0 then
		script_error("ERROR: start_early_game_hero_building_mission_listener() called but supplied target building list is empty");
		return false;
	end;
	
	for i = 1, #target_building_list do
		if not is_string(target_building_list[i]) then
			script_error("ERROR: start_early_game_hero_building_mission_listener() called but item [" .. i .. "] in supplied target building list [" .. tostring(target_building_list[i]) .. "] is not a string");
			return false;
		end;
	end;
	
	if not mission_rewards then
		mission_rewards = {"money 1000"};
	end;
	
	if not is_table(mission_rewards) then
		script_error("ERROR: start_early_game_hero_building_mission_listener() called but supplied mission rewards [" .. mission_rewards .. "] is not a table");
		return false;
	end;
	
	if #mission_rewards == 0 then
		script_error("ERROR: start_early_game_hero_building_mission_listener() called but supplied mission rewards table is empty");
		return false;
	end;
	
	for i = 1, #mission_rewards do
		if not is_string(mission_rewards[i]) then
			script_error("ERROR: start_early_game_hero_building_mission_listener() called but supplied mission reward [" .. i .. "] is [" .. tostring(mission_rewards[i]) .. "] and not a string");
			return false;
		end;
	end;
	
	local local_faction = cm:get_local_faction_name();
	local listener_name = "start_early_game_hero_building_mission_listener";
	
	-- affects how prominently this advice will be delivered based on advice level/history
	-- possible values:
	-- EARLY_GAME_ADVICE_VOICED_BY_LEGENDARY_LORD		| advice voiced by LL, relax criteria for showing it
	-- EARLY_GAME_ADVICE_SPECIFIC_TO_FACTION			| advice voiced by advisor, string is different for different factions
	-- EARLY_GAME_ADVICE_SHARED							| advice voiced by advisor, but string is shared between factions
	local advice_mode = EARLY_GAME_ADVICE_SHARED;
	
	-- set up mission
	local mm = mission_manager:new(
		local_faction, 
		mission_key,
		function() core:trigger_event("ScriptEventHeroBuildingMissionCompleted") end 			-- success
	);
	
	mm:add_new_objective("CONSTRUCT_N_BUILDINGS_FROM");
	mm:add_condition("faction " .. local_faction);
	mm:add_condition("total 1");
	
	if mission_issuer then
		mm:set_mission_issuer(mission_issuer);
	end;
	
	for i = 1, #target_building_list do
		mm:add_condition("building_level " .. target_building_list[i]);
	end;
	
	for i = 1, #mission_rewards do
		mm:add_payload(mission_rewards[i]);
	end;
	
	local event_name = "early_game_hero_building_mission_issued";
	
	-- pre-declare the intervention variable, so that it exists as a local for the subsequent function
	local in_eg_hero_building_mission = false;
	
	-- intervention trigger function
	local function in_eg_hero_building_mission_trigger()
		out.design("[EG] start_early_game_hero_building_mission_listener() is triggering mission, advice level is " .. core:get_advice_level());
		
		local delivery_mode, delivery_mode_str = early_game_decide_content_delivery_mode(advice_mode, advice_key);
		out.design("\t" .. delivery_mode_str);
	
		core:remove_listener(listener_name);
		
		if delivery_mode == EARLY_GAME_SHOW_MISSION_ONLY then
			out.design("\tjust issuing mission");
			set_early_game_event_experienced(event_name, true);
			--mm:trigger(function() in_eg_hero_building_mission:complete() end);
			mm:trigger();
			cm:callback(function() in_eg_hero_building_mission:complete() end, 1);
			
		else
			if not early_game_should_show_infotext(advice_mode, advice_key, event_name) then
				out.design("\tnot showing infotext");
				infotext = {};
			end;
		
			set_early_game_event_experienced(event_name);
			
			local region_key = cm:get_saved_value("early_game_hero_building_mission_target_region");
			
			if delivery_mode == EARLY_GAME_SCROLL_CAMERA_WITH_ADVICE_AND_MISSION and region_key then
				out.design("\tscrolling camera to settlement with advice and mission");
				in_eg_hero_building_mission:scroll_camera_to_settlement_for_intervention(
					region_key,
					advice_key,
					infotext,
					mm
				);
			else
				out.design("\tplaying advice with mission");
				in_eg_hero_building_mission:play_advice_for_intervention(
					advice_key,
					infotext,
					mm
				);
			end;
		end;
	end;
	
	
	if not get_early_game_event_experienced(event_name, true) and not cm:get_saved_value("early_game_hero_building_mission_target_region") then
		out.design("[EG] start_early_game_hero_building_mission_listener() is establishing listener for player completing hero building");
	
		core:add_listener(
			listener_name,
			"ScriptEventPlayerBuildingCompleted",
			function(context)
				local building_key = context:building():name();
				for i = 1, #trigger_building_list do
					if building_key == trigger_building_list[i] then
						local region = context:garrison_residence():region();
						cm:set_saved_value("early_game_hero_building_mission_target_region", region:name());
						out.design("[EG] start_early_game_hero_building_mission_listener() has detected player completing dependency building " .. building_key .. " in region " .. region:name() .. ", turn_delay before triggering hero building mission is " .. tostring(turn_delay));
						return true;
					end;
				end;
				return false;
			end,
			function()
				if turn_delay == 0 then
					core:trigger_event("ScriptEventTriggerEGHeroBuildingMission");
				else
					cm:add_turn_countdown_event(
						local_faction, 
						turn_delay, 
						"ScriptEventTriggerEGHeroBuildingMission"
					);
				end;
			end,
			false
		);
		
		-- failsafe listener for one of the hero buildings being constructed - in this case, issue the 
		-- forward event so the recruit-hero mission triggers, and shut everything down here
		core:add_listener(
			listener_name,
			"ScriptEventPlayerBuildingCompleted",
			true,
			function(context)
				local building_key = context:building():name();
				
				for i = 1, #target_building_list do
					if target_building_list[i] == building_key then
						out.design("[EG] start_early_game_hero_building_mission_listener() has detected player completing target building " .. building_key .. ", shutting down the hero building mission and starting the recruit hero mission");
						set_early_game_event_experienced(event_name, true);
						core:remove_listener(listener_name);
						core:trigger_event("ScriptEventHeroBuildingMissionCompleted");
					end;
				end;
			end,
			true
		);
	end;
	
	
	-- set up intervention	
	in_eg_hero_building_mission = intervention:new(
		"eg_hero_building_mission", 											-- string name
		65,	 																	-- cost
		function() in_eg_hero_building_mission_trigger() end,					-- trigger callback
		BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
	);
	
	in_eg_hero_building_mission:set_must_trigger(true);
	
	in_eg_hero_building_mission:add_precondition(
		function()
			return not get_early_game_event_experienced(event_name, true);
		end
	);
	if start_from_growth_mission_succeeded == true then
		in_eg_hero_building_mission:add_trigger_condition(
			"ScriptEventGrowthPointMissionSucceeded",
			true
		);
	else
		in_eg_hero_building_mission:add_trigger_condition(
			"ScriptEventTriggerEGHeroBuildingMission",
			true
		);
	end;
	
	in_eg_hero_building_mission:start();
end;












-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	hero technology
--
--	directs the player to research a technology which grants access to a hero
--	triggers once the early-game research tech mission is completed
--	(primarily used for Tomb Kings)
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------


function start_early_game_hero_technology_mission_listener(advice_key, infotext, mission_key, mission_issuer, mission_rewards)

	if not is_string(advice_key) then
		script_error("ERROR: start_early_game_hero_technology_mission_listener() called but supplied advice key [" .. tostring(advice_key) .. "] is not a string");
		return false;
	end;
	
	-- default infotext value
	if not infotext then
		infotext = {
			"war.camp.advice.heroes.info_001",					-- create default infotext
			"war.camp.advice.heroes.info_002",
			"war.camp.advice.heroes.info_005"
		};
	end;
	
	if not is_table(infotext) then
		script_error("ERROR: start_early_game_hero_technology_mission_listener() called but supplied infotext [" .. tostring(infotext) .. "] is not a table or nil");
		return false;
	end;
	
	if not is_string(mission_key) then
		script_error("ERROR: start_early_game_hero_technology_mission_listener() called but supplied mission key [" .. tostring(mission_key) .. "] is not a string");
		return false;
	end;
	
	if mission_issuer and not is_string(mission_issuer) then
		script_error("ERROR: start_early_game_hero_technology_mission_listener() called but supplied mission issuer [" .. tostring(mission_issuer) .. "] is not a string or nil");
		return false;
	end;
		
	if not mission_rewards then
		mission_rewards = {"money 1000"};
	end;
	
	if not is_table(mission_rewards) then
		script_error("ERROR: start_early_game_hero_technology_mission_listener() called but supplied mission rewards [" .. mission_rewards .. "] is not a table");
		return false;
	end;
	
	if #mission_rewards == 0 then
		script_error("ERROR: start_early_game_hero_technology_mission_listener() called but supplied mission rewards table is empty");
		return false;
	end;
	
	for i = 1, #mission_rewards do
		if not is_string(mission_rewards[i]) then
			script_error("ERROR: start_early_game_hero_technology_mission_listener() called but supplied mission reward [" .. i .. "] is [" .. tostring(mission_rewards[i]) .. "] and not a string");
			return false;
		end;
	end;
	
	
	local local_faction = cm:get_local_faction_name();
	local listener_name = "start_early_game_hero_technology_mission_listener";
	
	-- affects how prominently this advice will be delivered based on advice level/history
	-- possible values:
	-- EARLY_GAME_ADVICE_VOICED_BY_LEGENDARY_LORD		| advice voiced by LL, relax criteria for showing it
	-- EARLY_GAME_ADVICE_SPECIFIC_TO_FACTION			| advice voiced by advisor, string is different for different factions
	-- EARLY_GAME_ADVICE_SHARED							| advice voiced by advisor, but string is shared between factions
	local advice_mode = EARLY_GAME_ADVICE_SHARED;
	
	-- set up mission
	local mm = mission_manager:new(
		local_faction, 
		mission_key,
		function() core:trigger_event("ScriptEventHeroTechnologyMissionCompleted") end 			-- success
	);
	
	local eligible_technologies = {
		"wh2_dlc09_tech_tmb_liche_priest_1",
		"wh2_dlc09_tech_tmb_liche_priest_2",
		"wh2_dlc09_tech_tmb_liche_priest_3",
		"wh2_dlc09_tech_tmb_liche_priest_4",
		"wh2_dlc09_tech_tmb_liche_priest_5",
		"wh2_dlc09_tech_tmb_liche_priest_6",
		"wh2_dlc09_tech_tmb_necrotect_1",
		"wh2_dlc09_tech_tmb_necrotect_2",
		"wh2_dlc09_tech_tmb_necrotect_3",
		"wh2_dlc09_tech_tmb_necrotect_4",
		"wh2_dlc09_tech_tmb_necrotect_5",
		"wh2_dlc09_tech_tmb_necrotect_6",
		"wh2_dlc09_tech_tmb_tomb_prince_1",
		"wh2_dlc09_tech_tmb_tomb_prince_2",
		"wh2_dlc09_tech_tmb_tomb_prince_3",
		"wh2_dlc09_tech_tmb_tomb_prince_4",
		"wh2_dlc09_tech_tmb_tomb_prince_5",
		"wh2_dlc09_tech_tmb_tomb_prince_6"
	};
	
	mm:add_new_scripted_objective(
		"mission_text_text_dlc09_early_game_hero_technology_mission_objective",
		"ResearchCompleted",
		function(context)
			if context:faction():name() == local_faction then
				local technology_key = context:technology();
				
				for i = 1, #eligible_technologies do
					if eligible_technologies[i] == technology_key then
						return true;
					end;
				end;
			end;
		end
	);
	
	if mission_issuer then
		mm:set_mission_issuer(mission_issuer);
	end;
		
	for i = 1, #mission_rewards do
		mm:add_payload(mission_rewards[i]);
	end;
	
	local event_name = "early_game_hero_technology_mission_issued";
	
	-- pre-declare the intervention variable, so that it exists as a local for the subsequent function
	local in_eg_hero_technology_mission = false;
	
	-- intervention trigger function
	local function in_eg_hero_technology_mission_trigger()
		out.design("[EG] start_early_game_hero_technology_mission_listener() is triggering mission, advice level is " .. core:get_advice_level());
		
		local delivery_mode, delivery_mode_str = early_game_decide_content_delivery_mode(advice_mode, advice_key);
		out.design("\t" .. delivery_mode_str);
	
		core:remove_listener(listener_name);
		
		if delivery_mode == EARLY_GAME_SHOW_MISSION_ONLY then
			out.design("\tjust issuing mission");
			set_early_game_event_experienced(event_name, true);
			--mm:trigger(function() in_eg_hero_technology_mission:complete() end);
			mm:trigger();
			cm:callback(function() in_eg_hero_technology_mission:complete() end, 1);
		else
			if not early_game_should_show_infotext(advice_mode, advice_key, event_name) then
				out.design("\tnot showing infotext");
				infotext = {};
			end;
		
			set_early_game_event_experienced(event_name);
			
			out.design("\tplaying advice with mission");
			in_eg_hero_technology_mission:play_advice_for_intervention(
				advice_key,
				infotext,
				mm
			);
		end;
	end;
	
	
	-- set up intervention	
	in_eg_hero_technology_mission = intervention:new(
		"eg_hero_technology_mission", 											-- string name
		65,	 																	-- cost
		function() in_eg_hero_technology_mission_trigger() end,					-- trigger callback
		BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
	);
	
	in_eg_hero_technology_mission:set_must_trigger(true);
	
	in_eg_hero_technology_mission:add_precondition(
		function()
			return not get_early_game_event_experienced(event_name, true);
		end
	);
	
	in_eg_hero_technology_mission:add_trigger_condition(
		"ScriptEventEarlyGameTechResearched",
		true
	);
	
	in_eg_hero_technology_mission:start();
end;














-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	hero recruitment
--
--	directs the player to recruit a hero
--	triggers once the hero building construction mission is completed
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

function start_early_game_hero_recruitment_mission_listener(advice_key, infotext, mission_key, mission_issuer, mission_rewards)

	if not is_string(advice_key) then
		script_error("ERROR: start_early_game_hero_recruitment_mission_listener() called but supplied advice key [" .. tostring(advice_key) .. "] is not a string");
		return false;
	end;
	
	-- default infotext value
	if not infotext then
		infotext = {
			"war.camp.advice.heroes.info_001",					-- create default infotext
			"war.camp.advice.heroes.info_002",
			"war.camp.advice.heroes.info_005"
		};
	end;
	
	if not is_table(infotext) then
		script_error("ERROR: start_early_game_hero_recruitment_mission_listener() called but supplied infotext [" .. tostring(infotext) .. "] is not a table or nil");
		return false;
	end;
	
	if not is_string(mission_key) then
		script_error("ERROR: start_early_game_hero_recruitment_mission_listener() called but supplied mission key [" .. tostring(mission_key) .. "] is not a string");
		return false;
	end;
	
	if mission_issuer and not is_string(mission_issuer) then
		script_error("ERROR: start_early_game_hero_recruitment_mission_listener() called but supplied mission issuer [" .. tostring(mission_issuer) .. "] is not a string or nil");
		return false;
	end;
	
	if not mission_rewards then
		mission_rewards = {"money 1000"};
	end;
	
	if not is_table(mission_rewards) then
		script_error("ERROR: start_early_game_hero_recruitment_mission_listener() called but supplied mission rewards [" .. mission_rewards .. "] is not a table");
		return false;
	end;
	
	if #mission_rewards == 0 then
		script_error("ERROR: start_early_game_hero_recruitment_mission_listener() called but supplied mission rewards table is empty");
		return false;
	end;
	
	for i = 1, #mission_rewards do
		if not is_string(mission_rewards[i]) then
			script_error("ERROR: start_early_game_hero_recruitment_mission_listener() called but supplied mission reward [" .. i .. "] is [" .. tostring(mission_rewards[i]) .. "] and not a string");
			return false;
		end;
	end;
	
	-- affects how prominently this advice will be delivered based on advice level/history
	-- possible values:
	-- EARLY_GAME_ADVICE_VOICED_BY_LEGENDARY_LORD		| advice voiced by LL, relax criteria for showing it
	-- EARLY_GAME_ADVICE_SPECIFIC_TO_FACTION			| advice voiced by advisor, string is different for different factions
	-- EARLY_GAME_ADVICE_SHARED							| advice voiced by advisor, but string is shared between factions
	local advice_mode = EARLY_GAME_ADVICE_SHARED;
	
	local local_faction = cm:get_local_faction_name();
	
	-- set up mission
	local mm = mission_manager:new(
		local_faction, 
		mission_key
	);
	
	mm:add_new_objective("RECRUIT_AGENT");
	mm:add_condition("total 1");
	
	if mission_issuer then
		mm:set_mission_issuer(mission_issuer);
	end;
	
	for i = 1, #mission_rewards do
		mm:add_payload(mission_rewards[i]);
	end
	
	local event_name = "early_game_hero_recruitment_mission_issued";
	
	-- pre-declare the intervention variable, so that it exists as a local for the subsequent function
	local in_eg_hero_recruitment_mission = false;
	
	-- intervention trigger function
	local function in_eg_hero_recruitment_mission_trigger()
		out.design("[EG] start_early_game_hero_recruitment_mission_listener() is triggering mission, advice level is " .. core:get_advice_level());
		
		local delivery_mode = early_game_decide_content_delivery_mode(advice_mode, advice_key);
		
		if delivery_mode == EARLY_GAME_SHOW_MISSION_ONLY then
			out.design("\tjust issuing mission");
			set_early_game_event_experienced(event_name, true);
			mm:trigger(function() in_eg_hero_recruitment_mission:complete() end);			
		else
			if not early_game_should_show_infotext(advice_mode, advice_key, event_name) then
				out.design("\tnot showing infotext");
				infotext = {};
			end;
			
			out.design("\tplaying advice with mission");
			set_early_game_event_experienced(event_name);
			in_eg_hero_recruitment_mission:play_advice_for_intervention(
				advice_key,
				infotext,
				mm
			);
		end;
	end;
	
	-- set up intervention	
	in_eg_hero_recruitment_mission = intervention:new(
		"eg_hero_recruitment_mission", 											-- string name
		65,	 																	-- cost
		function() in_eg_hero_recruitment_mission_trigger() end,				-- trigger callback
		BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
	);
	
	in_eg_hero_recruitment_mission:set_must_trigger(true);
	
	in_eg_hero_recruitment_mission:add_precondition(
		function()
			return not get_early_game_event_experienced(event_name, true);
		end
	);
	
	in_eg_hero_recruitment_mission:add_trigger_condition(
		"ScriptEventHeroBuildingMissionCompleted",
		true
	);
	
	in_eg_hero_recruitment_mission:add_trigger_condition(
		"ScriptEventHeroTechnologyMissionCompleted",
		true
	);
	
	in_eg_hero_recruitment_mission:start();
end;









-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	hero actions
--
--	directs the player to use a hero
--	triggers once a hero is available
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

function start_early_game_hero_action_mission_listener(advice_key, infotext, mission_key, mission_issuer, mission_rewards)

	if not is_string(advice_key) then
		script_error("ERROR: start_early_game_hero_action_mission_listener() called but supplied advice key [" .. tostring(advice_key) .. "] is not a string");
		return false;
	end;
	
	-- default infotext value
	if not infotext then
		infotext = {
			"war.camp.advice.hero_actions.info_001",					-- create default infotext
			"war.camp.advice.hero_actions.info_002",
			"war.camp.advice.hero_actions.info_003"
		};
	end;
	
	if not is_table(infotext) then
		script_error("ERROR: start_early_game_hero_action_mission_listener() called but supplied infotext [" .. tostring(infotext) .. "] is not a table or nil");
		return false;
	end;
	
	if not is_string(mission_key) then
		script_error("ERROR: start_early_game_hero_action_mission_listener() called but supplied mission key [" .. tostring(mission_key) .. "] is not a string");
		return false;
	end;
	
	if mission_issuer and not is_string(mission_issuer) then
		script_error("ERROR: start_early_game_hero_action_mission_listener() called but supplied mission issuer [" .. tostring(mission_issuer) .. "] is not a string or nil");
		return false;
	end;
	
	if not mission_rewards then
		mission_rewards = {"money 1000"};
	end;
	
	if not is_table(mission_rewards) then
		script_error("ERROR: start_early_game_hero_action_mission_listener() called but supplied mission rewards [" .. mission_rewards .. "] is not a table");
		return false;
	end;
	
	if #mission_rewards == 0 then
		script_error("ERROR: start_early_game_hero_action_mission_listener() called but supplied mission rewards table is empty");
		return false;
	end;
	
	for i = 1, #mission_rewards do
		if not is_string(mission_rewards[i]) then
			script_error("ERROR: start_early_game_hero_action_mission_listener() called but supplied mission reward [" .. i .. "] is [" .. tostring(mission_rewards[i]) .. "] and not a string");
			return false;
		end;
	end;
	
	local local_faction = cm:get_local_faction_name();
	
	-- affects how prominently this advice will be delivered based on advice level/history
	-- possible values:
	-- EARLY_GAME_ADVICE_VOICED_BY_LEGENDARY_LORD		| advice voiced by LL, relax criteria for showing it
	-- EARLY_GAME_ADVICE_SPECIFIC_TO_FACTION			| advice voiced by advisor, string is different for different factions
	-- EARLY_GAME_ADVICE_SHARED							| advice voiced by advisor, but string is shared between factions
	local advice_mode = EARLY_GAME_ADVICE_SHARED;
	
	-- set up mission
	local mm = mission_manager:new(
		local_faction, 
		mission_key
	);
	
	mm:add_new_objective("PERFORM_ANY_AGENT_ACTION");
	
	if mission_issuer then
		mm:set_mission_issuer(mission_issuer);
	end;
	
	for i = 1, #mission_rewards do
		mm:add_payload(mission_rewards[i]);
	end;
	
	local event_name = "early_game_hero_action_mission_issued";
	
	-- pre-declare the intervention variable, so that it exists as a local for the subsequent function
	local in_eg_hero_action_mission = false;
	
	-- intervention trigger function
	local function in_eg_hero_action_mission_trigger()
		out.design("[EG] start_early_game_hero_action_mission_listener() is triggering mission, advice level is " .. core:get_advice_level());
		
		local delivery_mode, delivery_mode_str = early_game_decide_content_delivery_mode(advice_mode, advice_key);
		out.design("\t" .. delivery_mode_str);
		
		local char_cqi = in_eg_hero_action_mission.char_cqi;

		if delivery_mode == EARLY_GAME_SHOW_MISSION_ONLY then
			out.design("\tjust issuing mission");
			set_early_game_event_experienced(event_name, true);
			--mm:trigger(function() in_eg_hero_action_mission:complete() end);
			mm:trigger();
			cm:callback(function() in_eg_hero_action_mission:complete() end, 1);
		else
			if not early_game_should_show_infotext(advice_mode, advice_key, event_name) then
				out.design("\tnot showing infotext");
				infotext = {};
			end;
			
			set_early_game_event_experienced(event_name);
			
			-- DISABLED: playing a cutscene while a ritual animation is playing breaks things, so disabling this until we have a better solution
			if delivery_mode == EARLY_GAME_SCROLL_CAMERA_WITH_ADVICE_AND_MISSION and char_cqi then
				out.design("\tscrolling camera to character (cqi: " .. char_cqi .. ") with advice and mission");
				in_eg_hero_action_mission:scroll_camera_to_character_for_intervention(
					char_cqi,
					advice_key,
					infotext,
					mm
				);
			
			else
				out.design("\tplaying advice with mission");
				in_eg_hero_action_mission:play_advice_for_intervention(
					advice_key,
					infotext,
					mm
				);
			end;
		end;		
	end;
	
	-- set up intervention	
	in_eg_hero_action_mission = intervention:new(
		"eg_hero_action_mission", 												-- string name
		80,	 																	-- cost
		function() in_eg_hero_action_mission_trigger() end,						-- trigger callback
		BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
	);
	
	in_eg_hero_action_mission:set_must_trigger(true);
	
	in_eg_hero_action_mission:add_precondition(
		function()
			return not get_early_game_event_experienced(event_name, true);
		end
	);
	
	in_eg_hero_action_mission:add_trigger_condition(
		"ScriptEventPlayerFactionCharacterCreated",
		function(context)
			local character = context:character();
			
			if cm:char_is_agent(character) and cm:turn_number() >= 2 then
				-- return true, but store the character involved
				in_eg_hero_action_mission.char_cqi = context:character():cqi();
				return true;
			end;
			
			return false;
		end
	);
	
	in_eg_hero_action_mission:start();
end;







-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	raise army
--
--	triggers when the player is at war with two armies, is outnumbered,
--	and can afford a second army (or when all their armies die)
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

function start_early_game_raise_army_mission_listener(advice_key, infotext, mission_key, mission_issuer, mission_rewards)

	if not is_string(advice_key) then
		script_error("ERROR: start_early_game_raise_army_mission_listener() called but supplied advice key [" .. tostring(advice_key) .. "] is not a string");
		return false;
	end;
	
	-- default infotext value
	if not infotext then
		infotext = {
			"war.camp.advice.raise_forces.info_001",				-- default infotext
			"war.camp.advice.raise_forces.info_002",
			"war.camp.advice.raise_forces.info_003",
			"war.camp.advice.raise_forces.info_004"
		};
	end;
	
	if not is_table(infotext) then
		script_error("ERROR: start_early_game_raise_army_mission_listener() called but supplied infotext [" .. tostring(infotext) .. "] is not a table or nil");
		return false;
	end;
	
	if not is_string(mission_key) then
		script_error("ERROR: start_early_game_raise_army_mission_listener() called but supplied mission key [" .. tostring(mission_key) .. "] is not a string");
		return false;
	end;
	
	if mission_issuer and not is_string(mission_issuer) then
		script_error("ERROR: start_early_game_raise_army_mission_listener() called but supplied mission issuer [" .. tostring(mission_issuer) .. "] is not a string or nil");
		return false;
	end;
	
	if not mission_rewards then
		mission_rewards = {"money 1000"};
	end;
	
	if not is_table(mission_rewards) then
		script_error("ERROR: start_early_game_raise_army_mission_listener() called but supplied mission rewards [" .. mission_rewards .. "] is not a table");
		return false;
	end;
	
	if #mission_rewards == 0 then
		script_error("ERROR: start_early_game_raise_army_mission_listener() called but supplied mission rewards table is empty");
		return false;
	end;
	
	for i = 1, #mission_rewards do
		if not is_string(mission_rewards[i]) then
			script_error("ERROR: start_early_game_raise_army_mission_listener() called but supplied mission reward [" .. i .. "] is [" .. tostring(mission_rewards[i]) .. "] and not a string");
			return false;
		end;
	end;
	
	local local_faction = cm:get_local_faction_name();
	
	-- affects how prominently this advice will be delivered based on advice level/history
	-- possible values:
	-- EARLY_GAME_ADVICE_VOICED_BY_LEGENDARY_LORD		| advice voiced by LL, relax criteria for showing it
	-- EARLY_GAME_ADVICE_SPECIFIC_TO_FACTION			| advice voiced by advisor, string is different for different factions
	-- EARLY_GAME_ADVICE_SHARED							| advice voiced by advisor, but string is shared between factions
	local advice_mode = EARLY_GAME_ADVICE_SHARED;
	
	-- set up mission
	local mm = mission_manager:new(
		local_faction, 
		mission_key,
		function() core:trigger_event("ScriptEventPlayerCompletesRaiseArmy") end 
	);
	
	mm:add_new_objective("RAISE_FORCE");
	
	if mission_issuer then
		mm:set_mission_issuer(mission_issuer);
	end;
	
	for i = 1, #mission_rewards do
		mm:add_payload(mission_rewards[i]);
	end;
	
	local event_name = "early_game_raise_army_mission_issued";
	
	-- pre-declare the intervention variable, so that it exists as a local for the subsequent function
	local in_eg_raise_army_mission = false;
	
	-- intervention trigger function
	local function in_eg_raise_army_mission_trigger()
		out.design("[EG] start_early_game_raise_army_mission_listener() is triggering mission, advice level is " .. core:get_advice_level());
		
		local delivery_mode, delivery_mode_str = early_game_decide_content_delivery_mode(advice_mode, advice_key);
		out.design("\t" .. delivery_mode_str);
		
		if delivery_mode == EARLY_GAME_SHOW_MISSION_ONLY then
			out.design("\tjust triggering mission");
			set_early_game_event_experienced(event_name, true);
			--mm:trigger(function() in_eg_raise_army_mission:complete() end);
			mm:trigger();
			cm:callback(function() in_eg_raise_army_mission:complete() end, 1);
		else
			if not early_game_should_show_infotext(advice_mode, advice_key, event_name) then
				out.design("\tnot showing infotext");
				infotext = {};
			end;
			
			out.design("\tplaying advice with mission");
			set_early_game_event_experienced(event_name);
			in_eg_raise_army_mission:play_advice_for_intervention(
				advice_key,
				infotext,
				mm
			);
		end;
	end;
	
	-- set up intervention	
	in_eg_raise_army_mission = intervention:new(
		"eg_raise_army_mission", 												-- string name
		65,	 																	-- cost
		function() in_eg_raise_army_mission_trigger() end,						-- trigger callback
		BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
	);
	
	in_eg_raise_army_mission:set_must_trigger(true);
	
	in_eg_raise_army_mission:add_precondition(
		function()
			return not get_early_game_event_experienced(event_name, true);
		end
	);
	
	in_eg_raise_army_mission:add_trigger_condition(
		"ScriptEventPlayerFactionTurnStart",
		function(context)	
			-- return true if the player is gaining money, has more than 10000 money, and all the factions the player is at war with have more armies than the player
			local faction = cm:get_faction(local_faction);
			
			-- return false if the player is losing money or has less than 10000 money
			if faction:losing_money() or faction:treasury() < 10000 then
				return false;
			end;
			
			local faction_list = faction:factions_at_war_with();
			
			-- return false if the player is not at war with multiple factions
			if faction_list:num_items() < 2 then
				return false
			end;
			
			-- count number of enemy armies
			local num_enemy_armies = 0;
			
			for i = 0, faction_list:num_items() - 1 do
				num_enemy_armies = num_enemy_armies + cm:num_mobile_forces_in_force_list(faction_list:item_at(i):military_force_list(), non_standard_army_types);
			end;
			
			-- count number of allied armies
			local mf_list = faction:military_force_list();
				
			if num_enemy_armies > cm:num_mobile_forces_in_force_list(faction:military_force_list(), non_standard_army_types) then
				return true;
			end;
			
			return false;
		end
	);
	
	in_eg_raise_army_mission:add_trigger_condition(
		"ScriptEventPlayerBattleSequenceCompleted",
		function()
			-- return true if the player has no military forces following battle
			local faction = cm:get_faction(local_faction);
			local mf_list = faction:military_force_list();
			
			for i = 0, mf_list:num_items() - 1 do
				local current_mf = mf_list:item_at(i);
				if not current_mf:is_armed_citizenry() and current_mf:unit_list():num_items() > 0 then
					return false;
				end;
			end;
			
			return true;
		end
	);
	
	in_eg_raise_army_mission:start();
end;











-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	non-aggression pact
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

function start_early_game_non_aggression_pact_mission_listener(advice_key, infotext, mission_key, mission_issuer, target_faction_key, turn_threshold, mission_rewards)

	if not is_string(advice_key) then
		script_error("ERROR: start_early_game_non_aggression_pact_mission_listener() called but supplied advice key [" .. tostring(advice_key) .. "] is not a string");
		return false;
	end;
	
	-- default infotext value
	if not infotext then
		infotext = {
			"war.camp.advice.non_aggression_pact.info_001",				-- default infotext
			"war.camp.advice.non_aggression_pact.info_002",
			"war.camp.advice.non_aggression_pact.info_003"
		};
	end;
	
	if not is_table(infotext) then
		script_error("ERROR: start_early_game_non_aggression_pact_mission_listener() called but supplied infotext [" .. tostring(infotext) .. "] is not a table or nil");
		return false;
	end;
	
	if not is_string(mission_key) then
		script_error("ERROR: start_early_game_non_aggression_pact_mission_listener() called but supplied mission key [" .. tostring(mission_key) .. "] is not a string");
		return false;
	end;
	
	if mission_issuer and not is_string(mission_issuer) then
		script_error("ERROR: start_early_game_non_aggression_pact_mission_listener() called but supplied mission issuer [" .. tostring(mission_issuer) .. "] is not a string or nil");
		return false;
	end;
	
	if not is_string(target_faction_key) then
		script_error("ERROR: start_early_game_non_aggression_pact_mission_listener() called but supplied target faction key [" .. tostring(target_faction_key) .. "] is not a string");
		return false;
	end;
	
	if not cm:get_faction(target_faction_key) then
		script_error("ERROR: start_early_game_non_aggression_pact_mission_listener() called but no faction with supplied faction key [" .. target_faction_key .. "] can be found");
		return false;
	end;
	
	turn_threshold = turn_threshold or 4;		-- default
	
	if not is_number(turn_threshold) then
		script_error("ERROR: start_early_game_non_aggression_pact_mission_listener() called but supplied turn threshold [" .. tostring(turn_threshold) .. "] is not a number or nil");
		return false;
	end;
	
	if not mission_rewards then
		mission_rewards = {"money 1000"};
	end;
	
	if not is_table(mission_rewards) then
		script_error("ERROR: start_early_game_non_aggression_pact_mission_listener() called but supplied mission rewards [" .. mission_rewards .. "] is not a table");
		return false;
	end;
	
	if #mission_rewards == 0 then
		script_error("ERROR: start_early_game_non_aggression_pact_mission_listener() called but supplied mission rewards table is empty");
		return false;
	end;
	
	for i = 1, #mission_rewards do
		if not is_string(mission_rewards[i]) then
			script_error("ERROR: start_early_game_non_aggression_pact_mission_listener() called but supplied mission reward [" .. i .. "] is [" .. tostring(mission_rewards[i]) .. "] and not a string");
			return false;
		end;
	end;
	
	local local_faction = cm:get_local_faction_name();
	
	-- affects how prominently this advice will be delivered based on advice level/history
	-- possible values:
	-- EARLY_GAME_ADVICE_VOICED_BY_LEGENDARY_LORD		| advice voiced by LL, relax criteria for showing it
	-- EARLY_GAME_ADVICE_SPECIFIC_TO_FACTION			| advice voiced by advisor, string is different for different factions
	-- EARLY_GAME_ADVICE_SHARED							| advice voiced by advisor, but string is shared between factions
	local advice_mode = EARLY_GAME_ADVICE_SPECIFIC_TO_FACTION;
	
	-- set up mission
	local mm = mission_manager:new(
		local_faction, 
		mission_key,
		function() core:trigger_event("ScriptEventEGNonAggressionPactMissionCompleted") end
	);
	
	mm:add_new_objective("SIGN_NON_AGGRESSION_PACT");
	mm:add_condition("faction " .. target_faction_key);
	
	if mission_issuer then
		mm:set_mission_issuer(mission_issuer);
	end;
	
	mm:set_turn_limit(15);
	for i = 1, #mission_rewards do
		mm:add_payload(mission_rewards[i]);
	end;
	
	local event_name = "early_game_non_aggression_pact_mission_issued";
	
	-- pre-declare the intervention variable, so that it exists as a local for the subsequent function
	local in_eg_non_aggression_pact_mission = false;
	
	-- intervention trigger function
	local function in_eg_non_aggression_pact_mission_trigger()
		out.design("[EG] start_early_game_non_aggression_pact_mission_listener() is triggering mission, advice level is " .. core:get_advice_level());
		
		local delivery_mode, delivery_mode_str = early_game_decide_content_delivery_mode(advice_mode, advice_key);
		out.design("\t" .. delivery_mode_str);
		
		if delivery_mode == EARLY_GAME_SHOW_MISSION_ONLY then
			out.design("\tjust triggering mission");
			set_early_game_event_experienced(event_name, true);
			--mm:trigger(function() in_eg_non_aggression_pact_mission:complete() end);
			mm:trigger();
			cm:callback(function() in_eg_non_aggression_pact_mission:complete() end, 1);
		
		else
			if not early_game_should_show_infotext(advice_mode, advice_key, event_name) then
				out.design("\tnot showing infotext");
				infotext = {};
			end;
		
			out.design("\tplaying advice with mission");
			set_early_game_event_experienced(event_name);
			in_eg_non_aggression_pact_mission:play_advice_for_intervention(
				advice_key,
				infotext,
				mm
			);
		end;
		
		-- send a message to permit other factions to propose NAPs to the player
		core:trigger_event("ScriptEventEGAllowAIToRequestNAP");
	end;
	
	-- set up intervention	
	in_eg_non_aggression_pact_mission = intervention:new(
		"eg_non_aggression_pact_mission", 										-- string name
		5,	 																	-- cost
		function() in_eg_non_aggression_pact_mission_trigger() end,				-- trigger callback
		BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
	);
	
	-- in_eg_non_aggression_pact_mission:set_must_trigger(true);
	
	in_eg_non_aggression_pact_mission:add_precondition(
		function()
			local player_faction = cm:get_faction(local_faction);
			local target_faction = cm:get_faction(target_faction_key);
			local can_trigger = not get_early_game_event_experienced(event_name, true) and target_faction and
					--[[cm:model():turn_number() <= turn_threshold + cm:get_saved_value("first_turn_count_modifier") and]]
					not target_faction:is_dead() and
					not cm:faction_has_nap_with_faction(player_faction, target_faction) and
					not cm:faction_has_trade_agreement_with_faction(player_faction, target_faction) and
					not player_faction:allied_with(target_faction) and
					not player_faction:at_war_with(target_faction);
					
			if not can_trigger then
				out.design("[EG] start_early_game_non_aggression_pact_mission_listener() cannot trigger its mission for some reason, stopping. Will allow AI to request NAPs and allow trade mission to happen");
			
				-- this intervention cannot trigger, send an event that unlocks others factions proposing NAPs (if they're currently prevented)
				core:trigger_event("ScriptEventEGAllowAIToRequestNAP");
				
				-- also send an event to imitate the NAP mission being completed, so the trade mission has a chance to happen
				core:trigger_event("ScriptEventEGNonAggressionPactMissionCompleted");
			end;
		
			return can_trigger;
		end
	);
	
	in_eg_non_aggression_pact_mission:add_trigger_condition(
		"ScriptEventPlayerFactionTurnStart",
		function(context)
			-- return false if it's not yet the specified turn
			if cm:model():turn_number() < turn_threshold + cm:get_saved_value("first_turn_count_modifier") then
				return false;
			end;
			
			return true;
		end
	);
	
	in_eg_non_aggression_pact_mission:start();
end;









-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	trade-agreement
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

function start_early_game_trade_agreement_mission_listener(advice_key, infotext, mission_key, mission_issuer, target_faction_key, min_turn_threshold, max_turn_threshold, mission_rewards)

	if not is_string(advice_key) then
		script_error("ERROR: start_early_game_trade_agreement_mission_listener() called but supplied advice key [" .. tostring(advice_key) .. "] is not a string");
		return false;
	end;
	
	-- default infotext value
	if not infotext then
		infotext = {
			"war.camp.advice.trade.info_001",				-- default infotext
			"war.camp.advice.trade.info_002",
			"war.camp.advice.trade.info_003"
		};
	end;
	
	if not is_table(infotext) then
		script_error("ERROR: start_early_game_trade_agreement_mission_listener() called but supplied infotext [" .. tostring(infotext) .. "] is not a table or nil");
		return false;
	end;
	
	if not is_string(mission_key) then
		script_error("ERROR: start_early_game_trade_agreement_mission_listener() called but supplied mission key [" .. tostring(mission_key) .. "] is not a string");
		return false;
	end;
	
	if mission_issuer and not is_string(mission_issuer) then
		script_error("ERROR: start_early_game_trade_agreement_mission_listener() called but supplied mission issuer [" .. tostring(mission_issuer) .. "] is not a string or nil");
		return false;
	end;
	
	if not is_string(target_faction_key) then
		script_error("ERROR: start_early_game_trade_agreement_mission_listener() called but supplied target faction key [" .. tostring(target_faction_key) .. "] is not a string");
		return false;
	end;
	
	if not cm:get_faction(target_faction_key) then
		script_error("ERROR: start_early_game_trade_agreement_mission_listener() called but no faction with supplied faction key [" .. target_faction_key .. "] can be found");
		return false;
	end;
	
	min_turn_threshold = min_turn_threshold or 1;		-- default
	
	if not is_number(min_turn_threshold) then
		script_error("ERROR: start_early_game_trade_agreement_mission_listener() called but supplied minimum turn threshold [" .. tostring(min_turn_threshold) .. "] is not a number or nil");
		return false;
	end;
	
	max_turn_threshold = max_turn_threshold or 100;		-- default
	
	if not is_number(max_turn_threshold) then
		script_error("ERROR: start_early_game_trade_agreement_mission_listener() called but supplied maximum turn threshold [" .. tostring(max_turn_threshold) .. "] is not a number or nil");
		return false;
	end;
	
	if not mission_rewards then
		mission_rewards = {"money 1000"};
	end;
	
	if not is_table(mission_rewards) then
		script_error("ERROR: start_early_game_trade_agreement_mission_listener() called but supplied mission rewards [" .. mission_rewards .. "] is not a table");
		return false;
	end;
	
	if #mission_rewards == 0 then
		script_error("ERROR: start_early_game_trade_agreement_mission_listener() called but supplied mission rewards table is empty");
		return false;
	end;
	
	for i = 1, #mission_rewards do
		if not is_string(mission_rewards[i]) then
			script_error("ERROR: start_early_game_trade_agreement_mission_listener() called but supplied mission reward [" .. i .. "] is [" .. tostring(mission_rewards[i]) .. "] and not a string");
			return false;
		end;
	end;
	
	local local_faction = cm:get_local_faction_name();
	
	-- affects how prominently this advice will be delivered based on advice level/history
	-- possible values:
	-- EARLY_GAME_ADVICE_VOICED_BY_LEGENDARY_LORD		| advice voiced by LL, relax criteria for showing it
	-- EARLY_GAME_ADVICE_SPECIFIC_TO_FACTION			| advice voiced by advisor, string is different for different factions
	-- EARLY_GAME_ADVICE_SHARED							| advice voiced by advisor, but string is shared between factions
	local advice_mode = EARLY_GAME_ADVICE_SPECIFIC_TO_FACTION;
	
	-- set up mission
	local mm = mission_manager:new(
		local_faction, 
		mission_key
	);
	
	mm:add_new_objective("MAKE_TRADE_AGREEMENT");
	mm:add_condition("faction " .. target_faction_key);
	
	if mission_issuer then
		mm:set_mission_issuer(mission_issuer);
	end;
	
	mm:set_turn_limit(15);
	for i = 1, #mission_rewards do
		mm:add_payload(mission_rewards[i]);
	end;
	
	local event_name = "early_game_trade_agreement_mission_issued";
	local listener_name = "early_game_trade_agreement_mission_listener";
	
	-- pre-declare the intervention variable, so that it exists as a local for the subsequent function
	local in_eg_trade_agreement_mission = false;
	
	-- intervention trigger function
	local function in_eg_trade_agreement_mission_trigger()
		out.design("[EG] start_early_game_trade_agreement_mission_listener() is triggering mission, advice level is " .. core:get_advice_level());
		
		local delivery_mode, delivery_mode_str = early_game_decide_content_delivery_mode(advice_mode, advice_key);
		out.design("\t" .. delivery_mode_str);
	
		core:remove_listener(listener_name);
	
		if delivery_mode == EARLY_GAME_SHOW_MISSION_ONLY then
			out.design("\tjust triggering mission");
			set_early_game_event_experienced(event_name, true);
			--mm:trigger(function() in_eg_trade_agreement_mission:complete() end);
			mm:trigger();
			cm:callback(function() in_eg_trade_agreement_mission:complete() end, 1);
		else
			if not early_game_should_show_infotext(advice_mode, advice_key, event_name) then
				out.design("\tnot showing infotext");
				infotext = {};
			end;
			
			out.design("\tplaying advice with mission");
			in_eg_trade_agreement_mission:play_advice_for_intervention(
				advice_key,
				infotext,
				mm
			);
			set_early_game_event_experienced(event_name);
		end;
	end;
	
	-- set up intervention	
	in_eg_trade_agreement_mission = intervention:new(
		"eg_trade_agreement_mission", 										-- string name
		60,	 																-- cost
		function() in_eg_trade_agreement_mission_trigger() end,				-- trigger callback
		BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
	);
	
	in_eg_trade_agreement_mission:set_must_trigger(true);
	
	in_eg_trade_agreement_mission:add_precondition(
		function()
			local max_turn_number = cm:get_saved_value("early_game_trade_agreement_mission_max_turn");
			local target_faction = cm:get_faction(target_faction_key);
			return not get_early_game_event_experienced(event_name, true) and 
					(not is_number(max_turn_number) or cm:model():turn_number() <= max_turn_number + cm:get_saved_value("first_turn_count_modifier")) and 
					target_faction and not target_faction:is_dead() and
					not cm:faction_has_trade_agreement_with_faction(cm:get_faction(local_faction), target_faction);
		end
	);
	
	in_eg_trade_agreement_mission:add_trigger_condition(
		"ScriptEventPlayerFactionTurnStart",
		function(context)
			local min_turn_number = cm:get_saved_value("early_game_trade_agreement_mission_min_turn");
			
			-- if the min turn number is not yet set, then the NAP that should precede this mission has not yet happened
			if not is_number(min_turn_number) then
				return false;
			end;
			
			-- if the current turn is less than the min turn then don't proceed as it's too early to trigger the mission
			if cm:model():turn_number() < min_turn_number then
				return false;
			end;
			
			local target_faction = cm:get_faction(target_faction_key);
			
			-- only proceed if the relationship between the two factions is good enough	
			return target_faction:diplomatic_standing_with(local_faction) >= 20;
		end
	);
	
	in_eg_trade_agreement_mission:start();
	
	-- listen for the non-aggression pact mission being completed, and record the min/max turns
	if not get_early_game_event_experienced(event_name, true) then
		out.design("[EG] start_early_game_trade_agreement_mission_listener() is establishing listener for ScriptEventEGNonAggressionPactMissionCompleted");
		core:add_listener(
			listener_name,
			"ScriptEventEGNonAggressionPactMissionCompleted",
			true,
			function()
				local turn_number_modified = cm:model():turn_number() + cm:get_saved_value("first_turn_count_modifier");
				
				-- store the min and max turn number
				cm:set_saved_value("early_game_trade_agreement_mission_min_turn", turn_number_modified + min_turn_threshold);
				cm:set_saved_value("early_game_trade_agreement_mission_max_turn", turn_number_modified + max_turn_threshold);
				
				out.design("[EG] start_early_game_trade_agreement_mission_listener() listener for ScriptEventEGNonAggressionPactMissionCompleted has triggered, min turn on which the mission itself will trigger is [" .. turn_number_modified + min_turn_threshold .. "], max turn [" .. turn_number_modified + max_turn_threshold .. "]");
			end,
			false
		);
	end;
end;








-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	ritual settlement capture mission
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

function start_early_game_ritual_settlement_capture_mission_listener(advice_key, cutscene, infotext, infotext_delay, mission_key, mission_issuer, region_key, turn_threshold, mission_rewards)

	-- first advice key needed solely for advice history checking
	if not is_string(advice_key) then
		script_error("ERROR: start_early_game_ritual_settlement_capture_mission_listener() called but supplied advice key [" .. tostring(advice_key) .. "] is not a string");
	end;


	if not is_campaigncutscene(cutscene) then
		script_error("ERROR: start_early_game_ritual_settlement_capture_mission_listener() called but supplied cutscene [" .. tostring(cutscene) .. "] is not a valid campaign cutscene object");
		return false;
	end;
	
	-- default infotext value
	if not infotext then
		infotext = {	
			"wh2.camp.advice.ritual_settlements.info_001",		-- default infotext
			"wh2.camp.advice.ritual_settlements.info_002",
			"wh2.camp.advice.ritual_settlements.info_003"
		};
	end;
	
	if not is_table(infotext) then
		script_error("ERROR: start_early_game_ritual_settlement_capture_mission_listener() called but supplied infotext [" .. tostring(infotext) .. "] is not a table or nil");
		return false;
	end;
	
	infotext_delay = infotext_delay or 0;
	
	if not is_number(infotext_delay) or infotext_delay < 0 then
		script_error("ERROR: start_early_game_ritual_settlement_capture_mission_listener() called but supplied infotext delay [" .. tostring(infotext_delay) .. "] is not a positive number or nil");
		return false;
	end;
	
	if not is_string(mission_key) then
		script_error("ERROR: start_early_game_ritual_settlement_capture_mission_listener() called but supplied mission key [" .. tostring(mission_key) .. "] is not a string");
		return false;
	end;
	
	if mission_issuer and not is_string(mission_issuer) then
		script_error("ERROR: start_early_game_ritual_settlement_capture_mission_listener() called but supplied mission issuer [" .. tostring(mission_issuer) .. "] is not a string or nil");
		return false;
	end;
	
	if not is_string(region_key) then
		script_error("ERROR: start_early_game_ritual_settlement_capture_mission_listener() called but supplied target faction key [" .. tostring(region_key) .. "] is not a string");
		return false;
	end;
	
	turn_threshold = turn_threshold or 12;
	
	if not is_number(turn_threshold) or turn_threshold < 2 then
		script_error("ERROR: start_early_game_ritual_settlement_capture_mission_listener() called but supplied turn threshold [" .. tostring(turn_threshold) .. "] is not a number greater than 1");
		return false;
	end;
	
	if not mission_rewards then
		mission_rewards = {"money 1000"};
	end;
	
	if not is_table(mission_rewards) then
		script_error("ERROR: start_early_game_ritual_settlement_capture_mission_listener() called but supplied mission rewards [" .. mission_rewards .. "] is not a table");
		return false;
	end;
	
	if #mission_rewards == 0 then
		script_error("ERROR: start_early_game_ritual_settlement_capture_mission_listener() called but supplied mission rewards table is empty");
		return false;
	end;
	
	for i = 1, #mission_rewards do
		if not is_string(mission_rewards[i]) then
			script_error("ERROR: start_early_game_ritual_settlement_capture_mission_listener() called but supplied mission reward [" .. i .. "] is [" .. tostring(mission_rewards[i]) .. "] and not a string");
			return false;
		end;
	end;
	
	local local_faction = cm:get_local_faction_name();
	
	-- affects how prominently this advice will be delivered based on advice level/history
	-- possible values:
	-- EARLY_GAME_ADVICE_VOICED_BY_LEGENDARY_LORD		| advice voiced by LL, relax criteria for showing it
	-- EARLY_GAME_ADVICE_SPECIFIC_TO_FACTION			| advice voiced by advisor, string is different for different factions
	-- EARLY_GAME_ADVICE_SHARED							| advice voiced by advisor, but string is shared between factions
	local advice_mode = EARLY_GAME_ADVICE_SPECIFIC_TO_FACTION;
	
	-- set up mission
	local mm = mission_manager:new(
		local_faction, 
		mission_key,
		function() core:trigger_event("ScriptEventEGPlayerCapturesRitualSettlement") end
	);
	
	mm:add_new_objective("CAPTURE_REGIONS");
	mm:add_condition("region " .. region_key);
	
	if mission_issuer then
		mm:set_mission_issuer(mission_issuer);
	end;
	
	for i = 1, #mission_rewards do
		mm:add_payload(mission_rewards[i]);
	end;
	
	
	-- pre-declare the intervention variable, so that it exists as a local for the subsequent function
	local in_eg_ritual_settlement_capture_mission = false;	
	
	-- add the infotext to the cutscene
	cutscene:action(
		function()
			if #infotext > 0 then
				cm:add_infotext(unpack(infotext));
			end;
		end, 
		infotext_delay
	);
	
	-- make the cutscene trigger the mission when it finishes
	cutscene:set_end_callback(
		function()
			mm:trigger(function() in_eg_ritual_settlement_capture_mission:complete() end);
			cm:modify_advice(true);
		end
	);
	
	local event_name = "early_game_ritual_settlement_capture_mission_issued";
	
	-- intervention trigger function
	local function in_eg_ritual_settlement_capture_mission_trigger()
		out.design("[EG] start_early_game_ritual_settlement_capture_mission_listener() is triggering mission, advice level is " .. core:get_advice_level());
		
		local delivery_mode, delivery_mode_str = early_game_decide_content_delivery_mode(advice_mode, advice_key);
		out.design("\t" .. delivery_mode_str);
		
		if delivery_mode == EARLY_GAME_SHOW_MISSION_ONLY then
			out.design("\tjust triggering mission");
			set_early_game_event_experienced(event_name, true);
			--mm:trigger(function() in_eg_ritual_settlement_capture_mission:complete() end);
			mm:trigger();
			cm:callback(function() in_eg_ritual_settlement_capture_mission:complete() end, 1);
		else
			if not early_game_should_show_infotext(advice_mode, advice_key, event_name) then
				out.design("\tnot showing infotext");
				infotext = {};
			end;
		
			cutscene:start();
			set_early_game_event_experienced(event_name);
		end;
	end;
	
	-- set up intervention	
	in_eg_ritual_settlement_capture_mission = intervention:new(
		"eg_ritual_settlement_capture_mission", 								-- string name
		0,	 																	-- cost
		function() in_eg_ritual_settlement_capture_mission_trigger() end,		-- trigger callback
		BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
	);
	
	in_eg_ritual_settlement_capture_mission:add_precondition(
		function()
			return not get_early_game_event_experienced(event_name, true);
		end
	);
	
	-- trigger if the player gets close to the target settlement
	in_eg_ritual_settlement_capture_mission:add_trigger_condition(
		"ScriptEventPlayerFactionTurnStart",
		function()
			local garrison_residence = cm:get_region(region_key):garrison_residence();
			local garrison_army = cm:get_armed_citizenry_from_garrison(garrison_residence);
			
			if garrison_army and garrison_army:has_general() then
				local garrison_commander = garrison_army:general_character();
				
				local closest_player_char = cm:get_closest_general_to_position_from_faction(cm:get_faction(local_faction), garrison_residence:settlement_interface():logical_position_x(), garrison_residence:settlement_interface():logical_position_y(), false)
				
				if cm:character_can_reach_character(closest_player_char, garrison_commander) then
					return true;
				end;
			end;			
		end
	);
	
	-- trigger on the specified turn if nothing else
	in_eg_ritual_settlement_capture_mission:add_trigger_condition(
		"ScriptEventPlayerFactionTurnStart",
		function()
			return cm:model():turn_number() >= turn_threshold + cm:get_saved_value("first_turn_count_modifier");
		end
	);
	
	-- trigger when specifically requested
	in_eg_ritual_settlement_capture_mission:add_trigger_condition(
		"ScriptEventEGTriggerRitualSettlementMission",
		true
	);
	
	in_eg_ritual_settlement_capture_mission:start();
end;








-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	construct ritual building mission
--
--	triggers after ritual settlement is captured
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

function start_early_game_ritual_building_mission_listener(advice_key, infotext, mission_key, mission_issuer, region_key, building_key, mission_rewards)

	if not is_string(advice_key) then
		script_error("ERROR: start_early_game_ritual_building_mission_listener() called but supplied advice key [" .. tostring(advice_key) .. "] is not a string");
		return false;
	end;
	
	-- default infotext value
	if not infotext then
		infotext = {
			"wh2.camp.advice.ritual_settlements.info_001",		-- default infotext
			"wh2.camp.advice.ritual_settlements.info_002",
			"wh2.camp.advice.ritual_settlements.info_003"
		};
	end;
	
	if not is_table(infotext) then
		script_error("ERROR: start_early_game_ritual_building_mission_listener() called but supplied infotext [" .. tostring(infotext) .. "] is not a table or nil");
		return false;
	end;
	
	if not is_string(mission_key) then
		script_error("ERROR: start_early_game_ritual_building_mission_listener() called but supplied mission key [" .. tostring(mission_key) .. "] is not a string");
		return false;
	end;
	
	if mission_issuer and not is_string(mission_issuer) then
		script_error("ERROR: start_early_game_ritual_building_mission_listener() called but supplied mission issuer [" .. tostring(mission_issuer) .. "] is not a string or nil");
		return false;
	end;
	
	if not is_string(region_key) then
		script_error("ERROR: start_early_game_ritual_building_mission_listener() called but supplied region key [" .. tostring(region_key) .. "] is not a string");
		return false;
	end;
	
	if not cm:get_region(region_key) then
		script_error("ERROR: start_early_game_ritual_building_mission_listener() called but no region with supplied key [" .. region_key .. "] could be found");
		return false;
	end;
	
	if not is_string(building_key) then
		script_error("ERROR: start_early_game_ritual_building_mission_listener() called but supplied building key [" .. tostring(building_key) .. "] is not a string");
		return false;
	end;
	
	if not mission_rewards then
		mission_rewards = {"money 1000"};
	end;
	
	if not is_table(mission_rewards) then
		script_error("ERROR: start_early_game_ritual_building_mission_listener() called but supplied mission rewards [" .. mission_rewards .. "] is not a table");
		return false;
	end;
	
	if #mission_rewards == 0 then
		script_error("ERROR: start_early_game_ritual_building_mission_listener() called but supplied mission rewards table is empty");
		return false;
	end;
	
	for i = 1, #mission_rewards do
		if not is_string(mission_rewards[i]) then
			script_error("ERROR: start_early_game_ritual_building_mission_listener() called but supplied mission reward [" .. i .. "] is [" .. tostring(mission_rewards[i]) .. "] and not a string");
			return false;
		end;
	end;
	
	local local_faction = cm:get_local_faction_name();
	
	-- affects how prominently this advice will be delivered based on advice level/history
	-- possible values:
	-- EARLY_GAME_ADVICE_VOICED_BY_LEGENDARY_LORD		| advice voiced by LL, relax criteria for showing it
	-- EARLY_GAME_ADVICE_SPECIFIC_TO_FACTION			| advice voiced by advisor, string is different for different factions
	-- EARLY_GAME_ADVICE_SHARED							| advice voiced by advisor, but string is shared between factions
	local advice_mode = EARLY_GAME_ADVICE_SPECIFIC_TO_FACTION;
	
	local event_name = "early_game_construct_ritual_building_mission_issued";
	
	-- set up mission
	local mm = mission_manager:new(
		local_faction, 
		mission_key
	);
	
	mm:add_new_objective("CONSTRUCT_N_BUILDINGS_INCLUDING");
	mm:add_condition("faction " .. local_faction);
	mm:add_condition("total 1");
	mm:add_condition("building_level " .. building_key);
	
	if mission_issuer then
		mm:set_mission_issuer(mission_issuer);
	end;
	
	for i = 1, #mission_rewards do
		mm:add_payload(mission_rewards[i]);
	end;
	
	-- pre-declare the intervention variable, so that it exists as a local for the subsequent function
	local in_eg_construct_ritual_building_mission = false;
	
	-- intervention trigger function
	local function in_eg_construct_ritual_building_mission_trigger()
		out.design("[EG] start_early_game_ritual_building_mission_listener() is triggering mission, advice level is " .. core:get_advice_level());
		
		-- if the designated settlement already has the designated building in, then complete immediately without doing anything
		if cm:get_region(region_key):building_exists(building_key) then
			out.design("\tbuilding already exists, not issuing mission");
			in_eg_construct_ritual_building_mission:complete();
			return;
		end;
		
		local delivery_mode, delivery_mode_str = early_game_decide_content_delivery_mode(advice_mode, advice_key);
		out.design("\t" .. delivery_mode_str);
		
		if delivery_mode == EARLY_GAME_SHOW_MISSION_ONLY then
			out.design("\tjust issuing mission");
			
			set_early_game_event_experienced(event_name, true);
			--mm:trigger(function() in_eg_construct_ritual_building_mission:complete() end);	
			mm:trigger();
			cm:callback(function() in_eg_construct_ritual_building_mission:complete() end, 1);
		else
			if not early_game_should_show_infotext(advice_mode, advice_key, event_name) then
				out.design("\tnot showing infotext");
				infotext = {};
			end;
		
			set_early_game_event_experienced(event_name);
			
			if delivery_mode == EARLY_GAME_SCROLL_CAMERA_WITH_ADVICE_AND_MISSION then
				out.design("\tscrolling camera to settlement with advice and mission");
				in_eg_construct_ritual_building_mission:scroll_camera_to_settlement_for_intervention(
					region_key,
					advice_key,
					infotext,
					mm
				);
			else
				out.design("\tplaying advice with mission");
				in_eg_construct_ritual_building_mission:play_advice_for_intervention(
					advice_key,
					infotext,
					mm
				);
			end;
		end;
	end;
	
	
	-- set up intervention	
	in_eg_construct_ritual_building_mission = intervention:new(
		"eg_construct_ritual_building_mission", 									-- string name
		0,	 																		-- cost
		function() in_eg_construct_ritual_building_mission_trigger() end,			-- trigger callback
		BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
	);
	
	in_eg_construct_ritual_building_mission:add_precondition(
		function()
			return not get_early_game_event_experienced(event_name, true);
		end
	);
	
	-- trigger once the player has upgraded their settlement
	in_eg_construct_ritual_building_mission:add_trigger_condition(
		"ScriptEventEGPlayerCapturesRitualSettlement",
		true
	);
	
	in_eg_construct_ritual_building_mission:start();
end;











-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	ritual building limiter
--
--	prevents the ai from building any of the supplied set of buildings until the
--	player captures the ritual settlement
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

function start_early_game_ritual_building_limiter_listener(faction_list, building_list)
	if faction_list then
		if not is_table(faction_list) then
			script_error("ERROR: start_early_game_ritual_building_limiter_listener() called but supplied faction list [" .. tostring(faction_list) .. "] is not a table");
			return false;
		end;
		
		for i = 1, #faction_list do
			if not is_string(faction_list[i]) then
				script_error("ERROR: start_early_game_ritual_building_limiter_listener() called but item [" .. i .. "] of supplied faction list is not a string but is [" .. tostring(faction_list[i]) .. "]");
				return false;
			end;
		end;
	end;
	
	if not is_table(building_list) then
		script_error("ERROR: start_early_game_ritual_building_limiter_listener() called but supplied building list [" .. tostring(building_list) .. "] is not a table");
		return false;
	end;
	
	for i = 1, #building_list do
		if not is_string(building_list[i]) then
			script_error("ERROR: start_early_game_ritual_building_limiter_listener() called but item [" .. i .. "] of supplied building list is not a string but is [" .. tostring(building_list[i]) .. "]");
			return false;
		end;
	end;
	
	local event_name = "early_game_ritual_building_limiter";
	
	if not get_early_game_event_experienced(event_name, true) then
		if cm:model():turn_number() <= cm:get_saved_value("first_turn_count_modifier") + 1 then
			
			local game_interface = cm:get_game_interface();
			
			
			if faction_list then
				-- restrict supplied factions
				out.design("[EG] start_early_game_ritual_building_limiter_listener() is restricting supplied factions from constructing ritual currency buildings");
				for i = 1, #faction_list do
					for j = 1, #building_list do
						game_interface:add_restricted_building_level_record_for_faction(building_list[j], faction_name);
					end;
				end;
			else
				
				-- restrict all non-player factions
				out.design("[EG] start_early_game_ritual_building_limiter_listener() is restricting all non-player/non-primary factions from constructing ritual currency buildings");
			
				-- if there is no faction list, then make one
			
				-- using a different table structure here is not ideal, but it does make removing the primary factions a lot faster
				local temp_faction_list = {};
				local full_faction_list = game_interface:model():world():faction_list();
				
				for i = 0, full_faction_list:num_items() - 1 do
					local current_faction = full_faction_list:item_at(i);
					
					if current_faction:is_human() == false then
						temp_faction_list[current_faction:name()] = true;
					end;
				end;
				
				-- remove primary ritual factions from the temp faction list
				temp_faction_list[eataine_faction_str] = false;
				temp_faction_list[order_of_loremasters_faction_str] = false;
				temp_faction_list[naggarond_faction_str] = false;
				temp_faction_list[cult_of_pleasure_faction_str] = false;
				temp_faction_list[hexoatl_faction_str] = false;
				temp_faction_list[last_defenders_faction_str] = false;
				temp_faction_list[clan_mors_faction_str] = false;
				temp_faction_list[clan_pestilens_faction_str] = false;
				
				for faction_name in pairs(temp_faction_list) do
					for j = 1, #building_list do
						--game_interface:add_restricted_building_level_record_for_faction(building_list[j], faction_name);
					end;
				end;
			end;
		end;

		core:add_listener(
			"early_game_ritual_building_limiter",
			"ScriptEventEGPlayerCapturesRitualSettlement",
			true,
			function()
				out.design("[EG] start_early_game_ritual_building_limiter_listener() is responding to event ScriptEventEGPlayerCapturesRitualSettlement");
				
				set_early_game_event_experienced(event_name);
				
				local game_interface = cm:get_game_interface();
				
				if faction_list then
					-- restrict supplied factions
					out.design("[EG] start_early_game_ritual_building_limiter_listener() is unrestricting supplied factions from constructing ritual currency buildings");
					for i = 1, #faction_list do
						for j = 1, #building_list do
							--game_interface:remove_restricted_building_level_record_for_faction(building_list[j], faction_name);
						end;
					end;
				else
					
					-- restrict all non-player factions
					out.design("[EG] start_early_game_ritual_building_limiter_listener() is unrestricting all non-player/non-primary factions from constructing ritual currency buildings");
				
					-- if there is no faction list, then make one
				
					-- using a different table structure here is not ideal, but it does make removing the primary factions a lot faster
					local temp_faction_list = {};
					local full_faction_list = game_interface:model():world():faction_list();
					
					for i = 0, full_faction_list:num_items() - 1 do
						local current_faction = full_faction_list:item_at(i);
						
						if not current_faction:is_human() then
							temp_faction_list[current_faction:name()] = true;
						end;
					end;
					
					-- remove primary ritual factions from the temp faction list
					temp_faction_list[eataine_faction_str] = false;
					temp_faction_list[order_of_loremasters_faction_str] = false;
					temp_faction_list[naggarond_faction_str] = false;
					temp_faction_list[cult_of_pleasure_faction_str] = false;
					temp_faction_list[hexoatl_faction_str] = false;
					temp_faction_list[last_defenders_faction_str] = false;
					temp_faction_list[clan_mors_faction_str] = false;
					temp_faction_list[clan_pestilens_faction_str] = false;
					
					for faction_name in pairs(temp_faction_list) do
						for j = 1, #building_list do
							game_interface:remove_restricted_building_level_record_for_faction(building_list[j], faction_name);
						end;
					end;
				end;
			end,
			false
		);
	end;
end;













-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	ritual currency mission
--
--	triggers once the player has earned the supplied mission trigger currency 
--	threshold
--	issues either a mission to earn the currency required to enact the first
--	ritual (new players), or a mission to enact the ritual itself
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

function start_early_game_ritual_currency_mission_listener(advice_key, infotext, mission_trigger_currency_threshold, earn_currency_mission_key, earn_currency_mission_issuer, ritual_trigger_currency_threshold, enact_ritual_mission_key, enact_ritual_mission_issuer, ritual_key, mission_rewards)

	if not is_string(advice_key) then
		script_error("ERROR: start_early_game_ritual_currency_mission_listener() called but supplied advice key [" .. tostring(advice_key) .. "] is not a string");
		return false;
	end;
	
	-- default infotext value
	if not infotext then
		infotext = {
			"wh2.camp.advice.rituals.info_001",		-- default infotext
			"wh2.camp.advice.rituals.info_002",
			"wh2.camp.advice.rituals.info_003"
		};
	end;
	
	if not is_table(infotext) then
		script_error("ERROR: start_early_game_ritual_currency_mission_listener() called but supplied infotext [" .. tostring(infotext) .. "] is not a table or nil");
		return false;
	end;
	
	if not is_number(mission_trigger_currency_threshold) or mission_trigger_currency_threshold <= 0 then
		script_error("ERROR: start_early_game_ritual_currency_mission_listener() called but supplied trigger currency threshold [" .. tostring(mission_trigger_currency_threshold) .. "] is not a number > 0");
		return false;
	end;
	
	if not is_string(earn_currency_mission_key) then
		script_error("ERROR: start_early_game_ritual_currency_mission_listener() called but supplied earn-currency mission key [" .. tostring(earn_currency_mission_key) .. "] is not a string");
		return false;
	end;
	
	if earn_currency_mission_issuer and not is_string(earn_currency_mission_issuer) then
		script_error("ERROR: start_early_game_ritual_currency_mission_listener() called but supplied earn-currency mission issuer [" .. tostring(earn_currency_mission_issuer) .. "] is not a string or nil");
		return false;
	end;
	
	if not is_number(ritual_trigger_currency_threshold) or ritual_trigger_currency_threshold <= mission_trigger_currency_threshold then
		script_error("ERROR: start_early_game_ritual_currency_mission_listener() called but supplied ritual currency threshold [" .. tostring(ritual_trigger_currency_threshold) .. "] is not a number > supplied trigger threshold [" .. mission_trigger_currency_threshold .. "]");
		return false;
	end;
	
	if not is_string(enact_ritual_mission_key) then
		script_error("ERROR: start_early_game_ritual_currency_mission_listener() called but supplied enact-ritual mission key [" .. tostring(enact_ritual_mission_key) .. "] is not a string");
		return false;
	end;
	
	if enact_ritual_mission_issuer and not is_string(enact_ritual_mission_issuer) then
		script_error("ERROR: start_early_game_ritual_currency_mission_listener() called but supplied enact-ritual mission issuer [" .. tostring(enact_ritual_mission_issuer) .. "] is not a string or nil");
		return false;
	end;
	
	if not is_string(ritual_key) then
		script_error("ERROR: start_early_game_ritual_currency_mission_listener() called but supplied ritual key [" .. tostring(ritual_key) .. "] is not a string");
		return false;
	end;
	
	if not mission_rewards then
		mission_rewards = {"money 1000"};
	end;
	
	if not is_table(mission_rewards) then
		script_error("ERROR: start_early_game_ritual_currency_mission_listener() called but supplied mission rewards [" .. mission_rewards .. "] is not a table");
		return false;
	end;
	
	if #mission_rewards == 0 then
		script_error("ERROR: start_early_game_ritual_currency_mission_listener() called but supplied mission rewards table is empty");
		return false;
	end;
	
	for i = 1, #mission_rewards do
		if not is_string(mission_rewards[i]) then
			script_error("ERROR: start_early_game_ritual_currency_mission_listener() called but supplied mission reward [" .. i .. "] is [" .. tostring(mission_rewards[i]) .. "] and not a string");
			return false;
		end;
	end;
	
	local local_faction = cm:get_local_faction_name();
	local event_name = "early_game_ritual_currency_mission_issued";
	
	if cm:get_faction(local_faction):pooled_resource_manager():resource("wh2_main_ritual_currency"):is_null_interface() then
		script_error("WARNING: start_early_game_ritual_currency_mission_listener() called but player faction does not support pooled resource wh2_main_ritual_currency");
		return false;
	end;
	
	
	-- affects how prominently this advice will be delivered based on advice level/history
	-- possible values:
	-- EARLY_GAME_ADVICE_VOICED_BY_LEGENDARY_LORD		| advice voiced by LL, relax criteria for showing it
	-- EARLY_GAME_ADVICE_SPECIFIC_TO_FACTION			| advice voiced by advisor, string is different for different factions
	-- EARLY_GAME_ADVICE_SHARED							| advice voiced by advisor, but string is shared between factions
	local advice_mode = EARLY_GAME_ADVICE_VOICED_BY_LEGENDARY_LORD;
	
	local mm = false;
	
	if common.get_advice_history_string_seen("early_game_ritual_currency_mission_completed") then
		-- we have completed the mission to enact the first ritual before
		mm = mission_manager:new(
			local_faction, 
			enact_ritual_mission_key
		);
		
		mm:add_new_objective("PERFORM_RITUAL");
		mm:add_condition("ritual " .. ritual_key);
		
		if enact_ritual_mission_issuer then
			mm:set_mission_issuer(enact_ritual_mission_issuer);
		end;
		
	else
		-- we have never completed the mission to enact the first ritual
		mm = mission_manager:new(
			local_faction, 
			earn_currency_mission_key,
			function()
				common.set_advice_history_string_seen("early_game_ritual_currency_mission_completed");
				core:trigger_event("ScriptEventEGRitualMissionCompleted") 
			end 			-- success
		);
	
		mm:add_new_objective("HAVE_AT_LEAST_X_OF_A_POOLED_RESOURCE");
		mm:add_condition("pooled_resource wh2_main_ritual_currency");
		mm:add_condition("total " .. ritual_trigger_currency_threshold);
		
		if earn_currency_mission_issuer then
			mm:set_mission_issuer(earn_currency_mission_issuer);
		end;
	end;	
	
	for i = 1, #mission_rewards do
		mm:add_payload(mission_rewards[i]);
	end;
	
	-- pre-declare the intervention variable, so that it exists as a local for the subsequent function
	local in_eg_ritual_currency_mission = false;
	
	-- intervention trigger function
	local function in_eg_ritual_currency_mission_trigger()
		out.design("[EG] start_early_game_ritual_currency_mission_listener() is triggering mission, advice level is " .. core:get_advice_level());
		
		local delivery_mode, delivery_mode_str = early_game_decide_content_delivery_mode(advice_mode, advice_key);
		out.design("\t" .. delivery_mode_str);
		
		if delivery_mode == EARLY_GAME_SHOW_MISSION_ONLY then
			out.design("\tjust issuing mission");
			
			set_early_game_event_experienced(event_name, true);
			--mm:trigger(function() in_eg_ritual_currency_mission:complete() end);
			mm:trigger();
			cm:callback(function() in_eg_ritual_currency_mission:complete() end, 1);
		else
			if not early_game_should_show_infotext(advice_mode, advice_key, event_name) then
				out.design("\tnot showing infotext");
				infotext = {};
			end;
			
			set_early_game_event_experienced(event_name);
			out.design("\tplaying advice with mission");
			
			in_eg_ritual_currency_mission:play_advice_for_intervention(
				advice_key,
				infotext,
				mm
			);
		end;
	end;
	
	
	-- set up intervention	
	in_eg_ritual_currency_mission = intervention:new(
		"eg_ritual_currency_mission", 												-- string name
		0,	 																		-- cost
		function() in_eg_ritual_currency_mission_trigger() end,						-- trigger callback
		BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
	);
	
	in_eg_ritual_currency_mission:add_precondition(
		function()
			return not get_early_game_event_experienced(event_name, true);
		end
	);
	
	-- trigger if the player starts a turn with the required amount of currency
	in_eg_ritual_currency_mission:add_trigger_condition(
		"ScriptEventPlayerFactionTurnStart",
		function()
			local faction_currency = cm:get_faction(local_faction):pooled_resource_manager():resource("wh2_main_ritual_currency"):value();
			
			out.design("[EG] start_early_game_ritual_currency_mission_listener() is checking trigger condition, player ritual currency is [" .. faction_currency .. "] and trigger threshold is [" .. mission_trigger_currency_threshold .. "]");
			
			if faction_currency >= mission_trigger_currency_threshold then
				out.design("\ttriggering");
				return true;
			end;
			return false;
		end
	);
	
	in_eg_ritual_currency_mission:start();
end;









-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	ritual mission
--
--	triggers once the player has earned the supplied mission trigger currency 
--	threshold
--	issues either a mission to earn the currency required to enact the first
--	ritual (new players), or a mission to enact the ritual itself
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

function start_early_game_ritual_mission_listener(advice_key, infotext, ritual_trigger_currency_threshold, enact_ritual_mission_key, enact_ritual_mission_issuer, ritual_key, mission_rewards)

	if not is_string(advice_key) then
		script_error("ERROR: start_early_game_ritual_mission_listener() called but supplied advice key [" .. tostring(advice_key) .. "] is not a string");
		return false;
	end;
	
	-- default infotext value
	if not infotext then
		infotext = {
			"wh2.camp.advice.rituals.info_001",		-- default infotext
			"wh2.camp.advice.rituals.info_002",
			"wh2.camp.advice.rituals.info_003"
		};
	end;
	
	if not is_table(infotext) then
		script_error("ERROR: start_early_game_ritual_mission_listener() called but supplied infotext [" .. tostring(infotext) .. "] is not a table or nil");
		return false;
	end;
	
	if not is_number(ritual_trigger_currency_threshold) or ritual_trigger_currency_threshold < 0 then
		script_error("ERROR: start_early_game_ritual_mission_listener() called but supplied ritual currency threshold [" .. tostring(ritual_trigger_currency_threshold) .. "] is not a number > 0");
		return false;
	end;
	
	if not is_string(enact_ritual_mission_key) then
		script_error("ERROR: start_early_game_ritual_mission_listener() called but supplied enact-ritual mission key [" .. tostring(enact_ritual_mission_key) .. "] is not a string");
		return false;
	end;
	
	if enact_ritual_mission_issuer and not is_string(enact_ritual_mission_issuer) then
		script_error("ERROR: start_early_game_ritual_mission_listener() called but supplied enact-ritual mission issuer [" .. tostring(enact_ritual_mission_issuer) .. "] is not a string or nil");
		return false;
	end;
	
	if not is_string(ritual_key) then
		script_error("ERROR: start_early_game_ritual_mission_listener() called but supplied ritual key [" .. tostring(ritual_key) .. "] is not a string");
		return false;
	end;
	
	if not mission_rewards then
		mission_rewards = {"money 1000"};
	end;
	
	if not is_table(mission_rewards) then
		script_error("ERROR: start_early_game_ritual_mission_listener() called but supplied mission rewards [" .. mission_rewards .. "] is not a table");
		return false;
	end;
	
	if #mission_rewards == 0 then
		script_error("ERROR: start_early_game_ritual_mission_listener() called but supplied mission rewards table is empty");
		return false;
	end;
	
	for i = 1, #mission_rewards do
		if not is_string(mission_rewards[i]) then
			script_error("ERROR: start_early_game_ritual_mission_listener() called but supplied mission reward [" .. i .. "] is [" .. tostring(mission_rewards[i]) .. "] and not a string");
			return false;
		end;
	end;
	
	local local_faction = cm:get_local_faction_name();
	local event_name = "early_game_ritual_mission_issued";
	local should_trigger_mission = false;
	
	-- affects how prominently this advice will be delivered based on advice level/history
	-- possible values:
	-- EARLY_GAME_ADVICE_VOICED_BY_LEGENDARY_LORD		| advice voiced by LL, relax criteria for showing it
	-- EARLY_GAME_ADVICE_SPECIFIC_TO_FACTION			| advice voiced by advisor, string is different for different factions
	-- EARLY_GAME_ADVICE_SHARED							| advice voiced by advisor, but string is shared between factions
	local advice_mode = EARLY_GAME_ADVICE_VOICED_BY_LEGENDARY_LORD;
	
	
	-- construct mission
	local mm = mission_manager:new(
		local_faction, 
		enact_ritual_mission_key
	);
	mm:add_new_objective("PERFORM_RITUAL");
	mm:add_condition("ritual " .. ritual_key);
	
	if enact_ritual_mission_issuer then
		mm:set_mission_issuer(enact_ritual_mission_issuer);
	end;
	
	for i = 1, #mission_rewards do
		mm:add_payload(mission_rewards[i]);
	end;
	
	-- pre-declare the intervention variable, so that it exists as a local for the subsequent function
	local in_eg_ritual_mission = false;
	
	-- intervention trigger function
	local function in_eg_ritual_mission_trigger()
		out.design("[EG] start_early_game_ritual_mission_listener() is triggering mission, advice level is " .. core:get_advice_level());
		
		local delivery_mode, delivery_mode_str = early_game_decide_content_delivery_mode(advice_mode, advice_key);
		out.design("\t" .. delivery_mode_str);
		
		if not early_game_should_show_infotext(advice_mode, advice_key, event_name) then
			out.design("\tnot showing infotext");
			infotext = {};
		end;
		
		if should_trigger_mission then
			out.design("\tintervention is triggering its mission");
			
			if delivery_mode == EARLY_GAME_SHOW_MISSION_ONLY then
				out.design("\tjust issuing mission");
				
				set_early_game_event_experienced(event_name, true);
				--mm:trigger(function() in_eg_ritual_mission:complete() end);
				mm:trigger();
				cm:callback(function() in_eg_ritual_mission:complete() end, 1);
			else				
				set_early_game_event_experienced(event_name);
				out.design("\tplaying advice with mission");
				
				in_eg_ritual_mission:play_advice_for_intervention(
					advice_key,
					infotext,
					mm
				);
			end;
		
		else
			out.design("\tintervention is not triggering its mission");
		
			-- if we shouldn't trigger our mission, then just play advice (if advice setting is not minimal)			
			if core:is_advice_level_minimal() then
				out.design("\tdoing nothing, just completing");
			
				-- do nothing
				set_early_game_event_experienced(event_name, true);
				in_eg_ritual_mission:complete();			
			else
				out.design("\tplaying advice");
			
				-- play advice
				set_early_game_event_experienced(event_name);
				in_eg_ritual_mission:play_advice_for_intervention(
					advice_key,
					infotext
				);
			end;		
		end;
	end;
	
	
	-- set up intervention	
	in_eg_ritual_mission = intervention:new(
		"eg_ritual_mission", 														-- string name
		0,	 																		-- cost
		function() in_eg_ritual_mission_trigger() end,								-- trigger callback
		BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
	);
	
	in_eg_ritual_mission:add_precondition(
		function()
			return not get_early_game_event_experienced(event_name, true);
		end
	);
	
	if common.get_advice_history_string_seen("early_game_ritual_currency_mission_completed") then
		out.design("[EG] start_early_game_ritual_mission_listener() is establishing a listener for the player earning enough currency to enact the ritual mission");
		
		-- ritual currency mission has previously been completed, so it won't have been issued again - listen for the currency reaching the desired level
		in_eg_ritual_mission:add_trigger_condition(
			"ScriptEventPlayerFactionTurnStart",
			function()
				return cm:get_faction(cm:get_local_faction_name()):pooled_resource_manager():resource("wh2_main_ritual_currency"):value() >= ritual_trigger_currency_threshold;
			end
		);
	else
		out.design("[EG] start_early_game_ritual_mission_listener() is establishing a listener for the player completing the previous mission to earn currency");
	
		-- ritual currency mission has not previously been completed, so it will be active - listen for its completion	
		in_eg_ritual_mission:add_trigger_condition(
			"ScriptEventEGRitualMissionCompleted",
			function()
				should_trigger_mission = true;
				return true;
			end
		);
	end;
	
	in_eg_ritual_mission:start();
end;














-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	resources mission
--
--	Triggers on a suitable early turn, or if the player comes within a turn's 
--	march of the supplied target settlement.
--	Issues a mission to gain access to a specified resource. Used for Tomb-Kings
--	early-game missions
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

function start_early_game_resources_mission_listener(advice_key, infotext, region_key, turn_threshold, mission_key, resource_key, mission_issuer, mission_rewards)

	if not is_string(advice_key) then
		script_error("ERROR: start_early_game_resources_mission_listener() called but supplied advice key [" .. tostring(advice_key) .. "] is not a string");
		return false;
	end;
	
	-- default infotext value
	if not infotext then
		infotext = {
			"war.camp.advice.resources.info_001",		-- default infotext
			"war.camp.advice.resources.info_002",
			"war.camp.advice.resources.info_003"
		};
	end;
	
	if not is_table(infotext) then
		script_error("ERROR: start_early_game_resources_mission_listener() called but supplied infotext [" .. tostring(infotext) .. "] is not a table or nil");
		return false;
	end;
		
	if not is_string(region_key) then
		script_error("ERROR: start_early_game_resources_mission_listener() called but supplied region key [" .. tostring(region_key) .. "] is not a string");
		return false;
	end;
	
	if not cm:get_region(region_key) then
		script_error("ERROR: start_early_game_resources_mission_listener() called but no region with supplied key [" .. region_key .. "] could be found");
		return false;
	end;
	
	if not is_string(mission_key) then
		script_error("ERROR: start_early_game_resources_mission_listener() called but supplied mission key [" .. tostring(mission_key) .. "] is not a string");
		return false;
	end;
	
	if not is_string(resource_key) then
		script_error("ERROR: start_early_game_resources_mission_listener() called but supplied resource key [" .. tostring(resource_key) .. "] is not a string");
		return false;
	end;
	
	if mission_issuer and not is_string(mission_issuer) then
		script_error("ERROR: start_early_game_resources_mission_listener() called but supplied mission issuer [" .. tostring(mission_issuer) .. "] is not a string or nil");
		return false;
	end;
	
	if not mission_rewards then
		mission_rewards = {"money 1000"};
	end;
	
	if not is_table(mission_rewards) then
		script_error("ERROR: start_early_game_resources_mission_listener() called but supplied mission rewards [" .. mission_rewards .. "] is not a table");
		return false;
	end;
	
	if #mission_rewards == 0 then
		script_error("ERROR: start_early_game_resources_mission_listener() called but supplied mission rewards table is empty");
		return false;
	end;
	
	for i = 1, #mission_rewards do
		if not is_string(mission_rewards[i]) then
			script_error("ERROR: start_early_game_resources_mission_listener() called but supplied mission reward [" .. i .. "] is [" .. tostring(mission_rewards[i]) .. "] and not a string");
			return false;
		end;
	end;
	
	local local_faction = cm:get_local_faction_name();
	local event_name = "early_game_resources_mission_issued";
	
	-- affects how prominently this advice will be delivered based on advice level/history
	-- possible values:
	-- EARLY_GAME_ADVICE_VOICED_BY_LEGENDARY_LORD		| advice voiced by LL, relax criteria for showing it
	-- EARLY_GAME_ADVICE_SPECIFIC_TO_FACTION			| advice voiced by advisor, string is different for different factions
	-- EARLY_GAME_ADVICE_SHARED							| advice voiced by advisor, but string is shared between factions
	local advice_mode = EARLY_GAME_ADVICE_SHARED;
	
	-- construct mission
	local mm = mission_manager:new(
		local_faction, 
		mission_key
	);
	
	mm:add_new_objective("HAVE_RESOURCES");
	mm:add_condition("resource " .. resource_key);
	
	if mission_issuer then
		mm:set_mission_issuer(mission_issuer);
	end;
	
	for i = 1, #mission_rewards do
		mm:add_payload(mission_rewards[i]);
	end;
	
	-- pre-declare the intervention variable, so that it exists as a local for the subsequent function
	local in_eg_resources_mission = false;
	
	-- intervention trigger function
	local function in_eg_resources_mission_trigger()
		out.design("[EG] start_early_game_resources_mission_listener() is triggering mission, advice level is " .. core:get_advice_level());
		
		local delivery_mode, delivery_mode_str = early_game_decide_content_delivery_mode(advice_mode, advice_key);
		out.design("\t" .. delivery_mode_str);
		
		if delivery_mode == EARLY_GAME_SHOW_MISSION_ONLY then
			out.design("\tjust issuing mission");
			set_early_game_event_experienced(event_name, true);
			--mm:trigger(function() in_eg_resources_mission:complete() end);
			mm:trigger();
			cm:callback(function() in_eg_resources_mission:complete() end, 1);
		else
			if not early_game_should_show_infotext(advice_mode, advice_key, event_name) then
				out.design("\tnot showing infotext");
				infotext = {};
			end;
		
			set_early_game_event_experienced(event_name);
			
			if delivery_mode == EARLY_GAME_SCROLL_CAMERA_WITH_ADVICE_AND_MISSION then
				out.design("\tscrolling camera to settlement with advice and mission");
				in_eg_resources_mission:scroll_camera_to_settlement_for_intervention(
					region_key,
					advice_key,
					infotext,
					mm
				);
			else
				out.design("\tplaying advice with mission");
				in_eg_resources_mission:play_advice_for_intervention(
					advice_key,
					infotext,
					mm
				);
			end;
		end;
	end;
	
	
	-- set up intervention	
	in_eg_resources_mission = intervention:new(
		"eg_resources_mission", 													-- string name
		0,	 																		-- cost
		function() in_eg_resources_mission_trigger() end,							-- trigger callback
		BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
	);
	
	in_eg_resources_mission:add_precondition(
		function()
			return not get_early_game_event_experienced(event_name, true);
		end
	);
	
	
	-- trigger if the turn number exceeds the supplied threshold
	in_eg_resources_mission:add_trigger_condition(
		"ScriptEventPlayerFactionTurnStart",
		function(context)
			return cm:model():turn_number() >= turn_threshold + cm:get_saved_value("first_turn_count_modifier") and not context:faction():trade_resource_exists(resource_key);
		end
	);
	
	-- trigger if any of the player's military forces come within a turn's march of the supplied target settlement
	in_eg_resources_mission:add_trigger_condition(
		"ScriptEventPlayerFactionTurnStart",
		function(context)
			if context:faction():trade_resource_exists(resource_key) then
				return false;
			end;
		
			local mf_list = context:faction():military_force_list();
			
			local target_settlement = cm:get_region(region_key):settlement();
			
			for i = 0, mf_list:num_items() - 1 do
				local current_mf = mf_list:item_at(i);
				
				if current_mf:has_general() and cm:character_can_reach_settlement(current_mf:general_character(), target_settlement) then
					return true;
				end;
			end;
		end
	);
	
	in_eg_resources_mission:start();
end;







-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	pooled resource mission
--
--	Triggers once the player earns a certain number of a pooled resource, and tasks
--	them to earn more.
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

function start_early_game_pooled_resource_mission_listener(advice_key, infotext, mission_key, resource_name, resource_min_threshold, resource_mission_threshold, mission_issuer, mission_rewards)

	if not is_string(advice_key) then
		script_error("ERROR: start_early_game_pooled_resource_mission_listener() called but supplied advice key [" .. tostring(advice_key) .. "] is not a string");
		return false;
	end;
	
	-- default infotext value
	if not infotext then
		infotext = {};				-- default infotext is blank
	end;
	
	if not is_table(infotext) then
		script_error("ERROR: start_early_game_pooled_resource_mission_listener() called but supplied infotext [" .. tostring(infotext) .. "] is not a table or nil");
		return false;
	end;
	
	if not is_string(mission_key) then
		script_error("ERROR: start_early_game_pooled_resource_mission_listener() called but supplied mission key [" .. tostring(mission_key) .. "] is not a string");
		return false;
	end;
	
	if not is_string(resource_name) then
		script_error("ERROR: start_early_game_pooled_resource_mission_listener() called but supplied pooled resource name [" .. tostring(resource_name) .. "] is not a string");
		return false;
	end;
	
	if not is_number(resource_min_threshold) or resource_min_threshold < 0 then
		script_error("ERROR: start_early_game_pooled_resource_mission_listener() called but supplied pooled resource minimum threshold [" .. tostring(resource_min_threshold) .. "] is not a positive number");
		return false;
	end;
	
	if not is_number(resource_mission_threshold) or resource_mission_threshold <= resource_min_threshold then
		script_error("ERROR: start_early_game_pooled_resource_mission_listener() called but supplied pooled resource mission threshold [" .. tostring(resource_mission_threshold) .. "] is not a number greater than the supplied minimum threshold [" .. resource_min_threshold .. "]");
		return false;
	end;
		
	if mission_issuer and not is_string(mission_issuer) then
		script_error("ERROR: start_early_game_pooled_resource_mission_listener() called but supplied mission issuer [" .. tostring(mission_issuer) .. "] is not a string or nil");
		return false;
	end;
	
	if not mission_rewards then
		mission_rewards = {"money 1000"};
	end;
	
	if not is_table(mission_rewards) then
		script_error("ERROR: start_early_game_pooled_resource_mission_listener() called but supplied mission rewards [" .. mission_rewards .. "] is not a table");
		return false;
	end;
	
	if #mission_rewards == 0 then
		script_error("ERROR: start_early_game_pooled_resource_mission_listener() called but supplied mission rewards table is empty");
		return false;
	end;
	
	for i = 1, #mission_rewards do
		if not is_string(mission_rewards[i]) then
			script_error("ERROR: start_early_game_pooled_resource_mission_listener() called but supplied mission reward [" .. i .. "] is [" .. tostring(mission_rewards[i]) .. "] and not a string");
			return false;
		end;
	end;
	
	local local_faction = cm:get_local_faction_name();
	local event_name = "early_game_pooled_resource_mission_issued";
	
	-- affects how prominently this advice will be delivered based on advice level/history
	-- possible values:
	-- EARLY_GAME_ADVICE_VOICED_BY_LEGENDARY_LORD		| advice voiced by LL, relax criteria for showing it
	-- EARLY_GAME_ADVICE_SPECIFIC_TO_FACTION			| advice voiced by advisor, string is different for different factions
	-- EARLY_GAME_ADVICE_SHARED							| advice voiced by advisor, but string is shared between factions
	local advice_mode = EARLY_GAME_ADVICE_SHARED;
	
	-- construct mission
	local mm = mission_manager:new(
		local_faction, 
		mission_key
	);
	mm:add_new_objective("HAVE_AT_LEAST_X_OF_A_POOLED_RESOURCE");
	mm:add_condition("pooled_resource " .. resource_name);
	mm:add_condition("total " .. resource_mission_threshold);
	
	if mission_issuer then
		mm:set_mission_issuer(mission_issuer);
	end;
	
	for i = 1, #mission_rewards do
		mm:add_payload(mission_rewards[i]);
	end;
	
	-- pre-declare the intervention variable, so that it exists as a local for the subsequent function
	local in_eg_pooled_resource_mission = false;
	
	-- intervention trigger function
	local function in_eg_pooled_resource_mission_trigger()
		out.design("[EG] start_early_game_pooled_resource_mission_listener() is triggering mission, advice level is " .. core:get_advice_level());
		
		local delivery_mode, delivery_mode_str = early_game_decide_content_delivery_mode(advice_mode, advice_key);
		out.design("\t" .. delivery_mode_str);
		
		if delivery_mode == EARLY_GAME_SHOW_MISSION_ONLY then
			out.design("\tjust issuing mission");
			set_early_game_event_experienced(event_name, true);
			--mm:trigger(function() in_eg_pooled_resource_mission:complete() end);
			mm:trigger();
			cm:callback(function() in_eg_pooled_resource_mission:complete() end, 1)
		else
			if not early_game_should_show_infotext(advice_mode, advice_key, event_name) then
				out.design("\tnot showing infotext");
				infotext = {};
			end;
		
			set_early_game_event_experienced(event_name);
			
			out.design("\tplaying advice with mission");
			in_eg_pooled_resource_mission:play_advice_for_intervention(
				advice_key,
				infotext,
				mm
			);
		end;
	end;
	
	
	-- set up intervention	
	in_eg_pooled_resource_mission = intervention:new(
		"eg_pooled_resource_mission", 												-- string name
		0,	 																		-- cost
		function() in_eg_pooled_resource_mission_trigger() end,						-- trigger callback
		BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
	);
	
	in_eg_pooled_resource_mission:add_precondition(
		function()
			return not get_early_game_event_experienced(event_name, true);
		end
	);
	
	
	-- trigger if the value of the pooled resource exceeds the minimum threshold
	in_eg_pooled_resource_mission:add_trigger_condition(
		"ScriptEventPlayerFactionTurnStart",
		function(context)
			local pooled_resources = context:faction():pooled_resource_manager():resources();
			
			for i = 0, pooled_resources:num_items() - 1 do
				local current_pr = pooled_resources:item_at(i);
				if current_pr:value() > resource_min_threshold --[[and current_pr:key() == resource_name]] then
					return true;
				end;
			end;
		end
	);
		
	in_eg_pooled_resource_mission:start();
end;











-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	mortuary cult mission
--
--	Triggers once the player can craft an item in the mortuary cult. Tomb Kings only.
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

function start_early_game_mortuary_cult_mission_listener(advice_key, infotext, mission_key, mission_issuer, mission_rewards)

	if not is_string(advice_key) then
		script_error("ERROR: start_early_game_mortuary_cult_mission_listener() called but supplied advice key [" .. tostring(advice_key) .. "] is not a string");
		return false;
	end;
	
	-- default infotext value
	if not infotext then
		infotext = {
			"war.camp.advice.mortuary_cult.info_001",
			"war.camp.advice.mortuary_cult.info_002",
			"war.camp.advice.mortuary_cult.info_003"
		};
	end;
	
	if not is_table(infotext) then
		script_error("ERROR: start_early_game_mortuary_cult_mission_listener() called but supplied infotext [" .. tostring(infotext) .. "] is not a table or nil");
		return false;
	end;
	
	if not is_string(mission_key) then
		script_error("ERROR: start_early_game_mortuary_cult_mission_listener() called but supplied mission key [" .. tostring(mission_key) .. "] is not a string");
		return false;
	end;
		
	if mission_issuer and not is_string(mission_issuer) then
		script_error("ERROR: start_early_game_mortuary_cult_mission_listener() called but supplied mission issuer [" .. tostring(mission_issuer) .. "] is not a string or nil");
		return false;
	end;
	
	if not mission_rewards then
		mission_rewards = {"money 1000"};
	end;
	
	if not is_table(mission_rewards) then
		script_error("ERROR: start_early_game_mortuary_cult_mission_listener() called but supplied mission rewards [" .. mission_rewards .. "] is not a table");
		return false;
	end;
	
	if #mission_rewards == 0 then
		script_error("ERROR: start_early_game_mortuary_cult_mission_listener() called but supplied mission rewards table is empty");
		return false;
	end;
	
	for i = 1, #mission_rewards do
		if not is_string(mission_rewards[i]) then
			script_error("ERROR: start_early_game_mortuary_cult_mission_listener() called but supplied mission reward [" .. i .. "] is [" .. tostring(mission_rewards[i]) .. "] and not a string");
			return false;
		end;
	end;
	
	-- list of crafting rituals, this must correspond with the db
	local crafting_rituals = {
		"wh2_dlc09_ritual_crafting_tmb_arcane_item_blue_khepra",
		"wh2_dlc09_ritual_crafting_tmb_arcane_item_enkhils_kanopi",
		"wh2_dlc09_ritual_crafting_tmb_arcane_item_neferras_scrolls_of_mighty_incantations",
		"wh2_dlc09_ritual_crafting_tmb_arcane_item_power_scroll",
		"wh2_dlc09_ritual_crafting_tmb_arcane_item_scroll_of_leeching",
		"wh2_dlc09_ritual_crafting_tmb_arcane_item_scroll_of_shielding",
		"wh2_dlc09_ritual_crafting_tmb_armour_armour_of_dawn",
		"wh2_dlc09_ritual_crafting_tmb_armour_armour_of_eternity",
		"wh2_dlc09_ritual_crafting_tmb_armour_armour_of_the_ages",
		"wh2_dlc09_ritual_crafting_tmb_armour_helmet_of_khsar",
		"wh2_dlc09_ritual_crafting_tmb_armour_mortuary_robes",
		"wh2_dlc09_ritual_crafting_tmb_armour_scorpion_armour",
		"wh2_dlc09_ritual_crafting_tmb_armour_shield_of_ptra",
		"wh2_dlc09_ritual_crafting_tmb_armour_skull_cap_of_the_moon",
		"wh2_dlc09_ritual_crafting_tmb_army_capacity",
		"wh2_dlc09_ritual_crafting_tmb_carrion",
		"wh2_dlc09_ritual_crafting_tmb_enchanted_item_brooch_of_the_great_desert",
		"wh2_dlc09_ritual_crafting_tmb_enchanted_item_death_mask_of_kharnut",
		"wh2_dlc09_ritual_crafting_tmb_enchanted_item_elixir_of_might",
		"wh2_dlc09_ritual_crafting_tmb_enchanted_item_hieratic_jar",
		"wh2_dlc09_ritual_crafting_tmb_enchanted_item_icon_of_rulership",
		"wh2_dlc09_ritual_crafting_tmb_enchanted_item_ouroboros",
		"wh2_dlc09_ritual_crafting_tmb_enchanted_item_potion_of_foolhardiness",
		"wh2_dlc09_ritual_crafting_tmb_enchanted_item_potion_of_speed",
		"wh2_dlc09_ritual_crafting_tmb_enchanted_item_potion_of_strength",
		"wh2_dlc09_ritual_crafting_tmb_enchanted_item_potion_of_toughness",
		"wh2_dlc09_ritual_crafting_tmb_enchanted_item_shroud_of_sokth",
		"wh2_dlc09_ritual_crafting_tmb_enchanted_item_vambraces_of_the_sun",
		"wh2_dlc09_ritual_crafting_tmb_necropolis_knights",
		"wh2_dlc09_ritual_crafting_tmb_nehekhara_horsemen",
		"wh2_dlc09_ritual_crafting_tmb_nehekhara_warriors",
		"wh2_dlc09_ritual_crafting_tmb_talisman_amulet_of_pha_stah",
		"wh2_dlc09_ritual_crafting_tmb_talisman_collar_of_shakkara",
		"wh2_dlc09_ritual_crafting_tmb_talisman_dawnstone",
		"wh2_dlc09_ritual_crafting_tmb_talisman_golden_ankhra",
		"wh2_dlc09_ritual_crafting_tmb_talisman_golden_eye_of_rah_nutt",
		"wh2_dlc09_ritual_crafting_tmb_talisman_obsidian_lodestone",
		"wh2_dlc09_ritual_crafting_tmb_weapon_blade_of_antarhak",
		"wh2_dlc09_ritual_crafting_tmb_weapon_blade_of_mourning_fire",
		"wh2_dlc09_ritual_crafting_tmb_weapon_blade_of_setep",
		"wh2_dlc09_ritual_crafting_tmb_weapon_crook_and_flail_of_radiance",
		"wh2_dlc09_ritual_crafting_tmb_weapon_destroyer_of_eternities",
		"wh2_dlc09_ritual_crafting_tmb_weapon_double_crescent_of_neru",
		"wh2_dlc09_ritual_crafting_tmb_weapon_enchanted_lapis_mace",
		"wh2_dlc09_ritual_crafting_tmb_weapon_fang_of_quaph",
		"wh2_dlc09_ritual_crafting_tmb_weapon_golden_dagger",
		"wh2_dlc09_ritual_crafting_tmb_weapon_inscribed_khopesh",
		"wh2_dlc09_ritual_crafting_tmb_weapon_spear_of_pakth"
	};
	
	local local_faction = cm:get_local_faction_name();
	local event_name = "early_game_mortuary_cult_mission_issued";
	
	-- affects how prominently this advice will be delivered based on advice level/history
	-- possible values:
	-- EARLY_GAME_ADVICE_VOICED_BY_LEGENDARY_LORD		| advice voiced by LL, relax criteria for showing it
	-- EARLY_GAME_ADVICE_SPECIFIC_TO_FACTION			| advice voiced by advisor, string is different for different factions
	-- EARLY_GAME_ADVICE_SHARED							| advice voiced by advisor, but string is shared between factions
	local advice_mode = EARLY_GAME_ADVICE_SHARED;
	
	-- construct mission
	local mm = mission_manager:new(
		local_faction, 
		mission_key
	);
	
	mm:add_new_scripted_objective(
		"ui_text_replacements_localised_text_mis_activity_perform_a_ritual_wh2_dlc09_sc_tmb_tomb_kings",
		"RitualStartedEvent",
		function(context)			
			if context:performing_faction():name() == local_faction then
				local ritual_key = context:ritual():ritual_key();
				
				for i = 1, #crafting_rituals do
					if crafting_rituals[i] == ritual_key then
						return true;
					end;
				end;
			end;
		end
	);
	
	if mission_issuer then
		mm:set_mission_issuer(mission_issuer);
	end;
	
	for i = 1, #mission_rewards do
		mm:add_payload(mission_rewards[i]);
	end;
	
	-- pre-declare the intervention variable, so that it exists as a local for the subsequent function
	local in_eg_mortuary_cult_mission = false;
	
	-- intervention trigger function
	local function in_eg_mortuary_cult_mission_trigger()
		out.design("[EG] start_early_game_mortuary_cult_mission_listener() is triggering mission, advice level is " .. core:get_advice_level());
		
		local delivery_mode, delivery_mode_str = early_game_decide_content_delivery_mode(advice_mode, advice_key);
		out.design("\t" .. delivery_mode_str);
		
		if delivery_mode == EARLY_GAME_SHOW_MISSION_ONLY then
			out.design("\tjust issuing mission");
			set_early_game_event_experienced(event_name, true);
			--mm:trigger(function() in_eg_mortuary_cult_mission:complete() end);
			mm:trigger();
			cm:callback(function() in_eg_mortuary_cult_mission:complete() end, 1)
		else
			if not early_game_should_show_infotext(advice_mode, advice_key, event_name) then
				out.design("\tnot showing infotext");
				infotext = {};
			end;
		
			set_early_game_event_experienced(event_name);
			
			out.design("\tplaying advice with mission");
			in_eg_mortuary_cult_mission:play_advice_for_intervention(
				advice_key,
				infotext,
				mm
			);
		end;
	end;
	
	
	-- set up intervention	
	in_eg_mortuary_cult_mission = intervention:new(
		"eg_mortuary_cult_mission", 												-- string name
		0,	 																		-- cost
		function() in_eg_mortuary_cult_mission_trigger() end,						-- trigger callback
		BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
	);
	
	in_eg_mortuary_cult_mission:add_precondition(
		function()
			return not get_early_game_event_experienced(event_name, true);
		end
	);
	
	
	local function check_can_craft()		
		local faction_rituals = cm:get_faction(local_faction):rituals();
		
		for i = 1, #crafting_rituals do		
			-- ritual_status is a bitmask of reasons why this ritual can't be cast, so 0 == available				
			if faction_rituals:ritual_status(crafting_rituals[i]):available() then			
				return true;
			end;
		end;
		
		out("");
	end;
	
	
	-- trigger if the value of the pooled resource exceeds the minimum threshold
	in_eg_mortuary_cult_mission:add_trigger_condition(
		"ScriptEventPlayerFactionTurnStart",
		function(context)
			return check_can_craft();
		end
	);
	
	
	in_eg_mortuary_cult_mission:add_trigger_condition(
		"ScriptEventPlayerBattleSequenceCompleted",
		function(context)
			return check_can_craft();
		end
	);
	
	
	-- received a short time after the MissionSucceeded event is triggered
	in_eg_mortuary_cult_mission:add_trigger_condition(
		"ScriptEventPlayerMissionSucceeded",
		function(context)			
			return check_can_craft();
		end
	);
	
	
	in_eg_mortuary_cult_mission:start();
end;














-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Tomb Kings recruitment building mission
--
--	Triggers at the start of a certain turn. Instructs the player to construct
--	a supplied that will grant access to a new unit type.
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

function start_early_game_tmb_recruitment_building_mission_listener(advice_key, infotext, mission_key, trigger_turn, upgrade_buildings_list, mission_issuer, mission_rewards)

	if not is_string(advice_key) then
		script_error("ERROR: start_early_game_tmb_recruitment_building_mission_listener() called but supplied advice key [" .. tostring(advice_key) .. "] is not a string");
		return false;
	end;
	
	-- default infotext value
	if not infotext then
		infotext = {
			"war.camp.advice.day_of_awakening.info_001",
			"war.camp.advice.day_of_awakening.info_002",
			"war.camp.advice.day_of_awakening.info_003"
		};
	end;
	
	if not is_table(infotext) then
		script_error("ERROR: start_early_game_tmb_recruitment_building_mission_listener() called but supplied infotext [" .. tostring(infotext) .. "] is not a table or nil");
		return false;
	end;
	
	if not is_string(mission_key) then
		script_error("ERROR: start_early_game_tmb_recruitment_building_mission_listener() called but supplied mission key [" .. tostring(mission_key) .. "] is not a string");
		return false;
	end;
	
	trigger_turn = trigger_turn or 2;
	
	if not is_number(trigger_turn) or trigger_turn <= 0 then
		script_error("ERROR: start_early_game_tmb_recruitment_building_mission_listener() called but supplied trigger turn [" .. tostring(trigger_turn) .. "] is not a number greater than 0");
	end;
	
	if not is_table(upgrade_buildings_list) then
		script_error("ERROR: start_early_game_tmb_recruitment_building_mission_listener() called but supplied upgrade buildings list [" .. tostring(upgrade_buildings_list) .. "] is not a table");
		return false;
	end;
	
	if #upgrade_buildings_list == 0 then
		script_error("ERROR: start_early_game_tmb_recruitment_building_mission_listener() called but supplied upgrade buildings list is empty");
		return false;
	end;
	
	for i = 1, #upgrade_buildings_list do
		if not is_string(upgrade_buildings_list[i]) then
			script_error("ERROR: start_early_game_tmb_recruitment_building_mission_listener() called but element [" .. i .. "] in supplied upgrade buildings list is not a string (value is [" .. tostring(upgrade_buildings_list[i]) .. "])");
			return false;
		end;
	end;
	
	if mission_issuer and not is_string(mission_issuer) then
		script_error("ERROR: start_early_game_tmb_recruitment_building_mission_listener() called but supplied mission issuer [" .. tostring(mission_issuer) .. "] is not a string or nil");
		return false;
	end;
	
	if not mission_rewards then
		mission_rewards = {"money 1000"};
	end;
	
	if not is_table(mission_rewards) then
		script_error("ERROR: start_early_game_tmb_recruitment_building_mission_listener() called but supplied mission rewards [" .. mission_rewards .. "] is not a table");
		return false;
	end;
	
	if #mission_rewards == 0 then
		script_error("ERROR: start_early_game_tmb_recruitment_building_mission_listener() called but supplied mission rewards table is empty");
		return false;
	end;
	
	for i = 1, #mission_rewards do
		if not is_string(mission_rewards[i]) then
			script_error("ERROR: start_early_game_tmb_recruitment_building_mission_listener() called but supplied mission reward [" .. i .. "] is [" .. tostring(mission_rewards[i]) .. "] and not a string");
			return false;
		end;
	end;
	
	local local_faction = cm:get_local_faction_name();
	local event_name = "early_game_tmb_recruitment_building_mission_issued";
	
	-- make an internal list of buildings, as we will be modifying it
	local internal_upgrade_list = {};
	for i = 1, #upgrade_buildings_list do
		table.insert(internal_upgrade_list, upgrade_buildings_list[i]);
	end;
	
	-- remove all buildings in the internal buildings list that the player has already constructed
	do
		local faction = cm:get_faction(local_faction);
		for i = #internal_upgrade_list, 1, -1 do
			if cm:faction_contains_building(faction, internal_upgrade_list[i]) then
				out.design("\tplayer has already constructed " .. internal_upgrade_list[i] .. ", removing it from mission list");
				table.remove(internal_upgrade_list, i);
			end;
		end;
	end;
	
	-- affects how prominently this advice will be delivered based on advice level/history
	-- possible values:
	-- EARLY_GAME_ADVICE_VOICED_BY_LEGENDARY_LORD		| advice voiced by LL, relax criteria for showing it
	-- EARLY_GAME_ADVICE_SPECIFIC_TO_FACTION			| advice voiced by advisor, string is different for different factions
	-- EARLY_GAME_ADVICE_SHARED							| advice voiced by advisor, but string is shared between factions
	local advice_mode = EARLY_GAME_ADVICE_SHARED;
	
	local constructed_building_region_key = false;
	
	-- construct mission
	local mm = mission_manager:new(
		local_faction, 
		mission_key,
		function() core:trigger_event("ScriptEventTMBRecruitmentBuildingMissionCompleted", constructed_building_region_key) end
	);
	
	mm:add_new_scripted_objective(
		"mission_text_text_dlc09_early_game_tomb_kings_recruitment_building_mission_objective",
		"BuildingCompleted",				-- event
		function(context)					-- condition to test
			if context:building():faction():name() == local_faction then
				local building_name = context:building():name();
				
				for i = 1, #internal_upgrade_list do
					if building_name == internal_upgrade_list[i] then
						constructed_building_region_key = context:building():region():name();
						return true;
					end;
				end;
			end;			
		end
	);
	
	if mission_issuer then
		mm:set_mission_issuer(mission_issuer);
	end;
	
	for i = 1, #mission_rewards do
		mm:add_payload(mission_rewards[i]);
	end;
	
	-- pre-declare the intervention variable, so that it exists as a local for the subsequent function
	local in_eg_tmb_recruitment_building_mission = false;
	
	-- intervention trigger function
	local function in_eg_tmb_recruitment_building_mission_trigger()
		out.design("[EG] start_early_game_tmb_recruitment_building_mission_listener() is triggering mission, advice level is " .. core:get_advice_level());
		
		local delivery_mode, delivery_mode_str = early_game_decide_content_delivery_mode(advice_mode, advice_key);
		out.design("\t" .. delivery_mode_str);
		
		if delivery_mode == EARLY_GAME_SHOW_MISSION_ONLY then
			out.design("\tjust issuing mission");
			set_early_game_event_experienced(event_name, true);
			--mm:trigger(function() in_eg_tmb_recruitment_building_mission:complete() end);
			mm:trigger();
			cm:callback(function() in_eg_tmb_recruitment_building_mission:complete() end, 1)
		else
			if not early_game_should_show_infotext(advice_mode, advice_key, event_name) then
				out.design("\tnot showing infotext");
				infotext = {};
			end;
		
			set_early_game_event_experienced(event_name);
			
			out.design("\tplaying advice with mission");
			in_eg_tmb_recruitment_building_mission:play_advice_for_intervention(
				advice_key,
				infotext,
				mm
			);
		end;
	end;
	
	
	-- set up intervention	
	in_eg_tmb_recruitment_building_mission = intervention:new(
		"eg_tmb_recruitment_building_mission", 										-- string name
		0,	 																		-- cost
		function() in_eg_tmb_recruitment_building_mission_trigger() end,			-- trigger callback
		BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
	);
	
	in_eg_tmb_recruitment_building_mission:add_precondition(
		function()
			return not get_early_game_event_experienced(event_name, true);
		end
	);
	
	
	-- trigger if the value of the pooled resource exceeds the minimum threshold
	in_eg_tmb_recruitment_building_mission:add_trigger_condition(
		"ScriptEventPlayerFactionTurnStart",
		function(context)		
			return get_cm():model():turn_number() >= trigger_turn;
		end
	);
	
	in_eg_tmb_recruitment_building_mission:start();
	
end;











-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Tomb Kings Recruitment Guide
--
--	Triggers after the How-They-Play event is dismissed.
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

function start_early_game_tmb_recruitment_building_guide_listener(advice_key, infotext, mission_key, num_units, mission_issuer, mission_rewards)

	if not is_string(advice_key) then
		script_error("ERROR: start_early_game_tmb_recruitment_building_guide_listener() called but supplied advice key [" .. tostring(advice_key) .. "] is not a string");
		return false;
	end;
	
	-- default infotext value
	if not infotext then
		infotext = {
			"war.camp.advice.day_of_awakening.info_001",
			"war.camp.advice.day_of_awakening.info_002"
		};
	end;
	
	if not is_table(infotext) then
		script_error("ERROR: start_early_game_tmb_recruitment_building_guide_listener() called but supplied infotext [" .. tostring(infotext) .. "] is not a table or nil");
		return false;
	end;
	
	if not is_string(mission_key) then
		script_error("ERROR: start_early_game_tmb_recruitment_building_guide_listener() called but supplied mission key [" .. tostring(mission_key) .. "] is not a string");
		return false;
	end;
		
	if mission_issuer and not is_string(mission_issuer) then
		script_error("ERROR: start_early_game_tmb_recruitment_building_guide_listener() called but supplied mission issuer [" .. tostring(mission_issuer) .. "] is not a string or nil");
		return false;
	end;
	
	if not mission_rewards then
		mission_rewards = {"money 1000"};
	end;
	
	if not is_table(mission_rewards) then
		script_error("ERROR: start_early_game_tmb_recruitment_building_guide_listener() called but supplied mission rewards [" .. mission_rewards .. "] is not a table");
		return false;
	end;
	
	if #mission_rewards == 0 then
		script_error("ERROR: start_early_game_tmb_recruitment_building_guide_listener() called but supplied mission rewards table is empty");
		return false;
	end;
	
	for i = 1, #mission_rewards do
		if not is_string(mission_rewards[i]) then
			script_error("ERROR: start_early_game_tmb_recruitment_building_guide_listener() called but supplied mission reward [" .. i .. "] is [" .. tostring(mission_rewards[i]) .. "] and not a string");
			return false;
		end;
	end;
	
	local local_faction = cm:get_local_faction_name();
	local event_name = "early_game_tmb_recruitment_building_guide_issued";
	
	
	-- construct mission
	local mm = mission_manager:new(
		local_faction, 
		mission_key
	);
	
	mm:add_new_objective("OWN_N_UNITS");
	mm:add_condition("unit wh2_dlc09_tmb_inf_skeleton_spearmen_0");
	mm:add_condition("unit wh2_dlc09_tmb_inf_skeleton_warriors_0");
	
	mm:add_condition("total " .. num_units);
		
	if mission_issuer then
		mm:set_mission_issuer(mission_issuer);
	end;
	
	for i = 1, #mission_rewards do
		mm:add_payload(mission_rewards[i]);
	end;
	
	
	--
	-- scripted tour is complete (or aborted) - issue the follow-up mission to recruit capless units and complete
	local function issue_recruit_capless_units_mission_and_complete(intervention)
		
		mm:trigger(function() intervention:complete() end);		
	end;
	
	local constructed_building_region_key = false;
	
	
	--
	-- function that plays scripted tour
	local function start_recruitment_building_guide_scripted_tour(intervention)
		
		-- don't proceed if we don't know what region the building was constructed in
		local region = cm:get_region(constructed_building_region_key);
		if not region then
			out.design("\t\taborting as we couldn't find what region the building was constructed in (recorded key was " .. tostring(constructed_building_region_key) .. ")");
			
			issue_recruit_capless_units_mission_and_complete(intervention);
			return;
		end;
		
		local province_name = region:province_name();
		
		local faction = cm:get_faction(local_faction);
		local mf_list = faction:military_force_list();
		
		-- try and find a lord stood in the supplied region's provice
		local target_char = false;		
		for i = 0, mf_list:num_items() - 1 do
			local current_mf = mf_list:item_at(i);
			
			if current_mf:has_general() then
				local current_char = current_mf:general_character();
				
				if current_char:has_region() then
					if current_char:region():province_name() == province_name and not (current_char:has_garrison_residence() and current_char:garrison_residence():is_under_siege()) then
						target_char = current_char;
						break;
					end;
				end;
			end;
		end;
		
		-- don't proceed if we didn't find a Lord in the building's province
		if not target_char then
			out.design("\t\taborting as we couldn't find a player's Lord in the province the building was constructed in that's not under siege in a settlement");
			issue_recruit_capless_units_mission_and_complete(intervention);
			return;
		end;
		
		local target_char_cqi = target_char:cqi();
		
		local function recruitment_building_guide_disable_ui(should_disable)
			local uim = cm:get_campaign_ui_manager();
		
			local overrides_to_disable = {
				"help_panel_button",
				"spell_browser",
				"camera_settings",
				"advice_settings_button",
				"radar_rollout_buttons",
				"faction_button",
				"diplomacy",
				"technology",
				"offices",
				"finance",
				"missions",
				"selection_change",
				"rituals",
				"mortuary_cult",
				"books_of_nagash",
				"regiments_of_renown"
			};
			
			if should_disable then
				for i = 1, #overrides_to_disable do
					uim:override(overrides_to_disable[i]):lock();
				end;
			else
				for i = 1, #overrides_to_disable do
					uim:override(overrides_to_disable[i]):unlock();
				end;
			end;
		end;
		
		-- lock ui
		recruitment_building_guide_disable_ui(true);
		
		-- show advice
		core:cache_and_set_advisor_priority(1500, true);
		cm:show_advice(advice_key);
		cm:add_infotext(1, unpack(infotext));
		
		-- highlight event dismiss button
		cm:callback(function() cm:highlight_event_dismiss_button(true) end, 1, "early_game_tmb_recruitment_building_guide_event_button_highlight");
		
		-- wait for player to dismiss events
		cm:progress_on_events_dismissed(
			"early_game_tmb_recruitment_building_guide_listener",
			function()
				-- unhighlight event dismiss button
				cm:highlight_event_dismiss_button(false);
				
				cm:remove_callback("early_game_tmb_recruitment_building_guide_event_button_highlight");
				
				cm:callback(
					function()
						-- scroll the camera to the target character
						cm:scroll_camera_with_cutscene_to_character(
							2, 
							function() 
								local uic_banner = find_uicomponent(core:get_ui_root(), "3d_ui_parent", "label_" .. target_char_cqi);
								
								-- don't proceed if we couldn't find the character's banner
								if not uic_banner then
									out.design("\t\taborting as we couldn't find a uicomponent for the Lord's banner");
									
									recruitment_building_guide_disable_ui(false);
									
									issue_recruit_capless_units_mission_and_complete(intervention);
									return;
								end;
								
								-- establish a listener for the character selection that's about to occur
								core:add_listener(
									"early_game_tmb_recruitment_building_guide_char_selection",
									"PanelOpenedCampaign",
									function(context) return context.string == "units_panel" end,
									function(context)
										cm:remove_callback("early_game_tmb_recruitment_building_guide_char_selection");
															
										local uic_recruitment_button = find_uicomponent(core:get_ui_root(), "hud_center", "small_bar", "button_group_army", "button_recruitment");
										
										-- don't proceed if the recruitment button is not active for whatever reason
										if not uic_recruitment_button or uic_recruitment_button:CurrentState() ~= "active" then
											out.design("\t\taborting as the recruitment button is not active for whatever reason");
											
											recruitment_building_guide_disable_ui(false);
											
											issue_recruit_capless_units_mission_and_complete(intervention);
											return;
										end;
										
										-- abort after half a second if the recruit units panel fails to open (failsafe)
										cm:callback(
											function()
												out.design("\t\taborting as the recruitment panel did not seem to open after the button click was simulated");
												core:remove_listener("early_game_tmb_recruitment_building_guide_char_selection");
												
												recruitment_building_guide_disable_ui(false);
												
												issue_recruit_capless_units_mission_and_complete(intervention);
												return;
											end, 
											0.5, 
											"early_game_tmb_recruitment_building_guide_char_selection"
										);								
										
										-- establish a listener for the recruitment panel opening
										core:add_listener(
											"early_game_tmb_recruitment_building_guide_char_selection",
											"PanelOpenedCampaign",
											function(context) return context.string == "units_recruitment" end,
											function(context)
												cm:remove_callback("early_game_tmb_recruitment_building_guide_char_selection");
												
												-- prevent selection changing again
												cm:get_campaign_ui_manager():override("selection_change"):lock();
												
												-- wait a short period for the recruitment panel to animate on-screen
												cm:callback(
													function()
														
														local uic_unit_card_list = find_uicomponent(core:get_ui_root(), "main_units_panel", "local1", "unit_list", "list_box");
														
														-- don't proceed if we couldn't find a unit card list for some reason
														if not uic_unit_card_list then
															out.design("\t\taborting as no unit card list on the recruitment panel could be found");
															
															recruitment_building_guide_disable_ui(false);
															
															issue_recruit_capless_units_mission_and_complete(intervention);
															return;
														end;
														
														local list_of_unit_cards = {};
														local list_of_unit_cards_no_cap = {};
														local list_of_unit_caps_to_highlight = {};
														
														-- go through all unit cards and add those that have a visible unit cap to a list
														for i = 0, uic_unit_card_list:ChildCount() - 1 do
															local uic_card = UIComponent(uic_unit_card_list:Find(i));
															
															if uic_card then
																local uic_unit_cap = find_uicomponent(uic_card, "unit_cap");
																
																table.insert(list_of_unit_cards, uic_card);
																
																if uic_unit_cap and uic_unit_cap:Visible() then
																	table.insert(list_of_unit_caps_to_highlight, uic_unit_cap);
																else
																	table.insert(list_of_unit_cards_no_cap, uic_card);
																end;
															end;
														end;
														
														if #list_of_unit_caps_to_highlight == 0 then
															out.design("\t\taborting as we could find no unit cards with a visible unit cap");
															
															recruitment_building_guide_disable_ui(false);
															
															issue_recruit_capless_units_mission_and_complete(intervention);
															return;
														end;
														
														if #list_of_unit_cards_no_cap == 0 then
															out.design("\t\taborting as we could find no unit cards with no visible unit cap");
															
															recruitment_building_guide_disable_ui(false);
															
															issue_recruit_capless_units_mission_and_complete(intervention);
															return;
														end;
														
														-- show fullscreen highlight around the unit cards
														core:show_fullscreen_highlight_around_components(25, false, false, unpack(list_of_unit_cards));
														
														-- set up cap text pointer
														local uic_cap_size_x, uic_cap_size_y = list_of_unit_caps_to_highlight[#list_of_unit_caps_to_highlight]:Dimensions();
														local uic_cap_pos_x, uic_cap_pos_y = list_of_unit_caps_to_highlight[#list_of_unit_caps_to_highlight]:Position();
														
														local tp_unit_cap = text_pointer:new("unit_cap", "left", 100, uic_cap_pos_x + uic_cap_size_x * 0.75, uic_cap_pos_y + (uic_cap_size_y / 2));
														tp_unit_cap:set_layout("text_pointer_text_only");
														tp_unit_cap:add_component_text("text", "ui_text_replacements_localised_text_dlc09_text_pointer_unit_cap");
														tp_unit_cap:set_style("semitransparent_highlight_dont_close");
														tp_unit_cap:set_panel_width(350);
														
														-- set up cap text pointer
														local uic_capless_size_x, uic_capless_size_y = list_of_unit_cards_no_cap[1]:Dimensions();
														local uic_capless_pos_x, uic_capless_pos_y = list_of_unit_cards_no_cap[1]:Position();
														
														local tp_unit_capless = text_pointer:new("unit_capless", "right", 100, uic_capless_pos_x + (uic_capless_size_x / 2), uic_capless_pos_y + (uic_capless_size_y / 2));
														tp_unit_capless:set_layout("text_pointer_text_only");
														tp_unit_capless:add_component_text("text", "ui_text_replacements_localised_text_dlc09_text_pointer_units_with_no_cap");
														tp_unit_capless:set_style("semitransparent_highlight_dont_close");
														tp_unit_capless:set_panel_width(300);
														
														tp_unit_cap:set_close_button_callback(
															function()
																
																-- stop pulsing unit cap components
																for i = 1, #list_of_unit_caps_to_highlight do
																	pulse_uicomponent(list_of_unit_caps_to_highlight[i], false, 3, true)
																end;
																
																cm:callback(
																	function() 
																		-- pulse unit cards with no cap
																		for i = 1, #list_of_unit_cards_no_cap do
																			pulse_uicomponent(list_of_unit_cards_no_cap[i], true, 3, true)
																		end;
																		
																		tp_unit_capless:show();
																	end, 
																	0.5
																);
															end
														);
														
														tp_unit_capless:set_close_button_callback(
															function()
																-- stop pulsing unit cards with no cap
																for i = 1, #list_of_unit_cards_no_cap do
																	pulse_uicomponent(list_of_unit_cards_no_cap[i], false, 3, true)
																end;
															
																tp_unit_cap:hide();
																tp_unit_capless:hide();
																
																-- lift fullscreen highlight
																core:hide_fullscreen_highlight();
																
																core:restore_advisor_priority();
																
																cm:modify_advice(true);
																
																-- proceed to mission issuing
																out.design("\t\tcompleted");
																
																
																-- close the recruitment panel if it's open
																if cm:get_campaign_ui_manager():is_panel_open("units_recruitment") then
																	
																	local uic_close_button = find_uicomponent(core:get_ui_root(), "main_units_panel", "recruitment_options", "title_docker", "button_minimise");
																	
																	out.design("\t\trecruitment panel is open");
																	
																	if uic_close_button and uic_close_button:Visible(true) then
																		out.design("\t\tclosing recruitment panel");
																		uic_close_button:SimulateLClick();
																	end
																	
																	cm:callback(
																		function()
																			recruitment_building_guide_disable_ui(false);
																			issue_recruit_capless_units_mission_and_complete(intervention);
																		end,
																		0.5
																	);
																else
																	recruitment_building_guide_disable_ui(false);
																	issue_recruit_capless_units_mission_and_complete(intervention);
																end;
															end
														);
														
														tp_unit_cap:show();
														
														-- pulse the unit cap components
														for i = 1, #list_of_unit_caps_to_highlight do
															pulse_uicomponent(list_of_unit_caps_to_highlight[i], true, 3, true)
														end;
														
													end, 
													0.3
												);
											end,
											false
										);
										
										-- simulate a click on the recruitment button
										uic_recruitment_button:SimulateLClick();
									end,
									false
								);
											
								-- simulate a click on the Lord's banner to select them
								cm:callback(
									function()
										cm:get_campaign_ui_manager():override("selection_change"):unlock();
										uic_banner:SetDisabled(false);
										uic_banner:SimulateLClick();
										uic_banner:SetDisabled(true);
									end, 
									0.5
								);
								
								-- abort after half a second if the character selection fails (failsafe)
								cm:callback(
									function()
										out.design("\t\taborting as the units panel did not seem to open after the banner click was simulated");
										core:remove_listener("early_game_tmb_recruitment_building_guide_char_selection");
										
										recruitment_building_guide_disable_ui(false);
										
										issue_recruit_capless_units_mission_and_complete(intervention);
										return;
									end, 
									1,
									"early_game_tmb_recruitment_building_guide_char_selection"
								);
							end, 
							target_char_cqi
						);
					end,
					0.5
				);
			end
		);		
	end;
	
	local advice_mode = EARLY_GAME_ADVICE_SHARED;
	
	-- pre-declare the intervention variable, so that it exists as a local for the subsequent function
	local in_eg_tmb_recruitment_building_guide = false;
	
	-- intervention trigger function
	local function in_eg_tmb_recruitment_building_guide_trigger()
		out.design("[EG] start_early_game_tmb_recruitment_building_guide_listener() is triggering, advice level is " .. core:get_advice_level());
				
		set_early_game_event_experienced(event_name, true);
		
		if (core:is_advice_level_minimal() or common.get_advice_thread_score(advice_key) > 0) and not core:is_tweaker_set("SKIP_SCRIPTED_CONTENT_5") then
			out.design("\tnot starting scripted tour as advice level is minimal or advice has been played before, just issuing mission");
			
			issue_recruit_capless_units_mission_and_complete(in_eg_tmb_recruitment_building_guide);
		else
			out.design("\tattempting to show advice");
			
			start_recruitment_building_guide_scripted_tour(in_eg_tmb_recruitment_building_guide);
		end;
	end;
	
	
	-- set up intervention	
	in_eg_tmb_recruitment_building_guide = intervention:new(
		"eg_tmb_recruitment_building_guide", 										-- string name
		0,	 																		-- cost
		function() in_eg_tmb_recruitment_building_guide_trigger() end,				-- trigger callback
		BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
	);
	
	in_eg_tmb_recruitment_building_guide:set_must_trigger(true, true);
	
	in_eg_tmb_recruitment_building_guide:add_precondition(
		function()
			return not get_early_game_event_experienced(event_name, true);
		end
	);
	
	in_eg_tmb_recruitment_building_guide:add_trigger_condition(
		"ScriptEventTMBRecruitmentBuildingMissionCompleted",
		function(context)
			constructed_building_region_key = context.string;
			return true;
		end
	);
		
	in_eg_tmb_recruitment_building_guide:start();
end;








-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Tomb Kings Books of Nagash mission
--
--	Triggers after the How-They-Play event is dismissed.
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

function start_early_game_books_of_nagash_mission_listener(mission_key, mission_issuer, mission_rewards, building_override_list)

	if not is_string(mission_key) then
		script_error("ERROR: start_early_game_books_of_nagash_mission_listener() called but supplied mission key [" .. tostring(mission_key) .. "] is not a string");
		return false;
	end;
	
	
	if mission_issuer and not is_string(mission_issuer) then
		script_error("ERROR: start_early_game_books_of_nagash_mission_listener() called but supplied mission issuer [" .. tostring(mission_issuer) .. "] is not a string or nil");
		return false;
	end;
	
	if not mission_rewards then
		mission_rewards = {"money 1000"};
	end;
	
	if not is_table(mission_rewards) then
		script_error("ERROR: start_early_game_books_of_nagash_mission_listener() called but supplied mission rewards [" .. mission_rewards .. "] is not a table");
		return false;
	end;
	
	if #mission_rewards == 0 then
		script_error("ERROR: start_early_game_books_of_nagash_mission_listener() called but supplied mission rewards table is empty");
		return false;
	end;
	
	for i = 1, #mission_rewards do
		if not is_string(mission_rewards[i]) then
			script_error("ERROR: start_early_game_books_of_nagash_mission_listener() called but supplied mission reward [" .. i .. "] is [" .. tostring(mission_rewards[i]) .. "] and not a string");
			return false;
		end;
	end;
	
	local local_faction = cm:get_local_faction_name();
	local event_name = "early_game_books_of_nagash_mission_listener";
		
	-- construct mission
	local mm = mission_manager:new(
		local_faction, 
		mission_key
	);
		
	mm:add_new_scripted_objective(
		"mission_text_text_wh2_dlc09_objective_override_book_collect_any",
		"ScriptEventBookOfNagashAcquired",
		true
	);
	
	if mission_issuer then
		mm:set_mission_issuer(mission_issuer);
	end;
	
	for i = 1, #mission_rewards do
		mm:add_payload(mission_rewards[i]);
	end;
	
	
	
	
	
	
	--
	-- Books of Nagash scripted tour
	--
	
	local function books_of_nagash_scripted_tour_disable_ui(should_disable)
		local uim = cm:get_campaign_ui_manager();
	
		local overrides_to_disable = {
			"help_panel_button",
			"spell_browser",
			"camera_settings",
			"advice_settings_button",
			"radar_rollout_buttons",
			"faction_button",
			"diplomacy",
			"technology",
			"offices",
			"finance",
			"missions",
			"selection_change",
			"rituals",
			"mortuary_cult",
			"regiments_of_renown"
		};
		
		if should_disable then
			for i = 1, #overrides_to_disable do
				uim:override(overrides_to_disable[i]):lock();
			end;
		else
			for i = 1, #overrides_to_disable do
				uim:override(overrides_to_disable[i]):unlock();
			end;
		end;
	end;
	
	local function start_books_of_nagash_scripted_tour(completion_callback)
	
		out("%%%%% start_books_of_nagash_scripted_tour() called");
		
		common.set_advice_history_string_seen("books_of_nagash_panel_tour");
	
		local uic_books_of_nagash_button = find_uicomponent(core:get_ui_root(), "hud_campaign", "resources_bar", "right_spacer_tomb_kings", "button_books_of_nagash");
		if not uic_books_of_nagash_button then
			script_error("ERROR: start_books_of_nagash_scripted_tour() could not find the books of nagash button, how can this be?");
			completion_callback();
			return false;
		end;
		
		-- lock ui
		books_of_nagash_scripted_tour_disable_ui(true);
		
		-- show fullscreen highlight around the books of nagash button
		core:show_fullscreen_highlight_around_components(25, false, false, uic_books_of_nagash_button);
		
		-- pulse the button
		pulse_uicomponent(uic_books_of_nagash_button, true, 5);
		
		-- set up button text pointer
		local uic_button_size_x, uic_button_size_y = uic_books_of_nagash_button:Dimensions();
		local uic_button_pos_x, uic_button_pos_y = uic_books_of_nagash_button:Position();
		
		local tp_books_of_nagash_button = text_pointer:new("books_of_nagash_button", "top", 100, uic_button_pos_x + uic_button_size_x / 2, uic_button_pos_y + (uic_button_size_y / 2));
		tp_books_of_nagash_button:set_layout("text_pointer_text_only");
		tp_books_of_nagash_button:add_component_text("text", "ui_text_replacements_localised_text_dlc09_text_pointer_books_of_nagash_button");
		tp_books_of_nagash_button:set_style("semitransparent_highlight_dont_close");
		tp_books_of_nagash_button:set_panel_width(300);
		
		tp_books_of_nagash_button:set_close_button_callback(
			function()
				
				-- stop pulsing button
				pulse_uicomponent(uic_books_of_nagash_button, false, 5);
				
				cm:callback(
					function() 
						-- hide text pointer
						tp_books_of_nagash_button:hide();
					
						-- lift fullscreen highlight
						core:hide_fullscreen_highlight();

						-- establish listener for the books of nagash panel opening						
						core:add_listener(
							event_name,
							"PanelOpenedCampaign",
							function(context)
								return context.string == "books_of_nagash"
							end,
							function(context)
								out("%%%%% Books of Nagash panel opened");
							
								cm:remove_callback(event_name);
								
								local uic_panel = find_child_uicomponent(core:get_ui_root(), "books_of_nagash");
								if not uic_panel then
									script_error("ERROR: start_books_of_nagash_scripted_tour() could not find the books of nagash panel, how can this be?");
									books_of_nagash_scripted_tour_disable_ui(false);
									completion_callback();
									return false;
								end;
								
								-- wait for the panel to finish animating
								core:progress_on_uicomponent_animation(
									event_name, 
									uic_panel, 
									function()
									
										-- get a handle to the map on the panel
										local uic_map = find_uicomponent(uic_panel, "map");
										
										if not uic_map then
											script_error("WARNING: start_books_of_nagash_scripted_tour() could not find the map uicomponent on the books of nagash panel, how can this be?");
											books_of_nagash_scripted_tour_disable_ui(false);
											completion_callback();
											return false;
										end;
										
										-- show fullscreen highlight over the map
										core:show_fullscreen_highlight_around_components(25, false, false, uic_map);
										
										-- pulse each of the book icons
										pulse_uicomponent(uic_map, true, 5, true);
										
										-- set up text pointer
										local uic_map_size_x, uic_map_size_y = uic_map:Dimensions();
										local uic_map_pos_x, uic_map_pos_y = uic_map:Position();
										
										local tp_map = text_pointer:new("map", "right", 100, uic_map_pos_x + (uic_map_size_x / 4), uic_map_pos_y + (uic_map_size_y / 2));
										tp_map:set_layout("text_pointer_text_only");
										tp_map:add_component_text("text", "ui_text_replacements_localised_text_dlc09_text_pointer_books_of_nagash_panel_map");
										tp_map:set_style("semitransparent_highlight_dont_close");
										tp_map:set_panel_width(250);
										
										tp_map:set_close_button_callback(
											function()
												-- hide text pointer
												tp_map:hide();
												
												-- stop pulsing highlight of book icons
												pulse_uicomponent(uic_map, false, 5, true);
												
												-- lift fullscreen highlight
												core:hide_fullscreen_highlight();
												
												-- highlight panel close button
												local uic_close_button = find_uicomponent(core:get_ui_root(), "hud_campaign", "hud_center", "small_bar", "button_close_holder", "button_close");
												if not uic_close_button then
													script_error("WARNING: start_books_of_nagash_scripted_tour() could not find the books of nagash panel close button, how can this be?");
													books_of_nagash_scripted_tour_disable_ui(false);
													completion_callback();
													return false;
												end;
												
												cm:callback(
													function()
														
														if cm:get_campaign_ui_manager():is_panel_open("books_of_nagash") then
															-- highlight close button for clicking if the panel is still open
															-- uic_close_button:Highlight(true, false, 0);
															
															-- add listener to re-enable the ui once the panel is closed
															core:add_listener(
																event_name,
																"PanelClosedCampaign",
																function(context) return context.string == "books_of_nagash" end,
																function()
																	-- uic_close_button:Highlight(false, false, 0);
																	books_of_nagash_scripted_tour_disable_ui(false);
																end,
																false
															);
														else
															-- re-enable the ui immediately, as the panel is already closed
															books_of_nagash_scripted_tour_disable_ui(false);
														end;														
														
														-- complete intervention (the panel being open will prevent it from progressing immediately)
														completion_callback();
													end,
													0.5
												);
											end
										);
										
										cm:callback(
											function()
												tp_map:show();
											end,
											0.5
										);
									end
								);
							end,
							false
						);
						
						-- failsafe: panel hasn't opened for some reason, exit
						cm:callback(
							function()
								script_error("WARNING: start_books_of_nagash_scripted_tour() attempted to open the Books of Nagash panel but it didn't open, exiting");
								core:remove_listener(event_name);
								books_of_nagash_scripted_tour_disable_ui(false);
								completion_callback();
								return false;
							end,
							0.5,
							event_name
						);						
						
						-- simulate click on books of nagash button to open the books of nagash panel
						uic_books_of_nagash_button:SimulateLClick();
					end, 
					0.5
				);
			end
		);
		
		tp_books_of_nagash_button:show();
	end;
	
	
	-- pre-declare the intervention variable, so that it exists as a local for the subsequent function
	local in_eg_books_of_nagash_mission = false;
	
	-- intervention trigger function
	local function in_eg_books_of_nagash_mission_trigger()
		out.design("[EG] start_early_game_books_of_nagash_mission_listener() is triggering mission, advice level is " .. core:get_advice_level());
		out.design("\tjust issuing mission");
		set_early_game_event_experienced(event_name, true);
		mm:trigger(
			function()
				local function completion_callback()
					core:trigger_event("ScriptEventBooksOfNagashMissionIssued");
					in_eg_books_of_nagash_mission:complete();
				end;
			
				-- play books of nagash scripted tour if it's not been seen already
				if core:is_tweaker_set("SKIP_SCRIPTED_CONTENT_6") or not common.get_advice_history_string_seen("books_of_nagash_panel_tour") then
					start_books_of_nagash_scripted_tour(completion_callback);
				else
					completion_callback();
				end;
			end
		);
		
	end;
	
	
	-- set up intervention	
	in_eg_books_of_nagash_mission = intervention:new(
		"eg_books_of_nagash_mission", 												-- string name
		0,	 																		-- cost
		function() in_eg_books_of_nagash_mission_trigger() end,						-- trigger callback
		BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
	);
	
	in_eg_books_of_nagash_mission:add_precondition(
		function()
			return not get_early_game_event_experienced(event_name, true);
		end
	);
		
	-- trigger after how-they-play event is received
	in_eg_books_of_nagash_mission:add_trigger_condition(
		"ScriptEventHowTheyPlayEventDismissed",
		true
	);
		
	in_eg_books_of_nagash_mission:start();
end;


-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	establish pirate cove mission
--
--	triggers after capture province mission completed
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

function start_early_game_cst_pirate_cove_mission_listener(advice_key, infotext, mission_key, mission_issuer, buildings, mission_rewards)

	if not is_string(advice_key) then
		script_error("ERROR: start_early_game_cst_pirate_cove_mission_listener() called but supplied advice key [" .. tostring(advice_key) .. "] is not a string");
		return false;
	end;
	
	-- default infotext value
	if not infotext then
		infotext = {
			"wh2.camp.eg.technology_buildings.info_001",		-- create default infotext
			"wh2.camp.eg.technology_buildings.info_002",
			"wh2.camp.eg.technology_buildings.info_003"
		};
	end;
	
	if not is_table(infotext) then
		script_error("ERROR: start_early_game_cst_pirate_cove_mission_listener() called but supplied infotext [" .. tostring(infotext) .. "] is not a table or nil");
		return false;
	end;
	
	if not is_string(mission_key) then
		script_error("ERROR: start_early_game_cst_pirate_cove_mission_listener() called but supplied mission key [" .. tostring(mission_key) .. "] is not a string");
		return false;
	end;
	
	if mission_issuer and not is_string(mission_issuer) then
		script_error("ERROR: start_early_game_cst_pirate_cove_mission_listener() called but supplied mission key [" .. tostring(mission_issuer) .. "] is not a string or nil");
		return false;
	end;
	
	for i = 1, #mission_rewards do
		if not is_string(mission_rewards[i]) then
			script_error("ERROR: start_early_game_cst_pirate_cove_mission_listener() called but supplied mission reward [" .. i .. "] is [" .. tostring(mission_rewards[i]) .. "] and not a string");
			return false;
		end;
	end;
	
	if #buildings == 0 then
		script_error("ERROR: start_early_game_cst_pirate_cove_mission_listener() called but no building keys supplied");
		return false;
	end;	
	
	for i = 1, #buildings do
		if not is_string(buildings[i]) then
			script_error("ERROR: start_early_game_cst_pirate_cove_mission_listener() called but item [" .. i .. "] in supplied building key list [" .. tostring(buildings[i]) .. "] is not a string");
			return false;
		end;
	end;
	
	if not mission_rewards then
		mission_rewards = {"money 1000"};
	end;
	
	if not is_table(mission_rewards) then
		script_error("ERROR: start_early_game_cst_pirate_cove_mission_listener() called but supplied mission rewards [" .. mission_rewards .. "] is not a table");
		return false;
	end;
	
	if #mission_rewards == 0 then
		script_error("ERROR: start_early_game_cst_pirate_cove_mission_listener() called but supplied mission rewards table is empty");
		return false;
	end;
	
	local local_faction = cm:get_local_faction_name();
	local event_name = "early_game_construct_pirate_cove_mission_issued";
	
	-- affects how prominently this advice will be delivered based on advice level/history
	-- possible values:
	-- EARLY_GAME_ADVICE_VOICED_BY_LEGENDARY_LORD		| advice voiced by LL, relax criteria for showing it
	-- EARLY_GAME_ADVICE_SPECIFIC_TO_FACTION			| advice voiced by advisor, string is different for different factions
	-- EARLY_GAME_ADVICE_SHARED							| advice voiced by advisor, but string is shared between factions
	local advice_mode = EARLY_GAME_ADVICE_SPECIFIC_TO_FACTION;
	
	-- set up mission
	local mm = mission_manager:new(
		local_faction, 
		mission_key
	);
	
	mm:add_new_objective("CONSTRUCT_N_BUILDINGS_FROM");
	mm:add_condition("faction " .. local_faction);
	mm:add_condition("total 1");
	
	if mission_issuer then
		mm:set_mission_issuer(mission_issuer);
	end;
	
	for i = 1, #buildings do
		mm:add_condition("building_level " .. buildings[i]);
	end;
	for i = 1, #mission_rewards do
		mm:add_payload(mission_rewards[i]);
	end
	
	-- pre-declare the intervention variable, so that it exists as a local for the subsequent function
	local in_eg_construct_pirate_cove_mission = false;
	
	-- intervention trigger function
	local function in_eg_construct_pirate_cove_mission_trigger()
		out.design("[EG] start_early_game_cst_pirate_cove_mission_listener() is triggering mission, advice level is " .. core:get_advice_level());
		
		local delivery_mode, delivery_mode_str = early_game_decide_content_delivery_mode(advice_mode, advice_key);
		out.design("\t" .. delivery_mode_str);
		
		-- override delivery_mode to only show the mission for now
		delivery_mode = EARLY_GAME_SHOW_MISSION_ONLY;
		
		if delivery_mode == EARLY_GAME_SHOW_MISSION_ONLY then
			out.design("\tjust issuing mission");
			
			set_early_game_event_experienced(event_name, true);
			--mm:trigger(function() in_eg_construct_pirate_cove_mission:complete() end);
			mm:trigger();
			cm:callback(function() in_eg_construct_pirate_cove_mission:complete() end, 1)
		else
			if not early_game_should_show_infotext(advice_mode, advice_key, event_name) then
				out.design("\tnot showing infotext");
				infotext = {};
			end;
			
			out.design("\tplaying advice with mission");
		
			set_early_game_event_experienced(event_name);
			in_eg_construct_pirate_cove_mission:play_advice_for_intervention(
				advice_key,
				infotext,
				mm
			);
		end;
	end;
	
	-- set up intervention	
	in_eg_construct_pirate_cove_mission = intervention:new(
		"eg_construct_pirate_cove_mission", 									-- string name
		60,	 																	-- cost
		function() in_eg_construct_pirate_cove_mission_trigger() end,			-- trigger callback
		BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
	);
	
	in_eg_construct_pirate_cove_mission:set_must_trigger(true);
	
	in_eg_construct_pirate_cove_mission:add_precondition(
		function()
			return not get_early_game_event_experienced(event_name, true);
		end
	);
	
	-- if we have a settlement override list then don't listen for the completion of the settlement upgraded mission, but listen for the player starting a turn
	-- with any one of those buildings completed
	if building_override_list then
		in_eg_construct_pirate_cove_mission:add_trigger_condition(
			"ScriptEventPlayerFactionTurnStart",
			function(context)
				local faction = cm:get_faction(local_faction);
				for i = 1, #building_override_list do
					local current_building = building_override_list[i];
					if cm:faction_contains_building(faction, current_building) then
						out.design("[EG] start_early_game_cst_pirate_cove_mission_listener() is triggering as player faction has building with key " .. current_building);
						return true;
					end;
				end;
				return false;
			end
		);	
	else
		-- trigger once the player has captured first province
		in_eg_construct_pirate_cove_mission:add_trigger_condition(
			"ScriptEventPlayerCompletesProvince",
			true
		);
	end;
	
	in_eg_construct_pirate_cove_mission:start();
end;

-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	growth mission - ships building
--
--	this is a mission for the player to upgrade their ships captain quarters 
--	this triggers once the player receives their first growth point for their LL 
--	with the supplied building, informs the player about growth points, and tasks 
--	them to upgrade their ships buildings further
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

function start_early_game_cst_growth_point_ship_mission_listener(advice_key, infotext, mission_key, mission_issuer, faction_key, upgrade_building_keys, mission_rewards)

	if not is_string(advice_key) then
		script_error("ERROR: start_early_game_cst_ship_growth_point_mission_listener() called but supplied advice key [" .. tostring(advice_key) .. "] is not a string");
		return false;
	end;
	
	-- default infotext value
	if not infotext then
		infotext = {
			"wh2.camp.advice.growth.info_001",					-- create default infotext
			"wh2.camp.advice.growth.info_002",
			"wh2.camp.advice.growth.info_003",
			"wh2.camp.advice.growth.info_004",
			"wh2.camp.advice.growth.info_005"
		};
	end;
	
	if not is_table(infotext) then
		script_error("ERROR: start_early_game_cst_ship_growth_point_mission_listener() called but supplied infotext [" .. tostring(infotext) .. "] is not a table or nil");
		return false;
	end;
	
	if not is_string(mission_key) then
		script_error("ERROR: start_early_game_cst_ship_growth_point_mission_listener() called but supplied mission key [" .. tostring(mission_key) .. "] is not a string");
		return false;
	end;
	
	if mission_issuer and not is_string(mission_issuer) then
		script_error("ERROR: start_early_game_cst_ship_growth_point_mission_listener() called but supplied mission issuer [" .. tostring(mission_issuer) .. "] is not a string or nil");
		return false;
	end;
	
	if not cm:get_faction(faction_key) then
		script_error("ERROR: start_early_game_cst_ship_growth_point_mission_listener() called but no faction with supplied key [" .. faction_key .. "] could be found");
		return false;
	end;	
	
	-- if only a single upgrade_building_key was passed in, convert it to a table with one string entry
	if is_string(upgrade_building_keys) then
		upgrade_building_keys = {upgrade_building_keys};
	end;
	
	if not is_table(upgrade_building_keys) then	
		script_error("ERROR: start_early_game_cst_ship_growth_point_mission_listener() called but supplied upgrade building key list [" .. tostring(upgrade_building_keys) .. "] is not a table (or a single string)");
		return false;
	end;
	
	if #upgrade_building_keys == 0 then
		script_error("ERROR: start_early_game_cst_ship_growth_point_mission_listener() called but supplied upgrade building key list is empty");
		return false;
	end;
	
	for i = 1, #upgrade_building_keys do
		if not is_string(upgrade_building_keys[i]) then
			script_error("ERROR: start_early_game_cst_ship_growth_point_mission_listener() called but entry [" .. i .. "] in supplied upgrade building key list is not a string, its value is [" .. tostring(upgrade_building_keys[i]) .. "]");
			return false;
		end;
	end;
	
	if not mission_rewards then
		mission_rewards = {"money 1000"};
	end;
	
	if not is_table(mission_rewards) then
		script_error("ERROR: start_early_game_cst_ship_growth_point_mission_listener() called but supplied mission rewards [" .. mission_rewards .. "] is not a table");
		return false;
	end;
	
	if #mission_rewards == 0 then
		script_error("ERROR: start_early_game_cst_ship_growth_point_mission_listener() called but supplied mission rewards table is empty");
		return false;
	end;
	
	for i = 1, #mission_rewards do
		if not is_string(mission_rewards[i]) then
			script_error("ERROR: start_early_game_cst_ship_growth_point_mission_listener() called but supplied mission reward [" .. i .. "] is [" .. tostring(mission_rewards[i]) .. "] and not a string");
			return false;
		end;
	end;
	
	-- affects how prominently this advice will be delivered based on advice level/history
	-- possible values:
	-- EARLY_GAME_ADVICE_VOICED_BY_LEGENDARY_LORD		| advice voiced by LL, relax criteria for showing it
	-- EARLY_GAME_ADVICE_SPECIFIC_TO_FACTION			| advice voiced by advisor, string is different for different factions
	-- EARLY_GAME_ADVICE_SHARED							| advice voiced by advisor, but string is shared between factions
	local advice_mode = EARLY_GAME_ADVICE_SHARED;
	
	-- set up mission
	local mm = mission_manager:new(
		faction_key, 
		mission_key,
		function() core:trigger_event("ScriptEventGrowthPointMissionSucceeded"); end
	);
	
	mm:add_new_objective("CONSTRUCT_N_BUILDINGS_FROM");
	
	for i = 1, #upgrade_building_keys do
		mm:add_condition("building_level " .. upgrade_building_keys[i]);
	end;
	mm:add_condition("total 1");
	mm:add_condition("faction " .. faction_key);
	
	if mission_issuer then
		mm:set_mission_issuer(mission_issuer);
	end;
	
	for i = 1, #mission_rewards do
		mm:add_payload(mission_rewards[i]);
	end
	
	local event_name = "early_game_growth_point_ship_mission_issued";
	
	-- pre-declare the intervention variable, so that it exists as a local for the subsequent function
	local in_eg_growth_point_ship_mission = false;
	
	-- intervention trigger function
	local function in_eg_growth_point_ship_mission_trigger()
		out.design("[EG] start_early_game_cst_ship_growth_point_mission_listener() is triggering mission, advice level is " .. core:get_advice_level());
		
		local delivery_mode, delivery_mode_str = early_game_decide_content_delivery_mode(advice_mode, advice_key);
		
		out.design("\t" .. delivery_mode_str);
		
		-- override delivery_mode to only show the mission for now
		delivery_mode = EARLY_GAME_SHOW_MISSION_ONLY;
		
		if delivery_mode == EARLY_GAME_SHOW_MISSION_ONLY then
			out.design("\tjust issuing mission");
			
			set_early_game_event_experienced(event_name, true);
			--mm:trigger(function() in_eg_growth_point_ship_mission:complete() end);
			mm:trigger();
			cm:callback(function() in_eg_growth_point_ship_mission:complete() end, 1);
		else
			if not early_game_should_show_infotext(advice_mode, advice_key, event_name) then
				out.design("\tnot showing infotext");
				infotext = {};
			end;
			
			out.design("\tplaying advice with mission");
			in_eg_growth_point_ship_mission:play_advice_for_intervention(
				advice_key,
				infotext,
				mm
			);
			
		end;
	end;
	
	
	
	-- set up intervention	
	in_eg_growth_point_ship_mission = intervention:new(
		"eg_growth_point_ship_mission", 												-- string name
		60,	 																			-- cost
		function() in_eg_growth_point_ship_mission_trigger() end,						-- trigger callback
		BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
	);
	
	in_eg_growth_point_ship_mission:set_must_trigger(true);
	
	in_eg_growth_point_ship_mission:add_precondition(
		function()
			return not get_early_game_event_experienced(event_name, true)
		end
	);
	
	in_eg_growth_point_ship_mission:add_trigger_condition(
		"MilitaryForceDevelopmentPointChange",
		function(context)
			local lord_faction = context:military_force():faction():name();
			if lord_faction == faction_key and (cm:turn_number() >= 2)  then
				return true;
			end;
			
			return false;
		end
	);
	
	in_eg_growth_point_ship_mission:start();
end;


-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Vampire Coast Loyalty mission
--
--	Triggers after the Raise Army Mission Completed
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

function start_early_game_cst_loyalty_mission_listener(advice_key, infotext, mission_key, mission_issuer, faction_key, mission_rewards)

	if not is_string(advice_key) then
		script_error("ERROR: start_early_game_cst_loyalty_mission_listener() called but supplied advice key [" .. tostring(advice_key) .. "] is not a string");
		return false;
	end;
	
	-- default infotext value
	if not infotext then
		infotext = {
			"wh2.camp.advice.growth.info_001",					-- create default infotext
			"wh2.camp.advice.growth.info_002",
			"wh2.camp.advice.growth.info_003",
			"wh2.camp.advice.growth.info_004",
			"wh2.camp.advice.growth.info_005"
		};
	end;
	
	if not is_table(infotext) then
		script_error("ERROR: start_early_game_cst_loyalty_mission_listener() called but supplied infotext [" .. tostring(infotext) .. "] is not a table or nil");
		return false;
	end;
	
	if not is_string(mission_key) then
		script_error("ERROR: start_early_game_cst_loyalty_mission_listener() called but supplied mission key [" .. tostring(mission_key) .. "] is not a string");
		return false;
	end;
	
	if mission_issuer and not is_string(mission_issuer) then
		script_error("ERROR: start_early_game_cst_loyalty_mission_listener() called but supplied mission issuer [" .. tostring(mission_issuer) .. "] is not a string or nil");
		return false;
	end;

	if not mission_rewards then
		mission_rewards = {"money 1000"};
	end;
	
	if not is_table(mission_rewards) then
		script_error("ERROR: start_early_game_cst_loyalty_mission_listener() called but supplied mission rewards [" .. mission_rewards .. "] is not a table");
		return false;
	end;
	
	if #mission_rewards == 0 then
		script_error("ERROR: start_early_game_cst_loyalty_mission_listener() called but supplied mission rewards table is empty");
		return false;
	end;
	
	for i = 1, #mission_rewards do
		if not is_string(mission_rewards[i]) then
			script_error("ERROR: start_early_game_cst_loyalty_mission_listener() called but supplied mission reward [" .. i .. "] is [" .. tostring(mission_rewards[i]) .. "] and not a string");
			return false;
		end;
	end;
	
	

	-- affects how prominently this advice will be delivered based on advice level/history
	-- possible values:
	-- EARLY_GAME_ADVICE_VOICED_BY_LEGENDARY_LORD		| advice voiced by LL, relax criteria for showing it
	-- EARLY_GAME_ADVICE_SPECIFIC_TO_FACTION			| advice voiced by advisor, string is different for different factions
	-- EARLY_GAME_ADVICE_SHARED							| advice voiced by advisor, but string is shared between factions
	local advice_mode = EARLY_GAME_ADVICE_SHARED;
	
	-- set up mission
	local mm = mission_manager:new(
		faction_key, 
		mission_key
	);
	
	mm:add_new_scripted_objective(
		"mission_text_text_mis_raise_loyalty_objective", 
		"ScriptEventHumanFactionTurnStart",
		function()
			local character_list = cm:get_faction(faction_key):character_list();
			for i = 0, character_list:num_items() - 1 do
				local character = character_list:item_at(i);
				if not character:is_faction_leader() then
					if character:has_military_force() and cm:char_is_general_with_army(character) and not character:military_force():is_armed_citizenry() and character:loyalty() > 7 then
						return true;
					end;
				end;
			end;
			return false;
		end
	);
	

	if mission_issuer then
		mm:set_mission_issuer(mission_issuer);
	end;
	
	for i = 1, #mission_rewards do
		mm:add_payload(mission_rewards[i]);
	end
	
	local event_name = "early_game_cst_loyalty_mission_issued";
	
	-- pre-declare the intervention variable, so that it exists as a local for the subsequent function
	local in_eg_cst_loyalty_mission = false;
	
	-- intervention trigger function
	local function in_eg_cst_loyalty_mission_trigger()
		out.design("[EG] start_early_game_cst_loyalty_mission_listener() is triggering mission, advice level is " .. core:get_advice_level());
		
		local delivery_mode, delivery_mode_str = early_game_decide_content_delivery_mode(advice_mode, advice_key);
		out.design("\t" .. delivery_mode_str);
		
		-- override delivery_mode to only show the mission for now
		delivery_mode = EARLY_GAME_SHOW_MISSION_ONLY;
		
		if delivery_mode == EARLY_GAME_SHOW_MISSION_ONLY then
			out.design("\tjust issuing mission");
			
			set_early_game_event_experienced(event_name, true);
			--mm:trigger(function() in_eg_cst_loyalty_mission:complete() end);
			mm:trigger();
			cm:callback(function() in_eg_cst_loyalty_mission:complete() end, 1);
		else
			if not early_game_should_show_infotext(advice_mode, advice_key, event_name) then
				out.design("\tnot showing infotext");
				infotext = {};
			end;
			
			out.design("\tplaying advice with mission");
			in_eg_cst_loyalty_mission:play_advice_for_intervention(
				advice_key,
				infotext,
				mm
			);
			
		end;
	end;
	
	-- set up intervention	
	in_eg_cst_loyalty_mission = intervention:new(
		"eg_cst_loyalty_mission", 												-- string name
		60,	 																			-- cost
		function() in_eg_cst_loyalty_mission_trigger() end,						-- trigger callback
		BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
	);
	
	in_eg_cst_loyalty_mission:set_must_trigger(true);
	
	in_eg_cst_loyalty_mission:add_precondition(
		function()
			return not get_early_game_event_experienced(event_name, true)
		end
	);
	
	in_eg_cst_loyalty_mission:add_trigger_condition(
		"ScriptEventPlayerCompletesRaiseArmy",
		true		
	);
	
	in_eg_cst_loyalty_mission:start();
end;

-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Vampire Coast treasure hunting mission
--
--	Triggers after capture settlement mission issued
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

function start_early_game_cst_treasure_hunting_mission_listener(advice_key, infotext, mission_key)

	if not is_string(advice_key) then
		script_error("ERROR: start_early_game_cst_treasure_hunting_mission_listener() called but supplied advice key [" .. tostring(advice_key) .. "] is not a string");
		return false;
	end;
	
	-- default infotext value
	if not infotext then
		infotext = {
			"dlc11.camp.advice.treasure_maps.info_001",
			"dlc11.camp.advice.treasure_maps.info_002",
			"dlc11.camp.advice.treasure_maps.info_005",
			"dlc11.camp.advice.treasure_maps.info_006"
		};
	end;
	
	if not is_table(infotext) then
		script_error("ERROR: start_early_game_cst_treasure_hunting_mission_listener() called but supplied infotext [" .. tostring(infotext) .. "] is not a table or nil");
		return false;
	end;
	
	if not is_string(mission_key) then
		script_error("ERROR: start_early_game_cst_treasure_hunting_mission_listener() called but supplied mission key [" .. tostring(mission_key) .. "] is not a string");
		return false;
	end;
	
	

	-- affects how prominently this advice will be delivered based on advice level/history
	-- possible values:
	-- EARLY_GAME_ADVICE_VOICED_BY_LEGENDARY_LORD		| advice voiced by LL, relax criteria for showing it
	-- EARLY_GAME_ADVICE_SPECIFIC_TO_FACTION			| advice voiced by advisor, string is different for different factions
	-- EARLY_GAME_ADVICE_SHARED							| advice voiced by advisor, but string is shared between factions
	local advice_mode = EARLY_GAME_ADVICE_SHARED;
	
	local local_faction = cm:get_local_faction_name();
	
	-- set up mission
	local mm = mission_manager:new(
		local_faction, 
		mission_key
	);
	
	-- the options for this mission are set up in the database
	mm:set_is_mission_in_db();
	
	local event_name = "early_game_cst_treasure_hunting_mission_issued";
	
	-- pre-declare the intervention variable, so that it exists as a local for the subsequent function
	local in_eg_cst_treasure_hunting_mission = false;
	
	-- intervention trigger function
	local function in_eg_cst_treasure_hunting_mission_trigger()
		out.design("[EG] start_early_game_cst_treasure_hunting_mission_listener() is triggering mission, advice level is " .. core:get_advice_level());
				
		local delivery_mode, delivery_mode_str = early_game_decide_content_delivery_mode(advice_mode, advice_key);
		out.design("\t" .. delivery_mode_str);
		
		if delivery_mode == EARLY_GAME_SHOW_MISSION_ONLY then
			out.design("\tjust issuing mission");
			
			set_early_game_event_experienced(event_name, true);
			--mm:trigger(function() in_eg_cst_treasure_hunting_mission:complete() end);
			mm:trigger();
			cm:callback(function() in_eg_cst_treasure_hunting_mission:complete() end, 1);
		else
			if not early_game_should_show_infotext(advice_mode, advice_key, event_name) then
				out.design("\tnot showing infotext");
				infotext = {};
			end;
			
			out.design("\tplaying advice with mission");
			in_eg_cst_treasure_hunting_mission:play_advice_for_intervention(
				advice_key,
				infotext,
				mm
			);
			
		end;
		
		core:trigger_event("ScriptEventEGTreasureHuntingMissionIssued");
	end;
	
	-- set up intervention	
	in_eg_cst_treasure_hunting_mission = intervention:new(
		"eg_cst_treasure_hunting_mission", 												-- string name
		60,	 																			-- cost
		function() in_eg_cst_treasure_hunting_mission_trigger() end,					-- trigger callback
		BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
	);
	
	in_eg_cst_treasure_hunting_mission:set_must_trigger(true);
	
	in_eg_cst_treasure_hunting_mission:add_precondition(
		function()
			return not get_early_game_event_experienced(event_name, true)
		end
	);
	
	in_eg_cst_treasure_hunting_mission:add_trigger_condition(
		"ScriptEventEGCaptureEnemySettlementMissionIssued",
		true
	);
	
	in_eg_cst_treasure_hunting_mission:start();
end;

---------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Vampire Coast main chain mission
--
--	Triggers after capture settlement mission issued
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

function start_early_game_cst_search_for_the_vengeance_mission_listener(advice_key, infotext, mission_key, target_faction_key, target_region_key)

	if not is_string(advice_key) then
		script_error("ERROR: start_early_game_cst_search_for_the_vengeance_mission_listener() called but supplied advice key [" .. tostring(advice_key) .. "] is not a string");
		return false;
	end;
	
	-- default infotext value
	if not infotext then		
		infotext = {};
	end;
	
	if not is_table(infotext) then
		script_error("ERROR: start_early_game_cst_search_for_the_vengeance_mission_listener() called but supplied infotext [" .. tostring(infotext) .. "] is not a table or nil");
		return false;
	end;
	
	if not is_string(mission_key) then
		script_error("ERROR: start_early_game_cst_search_for_the_vengeance_mission_listener() called but supplied mission key [" .. tostring(mission_key) .. "] is not a string");
		return false;
	end;

	if not is_string(target_faction_key) then
		script_error("ERROR: start_early_game_cst_search_for_the_vengeance_mission_listener() called but supplied target faction key [" .. tostring(target_faction_key) .. "] is not a string");
		return false;
	end;
	
	if target_region_key and not is_string(target_region_key) then
		script_error("ERROR: start_early_game_cst_search_for_the_vengeance_mission_listener() called but supplied target region key [" .. tostring(target_region_key) .. "] is not a string or nil");
		return false;
	end;
	
	-- affects how prominently this advice will be delivered based on advice level/history
	-- possible values:
	-- EARLY_GAME_ADVICE_VOICED_BY_LEGENDARY_LORD		| advice voiced by LL, relax criteria for showing it
	-- EARLY_GAME_ADVICE_SPECIFIC_TO_FACTION			| advice voiced by advisor, string is different for different factions
	-- EARLY_GAME_ADVICE_SHARED							| advice voiced by advisor, but string is shared between factions
	local advice_mode = EARLY_GAME_ADVICE_SHARED;
	
	local local_faction = cm:get_local_faction_name();
	
	-- set up mission
	local mm = mission_manager:new(
		local_faction, 
		mission_key
	);
	
	mm:set_mission_issuer("CLAN_ELDERS");
	mm:add_new_objective("ENGAGE_FORCE");
	mm:add_condition("requires_victory");
	mm:add_payload("effect_bundle{bundle_key wh2_dlc11_bundle_harpoon;turns 0;}");
	mm:add_payload("money 7000");
	
	local event_name = "early_game_cst_search_for_the_vengeance_mission_issued";
	
	-- pre-declare the intervention variable, so that it exists as a local for the subsequent function
	local in_eg_cst_search_for_the_vengeance_mission = false;
	
	-- intervention trigger function
	local function in_eg_cst_search_for_the_vengeance_mission_trigger()
		out.design("[EG] start_early_game_cst_treasure_hunting_mission_listener() is triggering mission, advice level is " .. core:get_advice_level());
		
		-- determine the target army here
		local target_faction_leader = cm:get_faction(target_faction_key):faction_leader()

		-- add their force cqi to the mission spec
		mm:add_condition("cqi ".. target_faction_leader:military_force():command_queue_index());
		
		local delivery_mode, delivery_mode_str = early_game_decide_content_delivery_mode(advice_mode, advice_key);
		
		
		local delivery_mode = EARLY_GAME_SCROLL_CAMERA_WITH_ADVICE_AND_MISSION;
		
		if core:is_advice_level_minimal() then
			delivery_mode = EARLY_GAME_SHOW_MISSION_ONLY;
		end;
		
		if delivery_mode == EARLY_GAME_SHOW_MISSION_ONLY then
			out.design("\tjust issuing mission");
			
			set_early_game_event_experienced(event_name, true);
			mm:trigger(
				function() 
					core:trigger_event("ScriptEventEGSearchForTheVengeanceCameraScrollComplete");
					in_eg_cst_search_for_the_vengeance_mission:complete() 
				end
			);
		
		else
			if not early_game_should_show_infotext(advice_mode, advice_key, event_name) then
				out.design("\tnot showing infotext");
				infotext = {};
			end;
			
			out.design("\tplaying advice with mission");

			cm:callback(
				function()
					if target_region_key then
						cm:make_region_visible_in_shroud(local_faction, target_region_key);
					end;

					in_eg_cst_search_for_the_vengeance_mission:scroll_camera_to_character_for_intervention(
						target_faction_leader:cqi(),
						advice_key,
						infotext,
						mm,
						nil,
						function()
							cm:cache_camera_position("in_eg_cst_search_for_the_vengeance_mission");
							core:trigger_event("ScriptEventEGSearchForTheVengeanceCameraScrollComplete");
						end,
						function(intervention)
							cm:progress_on_events_dismissed(
								"early_game_cst_treasure_hunting_mission_listener",
								function()
									-- if the camera has moved from when it was last cached then the player has moved it - it would be rude to scroll it again, so just release
									if cm:camera_has_moved_from_cached("in_eg_cst_search_for_the_vengeance_mission") then
										intervention:complete();
									else
										-- scroll camera back to faction leader
										local faction_leader = cm:get_faction(local_faction):faction_leader();
										
										local x, y, d, b, h = cm:get_camera_position();
										
										cm:scroll_camera_with_cutscene(
											2,
											function() intervention:complete() end,
											{faction_leader:display_position_x(), faction_leader:display_position_y(), d, b, h}
										);
									end;
								end,
								0.2
							);
						end
					);
				end,
				0.2
			);
		end;

		core:trigger_event("ScriptEventEGSearchForTheVengeanceMissionIssued");
	end;
	
	-- set up intervention	
	in_eg_cst_search_for_the_vengeance_mission = intervention:new(
		"eg_cst_search_for_the_vengeance_mission", 										-- string name
		60,	 																			-- cost
		function() in_eg_cst_search_for_the_vengeance_mission_trigger() end,			-- trigger callback
		BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
	);
	
	in_eg_cst_search_for_the_vengeance_mission:set_must_trigger(true);
	
	in_eg_cst_search_for_the_vengeance_mission:add_precondition(
		function()
			return not get_early_game_event_experienced(event_name, true)
		end
	);
	
	in_eg_cst_search_for_the_vengeance_mission:add_trigger_condition(
		"ScriptEventEGTreasureHuntingMissionIssued",
		true
	);
	
	in_eg_cst_search_for_the_vengeance_mission:start();
end;

-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Markus Wulfhart Recruit Hunter mission
--
--	Triggers after turn 5
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

function start_early_game_recruit_hunter_mission_listener(advice_key, infotext, mission_key, turn, mission_issuer, mission_rewards)
	
	if not is_string(advice_key) then
		script_error("ERROR: start_early_game_recruit_hunter_mission_listener() called but supplied advice key [" .. tostring(advice_key) .. "] is not a string");
		return false;
	end;
	
	-- default infotext value
	if not infotext then		
		infotext = {};
	end;
	
	if not is_table(infotext) then
		script_error("ERROR: start_early_game_recruit_hunter_mission_listener() called but supplied infotext [" .. tostring(infotext) .. "] is not a table or nil");
		return false;
	end;
	
	if not is_string(mission_key) then
		script_error("ERROR: start_early_game_recruit_hunter_mission_listener() called but supplied mission key [" .. tostring(mission_key) .. "] is not a string");
		return false;
	end;
	
	if not is_number(turn) then
		script_error("ERROR: start_early_game_recruit_hunter_mission_listener() called but supplied turn_number [" .. tostring(turn) .. "] is not a number or nil");
		return false;
	end;
	
	if mission_issuer and not is_string(mission_issuer) then
		script_error("ERROR: start_early_game_recruit_hunter_mission_listener() called but supplied mission issuer [" .. tostring(mission_issuer) .. "] is not a string or nil");
		return false;
	end;
	
	if not mission_rewards then
		mission_rewards = {"money 1000"};
	end;
	
	if not is_table(mission_rewards) then
		script_error("ERROR: start_early_game_recruit_hunter_mission_listener() called but supplied mission rewards [" .. mission_rewards .. "] is not a table");
		return false;
	end;
	
	if #mission_rewards == 0 then
		script_error("ERROR: start_early_game_recruit_hunter_mission_listener() called but supplied mission rewards table is empty");
		return false;
	end;
	
	for i = 1, #mission_rewards do
		if not is_string(mission_rewards[i]) then
			script_error("ERROR: start_early_game_recruit_hunter_mission_listener() called but supplied mission reward [" .. i .. "] is [" .. tostring(mission_rewards[i]) .. "] and not a string");
			return false;
		end;
	end;
	
		
	-- affects how prominently this advice will be delivered based on advice level/history
	-- possible values:
	-- EARLY_GAME_ADVICE_VOICED_BY_LEGENDARY_LORD		| advice voiced by LL, relax criteria for showing it
	-- EARLY_GAME_ADVICE_SPECIFIC_TO_FACTION			| advice voiced by advisor, string is different for different factions
	-- EARLY_GAME_ADVICE_SHARED							| advice voiced by advisor, but string is shared between factions
	local advice_mode = EARLY_GAME_ADVICE_VOICED_BY_LEGENDARY_LORD;
	
	-- set up mission
	local mm = mission_manager:new(
		cm:get_local_faction_name(), 
		mission_key,
		function() core:trigger_event("ScriptEventEGRecruitHunterMissionSucceeded") end 			-- success
	);
		
	mm:add_new_scripted_objective(
		"mission_text_text_mis_recruit_hunter_objective", 
		"HunterUnlocked",
		true
	);
	
	if mission_issuer then
		mm:set_mission_issuer(mission_issuer);
	end;
	
	-- mm:add_condition("region " .. region_key);			-- don't specify a target region, so the mission succeeds no matter which ruins are searched
	for i = 1, #mission_rewards do
		mm:add_payload(mission_rewards[i]);
	end
	
	local event_name = "early_game_recruit_hunter_mission_issued";
	
	-- pre-declare the intervention variable, so that it exists as a local for the subsequent function
	local in_eg_recruit_hunter_mission = false;
	
	-- intervention trigger function
	local function in_eg_recruit_hunter_mission_trigger()
		out.design("[EG] start_early_game_recruit_hunter_mission_listener() is triggering mission, advice level is " .. core:get_advice_level());
		
		local delivery_mode, delivery_mode_str = early_game_decide_content_delivery_mode(advice_mode, advice_key);
		
		out.design("\t" .. delivery_mode_str);
		
		-- override delivery_mode to only show the mission for now
		delivery_mode = EARLY_GAME_SHOW_MISSION_ONLY;
		
		if delivery_mode == EARLY_GAME_SHOW_MISSION_ONLY then
			out.design("\tjust issuing mission");
			
			set_early_game_event_experienced(event_name, true);
			--mm:trigger(function() in_eg_recruit_hunter_mission:complete() end);
			mm:trigger();
			cm:callback(function() in_eg_recruit_hunter_mission:complete() end, 1);
		else
			if not early_game_should_show_infotext(advice_mode, advice_key, event_name) then
				out.design("\tnot showing infotext");
				infotext = {};
			end;
			
			out.design("\tplaying advice with mission");
			in_eg_recruit_hunter_mission:play_advice_for_intervention(
				advice_key,
				infotext,
				mm
			);
			
		end;
	end;
	
	-- set up intervention	
	in_eg_recruit_hunter_mission = intervention:new(
		"eg_recruit_hunter_mission", 										-- string name
		70,	 																	-- cost
		function() in_eg_recruit_hunter_mission_trigger() end,					-- trigger callback
		BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
	);
	
	in_eg_recruit_hunter_mission:set_must_trigger(true);
	
	in_eg_recruit_hunter_mission:add_precondition(
		function()
			return not get_early_game_event_experienced(event_name, true);
		end
	);
		
	-- trigger at the start of the specified turn if it's not been triggered already
	in_eg_recruit_hunter_mission:add_trigger_condition(
		"ScriptEventPlayerFactionTurnStart",
		function()
			if cm:turn_number() >= turn	then
				return true;
			end
			return false;
		end
	);
	
	in_eg_recruit_hunter_mission:start();
	
end;

-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Markus Wulfhart Raise Wanted Level
--
--	Triggers after wanted bar pooled resouce is raised
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

function start_early_game_raise_wanted_level_mission_listener(advice_key, infotext, mission_key, current_wanted_level, target_wanted_level, mission_issuer, mission_rewards)
	
	if not is_string(advice_key) then
		script_error("ERROR: start_early_game_raise_wanted_level_mission_listener() called but supplied advice key [" .. tostring(advice_key) .. "] is not a string");
		return false;
	end;
	
	-- default infotext value
	if not infotext then
		infotext = {
			"wh2.camp.advice.ruins.info_001",		-- create default infotext
			"wh2.camp.advice.ruins.info_002",
			"wh2.camp.advice.ruins.info_003"
		};
	end;
	
	if not is_table(infotext) then
		script_error("ERROR: start_early_game_raise_wanted_level_mission_listener() called but supplied infotext [" .. tostring(infotext) .. "] is not a table or nil");
		return false;
	end;
	
	if not is_string(mission_key) then
		script_error("ERROR: start_early_game_raise_wanted_level_mission_listener() called but supplied mission key [" .. tostring(mission_key) .. "] is not a string");
		return false;
	end;
	
	if not is_number(current_wanted_level) then
		script_error("ERROR: start_early_game_raise_wanted_level_mission_listener() called but supplied turn_number [" .. tostring(current_wanted_level) .. "] is not a number or nil");
		return false;
	end;
	
	if not is_number(target_wanted_level) then
		script_error("ERROR: start_early_game_raise_wanted_level_mission_listener() called but supplied turn_number [" .. tostring(target_wanted_level) .. "] is not a number or nil");
		return false;
	end;
	
	if mission_issuer and not is_string(mission_issuer) then
		script_error("ERROR: start_early_game_raise_wanted_level_mission_listener() called but supplied mission issuer [" .. tostring(mission_issuer) .. "] is not a string or nil");
		return false;
	end;
	
	if not mission_rewards then
		mission_rewards = {"money 1000"};
	end;
	
	if not is_table(mission_rewards) then
		script_error("ERROR: start_early_game_raise_wanted_level_mission_listener() called but supplied mission rewards [" .. mission_rewards .. "] is not a table");
		return false;
	end;
	
	if #mission_rewards == 0 then
		script_error("ERROR: start_early_game_raise_wanted_level_mission_listener() called but supplied mission rewards table is empty");
		return false;
	end;
	
	for i = 1, #mission_rewards do
		if not is_string(mission_rewards[i]) then
			script_error("ERROR: start_early_game_raise_wanted_level_mission_listener() called but supplied mission reward [" .. i .. "] is [" .. tostring(mission_rewards[i]) .. "] and not a string");
			return false;
		end;
	end;
	
		
	-- affects how prominently this advice will be delivered based on advice level/history
	-- possible values:
	-- EARLY_GAME_ADVICE_VOICED_BY_LEGENDARY_LORD		| advice voiced by LL, relax criteria for showing it
	-- EARLY_GAME_ADVICE_SPECIFIC_TO_FACTION			| advice voiced by advisor, string is different for different factions
	-- EARLY_GAME_ADVICE_SHARED							| advice voiced by advisor, but string is shared between factions
	local advice_mode = EARLY_GAME_ADVICE_VOICED_BY_LEGENDARY_LORD;
	
	-- set up mission
	local mm = mission_manager:new(
		cm:get_local_faction_name(), 
		mission_key,
		function() core:trigger_event("ScriptEventEGRaiseWantedLevelMissionSucceeded") end 			-- success
	);
	
	mm:add_new_scripted_objective(
		"mission_text_text_mis_raise_wanted_level_objective", 
		"ScriptEventWantedLevel2Reached",
		true
	);
	
	if mission_issuer then
		mm:set_mission_issuer(mission_issuer);
	end;
	
	-- mm:add_condition("region " .. region_key);			-- don't specify a target region, so the mission succeeds no matter which ruins are searched
	for i = 1, #mission_rewards do
		mm:add_payload(mission_rewards[i]);
	end
	
	local event_name = "early_game_recruit_hunter_mission_issued";
	
	-- pre-declare the intervention variable, so that it exists as a local for the subsequent function
	local in_eg_raise_wanted_level_mission = false;
	
	-- intervention trigger function
	local function in_eg_raise_wanted_level_mission_trigger()
		out.design("[EG] start_early_game_recruit_hunter_mission_listener() is triggering mission, advice level is " .. core:get_advice_level());
		
		local delivery_mode, delivery_mode_str = early_game_decide_content_delivery_mode(advice_mode, advice_key);
		
		out.design("\t" .. delivery_mode_str);
		
		-- override delivery_mode to only show the mission for now
		delivery_mode = EARLY_GAME_SHOW_MISSION_ONLY;
		
		if delivery_mode == EARLY_GAME_SHOW_MISSION_ONLY then
			out.design("\tjust issuing mission");
			
			set_early_game_event_experienced(event_name, true);
			--mm:trigger(function() in_eg_raise_wanted_level_mission:complete() end);
			mm:trigger();
			cm:callback(function() in_eg_raise_wanted_level_mission:complete() end, 1);
		else
			if not early_game_should_show_infotext(advice_mode, advice_key, event_name) then
				out.design("\tnot showing infotext");
				infotext = {};
			end;
			
			out.design("\tplaying advice with mission");
			in_eg_raise_wanted_level_mission:play_advice_for_intervention(
				advice_key,
				infotext,
				mm
			);
			
		end;
	end;
	
	-- set up intervention	
	in_eg_raise_wanted_level_mission = intervention:new(
		"eg_raise_wanted_level_mission", 										-- string name
		70,	 																	-- cost
		function() in_eg_raise_wanted_level_mission_trigger() end,					-- trigger callback
		BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
	);
	
	in_eg_raise_wanted_level_mission:set_must_trigger(true);
	
	in_eg_raise_wanted_level_mission:add_precondition(
		function()
			return not get_early_game_event_experienced(event_name, true);
		end
	);
		
	-- trigger at the start of the specified turn if it's not been triggered already
	in_eg_raise_wanted_level_mission:add_trigger_condition(
		"ScriptEventPlayerFactionTurnStart",
		function(context)
			if context:faction():name() == "wh2_dlc13_emp_the_huntmarshals_expedition" and context:faction():is_human() == true then
				local pooled_resources = context:faction():pooled_resource_manager():resources();
				
				for i = 0, pooled_resources:num_items() - 1 do
					local current_pr = pooled_resources:item_at(i);
					if current_pr:key() == "emp_wanted" then
						if current_pr:value() >= current_wanted_level then
							return true;
						end;
					end;
					
				end;
			end;
		end
	);
	
	in_eg_raise_wanted_level_mission:start();
	
end;

-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Nakai Gift Region
--
--	Triggered after how they-play-event in a normal campaign
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

function start_early_game_nakai_gift_region_mission_listener(advice_key, infotext, region_key, mission_key, mission_issuer, mission_rewards)
	
	if not is_string(advice_key) then
		script_error("ERROR: start_early_game_nakai_gift_region_mission_listener() called but supplied advice key [" .. tostring(advice_key) .. "] is not a string");
		return false;
	end;
	
	-- default infotext value
	if not infotext then
		infotext = {
			"wh2.camp.advice.ruins.info_001",		-- create default infotext
			"wh2.camp.advice.ruins.info_002",
			"wh2.camp.advice.ruins.info_003"
		};
	end;
	
	if not is_table(infotext) then
		script_error("ERROR: start_early_game_nakai_gift_region_mission_listener() called but supplied infotext [" .. tostring(infotext) .. "] is not a table or nil");
		return false;
	end;
	
	if not is_string(region_key) then
		script_error("ERROR: start_early_game_nakai_gift_region_mission_listener() called but supplied region key [" .. tostring(region_key) .. "] is not a string");
		return false;
	end;
		
	local region = cm:get_region(region_key);
	
	if not region then
		script_error("ERROR: start_early_game_nakai_gift_region_mission_listener() called but no region with supplied name [" .. region_key .. "] could be found");
		return false;
	end;
	
	if not region:is_abandoned() and not cm:get_saved_value("early_game_nakai_gift_region_mission_issued") then
		script_error("ERROR: start_early_game_nakai_gift_region_mission_listener() called but region with supplied name [" .. region_key .. "] is currently owned by faction [" .. region:owning_faction():name() .. "] .. and the search-ruins mission has not been issued");
		return false;
	end;
	
	if not is_string(mission_key) then
		script_error("ERROR: start_early_game_nakai_gift_region_mission_listener() called but supplied mission key [" .. tostring(mission_key) .. "] is not a string");
		return false;
	end;
	
	if mission_issuer and not is_string(mission_issuer) then
		script_error("ERROR: start_early_game_nakai_gift_region_mission_listener() called but supplied mission issuer [" .. tostring(mission_issuer) .. "] is not a string or nil");
		return false;
	end;
	
	if not mission_rewards then
		mission_rewards = {"money 1000"};
	end;
	
	if not is_table(mission_rewards) then
		script_error("ERROR: start_early_game_nakai_gift_region_mission_listener() called but supplied mission rewards [" .. mission_rewards .. "] is not a table");
		return false;
	end;
	
	if #mission_rewards == 0 then
		script_error("ERROR: start_early_game_nakai_gift_region_mission_listener() called but supplied mission rewards table is empty");
		return false;
	end;
	
	for i = 1, #mission_rewards do
		if not is_string(mission_rewards[i]) then
			script_error("ERROR: start_early_game_nakai_gift_region_mission_listener() called but supplied mission reward [" .. i .. "] is [" .. tostring(mission_rewards[i]) .. "] and not a string");
			return false;
		end;
	end;
	
		
	-- affects how prominently this advice will be delivered based on advice level/history
	-- possible values:
	-- EARLY_GAME_ADVICE_VOICED_BY_LEGENDARY_LORD		| advice voiced by LL, relax criteria for showing it
	-- EARLY_GAME_ADVICE_SPECIFIC_TO_FACTION			| advice voiced by advisor, string is different for different factions
	-- EARLY_GAME_ADVICE_SHARED							| advice voiced by advisor, but string is shared between factions
	local advice_mode = EARLY_GAME_ADVICE_VOICED_BY_LEGENDARY_LORD;
	
	-- set up mission
	local mm = mission_manager:new(
		cm:get_local_faction_name(), 
		mission_key,
		function() core:trigger_event("ScriptEventEGNakaiGiftRegionMissionSucceeded") end 			-- success
	);
		
	mm:add_new_scripted_objective(
		"mission_text_text_mis_nakai_gift_region_objective", 
		"CharacterPerformsSettlementOccupationDecision",
		function(context)
			local faction = context:character():faction();
			
			if faction:name() == "wh2_dlc13_lzd_spirits_of_the_jungle" and faction:is_human() == true then
				
				if context:occupation_decision() == "696983577" then			--Quetzl
					return true;
				elseif context:occupation_decision() == "2006277474" then 	--Itzl
					return true;
				elseif context:occupation_decision() == "1211561161" then		--Xholankha
					return true;
				else
					return false;
				end;
				
			end;
			return false;
		end
	);
	
	if mission_issuer then
		mm:set_mission_issuer(mission_issuer);
	end;
	
	-- mm:add_condition("region " .. region_key);			-- don't specify a target region, so the mission succeeds no matter which ruins are searched
	for i = 1, #mission_rewards do
		mm:add_payload(mission_rewards[i]);
	end
	
	local event_name = "early_game_nakai_gift_region_mission_issued";
	
	-- pre-declare the intervention variable, so that it exists as a local for the subsequent function
	local in_eg_nakai_gift_region_mission = false;
	
	-- intervention trigger function
	local function in_eg_nakai_gift_region_mission_trigger()
		out.design("[EG] start_early_game_nakai_gift_region_mission_listener() is triggering mission, advice level is " .. core:get_advice_level());
		
		local delivery_mode, delivery_mode_str = early_game_decide_content_delivery_mode(advice_mode, advice_key);
		out.design("\t" .. delivery_mode_str);
		
		if delivery_mode == EARLY_GAME_SHOW_MISSION_ONLY then
			out.design("\tjust issuing mission");
			
			set_early_game_event_experienced(event_name, true);
			mm:trigger();
			cm:callback(function() in_eg_nakai_gift_region_mission:complete() end, 1);
			
		else
			if not early_game_should_show_infotext(advice_mode, advice_key, event_name) then
				out.design("\tnot showing infotext");
				infotext = {};
			end;
		
			set_early_game_event_experienced(event_name);		
			if delivery_mode == EARLY_GAME_SCROLL_CAMERA_WITH_ADVICE_AND_MISSION then
				out.design("\tscrolling camera to settlement with advice and mission");
			
				in_eg_nakai_gift_region_mission:scroll_camera_to_settlement_for_intervention(
					region_key,
					advice_key,
					infotext,
					mm
				);
			else
				out.design("\tplaying advice with mission");
			
				in_eg_nakai_gift_region_mission:play_advice_for_intervention(
					advice_key,
					infotext,
					mm
				);
			end;
		end;
	end;
	
	-- set up intervention	
	in_eg_nakai_gift_region_mission = intervention:new(
		"eg_nakai_gift_region_mission", 										-- string name
		70,	 																	-- cost
		function() in_eg_nakai_gift_region_mission_trigger() end,					-- trigger callback
		BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
	);
	
	in_eg_nakai_gift_region_mission:set_must_trigger(true);
	
	in_eg_nakai_gift_region_mission:add_precondition(
		function()
			return not get_early_game_event_experienced(event_name, true);
		end
	);
		
	-- trigger at the start of the specified turn if it's not been triggered already
	in_eg_nakai_gift_region_mission:add_trigger_condition(
		"ScriptEventHowTheyPlayEventDismissed",
		true
	);
	
	in_eg_nakai_gift_region_mission:start();
	
end;

