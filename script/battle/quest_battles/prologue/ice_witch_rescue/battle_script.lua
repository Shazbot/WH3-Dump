-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Yuri Barkov
-- Prologue
-- Ice Witch Rescue
-- Attacker

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries();

package.path = "script/battle/?.lua;"
require("wh3_battle_prologue_values");

--bm:camera():fade(true, 0);

gb = generated_battle:new(
	false,                                      		-- screen starts black
	true,                                      		-- prevent deployment for player
	true,                                      		-- prevent deployment for ai
	nil,         									-- intro cutscene function
	false                                      		-- debug mode
);

--preload stuttering fix
intro_cinematic_file = "script/battle/quest_battles/_cutscene/managers/wlm.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);

-- Hide start battle button.
bm:show_start_battle_button(false)

-- Stop camera movement.
bm:enable_camera_movement(false)

-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh3_main_sfx_01 = new_sfx("play_wh3_main_prologue_qb_frost_maiden_001_1");
wh3_main_sfx_02 = new_sfx("play_wh3_main_prologue_qb_frost_maiden_002_1");
 

-------------------------------------------------------------------------------------------------
------------------------------------------- CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------
function end_deployment_phase()
	bm:out("\tend_deployment_phase() called");
		
	local cam = bm:camera();
	
	-- declare cutscene
	local cutscene_intro = cutscene:new_from_cindyscene(
		"cutscene_intro", 																-- unique string name for cutscene
		ga_attacker_01.sunits,															-- unitcontroller over player's army
		function() cam:fade(false, 1) end,																			-- what to call when cutscene is finished
		"script/battle/quest_battles/_cutscene/managers/wlm.CindySceneManager",			-- path to cindyscene
		0,																				-- blend in time (s)
		0																				-- blend out time (s)
	);

	local player_units_hidden = false;
	
	-- set up subtitles
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();
	
	-- skip callback
	cutscene_intro:set_skippable(
		true, 
		function()
			bm:stop_cindy_playback(true);
			
			if player_units_hidden then
				ga_attacker_01:set_enabled(true)
			end;

			bm:hide_subtitles();

			bm:show_start_battle_button(true)
		end
	);
	

	--cutscene_intro:set_post_cutscene_fade_time(-0.1)

	-- set up actions on cutscene
	--cutscene_intro:action(function() cam:fade(false, 1) end, 1000);
	cutscene_intro:action(function() cam:fade(true, 1) end, 29021); --30s

	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_attacker_01:set_enabled(true) 
		end, 
		200
	);	
	
	-- Voiceover and Subtitles --

	-- Ursun is lost, but there is a way to find him within the maze!
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_main_prologue_qb_frost_maiden_001", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_main_prologue_qb_frost_maiden_001_1"));
				bm:show_subtitle("wh3_main_prologue_qb_frost_maiden_001", false, true);
			end
	);

	-- Strike down the Daemons which guard its profane walls!
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_main_prologue_qb_frost_maiden_002", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_main_prologue_qb_frost_maiden_002_1"));
				bm:show_subtitle("wh3_main_prologue_qb_frost_maiden_002", false, true);
			end
	);	


	cutscene_intro:start();
end;

bm:register_phase_change_callback(
    "Deployed",
	function()
		local cam = bm:camera();
		cam:fade(false, 1)
		
		gb.sm:trigger_message("01_intro_cutscene_end")
    end
);

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------
--Player Army
ga_attacker_01 = gb:get_army(gb:get_player_alliance_num(), 1);


