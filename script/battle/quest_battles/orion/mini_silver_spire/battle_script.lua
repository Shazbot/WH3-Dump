load_script_libraries();

local gc = generated_cutscene:new(true);

gb = generated_battle:new(
                false,                                      -- screen starts black
                false,                                      -- prevent deployment for player
                false,                                                 -- prevent deployment for ai
                function() 
                                                                gb:start_generated_cutscene(gc) 
                                                                bm:callback(function() bm:out("triggering dlc05.battle.advice.final.wef.01"); bm:queue_advisor("dlc05.battle.advice.final.wef.01") end, 2000);                                                             
                                                                bm:callback(function() bm:out("triggering dlc05.battle.advice.final.wef.02"); bm:queue_advisor("dlc05.battle.advice.final.wef.02") end, 5500);
                                                                bm:callback(function() bm:out("triggering dlc05.battle.advice.final.wef.03"); bm:queue_advisor("dlc05.battle.advice.final.wef.03") end, 6000);
                end,       -- intro cutscene function
                false                                                  -- debug mode
);

gc:add_element(nil,nil, "gc_qb_silver_spire_01", 8000, false, false, false);
gc:add_element(nil,nil, "gc_qb_silver_spire_02", 7000, false, false, false);
gc:add_element(nil, nil, "gc_orbit_90_medium_commander_front_close_low_01", 8000, true, true, false);

gb:set_cutscene_during_deployment(true);

---------------------------
----HARD SCRIPT VERSION----
---------------------------
--gb:set_objective_on_message("deployment_started", "wh_main_qb_objective_kill_enemy_general");

-------ARMY SETUP-------
-- ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1);	
-- ga_player_ally=gb:get_army(gb:get_player_alliance_num(), 2,"bst_ally");	
-- ga_ai_karl = gb:get_army(gb:get_non_player_alliance_num(), 1,"karl");
-- ga_ai_louen = gb:get_army(gb:get_non_player_alliance_num(), 2,"louen");
-- ga_ai_side_1 = gb:get_army(gb:get_non_player_alliance_num(), 3,"side");
-- ga_ai_side_2 = gb:get_army(gb:get_non_player_alliance_num(), 4,"side_2");
-- ga_ai_back_1 = gb:get_army(gb:get_non_player_alliance_num(), 5,"back_1");
-- ga_ai_back_2 = gb:get_army(gb:get_non_player_alliance_num(), 6,"back_2");
ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1);	
ga_player_ally=gb:get_army(gb:get_player_alliance_num(), 2);

ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), 1);
-- ga_ai_first_02 = gb:get_army(gb:get_non_player_alliance_num(1), 2,"first");
-- ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(1), 2,"left");
-- ga_ai_first_03 = gb:get_army(gb:get_non_player_alliance_num(1), 3,"first");
-- ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(1), 3,"right");
-- ga_ai_04 = gb:get_army(gb:get_non_player_alliance_num(1), 4);

if gb:get_army(gb:get_non_player_alliance_num(), 2):get_script_name() == "left" then
	ga_ai_first_02 = gb:get_army(gb:get_non_player_alliance_num(), 2,"first");
	ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(), 2,"left");
elseif gb:get_army(gb:get_non_player_alliance_num(), 3):get_script_name() == "left" then
	ga_ai_first_02 = gb:get_army(gb:get_non_player_alliance_num(), 3,"first");
	ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(), 3,"left");
else 
	ga_ai_first_02 = gb:get_army(gb:get_non_player_alliance_num(), 4,"first");
	ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(), 4,"left");
end

if gb:get_army(gb:get_non_player_alliance_num(), 2):get_script_name() == "right" then
	ga_ai_first_03 = gb:get_army(gb:get_non_player_alliance_num(), 2,"first");
	ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(), 2,"right");
elseif gb:get_army(gb:get_non_player_alliance_num(), 3):get_script_name() == "right" then
	ga_ai_first_03 = gb:get_army(gb:get_non_player_alliance_num(), 3,"first");
	ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(), 3,"right");
else 
	ga_ai_first_03 = gb:get_army(gb:get_non_player_alliance_num(), 4,"first");
	ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(), 4,"right");
end

if gb:get_army(gb:get_non_player_alliance_num(), 2):get_script_name() == "side" then
	ga_ai_04 = gb:get_army(gb:get_non_player_alliance_num(), 2);
elseif gb:get_army(gb:get_non_player_alliance_num(), 3):get_script_name() == "side" then
	ga_ai_04 = gb:get_army(gb:get_non_player_alliance_num(), 3);
else 
	ga_ai_04 = gb:get_army(gb:get_non_player_alliance_num(), 4);
end


-------OBJECTIVES-------
gb:queue_help_on_message("battle_started", "wh_dlc05_qb_wef_mini_silver_spire_hint_objective");

