

-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	ADVICE SCRIPTS
--	Battle advice trigger declarations go here
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

-- Variables
local function is_player_primary_general_male()
	if bm:get_player_alliance():is_attacker() then
		return core:svr_load_bool("primary_attacker_is_female") == false;
	end;
	return core:svr_load_bool("primary_defender_is_female") == false;
end;

local function is_enemy_primary_general_male()
	if bm:get_player_alliance():is_attacker() then
		return core:svr_load_bool("primary_defender_is_female") == false;
	end;
	return core:svr_load_bool("primary_attacker_is_female") == false;
end;

-- Settlement battle types
-- These are to be used to determine the different battle types
SIEGE_BATTLE_MAJOR = "settlement_standard";
SETTLEMENT_BATTLE_MINOR = "settlement_unfortified";


bm:out("********************************************************************");
bm:out("*** loading advice scripts");
bm:out("********************************************************************");
bm:out("");
bm:out("Player alliance number: " .. tostring(bm:get_player_alliance_num()));
bm:out("Battle type: " .. bm:battle_type());

bm:out("Primary attacker faction is [" .. tostring(core:svr_load_string("primary_attacker_faction_name")) .. "], subculture is [" .. tostring(core:svr_load_string("primary_attacker_subculture")) .. "], is player: " .. tostring(core:svr_load_bool("primary_attacker_is_player")));
bm:out("Primary defender faction is [" .. tostring(core:svr_load_string("primary_defender_faction_name")) .. "], subculture is [" .. tostring(core:svr_load_string("primary_defender_subculture")) .. "], is player: " .. tostring(core:svr_load_bool("primary_defender_is_player")));
bm:out("");

-- create an advice manager with debug output enabled
__am = advice_manager:new(true);

-- load scripted tour advice monitors
require("wh_battle_advice_scripted_tours");























--
--	siege attacker start (siege weapons)
--
if not bm:get_value_for_current_campaign("block_siege_attacker_start", false) then

	local infotext = {
		bm:get_value_for_current_campaign("war.battle.advice.siege_weapons.info_001"),
		bm:get_value_for_current_campaign("war.battle.advice.siege_weapons.info_002")
	}

	-- add additional infotext is it's not blocked
	if not bm:get_value_for_current_campaign("block_war.battle.advice.siege_weapons.info_003", false) then
		table.insert(infotext, bm:get_value_for_current_campaign("war.battle.advice.siege_weapons.info_003"));
	end;

	local am = advice_monitor:new(
		"siege_attacker_start",
		60,
		-- The siege weapons are in position, my lord, and are ready to begin their assault. Begin your advance!
		bm:get_value_for_current_campaign("war.battle.advice.siege_weapons.002"),
		infotext
	);

	am:add_trigger_condition(
		function()
			return bm:is_siege_battle() and bm:player_is_attacker() and bm:assault_equipment():vehicle_count() > 0;
		end,
		"ScriptEventConflictPhaseBegins"
	);
end;




















--
--	enemy general dead
--
if not bm:get_value_for_current_campaign("block_enemy_general_dead", false) then

	local infotext = {
		bm:get_value_for_current_campaign("war.battle.advice.the_general.info_001"),
		bm:get_value_for_current_campaign("war.battle.advice.the_general.info_002"),
		bm:get_value_for_current_campaign("war.battle.advice.the_general.info_003"),
	}

	-- add additional infotext is it's not blocked
	if not bm:get_value_for_current_campaign("block_war.battle.advice.the_general.info_004", false) then
		table.insert(infotext, bm:get_value_for_current_campaign("war.battle.advice.the_general.info_004"));
	end;

	local am = advice_monitor:new(
		"enemy_general_dead",
		60,
		-- The enemy general is slain, my lord, cursing your name with his dying breath! Send his army after him!
		bm:get_value_for_current_campaign("war.battle.advice.enemy_general.001"),
		infotext
	);

	am:set_can_interrupt_other_advice(true);

	am:add_start_condition(
		function()
			return is_enemy_primary_general_male();
		end,
		"ScriptEventConflictPhaseBegins"
	);

	am:add_trigger_condition(
		true,
		"ScriptEventEnemyGeneralDies"
	);
end;












--
--	enemy general wounded
--
if not bm:get_value_for_current_campaign("block_enemy_general_wounded", false) then

	local infotext = {
		bm:get_value_for_current_campaign("war.battle.advice.the_general.info_001"),
		bm:get_value_for_current_campaign("war.battle.advice.the_general.info_002"),
		bm:get_value_for_current_campaign("war.battle.advice.the_general.info_003")
	}
	
	-- add additional infotext is it's not blocked
	if not bm:get_value_for_current_campaign("block_war.battle.advice.the_general.info_004", false) then
		table.insert(infotext, bm:get_value_for_current_campaign("war.battle.advice.the_general.info_004"));
	end;

	local am = advice_monitor:new(
		"enemy_general_wounded",
		60,
		-- The enemy general has been wounded in battle, my lord, and can no longer lead his troops. Press home your advantage!
		bm:get_value_for_current_campaign("war.battle.advice.enemy_general.002"),
		infotext
	);

	am:set_can_interrupt_other_advice(true);

	am:add_start_condition(
		function()
			return is_enemy_primary_general_male();
		end,
		"ScriptEventConflictPhaseBegins"
	);

	am:add_trigger_condition(
		true,
		"ScriptEventEnemyGeneralWounded"
	);
end;











--
--	enemy general routing
--
if not bm:get_value_for_current_campaign("block_enemy_general_routing", false) then

	local infotext = {
		bm:get_value_for_current_campaign("war.battle.advice.the_general.info_001"),
		bm:get_value_for_current_campaign("war.battle.advice.the_general.info_002"),
		bm:get_value_for_current_campaign("war.battle.advice.the_general.info_003")
	}

	-- add additional infotext is it's not blocked
	if not bm:get_value_for_current_campaign("block_war.battle.advice.the_general.info_004", false) then
		table.insert(infotext, bm:get_value_for_current_campaign("war.battle.advice.the_general.info_004"));
	end;

	local am = advice_monitor:new(
		"enemy_general_routing",
		60,
		-- The enemy commander runs from the field, my lord, and a sorry spectacle it is too! His army will surely follow!
		bm:get_value_for_current_campaign("war.battle.advice.enemy_general.003"),
		infotext
	);

	am:add_halt_on_advice_monitor_triggering("enemy_general_dead");
	am:add_halt_on_advice_monitor_triggering("enemy_general_wounded");
	am:set_can_interrupt_other_advice(true);

	am:add_start_condition(
		function()
			return is_enemy_primary_general_male();
		end,
		"ScriptEventConflictPhaseBegins"
	);

	am:add_trigger_condition(
		true,
		"ScriptEventMainEnemyGeneralRouts"
	);
end;
















--
--	player general dead
--
if not bm:get_value_for_current_campaign("block_player_general_dead", false) then

	local infotext = {
		bm:get_value_for_current_campaign("war.battle.advice.the_general.info_001"),
		bm:get_value_for_current_campaign("war.battle.advice.the_general.info_002"),
		bm:get_value_for_current_campaign("war.battle.advice.the_general.info_003"),
	}

	-- add additional infotext is it's not blocked
	if not bm:get_value_for_current_campaign("block_war.battle.advice.the_general.info_004", false) then
		table.insert(infotext, bm:get_value_for_current_campaign("war.battle.advice.the_general.info_004"));
	end;

	local am = advice_monitor:new(
		"player_general_dead",
		60,
		-- Your commander has been killed in action, my lord! Word has already spread amongst your troops; they will surely lose heart.
		bm:get_value_for_current_campaign("war.battle.advice.general.001"),
		infotext
	);

	am:set_can_interrupt_other_advice(true);

	am:add_start_condition(
		true,
		"ScriptEventConflictPhaseBegins"
	);

	am:add_trigger_condition(
		true,
		"ScriptEventPlayerGeneralDies"
	);
end;












--
--	player general wounded
--
if not bm:get_value_for_current_campaign("block_player_general_wounded", false) then

	local infotext = {
		bm:get_value_for_current_campaign("war.battle.advice.the_general.info_001"),
		bm:get_value_for_current_campaign("war.battle.advice.the_general.info_002"),
		bm:get_value_for_current_campaign("war.battle.advice.the_general.info_003")
	}

	-- add additional infotext is it's not blocked
	if not bm:get_value_for_current_campaign("block_war.battle.advice.the_general.info_004", false) then
		table.insert(infotext, bm:get_value_for_current_campaign("war.battle.advice.the_general.info_004"));
	end;

	local am = advice_monitor:new(
		"player_general_wounded",
		60,
		-- Your general has been wounded in the fighting and carried from the field, Sire! His loss will be keenly felt by those left fighting.
		bm:get_value_for_current_campaign("war.battle.advice.general.002"),
		infotext
	);

	am:set_can_interrupt_other_advice(true);

	am:add_start_condition(
		function()
			local general_is_male = is_player_primary_general_male();
			return general_is_male;
		end,
		"ScriptEventConflictPhaseBegins"
	);

	am:add_trigger_condition(
		true,
		"ScriptEventPlayerGeneralWounded"
	);
end;











--
--	player general routing
--
if not bm:get_value_for_current_campaign("block_player_general_routing", false) then

	local infotext = {
		bm:get_value_for_current_campaign("war.battle.advice.the_general.info_001"),
		bm:get_value_for_current_campaign("war.battle.advice.the_general.info_002"),
		bm:get_value_for_current_campaign("war.battle.advice.the_general.info_003"),
	}

	if not bm:get_value_for_current_campaign("block_war.battle.advice.the_general.info_004", false) then
		table.insert(infotext, bm:get_value_for_current_campaign("war.battle.advice.the_general.info_004"));
	end;

	local am = advice_monitor:new(
		"player_general_routing",
		60,
		-- Your general flees the field, my lord! A shameful display!
		bm:get_value_for_current_campaign("war.battle.advice.general.003"),
		infotext
	);

	am:add_halt_on_advice_monitor_triggering("player_general_dead");
	am:add_halt_on_advice_monitor_triggering("player_general_wounded");
	am:set_can_interrupt_other_advice(true);

	am:add_start_condition(
		true,
		"ScriptEventConflictPhaseBegins"
	);

	am:add_trigger_condition(
		true,
		"ScriptEventPlayerGeneralRouts"
	);
end;


