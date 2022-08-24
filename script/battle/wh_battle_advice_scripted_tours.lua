

-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	SCRIPTED TOUR ADVICE MONITORS
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local im = get_infotext_manager();



bm:register_phase_change_callback(
	"deployed",
	function()
		core:svr_save_timestamp("timestamp_battle_started");

		if bm:battle_type() == "settlement_standard" then
			core:svr_save_timestamp("timestamp_major_siege_started");
		end;
	end
);











--
--	DEPLOYMENT_tour
--

if not bm:get_value_for_current_campaign("block_DEPLOYMENT_tour", false) then
	im:set_button_state_override(
		bm:get_value_for_current_campaign("war.battle.advice.deployment.info_004"),
		function()
			nt_deployment:start();
		end,
		function(uic)
			
		end,
		"ScriptEventConflictPhaseBegins"
	);

	do
		local am = advice_monitor:new(
			"DEPLOYMENT_tour",
			90,
			-- Your soldiers are ready to deploy for battle, my lord. They await your orders.
			bm:get_value_for_current_campaign("war.battle.advice.deployment.001"),
			{
				bm:get_value_for_current_campaign("war.battle.advice.deployment.info_001"),
				bm:get_value_for_current_campaign("war.battle.advice.deployment.info_002"),
				bm:get_value_for_current_campaign("war.battle.advice.deployment.info_003"),
				bm:get_value_for_current_campaign("war.battle.advice.deployment.info_004")
			}
		);

		am:add_ignore_advice_history_tweaker("SCRIPTED_TWEAKER_20");
		am:set_duration(0);

		local function trigger_condition()
			return bm:battle_type() ~= "land_ambush";
		end;

		am:add_trigger_condition(
			trigger_condition, 
			"ScriptEventDeploymentPhaseBegins"
		);

		am:add_trigger_condition(
			function()
				return bm:is_deployment_phase() and trigger_condition();
			end,
			"ScriptEventScriptedTourCompleted"
		);
	end;
end;











--
--	DEPLOYMENT_fundamentals_tour
--

if not bm:get_value_for_current_campaign("block_DEPLOYMENT_fundamentals_tour", false) then
	im:set_button_state_override(
		bm:get_value_for_current_campaign("wh3_main_st_battle_fundamentals_0004"),
		function()
			nt_battle_fundamentals:start();
		end,
		function(uic)
			
		end,
		"ScriptEventConflictPhaseBegins"
	);

	local am = advice_monitor:new(
		"DEPLOYMENT_fundamentals_tour",
		100,
		-- Greatness in battle may only be reached through rigorous training. Even the most skillful of generals must regularly practice their craft.
		bm:get_value_for_current_campaign("wh3_main_st_battle_fundamentals_0001"),
		{
			bm:get_value_for_current_campaign("wh3_main_st_battle_fundamentals_0001"),
			bm:get_value_for_current_campaign("wh3_main_st_battle_fundamentals_0002"),
			bm:get_value_for_current_campaign("wh3_main_st_battle_fundamentals_0003"),
			bm:get_value_for_current_campaign("wh3_main_st_battle_fundamentals_0004")
		}
	);

	am:add_ignore_advice_history_tweaker("SCRIPTED_TWEAKER_20");
	am:add_ignore_advice_history_condition(
		function()
			local timestamp_name = "timestamp_battle_started";
			local time_since_timestamp = core:svr_time_since_timestamp(timestamp_name);
			local threshold = 3 * SECONDS_PER_MONTH;

			if time_since_timestamp then
				if time_since_timestamp > threshold then
					get_advice_manager():out(am.name .. " will disregard advice history as time since timestamp " .. timestamp_name .. " was last recorded is " .. time_since_timestamp .. " which is more than threshold value " .. threshold);
					return true;
				end;
			else
				get_advice_manager():out(am.name .. " will disregard advice history as timestamp " .. timestamp_name .. " has not previously been recorded");
				return true;
			end;
		end
	);

	am:set_duration(0);

	local function trigger_condition()
		return nt_battle_fundamentals.min_player_units_threshold_reached and nt_battle_fundamentals.min_enemy_units_threshold_reached and nt_battle_fundamentals.bounding_box_to_use;
	end;

	am:add_trigger_condition(
		function()
			return trigger_condition();
		end, 
		"ScriptEventDeploymentPhaseBegins"
	);

	am:add_trigger_condition(
		function()
			return bm:is_deployment_phase() and trigger_condition();
		end,
		"ScriptEventScriptedTourCompleted"
	);
