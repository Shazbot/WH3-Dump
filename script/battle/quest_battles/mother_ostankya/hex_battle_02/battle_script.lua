-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Mother Ostankya
-- Hex 02 - Recreant Spirit
-- The Marthenil Archipelago
-- Attacker

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries();

gb = generated_battle:new(
	false,                                      		-- screen starts black
	false,                                      		-- prevent deployment for player
	false,                                      		-- prevent deployment for ai
	nil,  									          	-- intro cutscene function
	false                                      			-- debug mode
);

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player_01 = gb:get_army(gb:get_player_alliance_num());
ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), "start");
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_brt");
ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_cst");
ga_ai_spirit_01 = gb:get_army(gb:get_non_player_alliance_num(), "spirit_01");
ga_ai_spirit_02 = gb:get_army(gb:get_non_player_alliance_num(), "spirit_02");
ga_ai_spirit_03 = gb:get_army(gb:get_non_player_alliance_num(), "spirit_03");

boss_01 = ga_ai_spirit_01.sunits:item(1);
boss_02 = ga_ai_spirit_02.sunits:item(1);
boss_03 = ga_ai_spirit_03.sunits:item(1);

-------------------------------------------------------------------------------------------------
---------------------------------------- REINFORCEMENTS -----------------------------------------
-------------------------------------------------------------------------------------------------

local reinforcements = bm:reinforcements();

brt_reinforce = bm:get_spawn_zone_collection_by_name("brt_reinforce");
cst_reinforce = bm:get_spawn_zone_collection_by_name("cst_reinforce");

ga_ai_02:assign_to_spawn_zone_from_collection_on_message("start", brt_reinforce, false);
ga_ai_02:message_on_number_deployed("brt_reinforce_deployed", true, 1);
ga_ai_02:assign_to_spawn_zone_from_collection_on_message("brt_reinforce_deployed", brt_reinforce, false);

ga_ai_03:assign_to_spawn_zone_from_collection_on_message("start", cst_reinforce, false);

for i = 1, reinforcements:defender_reinforcement_lines_count() do
	
	local line = reinforcements:defender_reinforcement_line(i);
	
	if (line:script_id() == "brt_reinforce") then
		line:enable_random_deployment_position();		
	end
end;

---------------
-----SETUP-----
---------------

gb:message_on_time_offset("start", 100);
gb:message_on_time_offset("spirits_start", 1000);

-------------------------------------------------------------------------------------------------
------------------------------------------ALLY ORDERS--------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
------------------------------------------ENEMY ORDERS-------------------------------------------
-------------------------------------------------------------------------------------------------

gb:message_on_time_offset("objective_01", 7500);
gb:add_listener(
	"objective_01",
	function()
		boss_01:add_ping_icon(15);
	end
);

gb:message_on_time_offset("objective_02", 12500);
gb:add_listener(
	"objective_02",
	function()
		boss_02:add_ping_icon(15);
	end
);

gb:message_on_time_offset("objective_03", 17500);
gb:add_listener(
	"objective_03",
	function()
		boss_03:add_ping_icon(15);
	end
);

ga_ai_spirit_01:rush_on_message("spirits_in_combat");
ga_ai_spirit_01:message_on_rout_proportion("banshee_dead",0.99);

ga_ai_spirit_02:rush_on_message("spirits_in_combat");
ga_ai_spirit_02:message_on_rout_proportion("paladin_dead",0.99);

ga_ai_spirit_03:rush_on_message("spirits_in_combat");
ga_ai_spirit_03:message_on_rout_proportion("mourngul_weak",0.5);
ga_ai_spirit_03:message_on_rout_proportion("mourngul_dead",0.99);

ga_ai_01:rush_on_message("spirits_start");
ga_ai_01:message_on_proximity_to_enemy("spirits_in_combat", 100);
ga_ai_01:message_on_rout_proportion("starting_forces_dead",0.95);

ga_ai_02:deploy_at_random_intervals_on_message(
	"paladin_dead", 			-- message
	1, 							-- min units
	1, 							-- max units
	1500, 						-- min period
	1500, 						-- max period
	nil, 						-- cancel message
	nil,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_02.sunits:set_stat_attribute("unbreakable", true);

ga_ai_02:message_on_any_deployed("brt_in");
ga_ai_02:rush_on_message("brt_in");
ga_ai_02:message_on_rout_proportion("paladin_forces_dead",0.95);

ga_ai_03:reinforce_on_message("mourngul_weak");
ga_ai_03:message_on_any_deployed("cst_in");
ga_ai_03:rush_on_message("cst_in");
ga_ai_03:message_on_rout_proportion("mourngul_forces_dead",0.95);

gb:message_on_all_messages_received("forces_dead", "starting_forces_dead", "paladin_forces_dead", "mourngul_forces_dead");
gb:message_on_all_messages_received("spirits_defeated", "banshee_dead", "paladin_dead", "mourngul_dead");

gb:add_listener(
	"spirits_defeated",
	function()
		if ga_ai_01.sunits:are_any_active_on_battlefield() == true then
			ga_ai_01.sunits:kill_proportion_over_time(1.0, 5000, false);
		end;
		if ga_ai_02.sunits:are_any_active_on_battlefield() == true then
			ga_ai_02.sunits:kill_proportion_over_time(1.0, 5000, false);
		end;
		if ga_ai_03.sunits:are_any_active_on_battlefield() == true then
			ga_ai_03.sunits:kill_proportion_over_time(1.0, 5000, false);
		end;
	end,
	true
);

-------------------------------------------------------------------------------------------------
--------------------------------------- OBJECTIVES & HINTS --------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_locatable_objective_callback_on_message(
    "objective_01",
    "wh3_dlc24_ksl_hex_02_objective_01",
    0,
    function()
        local sunit = boss_01
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

gb:complete_objective_on_message("banshee_dead", "wh3_dlc24_ksl_hex_02_objective_01");

gb:set_locatable_objective_callback_on_message(
    "objective_02",
    "wh3_dlc24_ksl_hex_02_objective_02",
    0,
    function()
        local sunit = boss_02
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

gb:complete_objective_on_message("paladin_dead", "wh3_dlc24_ksl_hex_02_objective_02");

gb:set_locatable_objective_callback_on_message(
    "objective_03",
    "wh3_dlc24_ksl_hex_02_objective_03",
    0,
    function()
        local sunit = boss_03
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

gb:set_objective_on_message("objective_01", "wh3_dlc23_chd_hellshard_amulet_01", 15000);

gb:complete_objective_on_message("forces_dead", "wh3_dlc23_chd_hellshard_amulet_01");
gb:complete_objective_on_message("mourngul_dead", "wh3_dlc24_ksl_hex_02_objective_03");

gb:remove_objective_on_message("spirits_defeated", "wh3_dlc24_ksl_hex_02_objective_01", 15000);
gb:remove_objective_on_message("spirits_defeated", "wh3_dlc24_ksl_hex_02_objective_02", 15000);
gb:remove_objective_on_message("spirits_defeated", "wh3_dlc24_ksl_hex_02_objective_03", 15000);

gb:queue_help_on_message("start", "wh3_dlc24_ksl_hex_02_hint_01");
gb:queue_help_on_message("paladin_dead", "wh3_dlc24_ksl_hex_02_hint_02");
gb:queue_help_on_message("mourngul_weak", "wh3_dlc24_ksl_hex_02_hint_03");

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------