--
--	legendary lord routing prologue
--
if not bm:get_value_for_current_campaign("block_legendary_lord_routing_prologue", false) and bm:get_campaign_key() == "wh3_main_prologue" then

	local infotext = {
		bm:get_value_for_current_campaign("war.battle.advice.the_general.info_001"),
		bm:get_value_for_current_campaign("war.battle.advice.the_general.info_002"),
		bm:get_value_for_current_campaign("war.battle.advice.the_general.info_003"),
	}

	local am = advice_monitor:new(
		"legendary_lord_routing_prologue",
		60,
		-- Your general flees the field, my lord! A shameful display!
		bm:get_value_for_current_campaign("wh3_prologue_battle_advice_player_general_routing"),
		infotext
	);

	am:add_halt_on_advice_monitor_triggering("player_general_dead");
	am:add_halt_on_advice_monitor_triggering("player_general_wounded");
	am:set_can_interrupt_other_advice(true);

	am:add_start_condition(
		true,
		"ScriptEventConflictPhaseBegins"
	);

	am:add_trigger_condition(
		function()
			local main_player_army = bm:get_player_army()
			local player_units = main_player_army:units()
					
			for i = 1, player_units:count() do
				local current_unit = player_units:item(i)
				
				if current_unit:is_commanding_unit() and current_unit:type() == "wh3_main_pro_ksl_cha_yuri_0" and (current_unit:is_routing() or current_unit:is_shattered()) then
					return true	
				end
			end
		end,
		"BattleCommandingUnitRouts"
	);
end;


--
--	regular lord routing prologue
--
if not bm:get_value_for_current_campaign("block_regular_lord_routing_prologue", false) and bm:get_campaign_key() == "wh3_main_prologue" then

	local infotext = {
		bm:get_value_for_current_campaign("war.battle.advice.the_general.info_001"),
		bm:get_value_for_current_campaign("war.battle.advice.the_general.info_002"),
		bm:get_value_for_current_campaign("war.battle.advice.the_general.info_003"),
	}

	local am = advice_monitor:new(
		"regular_lord_routing_prologue",
		60,
		-- Your general flees the field, my lord! A shameful display!
		bm:get_value_for_current_campaign("wh3_prologue_battle_advice_player_general_routing_recruited"),
		infotext
	);

	am:add_halt_on_advice_monitor_triggering("player_general_dead");
	am:add_halt_on_advice_monitor_triggering("player_general_wounded");
	am:set_can_interrupt_other_advice(true);

	am:add_start_condition(
		true,
		"ScriptEventConflictPhaseBegins"
	);

	am:add_trigger_condition(
		function() 
			local main_player_army = bm:get_player_army()
			local player_units = main_player_army:units()
					
			for i = 1, player_units:count() do
				local current_unit = player_units:item(i)
				
				if current_unit:is_commanding_unit() and current_unit:type() ~= "wh3_main_pro_ksl_cha_yuri_0" and (current_unit:is_routing() or current_unit:is_shattered()) then
					return true	
				end
			end
		end,
		"BattleCommandingUnitRouts"
	);
end;







--
--	player unit routing
--
if not bm:get_value_for_current_campaign("block_player_unit_routing", false) then

	local infotext = {
		bm:get_value_for_current_campaign("war.battle.advice.leadership.info_001"),
		bm:get_value_for_current_campaign("war.battle.advice.leadership.info_002"),
		bm:get_value_for_current_campaign("war.battle.advice.leadership.info_003")
	}

	-- add additional infotext is it's not blocked
	if not bm:get_value_for_current_campaign("block_war.battle.advice.leadership.info_004", false) then
		table.insert(infotext, bm:get_value_for_current_campaign("war.battle.advice.leadership.info_004"));
	end;

	local am = advice_monitor:new(
		"player_unit_routing",
		40,
		-- Your craven warriors run from the battle, my Lord! Round them up, and send them back!
		bm:get_value_for_current_campaign("war.battle.advice.routing.002"),
		infotext
	);

	am:add_halt_on_advice_monitor_triggering("enemy_unit_routing");
	am:set_can_interrupt_other_advice(true);

	am:add_start_condition(
		true,
		"ScriptEventConflictPhaseBegins"
	);

	am:add_trigger_condition(
		true,
		"ScriptEventPlayerUnitRouts"
	);
end;












--
--	player unit rallies
--
if not bm:get_value_for_current_campaign("block_player_unit_rallies", false) then
	
	local infotext = {
		bm:get_value_for_current_campaign("war.battle.advice.rallying.info_001"),
		bm:get_value_for_current_campaign("war.battle.advice.rallying.info_002"),
		bm:get_value_for_current_campaign("war.battle.advice.rallying.info_003")
	}

	-- add additional infotext is it's not blocked
	if not bm:get_value_for_current_campaign("block_war.battle.advice.rallying.info_004", false) then
		table.insert(infotext, bm:get_value_for_current_campaign("war.battle.advice.rallying.info_004"));
	end;

	local am = advice_monitor:new(
		"player_unit_rallies",
		40,
		-- Your warriors begin to rally, Sire! Steady their nerves, and they will be able to rejoin the fight.
		bm:get_value_for_current_campaign("war.battle.advice.rallying.001"),
		infotext
	);

	am:set_can_interrupt_other_advice(true);
	am:set_advice_level(ADVICE_LEVEL_HIGH);

	am:add_start_condition(
		true,
		"ScriptEventConflictPhaseBegins"
	);

	am:add_trigger_condition(
		true,
		"ScriptEventPlayerUnitRallies"
	);
end;














--
--	enemy unit routing
--
if not bm:get_value_for_current_campaign("block_enemy_unit_routing", false) then
	
	local infotext = {
		bm:get_value_for_current_campaign("war.battle.advice.leadership.info_001"),
		bm:get_value_for_current_campaign("war.battle.advice.leadership.info_002"),
		bm:get_value_for_current_campaign("war.battle.advice.leadership.info_003")
	}

	-- add additional infotext is it's not blocked
	if not bm:get_value_for_current_campaign("block_war.battle.advice.leadership.info_004", false) then
		table.insert(infotext, bm:get_value_for_current_campaign("war.battle.advice.leadership.info_004"));
	end

	local am = advice_monitor:new(
		"enemy_unit_routing",
		40,
		-- The enemy waver, my lord, their troops begin to flee! Run the cowards down!
		bm:get_value_for_current_campaign("war.battle.advice.routing.001"),
		infotext
	);

	am:add_halt_on_advice_monitor_triggering("player_unit_routing");
	am:set_can_interrupt_other_advice(true);

	am:add_start_condition(
		true,
		"ScriptEventConflictPhaseBegins"
	);

	am:add_trigger_condition(
		true,
		"ScriptEventEnemyUnitRouts"
	);
end;










--
--	player_visibility
--
if not bm:get_value_for_current_campaign("block_player_visibility", false) then
	local infotext = {
		bm:get_value_for_current_campaign("war.battle.advice.visibility.info_001"),
		bm:get_value_for_current_campaign("war.battle.advice.visibility.info_002"),
	}

	-- add additional infotext is it's not blocked
	if not bm:get_value_for_current_campaign("block_war.battle.advice.visibility.info_003", false) then
		table.insert(infotext, bm:get_value_for_current_campaign("war.battle.advice.visibility.info_003"));
	end;

	local am = advice_monitor:new(
		"player_visibility",
		30,
		-- You may use the hills, valleys... and stranger formations of this place to your advantage, Commander. The terrain can conceal your forces.
		bm:get_value_for_current_campaign("war.battle.advice.visibility.002"),
		infotext
	);

	am:add_halt_on_advice_monitor_triggering("enemy_visibility");
	am:set_advice_level(ADVICE_LEVEL_HIGH);

	am:add_start_condition(
		function()
			return not bm:is_siege_battle()
		end,
		"ScriptEventConflictPhaseBegins"
	);

	am:add_trigger_condition(
		function()
			local player_army = am.player_army;
			local enemy_alliance = am.enemy_alliance;
			
			-- cache alliances if we don't have them
			if not player_army then
				player_army = bm:get_player_army();
				am.player_army = player_army;
				enemy_alliance = bm:get_non_player_alliance();
				am.enemy_alliance = enemy_alliance;
			end;
			
			local num_invisible_player_units, num_player_units = num_units_passing_test(
				player_army,
				function(unit)
					return not unit:is_visible_to_alliance(enemy_alliance);
				end
			);
			
			if num_player_units == 0 then
				return false;
			end;
			
			-- try and trigger if more than two units and more than 25% of the player's army is invisible
			return num_invisible_player_units > 2 and num_invisible_player_units / num_player_units > 0.25;
		end
	);

	am:add_halt_condition(true, "ScriptEventBattleArmiesEngaging");
end;










--
--	enemy_visibility
--
if not bm:get_value_for_current_campaign("block_enemy_visibility", false) then
	local infotext = {
		bm:get_value_for_current_campaign("war.battle.advice.visibility.info_001"),
		bm:get_value_for_current_campaign("war.battle.advice.visibility.info_002"),
	}
	
	-- add additional infotext is it's not blocked
	if not bm:get_value_for_current_campaign("block_war.battle.advice.visibility.info_003", false) then
		table.insert(infotext, bm:get_value_for_current_campaign("war.battle.advice.visibility.info_003"));
	end;

	local am = advice_monitor:new(
		"enemy_visibility",
		35,
		-- The terrain conceals the enemy's movements, Commander. We must be wary!
		bm:get_value_for_current_campaign("war.battle.advice.visibility.001"),
		infotext
	);

	am:add_halt_on_advice_monitor_triggering("player_visibility");

	am:add_start_condition(
		function()
			return not bm:is_siege_battle()
		end,
		"ScriptEventConflictPhaseBegins"
	);

	am:add_trigger_condition(
		function()
			local player_alliance = am.player_alliance;
			local enemy_army = am.enemy_army;
			
			-- cache alliances if we don't have them
			if not player_alliance then
				player_alliance = bm:get_player_alliance();
				am.player_alliance = player_alliance;
				enemy_army = bm:get_first_non_player_army();
				am.enemy_army = enemy_army;
			end;
			
			local num_invisible_enemy_units, num_enemy_units = num_units_passing_test(
				enemy_army,
				function(unit)
					return not unit:is_visible_to_alliance(player_alliance);
				end
			);
			
			if num_enemy_units == 0 then
				return false;
			end;
			
			-- try and trigger if more than three units and more than 33% of the enemy army is invisible
			return num_invisible_enemy_units > 3 and num_invisible_enemy_units / num_enemy_units > 0.33;
		end
	);

	am:add_halt_condition(true, "ScriptEventBattleArmiesEngaging");
end;