end;










--
--	DEPLOYMENT_unit_types_tour
--

if not bm:get_value_for_current_campaign("block_DEPLOYMENT_unit_types_tour", false) then
	im:set_button_state_override(
		bm:get_value_for_current_campaign("wh3_main_st_unit_types_0003"),
		function()
			nt_unit_types:start();
		end,
		function(uic)
			
		end,
		"ScriptEventConflictPhaseBegins"
	);

	local am = advice_monitor:new(
		"DEPLOYMENT_unit_types_tour",
		80,
		-- The troops that your enemies field are both many and varied. Mastery of their strengths and weaknesses will leave you best-placed to face them in battle.
		bm:get_value_for_current_campaign("wh3_main_st_battle_unit_types_0001"),
		{
			bm:get_value_for_current_campaign("wh3_main_st_unit_types_0001"),
			bm:get_value_for_current_campaign("wh3_main_st_unit_types_0002"),
			bm:get_value_for_current_campaign("wh3_main_st_unit_types_0003")
		}
	);

	am:add_ignore_advice_history_tweaker("SCRIPTED_TWEAKER_20");
	am:add_ignore_advice_history_condition(
		function()
			local timestamp_name = "timestamp_battle_started";
			local time_since_timestamp = core:svr_time_since_timestamp(timestamp_name);
			local threshold = 4 * SECONDS_PER_MONTH;

			if time_since_timestamp then 
				if time_since_timestamp > threshold then
					get_advice_manager():out(am.name .. " will disregard advice history as time since timestamp " .. timestamp_name .. " was last recorded is " .. time_since_timestamp .. " which is more than threshold value " .. threshold);
					return true;
				end;
			else
				get_advice_manager():out(am.name .. " will disregard advice history as timestamp " .. timestamp_name .. " has not previously been recorded");
				return true;
			end;
		end
	);

	am:set_duration(0);

	local function trigger_condition()
		return bm:battle_type() ~= "land_ambush";
	end;

	am:add_trigger_condition(
		trigger_condition, 
		"ScriptEventDeploymentPhaseBegins"
	);

	am:add_trigger_condition(
		function()
			return bm:is_deployment_phase() and trigger_condition();
		end,
		"ScriptEventScriptedTourCompleted"
	);
end;










--
--	DEPLOYMENT_major_siege_battle_defence_scripted_tour
--

if not bm:get_value_for_current_campaign("block_DEPLOYMENT_major_siege_battle_defence_scripted_tour", false) then
	im:set_button_state_override(
		bm:get_value_for_current_campaign("war.battle.advice.major_siege_battles.info_005"),
		function()
			nt_siege_defence:start();
		end,
		function(uic)
			
		end,
		"ScriptEventConflictPhaseBegins"
	);

	local am = advice_monitor:new(
		"DEPLOYMENT_major_siege_battle_defence_scripted_tour",
		95,
		-- The enemy look set to begin their attack soon. Should they drive out your forces or wrest key locations from your grasp then the city will surely be lost. Man the defences, for the city must not fall!
		bm:get_value_for_current_campaign("wh3_main_battle_advice_major_settlement_defence_01"),
		{
			bm:get_value_for_current_campaign("war.battle.advice.major_siege_battles.info_001"),
			bm:get_value_for_current_campaign("war.battle.advice.major_siege_battles.info_002"),
			bm:get_value_for_current_campaign("war.battle.advice.major_siege_battles.info_003"),
			bm:get_value_for_current_campaign("war.battle.advice.major_siege_battles.info_005")
		}
	);

	am:set_advice_level(ADVICE_LEVEL_LOW_HIGH);

	am:add_ignore_advice_history_tweaker("SCRIPTED_TWEAKER_20");
	am:add_ignore_advice_history_condition(
		function()
			local timestamp_name = "timestamp_major_siege_started";
			local time_since_timestamp = core:svr_time_since_timestamp(timestamp_name);
			local threshold = 3 * SECONDS_PER_MONTH;

			if time_since_timestamp then
				if time_since_timestamp > threshold then
					get_advice_manager():out(am.name .. " will disregard advice history as time since timestamp " .. timestamp_name .. " was last recorded is " .. time_since_timestamp .. " which is more than threshold value " .. threshold);
					return true;
				end;
			else
				get_advice_manager():out(am.name .. " will disregard advice history as timestamp " .. timestamp_name .. " has not previously been recorded");
				return true;
			end;
		end
	);

	am:set_duration(0);

	local function trigger_condition()
		return bm:battle_type() == "settlement_standard" and not bm:player_is_attacker();
	end;

	am:add_trigger_condition(
		trigger_condition,
		"ScriptEventDeploymentPhaseBegins"
	);

	am:add_trigger_condition(
		function()
			return bm:is_deployment_phase() and trigger_condition();
		end,
		"ScriptEventScriptedTourCompleted"
	);
