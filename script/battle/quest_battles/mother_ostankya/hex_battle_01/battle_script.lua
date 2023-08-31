-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Mother Ostankya
-- Hex 01 - Jinxed Land
-- Oak of Ages
-- Attacker

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries();

gb = generated_battle:new(
	false,                                      		-- screen starts black
	false,                                      		-- prevent deployment for player
	true,                                      			-- prevent deployment for ai
	nil,  									          	-- intro cutscene function
	false                                      			-- debug mode
);

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player_01 = gb:get_army(gb:get_player_alliance_num());

ga_ai_ally_01 = gb:get_army(gb:get_player_alliance_num(), "ally_01");
ga_ai_ally_boss = gb:get_army(gb:get_player_alliance_num(), "ally_boss");

ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), "wef_01");
ga_ai_01_reinforce = gb:get_army(gb:get_non_player_alliance_num(), "wef_02");

ally_boss = ga_ai_ally_boss.sunits:item(1);
enemy_boss = ga_ai_01.sunits:item(1);

ga_ai_01_reinforce:get_army():suppress_reinforcement_adc(1);

-------------------------------------------------------------------------------------------------
---------------------------------------- REINFORCEMENTS -----------------------------------------
-------------------------------------------------------------------------------------------------

local reinforcements = bm:reinforcements();

oak_reinforce = bm:get_spawn_zone_collection_by_name("oak_reinforcements");

ga_ai_01_reinforce:assign_to_spawn_zone_from_collection_on_message("start", oak_reinforce, false);
ga_ai_01_reinforce:message_on_number_deployed("oak_reinforce_01_deployed", true, 1);
ga_ai_01_reinforce:assign_to_spawn_zone_from_collection_on_message("oak_reinforce_01_deployed", oak_reinforce, false);

for i = 1, reinforcements:attacker_reinforcement_lines_count() do
	
	local line = reinforcements:attacker_reinforcement_line(i);
	
	if (line:script_id() == "oak_reinforcements") then
		line:enable_random_deployment_position();		
	end
end;

---------------
-----SETUP-----
---------------

ally_boss:set_stat_attribute("unbreakable", true);
enemy_boss:set_stat_attribute("unbreakable", true);

gb:message_on_time_offset("start", 100);
gb:message_on_time_offset("objective_01", 7500);
gb:message_on_time_offset("objective_02", 15000);

-------------------------------------------------------------------------------------------------
------------------------------------------ALLY ORDERS--------------------------------------------
-------------------------------------------------------------------------------------------------

gb:add_listener(
	"objective_02",
	function()
		ally_boss:add_ping_icon(15);
	end
);

ga_ai_ally_01:rush_on_message("start");

ga_ai_ally_boss:rush_on_message("start");

ga_ai_ally_boss:message_on_rout_proportion("forest_lost",1.0);

gb:add_listener(
	"forest_lost",
	function()
		if ga_player_01.sunits:are_any_active_on_battlefield() == true then
			ga_player_01.sunits:rout_over_time(10000);
		end;
		
		if ga_ai_ally_01.sunits:are_any_active_on_battlefield() == true then
			ga_ai_ally_01.sunits:rout_over_time(10000);
		end;
	end,
	true
);

gb:message_on_all_messages_received("forest_taken", "keepers_dead", "keepers_reinforce_dead");

-------------------------------------------------------------------------------------------------
------------------------------------------ENEMY ORDERS-------------------------------------------
-------------------------------------------------------------------------------------------------

ga_ai_01:rush_on_message("start");
ga_ai_01:message_on_rout_proportion("keepers_wounded",0.25);
ga_ai_01:message_on_rout_proportion("keepers_dead",0.95);

ga_ai_01_reinforce:deploy_at_random_intervals_on_message(
	"keepers_wounded", 			-- message
	1, 							-- min units
	1, 							-- max units
	10000, 						-- min period
	10000, 						-- max period
	nil, 						-- cancel message
	nil,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_01_reinforce:message_on_any_deployed("oak_reinforce_in");
ga_ai_01_reinforce:rush_on_message("oak_reinforce_in");
ga_ai_01_reinforce:message_on_rout_proportion("keepers_reinforce_dead",0.95);

-------------------------------------------------------------------------------------------------
--------------------------------------- OBJECTIVES & HINTS --------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_with_leader_on_message("objective_01", "wh3_dlc24_ksl_hex_01_objective_01");
gb:complete_objective_on_message("forest_taken", "wh3_dlc24_ksl_hex_01_objective_01");

gb:set_locatable_objective_callback_on_message(
    "objective_02",
    "wh3_dlc24_ksl_hex_01_objective_02",
    0,
    function()
        local sunit = ga_ai_ally_boss.sunits:get_general_sunit();
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

gb:complete_objective_on_message("forest_taken", "wh3_dlc24_ksl_hex_01_objective_02");
gb:fail_objective_on_message("forest_lost", "wh3_dlc24_ksl_hex_01_objective_02")

gb:queue_help_on_message("start", "wh3_dlc24_ksl_hex_01_hint_01");
gb:queue_help_on_message("oak_reinforce_in", "wh3_dlc24_ksl_hex_01_hint_02");
gb:queue_help_on_message("forest_lost", "wh3_dlc24_ksl_hex_01_hint_03");

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------
