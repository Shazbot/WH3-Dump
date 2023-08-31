-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Mother Ostankya
-- Hex 05 - Malediction of Ruin
-- Oakheart Forest – Wood Elf Forest
-- Attacker

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries();

gb = generated_battle:new(
	false,                                      		-- screen starts black
	false,                                      		-- prevent deployment for player
	true,                  	                    		-- prevent deployment for ai
	nil,  												-- intro cutscene function
	false                                      			-- debug mode
);

local sm = get_messager();

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player_01 = gb:get_army(gb:get_player_alliance_num());

ga_ai_ally_01 = gb:get_army(gb:get_player_alliance_num(), "hag_01");
ga_ai_ally_01_reinforce = gb:get_army(gb:get_player_alliance_num(), "hag_01_reinforce");
ga_ai_ally_02 = gb:get_army(gb:get_player_alliance_num(), "hag_02");
ga_ai_ally_02_reinforce = gb:get_army(gb:get_player_alliance_num(), "hag_02_reinforce");

ga_ai_boss_hag_01 = gb:get_army(gb:get_player_alliance_num(), "hag_01_boss");
ga_ai_boss_hag_02 = gb:get_army(gb:get_player_alliance_num(), "hag_02_boss");

boss_hag_01 = ga_ai_boss_hag_01.sunits:item(1);
boss_hag_02 = ga_ai_boss_hag_02.sunits:item(1);

ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_01");
ga_ai_reinforce_01 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_01_reinforce");
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_02");
ga_ai_reinforce_02 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_02_reinforce");

ga_ai_skv_01 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_skv_01");
ga_ai_skv_02 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_skv_02");

ga_ai_life_wizard_01 = gb:get_army(gb:get_non_player_alliance_num(), "life_wizard");

life_wizard = ga_ai_life_wizard_01.sunits:item(1);

-------------------------------------------------------------------------------------------------
---------------------------------------- REINFORCEMENTS -----------------------------------------
-------------------------------------------------------------------------------------------------

local reinforcements = bm:reinforcements();

enemy_reinforce_01 = bm:get_spawn_zone_collection_by_name("enemy_01_reinforce");
enemy_reinforce_02 = bm:get_spawn_zone_collection_by_name("enemy_02_reinforce");

skv_reinforce_01 = bm:get_spawn_zone_collection_by_name("skv_01_reinforce");
skv_reinforce_02 = bm:get_spawn_zone_collection_by_name("skv_02_reinforce");

ally_reinforce_01 = bm:get_spawn_zone_collection_by_name("ally_01_reinforce");
ally_reinforce_02 = bm:get_spawn_zone_collection_by_name("ally_02_reinforce");

ga_ai_reinforce_01:assign_to_spawn_zone_from_collection_on_message("start", enemy_reinforce_01, false);
ga_ai_reinforce_01:message_on_number_deployed("enemy_reinforce_01_deployed", true, 1);
ga_ai_reinforce_01:assign_to_spawn_zone_from_collection_on_message("enemy_reinforce_01_deployed", enemy_reinforce_01, false);

ga_ai_reinforce_02:assign_to_spawn_zone_from_collection_on_message("start", enemy_reinforce_02, false);
ga_ai_reinforce_02:message_on_number_deployed("enemy_reinforce_02_deployed", true, 1);
ga_ai_reinforce_02:assign_to_spawn_zone_from_collection_on_message("enemy_reinforce_02_deployed", enemy_reinforce_02, false);

ga_ai_ally_01_reinforce:assign_to_spawn_zone_from_collection_on_message("start", ally_reinforce_01, false);

ga_ai_ally_02_reinforce:assign_to_spawn_zone_from_collection_on_message("start", ally_reinforce_02, false);

ga_ai_skv_01:assign_to_spawn_zone_from_collection_on_message("start", skv_reinforce_01, false);
ga_ai_skv_01:message_on_number_deployed("skv_reinforce_01_deployed", true, 1);
ga_ai_skv_01:assign_to_spawn_zone_from_collection_on_message("skv_reinforce_01_deployed", skv_reinforce_01, false);

ga_ai_skv_02:assign_to_spawn_zone_from_collection_on_message("start", skv_reinforce_02, false);
ga_ai_skv_02:message_on_number_deployed("skv_reinforce_02_deployed", true, 1);
ga_ai_skv_02:assign_to_spawn_zone_from_collection_on_message("skv_reinforce_02_deployed", skv_reinforce_02, false);