--
--	enemy_giant
--
if not bm:get_value_for_current_campaign("block_enemy_giant", false) then
	local am = advice_monitor:new(
		"enemy_giant",
		40,
		-- A Giant, Commander! Take it down from afar! Don't let it near your massed infantry!
		bm:get_value_for_current_campaign("war.battle.advice.giants.001"),
		{
			bm:get_value_for_current_campaign("war.battle.advice.monsters.info_001"),
			bm:get_value_for_current_campaign("war.battle.advice.monsters.info_002"),
			bm:get_value_for_current_campaign("war.battle.advice.monsters.info_003")
		}
	);

	am:add_halt_on_advice_monitor_triggering("player_giant");

	am:add_start_condition(
		function()
			return not bm:is_siege_battle()
		end,
		"ScriptEventConflictPhaseBegins"
	);

	am:add_trigger_condition(
		function()		
			local player_alliance = am.player_alliance;
			local enemy_giants = am.enemy_giants;
			
			if not enemy_giants then
				-- build a list of all giants in the enemy alliance
				enemy_giants = get_all_matching_units(
					bm:get_non_player_alliance(), 
					function(unit)
						return string.find(unit:type(), "mon_giant");
					end
				);
				
				am.enemy_giants = enemy_giants;
				
				if #enemy_giants == 0 then
					am:halt("enemy has no giants");
					return false;
				end;
				
				player_alliance = bm:get_player_alliance();
				am.player_alliance = player_alliance;
			end;
					
			local num_visible_enemy_giants = num_units_passing_test(
				enemy_giants,
				function(unit)
					return unit:is_visible_to_alliance(player_alliance);
				end
			);
			
			return num_visible_enemy_giants > 0;
		end
	);

	am:add_halt_condition(true, "ScriptEventBattleArmiesEngaging");
end;













--
--	player_giant
--
if not bm:get_value_for_current_campaign("block_player_giant", false) then
	local am = advice_monitor:new(
		"player_giant",
		30,
		-- Your Giant terrorises the enemy, great lord! Send it into the main body of the enemy, and watch the carnage unfold!
		bm:get_value_for_current_campaign("war.battle.advice.giants.002"),
		{
			bm:get_value_for_current_campaign("war.battle.advice.monsters.info_001"),
			bm:get_value_for_current_campaign("war.battle.advice.monsters.info_002"),
			bm:get_value_for_current_campaign("war.battle.advice.monsters.info_003")
		}
	);

	am:add_halt_on_advice_monitor_triggering("enemy_giant");
	am:set_advice_level(ADVICE_LEVEL_HIGH);

	am:add_start_condition(
		function()
			if bm:is_siege_battle() then
				return false;
			end;
			
			-- build a list of all giants in the player's army
			am.player_giants = get_all_matching_units(
				bm:get_player_army(), 
				function(unit)
					return string.find(unit:type(), "mon_giant");
				end
			);
			
			am.enemy_alliance = bm:get_non_player_alliance();
			
			return true;
		end,
		"ScriptEventConflictPhaseBegins"
	);

	am:add_trigger_condition(
		function()
			local enemy_alliance = am.enemy_alliance;
			local player_giants = am.player_giants;
							
			-- return true when any giants in the player's army become visible
			local num_visible_player_giants = num_units_passing_test(
				player_giants,
				function(unit)
					return unit:is_visible_to_alliance(enemy_alliance);
				end
			);
			
			return num_visible_player_giants > 0;
		end
	);

	am:add_halt_condition(true, "ScriptEventBattleArmiesEngaging");
end;














--
--	enemy flying units
--
if not bm:get_value_for_current_campaign("block_enemy_flying_units", false) then
	local am = advice_monitor:new(
		"enemy_flying_units",
		32,
		-- The enemy field flying troops, my lord. Bring them down if they approach your forces.
		bm:get_value_for_current_campaign("war.battle.advice.flying_units.001"),
		{
			bm:get_value_for_current_campaign("war.battle.advice.flying_units.info_001"),
			bm:get_value_for_current_campaign("war.battle.advice.flying_units.info_002"),
			bm:get_value_for_current_campaign("war.battle.advice.flying_units.info_003")
		}
	);

	am:add_halt_on_advice_monitor_triggering("player_flying_units");

	am:add_start_condition(
		function()
			return not bm:is_siege_battle()
		end,
		"ScriptEventConflictPhaseBegins"
	);

	am:add_trigger_condition(
		function()		
			local player_alliance = am.player_alliance;
			local enemy_flying_units = am.enemy_flying_units;
			
			if not enemy_flying_units then
				-- build a list of all flying in the enemy alliance
				enemy_flying_units = get_all_matching_units(
					bm:get_non_player_alliance(), 
					function(unit)
						return unit:can_fly()
					end
				);
				
				am.enemy_flying_units = enemy_flying_units;
				
				if #enemy_flying_units == 0 then
					am:halt("enemy has no flying units");
					return false;
				end;
				
				player_alliance = bm:get_player_alliance();
				am.player_alliance = player_alliance;
			end;
					
			local num_visible_enemy_flying_units = num_units_passing_test(
				enemy_flying_units,
				function(unit)
					return unit:is_visible_to_alliance(player_alliance);
				end
			);
			
			return num_visible_enemy_flying_units > 1;
		end
	);

	am:add_halt_condition(true, "ScriptEventBattleArmiesEngaging");
end;











--
--	player_flying_units
--
if not bm:get_value_for_current_campaign("block_player_flying_units", false) then
	local am = advice_monitor:new(
		"player_flying_units",
		30,
		-- Your flying units afford you great flexibility, Commander. Scout and harass the enemy as they manoeuvre.
		bm:get_value_for_current_campaign("war.battle.advice.flying_units.002"),
		{
			bm:get_value_for_current_campaign("war.battle.advice.flying_units.info_001"),
			bm:get_value_for_current_campaign("war.battle.advice.flying_units.info_002"),
			bm:get_value_for_current_campaign("war.battle.advice.flying_units.info_003")
		}
	);

	am:add_halt_on_advice_monitor_triggering("enemy_flying_units");
	am:set_advice_level(ADVICE_LEVEL_HIGH);

	am:add_start_condition(
		function()
			if bm:is_siege_battle() then
				return false;
			end;
		
			local player_flying_units = num_units_passing_test(
				bm:get_player_army(), 
				function(unit)
					return unit:can_fly()
				end
			);
					
			return player_flying_units > 0;
		end,
		"ScriptEventConflictPhaseBegins"
	);

	am:add_trigger_condition(
		function()
			return true;
		end
	);

	am:add_halt_condition(true, "ScriptEventBattleArmiesEngaging");
end;











--
--	enemy artillery
--
if not bm:get_value_for_current_campaign("block_enemy_artillery", false) then
	local infotext = {
		bm:get_value_for_current_campaign("war.battle.advice.artillery.info_001"),
		bm:get_value_for_current_campaign("war.battle.advice.artillery.info_002"),
	}

	-- add additional infotext is it's not blocked
	if not bm:get_value_for_current_campaign("block_war.battle.advice.artillery.info_003", false) then
		table.insert(infotext, bm:get_value_for_current_campaign("war.battle.advice.artillery.info_003"));
	end;

	local am = advice_monitor:new(
		"enemy_artillery",
		42,
		-- The enemy bring mighty weapons of war to the battle! Have them destroyed, Commander, or they will decimate your troops from afar.
		bm:get_value_for_current_campaign("war.battle.advice.artillery.001"),
		infotext
	);

	am:add_halt_on_advice_monitor_triggering("player_artillery");

	am:add_start_condition(
		function()
			return not bm:is_siege_battle() and not bool_is_intro_battle;
		end,
		"ScriptEventConflictPhaseBegins"
	);

	am:add_trigger_condition(
		function()		
			local player_alliance = am.player_alliance;
			local enemy_artillery = am.enemy_artillery;
			
			if not enemy_artillery then		
				-- build a list of all flying in the enemy alliance
				enemy_artillery = get_all_matching_units(
					bm:get_non_player_alliance(), 
					function(unit)
						return unit:unit_class() == "art_fld"
					end
				);
				
				am.enemy_artillery = enemy_artillery;
				
				if #enemy_artillery == 0 then
					am:halt("enemy has no artillery");
					return false;
				end;
				
				player_alliance = bm:get_player_alliance();
				am.player_alliance = player_alliance;
			end;
					
			local num_visible_enemy_artillery = num_units_passing_test(
				enemy_artillery,
				function(unit)
					return unit:is_visible_to_alliance(player_alliance);
				end
			);
			
			return num_visible_enemy_artillery > 0;
		end
	);

	am:add_halt_condition(true, "ScriptEventBattleArmiesEngaging");
end;











--
--	player_artillery
--
if not bm:get_value_for_current_campaign("block_player_artillery", false) then
	local infotext = {
		bm:get_value_for_current_campaign("war.battle.advice.artillery.info_001"),
		bm:get_value_for_current_campaign("war.battle.advice.artillery.info_002"),
	}
	
	-- add additional infotext is it's not blocked
	if not bm:get_value_for_current_campaign("block_war.battle.advice.artillery.info_003", false) then
		table.insert(infotext, bm:get_value_for_current_campaign("war.battle.advice.artillery.info_003"));
	end;
	
	local am = advice_monitor:new(
		"player_artillery",
		34,
		-- Your ranged weapons may prove decisive in the coming battle, Commander. Bring them to bear against the enemy from afar, but be sure to protect them as well.
		bm:get_value_for_current_campaign("war.battle.advice.artillery.002"),
		infotext
	);

	am:add_halt_on_advice_monitor_triggering("enemy_artillery");
	am:set_advice_level(ADVICE_LEVEL_HIGH);

	am:add_start_condition(
		function()	
			local player_artillery = num_units_passing_test(
				bm:get_player_army(), 
				function(unit)
					return unit:unit_class() == "art_fld";
				end
			);
			
			return player_artillery > 0;
		end,
		"ScriptEventConflictPhaseBegins"
	);

	am:add_trigger_condition(
		function()
			return true;
		end
	);

	am:add_halt_condition(true, "ScriptEventBattleArmiesEngaging");
end;