end;














--
--	DEPLOYMENT_major_siege_battle_attacking_scripted_tour
--

if not bm:get_value_for_current_campaign("block_DEPLOYMENT_major_siege_battle_attacking_scripted_tour", false) then
	im:set_button_state_override(
		bm:get_value_for_current_campaign("war.battle.advice.major_siege_battles.info_004"),
		function()
			nt_siege_battle_attack:start();
		end,
		function(uic)
			
		end,
		"ScriptEventConflictPhaseBegins"
	);

	local am = advice_monitor:new(
		"DEPLOYMENT_major_siege_battle_attacking_scripted_tour",
		95,
		-- Your forces are lined up and ready to attack. The enemy fortifications are formidable, but you must seek to overcome them and either drive out the enemy forces or seize key locations within the city.
		bm:get_value_for_current_campaign("wh3_main_battle_advice_major_settlement_attack_01"),
		{
			bm:get_value_for_current_campaign("war.battle.advice.major_siege_battles.info_001"),
			bm:get_value_for_current_campaign("war.battle.advice.major_siege_battles.info_002"),
			bm:get_value_for_current_campaign("war.battle.advice.major_siege_battles.info_003"),
			bm:get_value_for_current_campaign("war.battle.advice.major_siege_battles.info_004")
		}
	);

	am:set_advice_level(ADVICE_LEVEL_LOW_HIGH);

	am:add_ignore_advice_history_tweaker("SCRIPTED_TWEAKER_20");
	am:add_ignore_advice_history_condition(
		function()
			local timestamp_name = "timestamp_major_siege_started";
			local time_since_timestamp = core:svr_time_since_timestamp(timestamp_name);
			local threshold = 3 * SECONDS_PER_MONTH;

			if time_since_timestamp then
				if time_since_timestamp > threshold then
					get_advice_manager():out(am.name .. " will disregard advice history as time since timestamp " .. timestamp_name .. " was last recorded is " .. time_since_timestamp .. " which is more than threshold value " .. threshold);
					return true;
				end;
			else
				get_advice_manager():out(am.name .. " will disregard advice history as timestamp " .. timestamp_name .. " has not previously been recorded");
				return true;
			end;
		end
	);

	am:set_duration(0);

	local function trigger_condition()
		return bm:battle_type() == "settlement_standard" and bm:player_is_attacker();
	end;

	am:add_trigger_condition(
		trigger_condition,
		"ScriptEventDeploymentPhaseBegins"
	);

	am:add_trigger_condition(
		function()
			return bm:is_deployment_phase() and trigger_condition();
		end,
		"ScriptEventScriptedTourCompleted"
	);
end;






--
--	DEPLOYMENT_minor_settlement_battle_defence_scripted_tour
--