for i = 1, reinforcements:attacker_reinforcement_lines_count() do
	
	local line = reinforcements:attacker_reinforcement_line(i);
	
	if (line:script_id() == "enemy_01_reinforce") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "enemy_02_reinforce") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "skv_01_reinforce") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "skv_02_reinforce") then
		line:enable_random_deployment_position();		
	end
end;

ga_ai_reinforce_01:get_army():suppress_reinforcement_adc(1);
ga_ai_reinforce_02:get_army():suppress_reinforcement_adc(1);

-------------------------------------------------------------------------------------------------
----------------------------------- CAPTURE POINT LOCATIONS -------------------------------------
-------------------------------------------------------------------------------------------------

local capture_point_lady = bm:capture_location_manager():capture_location_from_script_id("cp_lady");
local capture_point_water = bm:capture_location_manager():capture_location_from_script_id("cp_water");

---------------
-----SETUP-----
---------------

gb:message_on_time_offset("start", 100);
gb:message_on_time_offset("hags_in_place", 1000);
gb:message_on_time_offset("objective_01", 7500);
gb:message_on_time_offset("objective_02", 12500);
gb:message_on_time_offset("objective_02_offset", 15000);

-------------------------------------------------------------------------------------------------
------------------------------------------ALLY ORDERS--------------------------------------------
-------------------------------------------------------------------------------------------------

gb:add_listener(
	"objective_02",
	function()
		boss_hag_01:add_ping_icon(15);
	end,
	true
);

gb:add_listener(
	"objective_02_offset",
	function()
		boss_hag_02:add_ping_icon(15);
	end,
	true
);

ga_player_01:message_on_commander_death("ostankya_dead");

ga_ai_ally_01:defend_on_message("hags_in_place", 370, -255, 25);  
ga_ai_ally_01:rush_on_message("ritual_02_finished");

ga_ai_boss_hag_01:defend_on_message("hags_in_place", 370, -255, 25);  
ga_ai_boss_hag_01:message_on_rout_proportion("hag_01_dead",0.99);
ga_ai_boss_hag_01:rush_on_message("ritual_02_finished");

ga_ai_ally_02:defend_on_message("hags_in_place", -350, 80, 25);
ga_ai_ally_02:rush_on_message("ritual_01_finished");

ga_ai_boss_hag_02:defend_on_message("hags_in_place", -350, 80, 25);
ga_ai_boss_hag_02:message_on_rout_proportion("hag_02_dead",0.99);
ga_ai_boss_hag_02:rush_on_message("ritual_01_finished");

ga_ai_ally_01_reinforce:reinforce_on_message("ritual_02_finished");
ga_ai_ally_01_reinforce:message_on_any_deployed("hag_02_ally_in");
ga_ai_ally_01_reinforce:rush_on_message("hag_02_ally_in");

ga_ai_ally_02_reinforce:reinforce_on_message("ritual_01_finished");
ga_ai_ally_02_reinforce:message_on_any_deployed("hag_01_ally_in");
ga_ai_ally_02_reinforce:attack_on_message("hag_01_ally_in");

gb:add_listener(
	"ritual_02_finished",
	function()
		boss_hag_01:remove_ping_icon();
	end,
	true
);

gb:add_listener(
	"ritual_01_finished",
	function()
		boss_hag_02:remove_ping_icon();
	end,
	true
);

gb:message_on_capture_location_capture_completed("cp_1_owned", "objective_01", "cp1", nil, ga_player_01, ga_ai_01);
gb:message_on_capture_location_capture_completed("cp_2_owned", "objective_01", "cp2", nil, ga_player_01, ga_ai_01);
gb:message_on_capture_location_capture_completed("cp_3_owned", "objective_01", "cp3", nil, ga_player_01, ga_ai_01);

gb:queue_help_on_message("cp_1_owned", "wh3_dlc24_ksl_hex_04_hint_03");
gb:queue_help_on_message("cp_2_owned", "wh3_dlc24_ksl_hex_04_hint_03");
gb:queue_help_on_message("cp_3_owned", "wh3_dlc24_ksl_hex_04_hint_03");

gb:block_message_on_message("ritual_02_finished", "hags_dead", true);
gb:message_on_all_messages_received("hags_dead", "hag_01_dead", "hag_02_dead");

-------------------------------------------------------------------------------------------------
------------------------------------------ENEMY ORDERS-------------------------------------------
-------------------------------------------------------------------------------------------------

ga_ai_01:defend(200.0, -50.0, 100);
ga_ai_01:message_on_rout_proportion("emp_01_weaker",0.3);
ga_ai_01:message_on_rout_proportion("emp_01_main_dead",0.99);
ga_ai_01:message_on_proximity_to_enemy("help_us", 50);