--Enemy Armies
ga_defender_02 = gb:get_army(gb:get_non_player_alliance_num(), "defender_1"); -- Enemy army 1
ga_defender_03 = gb:get_army(gb:get_non_player_alliance_num(), "defender_2"); -- Enemy army 2
ga_defender_reinforcements_1 = gb:get_army(gb:get_non_player_alliance_num(), "reinforcements_1"); -- Reinforcements 1
ga_defender_reinforcements_2 = gb:get_army(gb:get_non_player_alliance_num(), "reinforcements_2"); -- Reinforcements 2
ga_defender_reinforcements_3 = gb:get_army(gb:get_non_player_alliance_num(), "reinforcements_3"); -- Reinforcements 3
ga_defender_reinforcements_4 = gb:get_army(gb:get_non_player_alliance_num(), "reinforcements_4"); -- Reinforcements 4
ga_defender_reinforcements_5 = gb:get_army(gb:get_non_player_alliance_num(), "reinforcements_5"); -- Reinforcements 5
ga_defender_reinforcements_6 = gb:get_army(gb:get_non_player_alliance_num(), "reinforcements_6"); -- Reinforcements 6
ga_defender_reinforcements_hidden = gb:get_army(gb:get_non_player_alliance_num(), "reinforcements_hidden"); -- Reinforcements Hidden

-- build spawn zone collections
sz_collection_1 = bm:get_spawn_zone_collection_by_name("defender_reinforcements_01");
sz_collection_2 = bm:get_spawn_zone_collection_by_name("defender_reinforcements_02");
sz_collection_3 = bm:get_spawn_zone_collection_by_name("defender_reinforcements_03");
sz_collection_4 = bm:get_spawn_zone_collection_by_name("defender_reinforcements_04");
sz_collection_5 = bm:get_spawn_zone_collection_by_name("defender_reinforcements_05");
sz_collection_6 = bm:get_spawn_zone_collection_by_name("defender_reinforcements_06");


-- assign reinforcement armies to spawn zones
ga_defender_reinforcements_1:assign_to_spawn_zone_from_collection_on_message("battle_started", sz_collection_1, false);
ga_defender_reinforcements_2:assign_to_spawn_zone_from_collection_on_message("battle_started", sz_collection_2, false);
ga_defender_reinforcements_3:assign_to_spawn_zone_from_collection_on_message("battle_started", sz_collection_3, false);
ga_defender_reinforcements_4:assign_to_spawn_zone_from_collection_on_message("battle_started", sz_collection_4, false);
ga_defender_reinforcements_5:assign_to_spawn_zone_from_collection_on_message("battle_started", sz_collection_5, false);
ga_defender_reinforcements_6:assign_to_spawn_zone_from_collection_on_message("battle_started", sz_collection_6, false);
ga_defender_reinforcements_hidden:assign_to_spawn_zone_from_collection_on_message("battle_started", sz_collection_6, false);


-- Print slots
bm:print_toggle_slots()

-------Gates-------
ga_attacker_01:enable_map_barrier_on_message("open_map_barrier_1", "map_barrier_1", false);
ga_attacker_01:enable_map_barrier_on_message("open_map_barrier_2", "map_barrier_2", false);

bm:register_phase_change_callback(
        "Deployment", 
        function()
			-- Enable camera movement.
			bm:enable_camera_movement(true);

            local v_top_left = v(-215, -435);
            local formation_width = 250;
 
            local sunits_player = bm:get_scriptunits_for_local_players_army();
            local uc = sunits_player:get_unitcontroller();
 
			uc:goto_location_angle_width(v_top_left, 25, formation_width);
			uc:change_group_formation("test_melee_forward_simple");

			--Yuri Barkov
			ga_attacker_01.sunits:item(1).uc:teleport_to_location(v(-207.93, -507.92), 25, 1.4);

			--Zorya Solovyov
				if ga_attacker_01:are_unit_types_in_army("wh3_main_pro_ksl_cha_frost_maiden_ice_0") then
					ga_attacker_01.sunits:get_sunit_by_type("wh3_main_pro_ksl_cha_frost_maiden_ice_0").uc:teleport_to_location(v(-204.79, -509.22), 25, 1.4);
				end

            uc:release_control();

			core:progress_on_loading_screen_dismissed(function() end_deployment_phase() end)
        end
    );

YuriInvulernableWhenRouting() -- Stop Yuri from being wounded.