if not bm:get_value_for_current_campaign("block_DEPLOYMENT_minor_settlement_battle_defence_scripted_tour", false) then
	im:set_button_state_override(
		bm:get_value_for_current_campaign("war.battle.advice.minor_settlement_battles.info_005"),
		function()
			nt_minor_settlement_defence:start();
		end,
		function(uic)
			
		end,
		"ScriptEventConflictPhaseBegins"
	);

	local am = advice_monitor:new(
		"DEPLOYMENT_minor_settlement_battle_defence_scripted_tour",
		95,
		-- Gather your warriors about you, for the enemy line up to attack! They will soon press forward, but your entrenched position places the settlement defences at your disposal. Use them wisely!
		bm:get_value_for_current_campaign("wh3_main_battle_advice_minor_settlement_defence_01"),
		{
			bm:get_value_for_current_campaign("war.battle.advice.minor_settlement_battles.info_001"),
			bm:get_value_for_current_campaign("war.battle.advice.minor_settlement_battles.info_002"),
			bm:get_value_for_current_campaign("war.battle.advice.minor_settlement_battles.info_003"),
			bm:get_value_for_current_campaign("war.battle.advice.minor_settlement_battles.info_005")
		}
	);

	am:set_advice_level(ADVICE_LEVEL_LOW_HIGH);

	am:add_ignore_advice_history_tweaker("SCRIPTED_TWEAKER_20");
	am:add_ignore_advice_history_condition(
		function()
			local timestamp_name = "timestamp_major_siege_started";
			local time_since_timestamp = core:svr_time_since_timestamp(timestamp_name);
			local threshold = 3 * SECONDS_PER_MONTH;

			if time_since_timestamp then
				if time_since_timestamp > threshold then
					get_advice_manager():out(am.name .. " will disregard advice history as time since timestamp " .. timestamp_name .. " was last recorded is " .. time_since_timestamp .. " which is more than threshold value " .. threshold);
					return true;
				end;
			else
				get_advice_manager():out(am.name .. " will disregard advice history as timestamp " .. timestamp_name .. " has not previously been recorded");
				return true;
			end;
		end
	);

	am:set_duration(0);

	local function trigger_condition()
		return bm:battle_type() == "settlement_unfortified" and not bm:player_is_attacker();
	end;

	am:add_trigger_condition(
		trigger_condition,
		"ScriptEventDeploymentPhaseBegins"
	);

	am:add_trigger_condition(
		function()
			return bm:is_deployment_phase() and trigger_condition();
		end,
		"ScriptEventScriptedTourCompleted"
	);
end;





--
--	DEPLOYMENT_minor_settlement_battle_attack_scripted_tour
--

if not bm:get_value_for_current_campaign("block_DEPLOYMENT_minor_settlement_battle_attack_scripted_tour", false) then
	im:set_button_state_override(
		bm:get_value_for_current_campaign("war.battle.advice.minor_settlement_battles.info_004"),
		function()
			nt_minor_settlement_attack:start();
		end,
		function(uic)
			
		end,
		"ScriptEventConflictPhaseBegins"
	);

	-- setup shared infotext
	local infotext = {
		bm:get_value_for_current_campaign("war.battle.advice.minor_settlement_battles.info_001"),
		bm:get_value_for_current_campaign("war.battle.advice.minor_settlement_battles.info_002"),
		bm:get_value_for_current_campaign("war.battle.advice.minor_settlement_battles.info_003")
	};

	-- add additional infotext is it's not blocked
	if not bm:get_value_for_current_campaign("block_war.battle.advice.minor_settlement_battles.info_004", false) then
		table.insert(infotext, bm:get_value_for_current_campaign("war.battle.advice.minor_settlement_battles.info_004"));
	end;

	local am = advice_monitor:new(
		"DEPLOYMENT_minor_settlement_battle_attack_scripted_tour",
		95,
		-- Your forces are ready to storm the defences! Yet I advise caution, for you face an entrenched enemy that has had time to prepare - be wary!
		bm:get_value_for_current_campaign("wh3_main_battle_advice_minor_settlement_attack_01"),
		infotext
	);

	am:set_advice_level(ADVICE_LEVEL_LOW_HIGH);

	am:add_ignore_advice_history_tweaker("SCRIPTED_TWEAKER_20");
	am:add_ignore_advice_history_condition(
		function()
			local timestamp_name = "timestamp_major_siege_started";
			local time_since_timestamp = core:svr_time_since_timestamp(timestamp_name);
			local threshold = 3 * SECONDS_PER_MONTH;

			if time_since_timestamp then
				if time_since_timestamp > threshold then
					get_advice_manager():out(am.name .. " will disregard advice history as time since timestamp " .. timestamp_name .. " was last recorded is " .. time_since_timestamp .. " which is more than threshold value " .. threshold);
					return true;
				end;
			else
				get_advice_manager():out(am.name .. " will disregard advice history as timestamp " .. timestamp_name .. " has not previously been recorded");
				return true;
			end;
		end
	);

	am:set_duration(0);

	local function trigger_condition()
		return bm:battle_type() == "settlement_unfortified" and bm:player_is_attacker();
	end;

	am:add_trigger_condition(
		trigger_condition,
		"ScriptEventDeploymentPhaseBegins"
	);

	am:add_trigger_condition(
		function()
			return bm:is_deployment_phase() and trigger_condition();
		end,
		"ScriptEventScriptedTourCompleted"
	);
end;