ga_ai_reinforce_01:deploy_at_random_intervals_on_message(
	"emp_01_weaker", 			-- message
	1, 							-- min units
	1, 							-- max units
	2000, 						-- min period
	2000, 						-- max period
	"end_this", 				-- cancel message
	nil,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_reinforce_01:message_on_any_deployed("emp_01_in");
ga_ai_reinforce_01:rush_on_message("emp_01_in");
ga_ai_reinforce_01:message_on_rout_proportion("emp_01_reinforce_dead",0.99);

ga_ai_02:defend(300.0, 360.0, 150);
ga_ai_02:message_on_rout_proportion("emp_02_main_dead",0.99);
ga_ai_02:rush_on_message("help_us");

ga_ai_life_wizard_01:defend(300.0, 360.0, 100);
ga_ai_life_wizard_01:message_on_casualties("life_wizard_interrupted",0.5);
ga_ai_life_wizard_01:message_on_rout_proportion("life_wizard_dead",0.99);

life_wizard:set_stat_attribute("unbreakable", true);

ga_ai_01:rush_on_message("wef_in");
ga_ai_02:rush_on_message("wef_in");
ga_ai_life_wizard_01:rush_on_message("wef_in");

gb:add_listener(
	"life_ritual",
	function()
		life_wizard:add_ping_icon(15);
	end
);

gb:add_listener(
	"life_wizard_interrupted",
	function()
		life_wizard:set_stat_attribute("unbreakable", false);
	end
);

ga_ai_reinforce_02:deploy_at_random_intervals_on_message(
	"release_wef", 				-- message
	1, 							-- min units
	1, 							-- max units
	5000, 						-- min period
	5000, 						-- max period
	"end_this", 				-- cancel message
	nil,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_reinforce_02:message_on_any_deployed("wef_in");
ga_ai_reinforce_02:rush_on_message("wef_in");
ga_ai_reinforce_02:message_on_rout_proportion("wef_dead",0.99);

ga_ai_skv_01:deploy_at_random_intervals_on_message(
	"summon_skv_01", 			-- message
	1, 							-- min units
	1, 							-- max units
	2000, 						-- min period
	2000, 						-- max period
	"end_this", 				-- cancel message
	nil,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_skv_01:message_on_any_deployed("skv_01_in");
ga_ai_skv_01:rush_on_message("skv_01_in");

ga_ai_skv_02:deploy_at_random_intervals_on_message(
	"summon_skv_02", 			-- message
	1, 							-- min units
	1, 							-- max units
	2000, 						-- min period
	2000, 						-- max period
	"end_this", 				-- cancel message
	nil,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_skv_02:message_on_any_deployed("skv_02_in");
ga_ai_skv_02:rush_on_message("skv_02_in");

gb:message_on_all_messages_received("enemy_forces_dead", "emp_01_main_dead", "emp_01_reinforce_dead", "emp_02_main_dead", "life_wizard_dead", "wef_dead");
gb:message_on_all_messages_received("battle_won", "ritual_03_finished", "enemy_forces_dead");

gb:add_listener(
	"life_wizard_interrupted",
	function()
		if ga_ai_reinforce_02.sunits:are_any_active_on_battlefield() == false then
			ga_ai_reinforce_02.sunits:kill_proportion_over_time(1.0, 100, false);
		end;
	end,
	true
);

-------------------------------------------------------------------------------------------------
--------------------------------------- OBJECTIVES & HINTS --------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_locatable_objective_callback_on_message(
    "objective_01",
    "wh3_dlc24_ksl_hex_05_objective_01",
    0,
    function()
        local sunit = ga_player_01.sunits:get_general_sunit();
        if sunit then
            local cam_targ = sunit.unit:position();
            local cam_pos = v_offset_by_bearing(
                cam_targ,
                get_bearing(cam_targ, bm:camera():position()),    -- horizontal bearing from camera target to current camera position
                75,                                                -- distance from camera position to camera target
                d_to_r(30)                                        -- vertical bearing from horizon to cam-targ/cam-pos line
            );
            return cam_pos, cam_targ;
        end;
    end,
    2
);

gb:complete_objective_on_message("enemy_forces_dead", "wh3_dlc24_ksl_hex_05_objective_01");
gb:fail_objective_on_message("ostankya_dead", "wh3_dlc24_ksl_hex_05_objective_01");

gb:queue_help_on_message("hags_in_place", "wh3_dlc24_ksl_hex_05_hint_01");
gb:queue_help_on_message("life_ritual", "wh3_dlc24_ksl_hex_05_hint_02");
gb:queue_help_on_message("emp_01_weaker", "wh3_dlc24_ksl_hex_05_hint_03");
gb:queue_help_on_message("release_wef", "wh3_dlc24_ksl_hex_05_hint_04");
gb:queue_help_on_message("life_wizard_interrupted", "wh3_dlc24_ksl_hex_05_hint_05");
gb:queue_help_on_message("summon_skv_01", "wh3_dlc24_ksl_hex_05_skv_hint_01");
gb:queue_help_on_message("summon_skv_02", "wh3_dlc24_ksl_hex_05_skv_hint_02");

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

final_obj_time = 3000
update_value = 5

gb:add_listener(
    "hag_01_dead",
	function()
		update_value = update_value -1
    end,
	true
)

gb:add_listener(
    "hag_02_dead",
	function()
		update_value = update_value -1
    end,
	true
)


gb:add_listener(
	"ritual_01_finished",
	function()
		--capture_point_lady:set_enabled(false);	
		update_value = update_value -1
	end
)

gb:add_listener(
	"ritual_02_finished",
	function()
		--capture_point_water:set_enabled(false);	
		update_value = update_value -1
	end
)

gb:add_listener(
    "objective_02",
	function()
		bm:set_objective("wh3_dlc24_ksl_hex_05_objective_02", final_obj_time)

		bm:repeat_callback(
			function()
				final_obj_time = final_obj_time - update_value

				if final_obj_time <= 2500 then
					sm:trigger_message("life_ritual");
				end

				if final_obj_time <= 2250 then
					sm:trigger_message("summon_skv_01");
				end

				if final_obj_time <= 2000 then
					sm:trigger_message("ritual_01_finished");
				end

				if final_obj_time <= 1750 then
					sm:trigger_message("summon_skv_02");
				end
				
				if final_obj_time <= 1500 then
					sm:trigger_message("ritual_02_finished");
				end

				if final_obj_time < 0 then
					sm:trigger_message("ritual_03_finished");
					bm:complete_objective("wh3_dlc24_ksl_hex_05_objective_02")
					bm:remove_callback("end_countdown")
				else
					bm:set_objective("wh3_dlc24_ksl_hex_05_objective_02", final_obj_time)
				end
			end, 
			1000,
			"end_countdown"
		)
	end
)

gb:add_listener(
    "hags_dead",
	function()
		bm:remove_callback("end_countdown");
    end
)

gb:fail_objective_on_message("hags_dead", "wh3_dlc24_ksl_hex_05_objective_02");

gb:add_listener(
    "ritual_01_finished",
	function()
		bm:queue_help_message("wh3_dlc24_ksl_hex_05_hint_obj_01", 5000, 100, true);
    end
)

gb:add_listener(
    "ritual_02_finished",
	function()
		bm:queue_help_message("wh3_dlc24_ksl_hex_05_hint_obj_02", 5000, 100, true);
    end
)

gb:add_listener(
    "ritual_03_finished",
	function()
		bm:queue_help_message("wh3_dlc24_ksl_hex_05_hint_obj_03", 5000, 100, true);
    end
)

sub_obj_time = 300
sub_update_value = 1

gb:add_listener(
    "life_wizard_interrupted",
	function()
		bm:complete_objective("wh3_dlc24_ksl_hex_05_objective_03")
		sm:trigger_message("release_wef");
		bm:remove_callback("end_sub_countdown")
    end,
	true
)

gb:add_listener(
    "life_ritual",
	function()
		bm:set_objective("wh3_dlc24_ksl_hex_05_objective_03", sub_obj_time)

		bm:repeat_callback(
			function()
				sub_obj_time = sub_obj_time - sub_update_value

				if sub_obj_time <= 0 then
					bm:fail_objective("wh3_dlc24_ksl_hex_05_objective_03")
					sm:trigger_message("release_wef");
					bm:remove_callback("end_sub_countdown")
				else
					bm:set_objective("wh3_dlc24_ksl_hex_05_objective_03", sub_obj_time)
				end
			end, 
			1000,
			"end_sub_countdown"
		)
	end
)

gb:remove_objective_on_message("release_wef", "wh3_dlc24_ksl_hex_05_objective_03", 15000);

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_ai_01:force_victory_on_message("ostankya_dead", 5000);
ga_ai_01:force_victory_on_message("hags_dead", 5000);
ga_player_01:force_victory_on_message("battle_won", 5000);