-------------------------------------------------------------------------------------------------
----------------------------------------- ARMY TELEPORT -----------------------------------------
-------------------------------------------------------------------------------------------------

function battle_start_teleport_units()
	bm:out("\tbattle_start_teleport_units() called");
	
----------------------------------- Enemy Deployment Setup -------------------------------------


--ga_defender_02 - First section

--Blue Horrors
ga_defender_02.sunits:item(1).uc:teleport_to_location(v(-20, -115), 235, 40);
--Forsaken
ga_defender_02.sunits:item(2).uc:teleport_to_location(v(115, -155), 235, 40);
--Pink Horrors
ga_defender_02.sunits:item(3).uc:teleport_to_location(v(60, -152), 235, 40);


--ga_defender_03 - Second section

--Herald of Tzeentch
ga_defender_03.sunits:item(1).uc:teleport_to_location(v(222, 88), 180, 40);
--Blue Horrors
ga_defender_03.sunits:item(2).uc:teleport_to_location(v(245, 94.53), 180, 40);
--Pink Horrors
ga_defender_03.sunits:item(3).uc:teleport_to_location(v(198.57, 94.53), 180, 40);
--Spawn of Tzeentch
ga_defender_03.sunits:item(4).uc:teleport_to_location(v(325, -55), 255, 40);
--Spawn of Tzeentch
ga_defender_03.sunits:item(5).uc:teleport_to_location(v(220, 25), 180, 40);

end;

battle_start_teleport_units();


-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------


--ga_defender_02 (First Section)
ga_defender_02:halt();
ga_defender_02:message_on_proximity_to_enemy("ga_defender_02_defend", 275);
ga_defender_02:message_on_under_attack("ga_defender_02_attack");
ga_defender_02:attack_on_message("attack");
ga_defender_02:message_on_casualties("attack", 0.02);
ga_defender_02:defend_on_message("ga_defender_02_defend", 100, -155, 200, 0);
ga_defender_02:prevent_rallying_if_routing_on_message("ga_defender_02_attack");
ga_defender_02:message_on_rout_proportion("ga_defender_02_defeated", 1);

--ga_defender_03 (Second Section)
ga_defender_03:halt();
ga_defender_03:message_on_proximity_to_enemy("ga_defender_03_attack", 160);
ga_defender_03:message_on_under_attack("ga_defender_03_attack");
--ga_defender_03:message_on_casualties("ga_defender_03_attack", 0.01);
ga_defender_03:attack_on_message("ga_defender_03_attack");
ga_defender_03:prevent_rallying_if_routing_on_message("ga_defender_03_attack");
ga_defender_03:message_on_rout_proportion("ga_defender_03_defeated", 1);

--ga_defender_reinforcements_1
ga_defender_reinforcements_1:reinforce_on_message("ga_defender_02_attack", 3000);
ga_defender_reinforcements_1:message_on_deployed("reinforcements_1_attack");
ga_defender_reinforcements_1:rush_on_message("reinforcements_1_attack");
ga_defender_reinforcements_1:message_on_under_attack("attack");
ga_defender_reinforcements_1:message_on_proximity_to_enemy("attack", 50);
ga_defender_reinforcements_1:prevent_rallying_if_routing_on_message("reinforcements_1_attack");
ga_defender_reinforcements_1:message_on_rout_proportion("ga_defender_reinforcements_1_defeated", 1);

--ga_defender_reinforcements_2 
ga_defender_reinforcements_2:reinforce_on_message("ga_defender_02_attack", 3000);
ga_defender_reinforcements_2:message_on_deployed("ga_defender_reinforcements_2_attack");
ga_defender_reinforcements_2:rush_on_message("ga_defender_reinforcements_2_attack");
ga_defender_reinforcements_2:message_on_under_attack("_attack");
ga_defender_reinforcements_2:message_on_proximity_to_enemy("attack", 50);
ga_defender_reinforcements_2:prevent_rallying_if_routing_on_message("ga_defender_reinforcements_2_attack");
ga_defender_reinforcements_2:message_on_rout_proportion("ga_defender_reinforcements_2_defeated", 1);