--
--	enemy_cavalry
--
if not bm:get_value_for_current_campaign("block_enemy_cavalry", false) then
	local am = advice_monitor:new(
		"enemy_cavalry",
		28,
		-- The enemy approach on mounts, Commander! Keep your vulnerable units close at hand.
		bm:get_value_for_current_campaign("war.battle.advice.cavalry.001"),
		{
			bm:get_value_for_current_campaign("war.battle.advice.mounted_units.info_001"),
			bm:get_value_for_current_campaign("war.battle.advice.mounted_units.info_002"),
			bm:get_value_for_current_campaign("war.battle.advice.mounted_units.info_003")
		}
	);

	am:add_halt_on_advice_monitor_triggering("player_cavalry");

	am:add_start_condition(
		function()
			return not bm:is_siege_battle()
		end,
		"ScriptEventConflictPhaseBegins"
	);

	am:add_trigger_condition(
		function()		
			local player_alliance = am.player_alliance;
			local enemy_cavalry = am.enemy_cavalry;
			
			if not enemy_cavalry then
				-- build a list of all flying in the enemy alliance
				enemy_cavalry = get_all_matching_units(
					bm:get_non_player_alliance(), 
					function(unit)
						return unit:is_cavalry()
					end
				);
				
				am.enemy_cavalry = enemy_cavalry;
				
				if #enemy_cavalry == 0 then
					am:halt("enemy has no cavalry");
					return false;
				end;
				
				player_alliance = bm:get_player_alliance();
				am.player_alliance = player_alliance;
			end;
					
			local num_visible_enemy_cavalry = num_units_passing_test(
				enemy_cavalry,
				function(unit)
					return unit:is_visible_to_alliance(player_alliance) and distance_between_forces(player_alliance, enemy_cavalry) < 300;
				end
			);
			
			return num_visible_enemy_cavalry > 1;
		end
	);

	am:add_halt_condition(true, "ScriptEventBattleArmiesEngaging");
end;







--
--	player_cavalry
--
if not bm:get_value_for_current_campaign("block_player_cavalry", false) then
	local am = advice_monitor:new(
		"player_cavalry",
		26,
		-- Be sure to use your mounted soldiers to full effect, Commander. Harass the enemy formation and strike at their weakest points.
		bm:get_value_for_current_campaign("war.battle.advice.cavalry.002"),
		{
			bm:get_value_for_current_campaign("war.battle.advice.mounted_units.info_001"),
			bm:get_value_for_current_campaign("war.battle.advice.mounted_units.info_002"),
			bm:get_value_for_current_campaign("war.battle.advice.mounted_units.info_003")
		}
	);

	am:add_halt_on_advice_monitor_triggering("enemy_cavalry");
	am:set_advice_level(ADVICE_LEVEL_HIGH);

	am:add_start_condition(
		function()
			if bm:is_siege_battle() and bm:get_campaign_key() ~= "wh3_main_prologue" then
				return false;
			end;
			
			local num_player_cavalry, num_player_units = num_units_passing_test(
				bm:get_player_army(), 
				function(unit)
					return unit:is_cavalry()
				end
			);
			
			if num_player_units == 0 then
				return false;
			end;
			
			-- trigger if more than 10% of the player's army is cavalry. In prologue, trigger if the player has at least 1 cav.
			if bm:get_campaign_key() == "wh3_main_prologue" then
				return true
			else
				return num_player_cavalry / num_player_units > 0.1;
			end
		end,
		"ScriptEventConflictPhaseBegins"
	);

	am:add_trigger_condition(
		function()
			return true;
		end
	);

	am:add_halt_condition(true, "ScriptEventBattleArmiesEngaging");
end;















--
--	player_fatigue_during_battle
--
if not bm:get_value_for_current_campaign("block_player_fatigue_during_battle", false) then
	local am = advice_monitor:new(
		"player_fatigue_during_battle",
		32,
		-- Your warriors tire, mighty lord, their exertions dull their ability to fight. Give them time to rest, even amidst the thickest of battles.
		bm:get_value_for_current_campaign("war.battle.advice.fatigue.002"),
		{
			bm:get_value_for_current_campaign("war.battle.advice.vigour.info_001"),
			bm:get_value_for_current_campaign("war.battle.advice.vigour.info_002"),
			bm:get_value_for_current_campaign("war.battle.advice.vigour.info_003")
		}
	);

	am:add_halt_on_advice_monitor_triggering("player_fatigue_battle_start");

	am:add_start_condition(
		function()
			return not bm:is_siege_battle();
		end,
		"ScriptEventConflictPhaseBegins"
	);

	am:add_trigger_condition(
		function()		
			local player_units = am.player_units;
			
			if not player_units then
				-- cache the player's army
				player_units = bm:get_player_army():units();
				am.player_units = player_units;
			end;
			
			local num_fatigued_units, total_units = num_units_passing_test(
				player_units,
				function(unit)
					local fatigue_state = unit:fatigue_state();
					return fatigue_state == "threshold_tired" or fatigue_state == "threshold_very_tired" or fatigue_state == "threshold_exhausted";
				end
			);
			
			if total_units == 0 then
				return false;
			end;
			
			return num_fatigued_units / total_units > 0.25;
		end
	);
end;













--
--	player_fatigue_battle_start
--
if not bm:get_value_for_current_campaign("block_player_fatigue_battle_start", false) then
	local am = advice_monitor:new(
		"player_fatigue_battle_start",
		55,
		-- Your army has marched long and hard, Commander. The troops have little strength left to fight - use it wisely!
		bm:get_value_for_current_campaign("war.battle.advice.fatigue.001"),
		{
			bm:get_value_for_current_campaign("war.battle.advice.vigour.info_001"),
			bm:get_value_for_current_campaign("war.battle.advice.vigour.info_002"),
			bm:get_value_for_current_campaign("war.battle.advice.vigour.info_003")
		}
	);

	am:add_trigger_condition(
		function()
			local player_units = bm:get_player_army():units();		
			local num_fatigued_units, total_units = num_units_passing_test(
				player_units,
				function(unit)
					local fatigue_state = unit:fatigue_state();
					return fatigue_state == "threshold_tired" or fatigue_state == "threshold_very_tired" or fatigue_state == "threshold_exhausted";
				end
			);
			
			if total_units == 0 then
				return false;
			end;
			
			return num_fatigued_units / total_units > 0.5;
		end,
		"ScriptEventConflictPhaseBegins" 
	);
end;