get_messager():add_listener(
	"battle_started",
	function()
		local vulnerability_loop_func = function()
			bm:out("*** Starting boss vulnerability loop");
				
			for i = 59, 1, -1 do
				bm:callback(function() bm:set_objective("wh_dlc05_qb_wef_mini_silver_spire", i) end, (60 - i) * 1000, "boss_vulnerability_loop");
			end;
			
			-- remove above objective
			bm:callback(function() bm:remove_objective("wh_dlc05_qb_wef_mini_silver_spire") end, 60000, "boss_vulnerability_loop");
			
			for i = 19, 1, -1 do
				bm:callback(function() bm:set_objective("wh_dlc05_qb_wef_mini_silver_spire_vulnerable", i) end, (80 - i) * 1000, "boss_vulnerability_loop");
			end;
			
			-- remove above objective
			bm:callback(function() bm:remove_objective("wh_dlc05_qb_wef_mini_silver_spire_vulnerable") end, 80000, "boss_vulnerability_loop");
		end;
		
		-- call first loop
		vulnerability_loop_func();
	
		-- call for subsequent loops
		bm:repeat_callback(
			function() 
				vulnerability_loop_func();
			end, 
			80000,
			"boss_vulnerability_loop"
		);

	end
);

--[[
number=60

if number>60
bm:set_objective("wh_dlc05_qb_wef_mini_silver_spire_vulnerable");
number=number-1;
else if 0<number=<60
bm:Set_objective("wh_dlc05_qb_wef_mini_silver_spire", number);
number=number-1;
else if number=0
number=80;
end;
]]

-------ORDERS-------

ga_ai_01:halt();
ga_player_ally:halt();

--ga_ai_karl:attack_on_message("battle_started");


ga_ai_02:attack_on_message("battle_started");
ga_ai_03:attack_on_message("battle_started");
ga_ai_04:attack_on_message("battle_started");
--ga_ai_05:attack_on_message("battle_started");

ga_ai_first_02:attack_on_message("battle_started");
ga_ai_first_02:reinforce_on_message("battle_started");
ga_ai_first_03:attack_on_message("battle_started");
ga_ai_first_03:reinforce_on_message("battle_started");

ga_ai_02:deploy_at_random_intervals_on_message("battle_started", 1, 1, 20000, 22000);
ga_ai_03:deploy_at_random_intervals_on_message("battle_started", 1, 1, 20000, 22000);
ga_ai_04:deploy_at_random_intervals_on_message("battle_started", 1, 1, 31000, 35000);
--ga_ai_05:deploy_at_random_intervals_on_message("battle_started", 2, 2, 60000, 65000);

gb:message_on_time_offset("I_release_you_from_duty", 600000);
ga_player_ally:message_on_proximity_to_enemy("beastmen_approach_0", 250);
ga_player_ally:message_on_under_attack("beastmen_approach_0");
ga_player_ally:release_on_message("I_release_you_from_duty");
ga_player_ally:defend_on_message("beastmen_approach_0", -250, -250, 40); 
ga_ai_01:message_on_commander_dead_or_routing("morghur_is_dead");
gb:queue_help_on_message("morghur_is_dead", "wh_dlc05_qb_wef_mini_silver_spire_hint_3");

-- remove/cancel timer when boss dies
get_messager():add_listener(
	"morghur_is_dead",
	function()
		bm:remove_process("boss_vulnerability_loop");
		bm:remove_objective("wh_dlc05_qb_wef_mini_silver_spire");
		bm:remove_objective("wh_dlc05_qb_wef_mini_silver_spire_vulnerable");
	end
);

gb:message_on_time_offset("morghur_joins", 60000);
ga_ai_01:attack_on_message("morghur_joins");
gb:queue_help_on_message("morghur_joins", "wh_dlc05_qb_wef_mini_silver_spire_hint_1",10000,1000);
gb:queue_help_on_message("morghur_joins", "wh_dlc05_qb_wef_mini_silver_spire_hint_1_0",10000,1000,20000);
gb:queue_help_on_message("morghur_joins", "wh_dlc05_qb_wef_mini_silver_spire_hint_1_1",10000,1000,80000);
gb:queue_help_on_message("morghur_joins", "wh_dlc05_qb_wef_mini_silver_spire_hint_1_0",10000,1000,100000);
gb:queue_help_on_message("morghur_joins", "wh_dlc05_qb_wef_mini_silver_spire_hint_1_1",10000,1000,160000);
gb:queue_help_on_message("morghur_joins", "wh_dlc05_qb_wef_mini_silver_spire_hint_2",10000,1000,180000);


--gb:message_on_time_offset("start_battle", 10);