--ga_defender_reinforcements_3 
ga_defender_reinforcements_3:reinforce_on_message("ga_defender_03_attack", 3000);
ga_defender_reinforcements_3:message_on_deployed("ga_defender_reinforcements_3_attack");
ga_defender_reinforcements_3:rush_on_message("ga_defender_reinforcements_3_attack");
ga_defender_reinforcements_3:prevent_rallying_if_routing_on_message("ga_defender_reinforcements_3_attack");
ga_defender_reinforcements_3:message_on_rout_proportion("ga_defender_reinforcements_3_defeated", 1);

--ga_defender_reinforcements_4
ga_defender_reinforcements_4:reinforce_on_message("ga_defender_03_attack", 3000);
ga_defender_reinforcements_4:message_on_deployed("ga_defender_reinforcements_4_attack");
ga_defender_reinforcements_4:rush_on_message("ga_defender_reinforcements_4_attack");
ga_defender_reinforcements_4:prevent_rallying_if_routing_on_message("ga_defender_reinforcements_4_attack");
ga_defender_reinforcements_4:message_on_rout_proportion("ga_defender_reinforcements_4_defeated", 1);

--ga_defender_reinforcements_5
ga_defender_reinforcements_5:reinforce_on_message("reached_maze_entrance", 3000);
ga_defender_reinforcements_5:message_on_deployed("ga_defender_reinforcements_5_attack");
ga_defender_reinforcements_5:rush_on_message("ga_defender_reinforcements_5_attack");
ga_defender_reinforcements_5:prevent_rallying_if_routing_on_message("ga_defender_reinforcements_5_attack");
ga_defender_reinforcements_5:message_on_rout_proportion("ga_defender_reinforcements_5_defeated", 1);
ga_defender_reinforcements_5:message_on_deployed("ga_defender_reinforcements_hidden_unhide");


--ga_defender_reinforcements_6
ga_defender_reinforcements_6:reinforce_on_message("reached_maze_entrance", 1000);
ga_defender_reinforcements_6:message_on_deployed("ga_defender_reinforcements_6_attack");
ga_defender_reinforcements_6:rush_on_message("ga_defender_reinforcements_6_attack");
ga_defender_reinforcements_6:prevent_rallying_if_routing_on_message("ga_defender_reinforcements_6_attack");
ga_defender_reinforcements_6:message_on_rout_proportion("ga_defender_reinforcements_6_defeated", 1);

--ga_defender_reinforcements_hidden
ga_defender_reinforcements_hidden:reinforce_on_message("battle_started", 1000);
ga_defender_reinforcements_hidden:message_on_deployed("ga_defender_reinforcements_hidden_hide");
ga_defender_reinforcements_hidden:set_enabled_on_message("ga_defender_reinforcements_hidden_hide", false);
ga_defender_reinforcements_hidden:set_enabled_on_message("ga_defender_reinforcements_hidden_unhide", true);
ga_defender_reinforcements_hidden:rush_on_message("ga_defender_reinforcements_hidden_unhide");


------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

--Defeat Tzeentch's Daemons to open the first barrier.
gb:set_objective_on_message("01_intro_cutscene_end", "wh3_main_qb_prologue_ksl_yuri_ice_witch_rescue_hints_main_objective_1", 3000);
gb:remove_objective_on_message("open_map_barrier_1", "wh3_main_qb_prologue_ksl_yuri_ice_witch_rescue_hints_main_objective_1");

--Defeat Tzeentch's Daemons to breach the second barrier.
gb:set_objective_on_message("open_map_barrier_1", "wh3_main_qb_prologue_ksl_yuri_ice_witch_rescue_hints_main_objective_2", 3000);
gb:remove_objective_on_message("open_map_barrier_2", "wh3_main_qb_prologue_ksl_yuri_ice_witch_rescue_hints_main_objective_2");