--
--	tactical_maps
--
if not bm:get_value_for_current_campaign("block_tactical_maps", false) then
	local am = advice_monitor:new(
		"tactical_maps",
		5,
		-- Be sure to use the maps available to assist your tactical planning, Commander.
		bm:get_value_for_current_campaign("war.battle.advice.maps.001"),
		{
			bm:get_value_for_current_campaign("war.battle.advice.tactical_map.info_001"),
			bm:get_value_for_current_campaign("war.battle.advice.tactical_map.info_002"),
			bm:get_value_for_current_campaign("war.battle.advice.tactical_map.info_003")
		}
	);

	-- advice_tactical_maps:set_delay_before_triggering(5000);
	am:set_advice_level(ADVICE_LEVEL_HIGH);

	am:add_start_condition(
		function()
			-- only trigger if this is not a siege battle and if the player difficulty is > legendary (where the tactical map isn't available)
			return not bm:is_siege_battle() and bm:get_player_army():army_handicap() >= -2;
		end,
		"ScriptEventConflictPhaseBegins"
	);

	am:add_trigger_condition(
		function()
			return bm:get_distance_between_forces() > 350;
		end
	);

	am:add_halt_condition(true, "ScriptEventBattleArmiesEngaging");
end;










--
--	formations
--
if not bm:get_value_for_current_campaign("block_formations", false) then
	local am = advice_monitor:new(
		"formations",
		0,
		-- Group your units for best effect, Commander. Formations may be useful when manoeuvring before the enemy.
		bm:get_value_for_current_campaign("war.battle.advice.formations.001"),
		{
			bm:get_value_for_current_campaign("war.battle.advice.formations.info_001"),
			bm:get_value_for_current_campaign("war.battle.advice.formations.info_002"),
			bm:get_value_for_current_campaign("war.battle.advice.formations.info_003"),
			bm:get_value_for_current_campaign("war.battle.advice.formations.info_004")
		}
	);

	am:set_delay_before_triggering(5000);
	am:set_advice_level(ADVICE_LEVEL_HIGH);

	am:add_start_condition(
		function()
			if bm:is_siege_battle() then
				return false;
			end;
		
			-- only continue if the player has more than ten units
			local army = bm:get_player_army();
			return army:units():count() > 10;
		end,
		"ScriptEventConflictPhaseBegins" 
	);

	am:add_trigger_condition(
		function()
			return bm:get_distance_between_forces() < 400;
		end
	);

	am:add_halt_condition(true, "ScriptEventBattleArmiesEngaging");
end;










--
--	fire_at_will
--
if not bm:get_value_for_current_campaign("block_fire_at_will", false) then
	local am = advice_monitor:new(
		"fire_at_will",
		10,
		-- Your troops will fire-at-will without orders to the contrary, Commander. Have them conserve their ammunition if you so wish.
		bm:get_value_for_current_campaign("war.battle.advice.fire_at_will.001"),
		{
			bm:get_value_for_current_campaign("war.battle.advice.fire_at_will.info_001"),
			bm:get_value_for_current_campaign("war.battle.advice.fire_at_will.info_002"),
			bm:get_value_for_current_campaign("war.battle.advice.fire_at_will.info_003"),
			bm:get_value_for_current_campaign("war.battle.advice.fire_at_will.info_004")
		}
	);

	am:set_advice_level(ADVICE_LEVEL_HIGH);

	am:add_start_condition(
		function()
			if bm:is_siege_battle() then
				return false;
			end;
		
			-- only start if the player has more than two units with ammo
			local player_army = bm:get_player_army();
			
			local num_units_with_ammo = num_units_passing_test(
				player_army,
				function(unit)
					return unit:starting_ammo() > 5
				end
			);
					
			return num_units_with_ammo > 1;
		end,
		"ScriptEventConflictPhaseBegins" 
	);

	am:add_trigger_condition(
		function()
			return bm:get_distance_between_forces() < 400;
		end
	);

	am:add_halt_condition(true, "ScriptEventBattleArmiesEngaging");
end;














--
--	attacking_capture_points
--
if not bm:get_value_for_current_campaign("block_player_attacking_capture_points", false) then
	local infotext = {
		bm:get_value_for_current_campaign("war.battle.advice.capture_locations.info_001"),
		bm:get_value_for_current_campaign("war.battle.advice.capture_locations.info_002"),
	}

	-- add additional infotext is it's not blocked
	if not bm:get_value_for_current_campaign("block_war.battle.advice.capture_locations.info_003", false) then
		table.insert(infotext, bm:get_value_for_current_campaign("war.battle.advice.capture_locations.info_003"));
	end;

	local am = advice_monitor:new(
		"player_attacking_capture_points",
		20,
		-- Send troops to capture the enemy defences, Commander. They can be turned to our service.
		bm:get_value_for_current_campaign("war.battle.advice.capture_points.002"),
		infotext
	);

	am:add_start_condition(
		function()				
			return bm:is_siege_battle() and bm:player_is_attacker();
		end,
		"ScriptEventConflictPhaseBegins" 
	);

	am:add_trigger_condition(true, "ScriptEventBattleArmiesEngaging");
end;















--
--	receiving_missile_fire
--
if not bm:get_value_for_current_campaign("block_receiving_missile_fire", false) then
	local am = advice_monitor:new(
		"receiving_missile_fire",
		20,
		-- Your troops come under fire, Commander! Have them find cover, or eliminate the source!
		bm:get_value_for_current_campaign("war.battle.advice.missile_fire.001"),
		{
			bm:get_value_for_current_campaign("war.battle.advice.missile_units.info_001"),
			bm:get_value_for_current_campaign("war.battle.advice.missile_units.info_002"),
			bm:get_value_for_current_campaign("war.battle.advice.missile_units.info_003")
		}
	);

	am:set_delay_before_triggering(5000);

	am:add_start_condition(
		function()
			return not bm:is_siege_battle();
		end,
		"ScriptEventConflictPhaseBegins" 
	);

	am:add_trigger_condition(
		function()
			-- trigger if the player has two or more units under fire
			return bm:get_num_units_under_fire() > 1;
		end
	);

	am:add_halt_condition(function() return bm:get_proportion_engaged() > 0.25 end);
end;
















--
--	player receives reinforcements
--
if not bm:get_value_for_current_campaign("block_player_reinforcements", false) then
	local player_reinforcements_priority = 30
	
	if bm:get_campaign_key() == "wh3_main_prologue" then
		player_reinforcements_priority = 90
	end

	local infotext = {
		bm:get_value_for_current_campaign("war.battle.advice.reinforcements.info_001"),
		bm:get_value_for_current_campaign("war.battle.advice.reinforcements.info_002"),
	}

	-- add additional infotext is it's not blocked
	if not bm:get_value_for_current_campaign("block_war.battle.advice.reinforcements.info_003", false) then
		table.insert(infotext, bm:get_value_for_current_campaign("war.battle.advice.reinforcements.info_003"));
	end;

	local am = advice_monitor:new(
		"player_reinforcements",
		player_reinforcements_priority,
		-- Allied reinforcements are arriving in support, Commander! Link up with them and surround the enemy.
		bm:get_value_for_current_campaign("war.battle.advice.reinforcements.001"),
		infotext
	);


	am:add_start_condition(
		function()
			if bm:get_campaign_key() == "wh3_main_prologue" then
				return true
			else
				return not bm:is_siege_battle();
			end
		end,
		"ScriptEventConflictPhaseBegins" 
	);


	am:add_trigger_condition(
		function(context)
			return context.string == "adc_own_reinforcements"
		end,
		"BattleAideDeCampEvent"
	);
end












--
--	enemy receives reinforcements
--
if not bm:get_value_for_current_campaign("block_enemy_reinforcements", false) then
	local enemy_reinforcements_priority = 32
	
	if bm:get_campaign_key() == "wh3_main_prologue" then
		enemy_reinforcements_priority = 95
	end

	local infotext = {
		bm:get_value_for_current_campaign("war.battle.advice.reinforcements.info_001"),
		bm:get_value_for_current_campaign("war.battle.advice.reinforcements.info_002")
	}

	-- add additional infotext is it's not blocked
	if not bm:get_value_for_current_campaign("block_war.battle.advice.reinforcements.info_003", false) then
		table.insert(infotext, bm:get_value_for_current_campaign("war.battle.advice.reinforcements.info_003"));
	end;

	local am = advice_monitor:new(
		"enemy_reinforcements",
		enemy_reinforcements_priority,
		-- Enemy reinforcements are approaching! Attack with caution, Commander.
		bm:get_value_for_current_campaign("war.battle.advice.reinforcements.002"),
		infotext
	);


	am:add_start_condition(
		function()
			if bm:get_campaign_key() == "wh3_main_prologue" then
				return true
			else
				return not bm:is_siege_battle();
			end
		end,
		"ScriptEventConflictPhaseBegins" 
	);


	am:add_trigger_condition(
		function(context)
			return context.string == "adc_enemy_reinforcements"
		end,
		"BattleAideDeCampEvent"
	);
end



























--
--	enemy capture victory point
--
if not bm:get_value_for_current_campaign("block_enemy_capture_victory_location", false) then
	local infotext = {
		bm:get_value_for_current_campaign("war.battle.advice.victory_locations.info_005"),
		bm:get_value_for_current_campaign("war.battle.advice.victory_locations.info_006"),
		bm:get_value_for_current_campaign("war.battle.advice.victory_locations.info_009")
	}

	-- add additional infotext is it's not blocked
	if not bm:get_value_for_current_campaign("block_war.battle.advice.victory_locations.info_008", false) then
		table.insert(infotext, bm:get_value_for_current_campaign("war.battle.advice.victory_locations.info_008"));
	end;

	local am = advice_monitor:new(
		"enemy_capture_victory_point",
		32,
		-- The enemy capture the city centre, Commander! Retake it quickly, before the city falls!
		bm:get_value_for_current_campaign("war.battle.advice.victory_points.001"),
		infotext
	);

	am:set_can_interrupt_other_advice(true);


	am:add_start_condition(
		function()
			return bm:is_siege_battle() and not bm:player_is_attacker() and bm:battle_type() == SIEGE_BATTLE_MAJOR
		end,
		"ScriptEventConflictPhaseBegins" 
	);


	am:add_trigger_condition(
		function(context)
			local contesting_unit = context:battle_unit();
			local capture_location = context:battle_capture_location();
			
			if contesting_unit and contesting_unit:alliance_index() == bm:get_non_player_alliance_num() then
				-- If a major settlement battle, check to see this is the main victory point.
				return capture_location:type() == "victory_point_plaza"
			end
		end,
		"BattleCaptureLocationCaptureCompleted"
	);
end;














--
--	enemy capturing victory point
--
if not bm:get_value_for_current_campaign("block_enemy_capturing_victory_location", false) then
	local infotext = {
		bm:get_value_for_current_campaign("war.battle.advice.victory_locations.info_005"),
		bm:get_value_for_current_campaign("war.battle.advice.victory_locations.info_006"),
		bm:get_value_for_current_campaign("war.battle.advice.victory_locations.info_009")
	}

	-- add additional infotext is it's not blocked
	if not bm:get_value_for_current_campaign("block_war.battle.advice.victory_locations.info_008", false) then
		table.insert(infotext, bm:get_value_for_current_campaign("war.battle.advice.victory_locations.info_008"));
	end;

	local am = advice_monitor:new(
		"enemy_capturing_victory_point",
		50,
		-- The city is falling to the enemy, Commander! Intercept them before it is taken!
		bm:get_value_for_current_campaign("war.battle.advice.victory_points.002"),
		infotext
	);

	am:set_can_interrupt_other_advice(true);


	am:add_start_condition(
		function()
			return bm:is_siege_battle() and not bm:player_is_attacker();
		end,
		"ScriptEventConflictPhaseBegins" 
	);


	am:add_trigger_condition(
		function(context)
			local contesting_unit = context:battle_unit();
			local capture_location = context:battle_capture_location();

			return (contesting_unit and contesting_unit:alliance_index() == bm:get_non_player_alliance_num()) and capture_location:contributes_to_victory();
		end,
		"BattleCaptureLocationCaptureCommenced"
	);
end;

















--
--	enemy capturing gates
--
if not bm:get_value_for_current_campaign("block_enemy_capturing_gates", false) then
	local infotext = {
		bm:get_value_for_current_campaign("war.battle.advice.capture_locations.info_001"),
		bm:get_value_for_current_campaign("war.battle.advice.capture_locations.info_002"),
	}

	-- add additional infotext is it's not blocked
	if not bm:get_value_for_current_campaign("block_war.battle.advice.capture_locations.info_003", false) then
		table.insert(infotext, bm:get_value_for_current_campaign("war.battle.advice.capture_locations.info_003"));
	end;

	local am = advice_monitor:new(
		"enemy_capturing_gates",
		20,
		-- The enemy are taking the walls, Commander! Drive them back!
		bm:get_value_for_current_campaign("war.battle.advice.capture_points.001"),
		infotext
	);


	am:add_start_condition(
		function()
			return bm:is_siege_battle() and not bm:player_is_attacker();
		end,
		"ScriptEventConflictPhaseBegins" 
	);


	am:add_trigger_condition(
		function(context)
			return context.string == "adc_enemy_capturing_gates"
		end,
		"BattleAideDeCampEvent"
	);


	am:add_trigger_condition(
		function(context)
			return context.string == "adc_own_tower_captured"
		end,
		"BattleAideDeCampEvent"
	);
end;


















--
--	player captures victory point
--
if not bm:get_value_for_current_campaign("block_player_captures_victory_location", false) then
	local infotext = {
		bm:get_value_for_current_campaign("war.battle.advice.victory_locations.info_005"),
		bm:get_value_for_current_campaign("war.battle.advice.victory_locations.info_006"),
		bm:get_value_for_current_campaign("war.battle.advice.victory_locations.info_010")
	}

	-- add additional infotext is it's not blocked
	if not bm:get_value_for_current_campaign("block_war.battle.advice.victory_locations.info_008", false) then
		table.insert(infotext, bm:get_value_for_current_campaign("war.battle.advice.victory_locations.info_008"));
	end;
	
	local am = advice_monitor:new(
		"player_captures_victory_point",
		30,
		-- The centre is yours! Defend it against the enemy that remain, my lord. The city will surely fall soon.
		bm:get_value_for_current_campaign("war.battle.advice.victory_points.004"),
		infotext
	);

	am:set_can_interrupt_other_advice(true);


	am:add_start_condition(
		function()
			return bm:is_siege_battle() and bm:player_is_attacker();
		end,
		"ScriptEventConflictPhaseBegins" 
	);


	am:add_trigger_condition(
		function(context)
			local contesting_unit = context:battle_unit();

			if contesting_unit and contesting_unit:alliance_index() == bm:get_player_alliance_num() then
				-- If a major settlement battle, check to see this is the main victory point.
				return context:battle_capture_location():type() == "victory_point_plaza"
			end
		end,
		"BattleCaptureLocationCaptureCompleted"
	);
end;

















--
--	player approaches victory point
--
if not bm:get_value_for_current_campaign("block_player_approaches_victory_location", false) then
	local am = advice_monitor:new(
		"player_approaches_victory_location",
		20,
		-- The heart of the city is within sight, my lord! Press forward!
		bm:get_value_for_current_campaign("war.battle.advice.victory_points.003"),
		{
			bm:get_value_for_current_campaign("war.battle.advice.victory_locations.info_005"),
			bm:get_value_for_current_campaign("war.battle.advice.victory_locations.info_006"),
			bm:get_value_for_current_campaign("war.battle.advice.victory_locations.info_007"),
			bm:get_value_for_current_campaign("war.battle.advice.victory_locations.info_008")
		}
	);

	am:add_start_condition(
		function()
			return bm:is_siege_battle() and bm:player_is_attacker() and #bm:get_victory_locations() > 0;
		end,
		"ScriptEventConflictPhaseBegins" 
	);


	am:add_trigger_condition(
		function()
			local victory_locations = bm:get_victory_locations();
			local player_sunits = bm:get_scriptunits_for_local_players_army();
			for i = 1, #victory_locations do
				local victory_pos = victory_locations[i]:position();
				local closest_sunit, distance = player_sunits:get_closest(victory_pos, true);
				if distance < 250 then
					return true;
				end;
			end
		end
	);
end;














--
--	player has high ground
--
if not bm:get_value_for_current_campaign("block_player_has_high_ground", false) then
	local infotext = {
		bm:get_value_for_current_campaign("war.battle.advice.terrain.info_001"),
		bm:get_value_for_current_campaign("war.battle.advice.terrain.info_002"),
		bm:get_value_for_current_campaign("war.battle.advice.terrain.info_005")
	}

	-- add additional infotext is it's not blocked
	if not bm:get_value_for_current_campaign("block_war.battle.advice.terrain.info_004", false) then
		table.insert(infotext, bm:get_value_for_current_campaign("war.battle.advice.terrain.info_004"));
	end;

	local am = advice_monitor:new(
		"player_has_high_ground",
		10,
		-- The high ground is yours, Commander. Be sure to use it to best advantage.
		bm:get_value_for_current_campaign("war.battle.advice.high_ground.001"),
		infotext
	);

	am:add_halt_on_advice_monitor_triggering("enemy_has_high_ground");
	am:set_advice_level(ADVICE_LEVEL_HIGH);

	am:add_start_condition(
		function()
			return not bm:is_siege_battle() and bm:get_player_alliance():armies():count() == 1 and bm:get_non_player_alliance():armies():count() == 1;
		end,
		"ScriptEventConflictPhaseBegins" 
	);


	am:add_trigger_condition(
		function()
			-- return true if the player <> enemy height difference is more than 10% of the distance between them
			return (bm:get_player_army_altitude() - bm:get_enemy_army_altitude()) * 10 > bm:get_distance_between_forces();
		end
	);

	am:add_halt_condition(true, "ScriptEventBattleArmiesEngaging");
end;







--
--	enemy has high ground
--
if not bm:get_value_for_current_campaign("block_enemy_has_high_ground", false) then
	local infotext = {
		bm:get_value_for_current_campaign("war.battle.advice.terrain.info_001"),
		bm:get_value_for_current_campaign("war.battle.advice.terrain.info_002"),
		bm:get_value_for_current_campaign("war.battle.advice.terrain.info_005")
	}

	-- add additional infotext is it's not blocked
	if not bm:get_value_for_current_campaign("block_war.battle.advice.terrain.info_004", false) then
		table.insert(infotext, bm:get_value_for_current_campaign("war.battle.advice.terrain.info_004"));
	end;

	local am = advice_monitor:new(
		"enemy_has_high_ground",
		15,
		-- The enemy command the high ground. Attack with caution, my Lord.
		bm:get_value_for_current_campaign("war.battle.advice.high_ground.002"),
		infotext
	);

	am:add_halt_on_advice_monitor_triggering("player_has_high_ground");

	am:add_start_condition(
		function()
			return not bm:is_siege_battle() and bm:get_player_alliance():armies():count() == 1 and bm:get_non_player_alliance():armies():count() == 1;
		end,
		"ScriptEventConflictPhaseBegins" 
	);

	am:add_trigger_condition(
		function()
			-- return true if the enemy <> player height difference is more than 10% of the distance between them
			local enemy_altitude = bm:get_enemy_army_altitude();
			local player_altitude = bm:get_player_army_altitude();
			local distance_between_forces = bm:get_distance_between_forces();
			
			return (bm:get_enemy_army_altitude() - bm:get_player_army_altitude()) * 10 > bm:get_distance_between_forces();
		end
	);

	am:add_halt_condition(true, "ScriptEventBattleArmiesEngaging");
end;




















--
--	player_being_flanked
--
if not bm:get_value_for_current_campaign("block_player_being_flanked", false) then
	local am = advice_monitor:new(
		"player_being_flanked",
		20,
		-- The enemy attack your flank, Commander! Drive them off!
		bm:get_value_for_current_campaign("war.battle.advice.flanking.001"),
		{
			bm:get_value_for_current_campaign("war.battle.advice.flanking.info_001"),
			bm:get_value_for_current_campaign("war.battle.advice.flanking.info_002"),
			bm:get_value_for_current_campaign("war.battle.advice.flanking.info_003")
		}
	);

	am:add_start_condition(
		function()
			return not bm:is_siege_battle();
		end,
		"ScriptEventConflictPhaseBegins" 
	);

	am:add_trigger_condition(
		function()
			local player_army = am.player_army;
			
			-- cache player army if we don't have it
			if not player_army then
				player_army = bm:get_player_army();
				am.player_army = player_army;
			end;
			
			local num_player_units_flanked, num_player_units = num_units_passing_test(
				player_army,
				function(unit)
					return unit:is_left_flank_threatened() or unit:is_right_flank_threatened() or unit:is_rear_flank_threatened();
				end
			);
			
			-- try and trigger if more than one unit is being flanked
			return num_player_units_flanked > 2;
		end
	);
end;


















--
--	player_units_hidden
--
if not bm:get_value_for_current_campaign("block_player_units_hidden", false) then
	local infotext = {
		bm:get_value_for_current_campaign("war.battle.advice.terrain.info_001"),
		bm:get_value_for_current_campaign("war.battle.advice.terrain.info_002"),
		bm:get_value_for_current_campaign("war.battle.advice.terrain.info_003"),
	}

	-- add additional infotext is it's not blocked
	if not bm:get_value_for_current_campaign("block_war.battle.advice.terrain.info_004", false) then
		table.insert(infotext, bm:get_value_for_current_campaign("war.battle.advice.terrain.info_004"));
	end;

	local am = advice_monitor:new(
		"player_units_hidden",
		20,
		-- The trees may be used to conceal your movements, Commander. Close with the enemy under cover of forest to retain the element of surprise.
		bm:get_value_for_current_campaign("war.battle.advice.forests.001"),
		infotext
	);

	am:add_halt_on_advice_monitor_triggering("enemy_units_hidden");
	am:set_advice_level(ADVICE_LEVEL_HIGH);

	am:add_start_condition(
		function()
			return not bm:is_siege_battle();
		end,
		"ScriptEventConflictPhaseBegins" 
	);

	am:add_trigger_condition(
		function()
			local player_army = am.player_army;
			
			-- cache player army if we don't have it
			if not player_army then
				player_army = bm:get_player_army();
				am.player_army = player_army;
			end;
			
			local num_player_units_hidden, num_player_units = num_units_passing_test(
				player_army,
				function(unit)
					return unit:is_hidden();
				end
			);
			
			-- try and trigger if more than one unit is being flanked
			return num_player_units_hidden > 1;
		end
	);

	am:add_halt_condition(true, "ScriptEventBattleArmiesEngaging");
end;















--
--	enemy_units_hidden
--
if not bm:get_value_for_current_campaign("block_enemy_units_hidden", false) then
	local infotext = {
		bm:get_value_for_current_campaign("war.battle.advice.terrain.info_001"),
		bm:get_value_for_current_campaign("war.battle.advice.terrain.info_002"),
		bm:get_value_for_current_campaign("war.battle.advice.terrain.info_003")
	}

	-- add additional infotext is it's not blocked
	if not bm:get_value_for_current_campaign("block_war.battle.advice.terrain.info_004", false) then
		table.insert(infotext, bm:get_value_for_current_campaign("war.battle.advice.terrain.info_004"));
	end;

	local am = advice_monitor:new(
		"enemy_units_hidden",
		24,
		-- The enemy use the forests to conceal their movements, my Lord! Approach with caution.
		bm:get_value_for_current_campaign("war.battle.advice.forests.002"),
		infotext
	);

	am:add_halt_on_advice_monitor_triggering("player_units_hidden");

	am:add_start_condition(
		function()
			return not bm:is_siege_battle();
		end,
		"ScriptEventConflictPhaseBegins" 
	);

	am:add_trigger_condition(
		function(context)
			return context.string == "adc_enemy_hidden_unit_spotted"
		end,
		"BattleAideDeCampEvent"
	);

	am:add_halt_condition(true, "ScriptEventBattleArmiesEngaging");
end;
























--
--	winds_of_magic_blowing
--
if not bm:get_value_for_current_campaign("block_winds_of_magic_blowing", false) then
	local am = advice_monitor:new(
		"winds_of_magic_blowing",
		24,
		-- The Winds of Magic blow strongly in this place, Commander. Harness its power and channel it against your enemy.
		bm:get_value_for_current_campaign("war.battle.advice.winds_of_magic.001"),
		{
			bm:get_value_for_current_campaign("war.battle.advice.winds_of_magic.info_001"),
			bm:get_value_for_current_campaign("war.battle.advice.winds_of_magic.info_002"),
			bm:get_value_for_current_campaign("war.battle.advice.winds_of_magic.info_003")
		}
	);

	-- am:add_halt_on_advice_monitor_triggering("enemy_uses_magic");

	am:add_start_condition(
		function()
			if bm:is_siege_battle() then
				return false;
			end;
		
			local player_units = bm:get_player_army():units();
			
			for i = 1, player_units:count() do
				if player_units:item(i):can_use_magic() then
					return true;
				end;
			end;
			
			return false;
		end,
		"ScriptEventConflictPhaseBegins" 
	);

	am:add_trigger_condition(
		function(context)
			local player_army = am.player_army;
			
			-- cache player army if we don't have it
			if not player_army then
				player_army = bm:get_player_army();
				am.player_army = player_army;
			end;
			
			local recharge_rate = player_army:winds_of_magic_remaining_recharge_rate();
			
			bm:out("advice_winds_of_magic_blowing :: recharge_rate is " .. tostring(recharge_rate));
				
			return recharge_rate > 0.5;
		end
	);

	am:add_halt_condition(true, "ScriptEventBattleArmiesEngaging");
end;

















--
--	magic_overcasting
--
if not bm:get_value_for_current_campaign("block_magic_overcasting", false) then
	local infotext = {
		bm:get_value_for_current_campaign("war.battle.advice.spells.info_001"),
		bm:get_value_for_current_campaign("war.battle.advice.spells.info_002"),
		bm:get_value_for_current_campaign("war.battle.advice.spells.info_003")
	}

	-- add additional infotext is it's not blocked
	if not bm:get_value_for_current_campaign("block_war.battle.advice.spells.info_004", false) then
		table.insert(infotext, bm:get_value_for_current_campaign("war.battle.advice.spells.info_004"));
	end;

	local am = advice_monitor:new(
		"magic_overcasting",
		10,
		-- Spells may be overcast to increase their potency, my Lord. Yet I advise caution: channelling so much raw magic at once brings the risk of disaster.
		bm:get_value_for_current_campaign("war.battle.advice.spells.001"),
		infotext
	);


	am:add_start_condition(
		function()
			if bm:is_siege_battle() then
				return false;
			end;
		
			local player_units = bm:get_player_army():units();
			
			for i = 1, player_units:count() do
				if player_units:item(i):can_use_magic() then
					return true;
				end;
			end;
			
			return false;
		end,
		"ScriptEventConflictPhaseBegins" 
	);


	am:add_trigger_condition(
		function()
			return bm:get_distance_between_forces() < 350;
		end
	);

	am:add_halt_condition(true, "ScriptEventBattleArmiesEngaging");
end;




















--
--	army_abilities
--
if not bm:get_value_for_current_campaign("block_army_abilities", false) then
	local am = advice_monitor:new(
		"army_abilities",
		25,
		-- You army marches into battle with great powers, my Lord. Be sure to make use of them.
		bm:get_value_for_current_campaign("wh2.battle.advice.army_abilities.001"),
		{
			bm:get_value_for_current_campaign("wh2.battle.advice.army_abilities.info_001"),
			bm:get_value_for_current_campaign("wh2.battle.advice.army_abilities.info_002"),
			bm:get_value_for_current_campaign("wh2.battle.advice.army_abilities.info_003")
		}
	);


	am:add_trigger_condition(
		function()
			-- trigger if the army abilities panel is visible
			local uic_army_abilities = find_uicomponent(core:get_ui_root(), "army_ability_parent");
			return uic_army_abilities and uic_army_abilities:Visible(true);
		end,
		"ScriptEventConflictPhaseBegins"
	);
end;
















--
--	unit_positioning
--
if not bm:get_value_for_current_campaign("block_unit_positioning", false) then
	local am = advice_monitor:new(
		"unit_positioning",
		90,
		-- Be sure to position your troops accurately in battle, my Lord. Drag out your formations for best effect.
		bm:get_value_for_current_campaign("wh2.battle.advice.positioning.001"),
		{
			bm:get_value_for_current_campaign("wh2.battle.intro.info_050"),
			bm:get_value_for_current_campaign("wh2.battle.intro.info_051"),
			bm:get_value_for_current_campaign("wh2.battle.intro.info_052"),
			bm:get_value_for_current_campaign("wh2.battle.intro.info_053")
		}
	);


	am:set_delay_before_triggering(5000);
	am:set_advice_level(ADVICE_LEVEL_LOW_HIGH);

	am:add_trigger_condition(
		true,
		"ScriptEventConflictPhaseBegins"
	);

	am:add_halt_condition(true, "ScriptEventBattleArmiesEngaging");
end;



















--
--	murderous_prowess
--
if not bm:get_value_for_current_campaign("block_murderous_prowess", false) then
	local am = advice_monitor:new(
		"murderous_prowess",
		50,
		-- Divine blessings may be earned by your kind through the act of killing, cunning Lord. Lead your fellow Druchii to slaughter in battle and they will gain great favour from Khaine, Lord of Murder.
		bm:get_value_for_current_campaign("wh2.battle.advice.murderous_prowess.001"),
		{
			bm:get_value_for_current_campaign("wh2.battle.advice.murderous_prowess.info_001"),
			bm:get_value_for_current_campaign("wh2.battle.advice.murderous_prowess.info_002"),
			bm:get_value_for_current_campaign("wh2.battle.advice.murderous_prowess.info_003")
		}
	);


	am:set_delay_before_triggering(5000);
	am:set_advice_level(ADVICE_LEVEL_LOW_HIGH);

	am:add_trigger_condition(
		function()	
			-- return true if the player is dark elves
			return bm:player_army_is_subculture("wh2_main_sc_def_dark_elves")
		end,
		"ScriptEventConflictPhaseBegins"
	);
end;















--
--	rampaging
--
if not bm:get_value_for_current_campaign("block_rampaging", false) then
	local am = advice_monitor:new(
		"rampaging",
		55,
		-- Your warriors rampage, mighty Lord! They no longer respond to orders!
		bm:get_value_for_current_campaign("wh2.battle.advice.rampaging.001"),
		{
			bm:get_value_for_current_campaign("wh2.battle.advice.rampaging.info_001"),
			bm:get_value_for_current_campaign("wh2.battle.advice.rampaging.info_002"),
			bm:get_value_for_current_campaign("wh2.battle.advice.rampaging.info_003")
		}
	);


	am:set_advice_level(ADVICE_LEVEL_LOW_HIGH);
	am:set_can_interrupt_other_advice(true);

	am:add_start_condition(
		function()	
			-- return true if the player is lizardmen
			return bm:player_army_is_subculture("wh2_main_sc_lzd_lizardmen")
		end,
		"ScriptEventConflictPhaseBegins"
	);


	am:add_trigger_condition(
		function()	
			-- trigger if any of the player's units are rampaging
			local player_units = bm:get_player_army():units();
			
			for i = 1, player_units:count() do
				if player_units:item(i):is_rampaging() then
					return true;
				end;
			end;
		end
	);
end;













--
--	realm_of_souls
--
if not bm:get_value_for_current_campaign("block_realm_of_souls", false) then
	local am = advice_monitor:new(
		"realm_of_souls",
		50,
		-- Your warriors may perish, yet their spirits are eternally bound to your service. From the Realm of Souls, the power of those that have fallen in battle continue to assist those that remain.
		bm:get_value_for_current_campaign("dlc09.battle.advice.realm_of_souls.001"),
		{
			bm:get_value_for_current_campaign("dlc09.battle.advice.realm_of_souls.info_001"),
			bm:get_value_for_current_campaign("dlc09.battle.advice.realm_of_souls.info_002"),
			bm:get_value_for_current_campaign("dlc09.battle.advice.realm_of_souls.info_003")
		}
	);


	am:set_delay_before_triggering(2000);
	am:set_advice_level(ADVICE_LEVEL_LOW_HIGH);

	am:add_start_condition(
		function()	
			-- return true if the player is tomb kings
			return bm:player_army_is_subculture("wh2_dlc09_sc_tmb_tomb_kings")
		end,
		"ScriptEventConflictPhaseBegins"
	);


	am:add_trigger_condition(
		function()	
			-- trigger if any of the player's units have taken casualties
			local player_units = bm:get_player_army():units();
			
			for i = 1, player_units:count() do
				local number_men_alive, initial_number_of_men = number_alive(player_units:item(i));
				
				if number_men_alive < initial_number_of_men then
					return true;
				end;
			end;
		end
	);
end;













--
--	vampire coast extra powder
--
if not bm:get_value_for_current_campaign("block_vampire_coast_extra_powder", false) then
	local am = advice_monitor:new(
		"vampire_coast_extra_powder",
		60,
		bm:get_value_for_current_campaign("wh2_dlc11.battle.advice.cst.extra_powder.001")
	);

	am:set_delay_before_triggering(2000);
	am:set_advice_level(ADVICE_LEVEL_LOW_HIGH);

	am:add_trigger_condition(
		function()	
			-- return true if the player is vampire coast
			return bm:player_army_is_subculture("wh2_dlc11_sc_cst_vampire_coast")
		end,
		"ScriptEventConflictPhaseBegins"
	);
end;














--
--	Cathay harmony player
--
if not bm:get_value_for_current_campaign("block_player_cathay_harmony", false) then

	local infotext = {
		bm:get_value_for_current_campaign("war.battle.hp.harmony.001"),
		bm:get_value_for_current_campaign("war.battle.hp.harmony.002"),
		bm:get_value_for_current_campaign("war.battle.hp.harmony.006"),
	};

	local am = advice_monitor:new(
		"player_harmony",
		50,
		-- Maintain harmony amongst your forces, even in the most chaotic of battles. The defenders of the Celestial Empire fight best when they fight together.
		bm:get_value_for_current_campaign("wh3_main_battle_advice_cathay_harmony_01"),
		infotext
	);

	am:set_advice_level(ADVICE_LEVEL_LOW_HIGH);

	am:add_trigger_condition(
		function()
			-- return true if the player is cathay
			return bm:player_army_is_subculture("wh3_main_sc_cth_cathay")
		end,
		"ScriptEventConflictPhaseBegins"
	);
end;










--
--	Cathay harmony enemy
--
if not bm:get_value_for_current_campaign("block_enemy_cathay_harmony", false) then

	local infotext = {
		bm:get_value_for_current_campaign("war.battle.hp.harmony.001"),
		bm:get_value_for_current_campaign("war.battle.hp.harmony.002"),
		bm:get_value_for_current_campaign("war.battle.hp.harmony.006"),
	};

	local am = advice_monitor:new(
		"enemy_harmony",
		40,
		-- The forces of Cathay are most effective when fighting in an ordered formation. Be wary of disrupting them, and breaking the harmony on which their fighting strength depends!
		bm:get_value_for_current_campaign("wh3_main_battle_advice_cathay_harmony_02"),
		infotext
	);

	am:set_advice_level(ADVICE_LEVEL_HIGH);

	am:add_trigger_condition(
		function()
			-- return true if the primary enemy army is cathay
			return bm:get_first_non_player_army():subculture_key() == "wh3_main_sc_cth_cathay";
		end,
		"ScriptEventConflictPhaseBegins"
	);
end;














--
--	Cathay mastery of the elemental winds
--
if not bm:get_value_for_current_campaign("block_player_cathay_elemental_winds", false) then

	local infotext = {
		bm:get_value_for_current_campaign("war.battle.hp.mastery_of_the_elemental_winds.001"),
		bm:get_value_for_current_campaign("war.battle.hp.mastery_of_the_elemental_winds.002"),
		bm:get_value_for_current_campaign("war.battle.hp.mastery_of_the_elemental_winds.004"),
	};

	local am = advice_monitor:new(
		"player_cathay_elemental_winds",
		45,
		-- Wizards trained in the Celestial Court are stronger when united on the battlefield. More hands allow the Winds of Magic to be wielded with greater potency.
		bm:get_value_for_current_campaign("wh3_main_battle_advice_cathay_mastery_of_the_elemental_winds_01"),
		infotext
	);

	am:set_advice_level(ADVICE_LEVEL_LOW_HIGH);

	am:add_trigger_condition(
		function()
			-- return true if the player is Cathay and has a number of spellcasters in the army
			local player_units = bm:get_player_army():units();
			local count = 0;
			for i = 1, player_units:count() do
				if player_units:item(i):can_use_magic() then
					count = count + 1;
				end;
			end;
			return bm:player_army_is_subculture("wh3_main_sc_cth_cathay") and count >= 2
		end,
		"ScriptEventConflictPhaseBegins"
	);
end;














--
--	Cathay dragon transformation
--
if not bm:get_value_for_current_campaign("block_dragon_transformation", false) then
	local infotext = {
		bm:get_value_for_current_campaign("war.battle.hp.dragon_transformation.001"),
		bm:get_value_for_current_campaign("war.battle.hp.dragon_transformation.002"),
		bm:get_value_for_current_campaign("war.battle.hp.dragon_transformation.005"),
	}

	local am = advice_monitor:new(
		"dragon_transformation",
		40,
		-- You may switch between your aspects as the battle demands, celestial majesty. Strike against your enemies in Dragon form, or use your human guise to empower the troops.
		bm:get_value_for_current_campaign("wh3_main_battle_advice_cathay_dragon_transformation_01"),
		infotext
	);

	am:set_advice_level(ADVICE_LEVEL_LOW_HIGH);

	am:add_trigger_condition(
		function()
			local player_units = bm:get_player_army():units();
			local num_dragon_transform_units, total_units = num_units_passing_test(
				player_units,
				function(unit)
					return unit:can_perform_special_ability("wh3_main_lord_abilities_iron_dragon_dragon_form") or unit:can_perform_special_ability("wh3_main_lord_abilities_storm_dragon_dragon_form");
				end
			);

			if total_units == 0 then
				return false;
			end;

			return bm:player_army_is_subculture("wh3_main_sc_cth_cathay") and num_dragon_transform_units >= 1;
		end,
		"ScriptEventConflictPhaseBegins"
	);
end;














--
--	player plague lord's blessing
--
if not bm:get_value_for_current_campaign("block_player_nurgle_plaguelord_blessing", false) then

	local infotext = {
		bm:get_value_for_current_campaign("war.battle.advice.plague_lords_blessings.info_001"),
		bm:get_value_for_current_campaign("war.battle.advice.plague_lords_blessings.info_002"),
		bm:get_value_for_current_campaign("war.battle.advice.plague_lords_blessings.info_003"),
		bm:get_value_for_current_campaign("war.battle.advice.plague_lords_blessings.info_004")
	};

	local am = advice_monitor:new(
		"player_nurgle_plaguelord_blessing",
		50,
		-- As the Lord of Rebirth, Grandfather Nurgle can restore rent flesh and broken limbs. The blessings of the Plague Lord will replenish your forces, even as they are weakened by enemy action.
		bm:get_value_for_current_campaign("wh3_main_battle_advice_nurgle_plaguelords_blessings_01"),
		infotext
	);

	am:set_advice_level(ADVICE_LEVEL_LOW_HIGH);

	am:add_trigger_condition(
		function()
			-- return true if the player is nurgle
			return bm:player_army_is_subculture("wh3_main_sc_nur_nurgle")
		end,
		"ScriptEventConflictPhaseBegins"
	);
end;














--
--	player slaanesh battle captives
--
if not bm:get_value_for_current_campaign("block_player_slaanesh_batle_captives", false) then

	local infotext = {
		bm:get_value_for_current_campaign("war.battle.advice.sensuous_seductions.info_001"),
		bm:get_value_for_current_campaign("war.battle.advice.sensuous_seductions.info_002"),
		bm:get_value_for_current_campaign("war.battle.advice.sensuous_seductions.info_003"),
		bm:get_value_for_current_campaign("war.battle.advice.sensuous_seductions.info_004")
	};

	local am = advice_monitor:new(
		"player_slaanesh_batle_captives",
		50,
		-- Captives taken in battle make excellent playthings for the Prince of Pleasure! The blessings of Slaanesh will multiply as enemies fall before you.
		bm:get_value_for_current_campaign("wh3_main_battle_advice_slaanesh_captives_01"),
		infotext
	);

	am:set_advice_level(ADVICE_LEVEL_LOW_HIGH);

	am:add_trigger_condition(
		function()
			-- return true if the player is slaanesh
			return bm:player_army_is_subculture("wh3_main_sc_sla_slaanesh")
		end,
		"ScriptEventConflictPhaseBegins"
	);
end;














--
--	player eye of tzeentch
--
if not bm:get_value_for_current_campaign("block_player_eye_of_tzeentch", false) then

	local infotext = {
		bm:get_value_for_current_campaign("war.battle.advice.eye_of_tzeentch.info_001"),
		bm:get_value_for_current_campaign("war.battle.advice.eye_of_tzeentch.info_002"),
		bm:get_value_for_current_campaign("war.battle.advice.eye_of_tzeentch.info_003"),
		bm:get_value_for_current_campaign("war.battle.advice.eye_of_tzeentch.info_004")
	};

	local am = advice_monitor:new(
		"player_slaanesh_eye_of_tzeentch",
		50,
		-- The Winds of Magic embody the arcane power of Tzeentch. Honour The Changer of Ways through acts of sorcery and his blessings will fall upon you.
		bm:get_value_for_current_campaign("wh3_main_battle_advice_tzeentch_eye_of_tzeentch_01"),
		infotext
	);

	am:set_advice_level(ADVICE_LEVEL_LOW_HIGH);

	am:add_trigger_condition(
		function()
			-- return true if the player is tzeentch
			return bm:player_army_is_subculture("wh3_main_sc_tze_tzeentch")
		end,
		"ScriptEventConflictPhaseBegins"
	);
end;














--
--	Storm of magic deployment
--
if not bm:get_value_for_current_campaign("block_storm_of_magic_deployment", false) then

	local infotext = {
		bm:get_value_for_current_campaign("war.battle.hp.storm_of_magic_battles.001"),
		bm:get_value_for_current_campaign("war.battle.hp.storm_of_magic_battles.002"),
		bm:get_value_for_current_campaign("war.battle.hp.storm_of_magic_battles.003"),
		bm:get_value_for_current_campaign("war.battle.hp.storm_of_magic_battles.008"),
	};

	local am = advice_monitor:new(
		"storm_of_magic_deployment",
		65,
		-- A Storm of Magic rages across the sky! Your Sorcerers – and those of the enemy – will have access to unlimited power!
		bm:get_value_for_current_campaign("wh3_main_battle_advice_storm_of_magic_01"),
		infotext
	);

	am:set_advice_level(ADVICE_LEVEL_LOW_HIGH);

	am:add_trigger_condition(
		function()
			-- return true if the player has any spellcasters in the army
			local player_units = bm:get_player_army():units();
			local has_spellcaster = false;
			for i = 1, player_units:count() do
				if player_units:item(i):can_use_magic() then
					has_spellcaster = true;
					break;
				end;
			end;
			return has_spellcaster and bm:is_storm_of_magic_battle()
		end,
		"ScriptEventDeploymentPhaseBegins"
	);
end;














--
--	Storm of magic early battle
--
if not bm:get_value_for_current_campaign("block_storm_of_magic_early_battle", false) then

	local infotext = {
		bm:get_value_for_current_campaign("war.battle.hp.storm_of_magic_battles.001"),
		bm:get_value_for_current_campaign("war.battle.hp.storm_of_magic_battles.004"),
		bm:get_value_for_current_campaign("war.battle.hp.storm_of_magic_battles.005"),
		bm:get_value_for_current_campaign("war.battle.hp.storm_of_magic_battles.006"),
		bm:get_value_for_current_campaign("war.battle.hp.storm_of_magic_battles.008"),
	};

	local am = advice_monitor:new(
		"storm_of_magic_early_battle",
		60,
		-- The tempest of magic roiling above grants access to spells of cataclysmic power.  Use them to wreak destruction on your enemy!
		bm:get_value_for_current_campaign("wh3_main_battle_advice_storm_of_magic_02"),
		infotext
	);

	am:set_advice_level(ADVICE_LEVEL_LOW_HIGH);

	am:add_trigger_condition(
		function()
			-- return true if the player has any spellcasters in the army
			local player_units = bm:get_player_army():units();
			local has_spellcaster = false;
			for i = 1, player_units:count() do
				if player_units:item(i):can_use_magic() then
					has_spellcaster = true;
					break;
				end;
			end;
			return has_spellcaster and bm:is_storm_of_magic_battle()
		end,
		"ScriptEventConflictPhaseBegins"
	);
end;















--
--	Player ogres wallbreaker
--
if not bm:get_value_for_current_campaign("block_player_ogre_wallbreaker", false) then

	local infotext = {
		bm:get_value_for_current_campaign("war.battle.advice.ogres.info_001"),
		bm:get_value_for_current_campaign("war.battle.hp.walls.007"),
		bm:get_value_for_current_campaign("war.battle.hp.walls.009"),
	};

	local am = advice_monitor:new(
		"player_ogre_wallbreaker",
		50,
		-- You Ogres are strong and terrifying creatures. Even the walls of a fortress cannot withstand their mighty blows! Press your attack!
		bm:get_value_for_current_campaign("wh3_main_battle_advice_ogre_wallbreaker_01"),
		infotext
	);

	am:set_advice_level(ADVICE_LEVEL_LOW_HIGH);

	am:add_trigger_condition(
		function()
			-- return true if the player is ogres and is fighting a major settlement siege battle
			return bm:player_army_is_subculture("wh3_main_sc_ogr_ogre_kingdoms") and bm:battle_type() == SIEGE_BATTLE_MAJOR
		end,
		"ScriptEventConflictPhaseBegins"
	);
end;














--
--	player khorne blood god
--
if not bm:get_value_for_current_campaign("block_player_khorne_blood_god", false) then

	local infotext = {
		bm:get_value_for_current_campaign("wh3.battle.advice.blood_for_the_blood_god.info_001"),
		bm:get_value_for_current_campaign("wh3.battle.advice.blood_for_the_blood_god.info_002"),
		bm:get_value_for_current_campaign("wh3.battle.advice.blood_for_the_blood_god.info_003"),
		bm:get_value_for_current_campaign("wh3.battle.advice.blood_for_the_blood_god.info_004")
	};

	local am = advice_monitor:new(
		"player_khorne_blood_god",
		50,
		-- The God of War exalts in killing! Shed blood in the name of Khorne and his favour will fall upon you.
		bm:get_value_for_current_campaign("wh3_main_battle_advice_khorne_blood_for_the_blood_god_01"),
		infotext
	);

	am:set_advice_level(ADVICE_LEVEL_LOW_HIGH);

	am:add_trigger_condition(
		function()
			-- return true if the player is khorne
			return bm:player_army_is_subculture("wh3_main_sc_kho_khorne")
		end,
		"ScriptEventConflictPhaseBegins"
	);
end;