--Go to the entrance of the Lucent Maze
local maze_entrance_position = v(240,699,362);

gb:set_objective_on_message("open_map_barrier_2", "wh3_main_qb_prologue_ksl_yuri_ice_witch_rescue_hints_main_objective_3", 3000);
gb:remove_objective_on_message("reached_maze_entrance", "wh3_main_qb_prologue_ksl_yuri_ice_witch_rescue_hints_main_objective_3");
ga_attacker_01:message_on_proximity_to_position("reached_maze_entrance", maze_entrance_position, 50);
gb:add_ping_icon_on_message("open_map_barrier_2", maze_entrance_position, 9, 1000);
gb:remove_ping_icon_on_message("reached_maze_entrance", maze_entrance_position, 1000);

--Defeat Tzeentch's Daemonic host!
gb:set_objective_on_message("reached_maze_entrance", "wh3_main_qb_prologue_ksl_yuri_ice_witch_rescue_hints_main_objective_4", 3000);


-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

--We must break through these magical barriers to find the runes we seek!
gb:queue_help_on_message("01_intro_cutscene_end", "wh3_main_qb_prologue_ksl_yuri_ice_witch_rescue_hints_main_hint_01", 10000, 2000, 1000, false);

--One barrier has fallen, the other still remains!
gb:queue_help_on_message("open_map_barrier_1", "wh3_main_qb_prologue_ksl_yuri_ice_witch_rescue_hints_main_hint_02", 10000, 2000, 1000, false);

--The final barrier falls and our path to the Lucent Maze is clear!
gb:queue_help_on_message("open_map_barrier_2", "wh3_main_qb_prologue_ksl_yuri_ice_witch_rescue_hints_main_hint_03", 10000, 2000, 1000, false);

--A trap! Defeat those that would stand in our way!
gb:queue_help_on_message("reached_maze_entrance", "wh3_main_qb_prologue_ksl_yuri_ice_witch_rescue_hints_main_hint_04", 10000, 2000, 5000, false);

--Their leader has been slain!
ga_defender_02:message_on_commander_dead_or_shattered("lord_dead");
gb:queue_help_on_message("lord_dead", "wh3_main_qb_prologue_ksl_yuri_ice_witch_rescue_hints_lord_dead", 10000, 2000, 1000, false);

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

--Open map barriers
gb:message_on_all_messages_received("open_map_barrier_1", "ga_defender_02_defeated", "ga_defender_reinforcements_1_defeated", "ga_defender_reinforcements_2_defeated");
gb:message_on_all_messages_received("open_map_barrier_2", "ga_defender_03_defeated", "ga_defender_reinforcements_3_defeated", "ga_defender_reinforcements_4_defeated");

--Battle Won
gb:message_on_all_messages_received("enemy_army_defeated", "ga_defender_reinforcements_5_defeated", "ga_defender_reinforcements_6_defeated");
ga_attacker_01:force_victory_on_message("enemy_army_defeated", 3000);
-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------

--Set the variable to load the correct campaign script
bm:register_phase_change_callback(
    "Complete",
	function()
		local player_army = bm:get_scriptunits_for_local_players_army();
		local yuri = player_army:get_general_sunit();
		if bm:victorious_alliance() == yuri.alliance_num then
			bm:out("Player has won!");
		   -- set variable
		   core:svr_save_bool("sbool_load_tzeentch_campaign", true)
	
			common.setup_dynamic_loading_screen("prologue_battle_lucent_maze_outro", "prologue")
		else
			bm:out("Player has lost!");
			-- try and load in the prologue_next_quote value from the prologue campaign
			local prologue_next_quote = tostring(core:svr_load_string("prologue_next_quote"));
			if prologue_next_quote then
				bm:out("prologue_next_quote is " .. tostring(prologue_next_quote));
				common.set_custom_loading_screen_text("wh3_prologue_loading_screen_quote_"..prologue_next_quote);
			else
				bm:out("prologue_next_quote is not set");
			end;
		end;
    end
);

