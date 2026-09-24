load_script_libraries();

bm = battle_manager:new(empire_battle:new());

gb = generated_battle:new(
                false,                         				-- screen starts black
                false,                         				-- prevent deployment for player
                true,                         				-- prevent deployment for ai
				function() play_intro_cutscene() end,    	-- intro cutscene function -- 
				nil,
                false                          				-- debug mode
);

---------------------------------------
----------HARD SCRIPT VERSION----------
---------------------------------------

local sm = get_messager();
local reinforcements = bm:reinforcements();

-------------------------------------------------------------------------------------------------
-------------------------------------------ARMY SETUP--------------------------------------------
-------------------------------------------------------------------------------------------------
--Player
ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1);

--Mannfred Force
ga_ai_ally_vmp_start = gb:get_army(gb:get_player_alliance_num(), "ally_vmp_start");

--Arkhan Force
ga_ai_ally_tmb_start = gb:get_army(gb:get_player_alliance_num(), "ally_tmb_start");

--Optional Mortarchs; Vlad, Luthor, Neferata
ga_ai_ally_vlad_reinforce = gb:get_army(gb:get_player_alliance_num(), "ally_vlad_reinforce");
ga_ai_ally_luthor_reinforce = gb:get_army(gb:get_player_alliance_num(), "ally_luthor_reinforce");
ga_ai_ally_neferata_reinforce = gb:get_army(gb:get_player_alliance_num(), "ally_neferata_reinforce");

--Wave 1 Invaders
ga_ai_order_wave_01_main = gb:get_army(gb:get_non_player_alliance_num(), "main_start");
ga_ai_order_wave_01_east = gb:get_army(gb:get_non_player_alliance_num(), "east_start");
ga_ai_order_wave_01_west = gb:get_army(gb:get_non_player_alliance_num(), "west_start");

--Wave 2 Invaders
ga_ai_chs_wave_02_sorcerers_east_01 = gb:get_army(gb:get_non_player_alliance_num(), "chs_sorcerers_east_01");
ga_ai_chs_wave_02_sorcerers_east_02 = gb:get_army(gb:get_non_player_alliance_num(), "chs_sorcerers_east_02");
ga_ai_chs_wave_02_sorcerers_west_01 = gb:get_army(gb:get_non_player_alliance_num(), "chs_sorcerers_west_01");
ga_ai_chs_wave_02_sorcerers_west_02 = gb:get_army(gb:get_non_player_alliance_num(), "chs_sorcerers_west_02");
ga_ai_chs_wave_02_east = gb:get_army(gb:get_non_player_alliance_num(), "chs_east_reinforcements");
ga_ai_chs_wave_02_west = gb:get_army(gb:get_non_player_alliance_num(), "chs_west_reinforcements");
ga_ai_chs_wave_02_south = gb:get_army(gb:get_non_player_alliance_num(), "chs_south_reinforcements");

--Wave 3 Invaders
ga_ai_skv_wave_03_lords_01 = gb:get_army(gb:get_non_player_alliance_num(), "skv_lords_01");
ga_ai_skv_wave_03_lords_02 = gb:get_army(gb:get_non_player_alliance_num(), "skv_lords_02");
ga_ai_skv_wave_03_lords_03 = gb:get_army(gb:get_non_player_alliance_num(), "skv_lords_03");
ga_ai_skv_wave_03_main = gb:get_army(gb:get_non_player_alliance_num(), "skv_main_reinforcements");
ga_ai_skv_wave_03_north = gb:get_army(gb:get_non_player_alliance_num(), "skv_north_reinforcements");

--Wave 4 Invaders
ga_ai_tmb_wave_04_main = gb:get_army(gb:get_non_player_alliance_num(), "tmb_main_reinforcements");
ga_ai_tmb_wave_04_south = gb:get_army(gb:get_non_player_alliance_num(), "tmb_south_reinforcements");
ga_ai_tmb_wave_04_east = gb:get_army(gb:get_non_player_alliance_num(), "tmb_east_reinforcements");
ga_ai_tmb_wave_04_west = gb:get_army(gb:get_non_player_alliance_num(), "tmb_west_reinforcements");

-------------------------------------------------------------------------------------------------
------------------------------------------SCRIPT UNITS-------------------------------------------
-------------------------------------------------------------------------------------------------
--Nagash
nagash_character = ga_player_01.sunits:item(1)

--Chaos Lords
chs_boss_01 = ga_ai_chs_wave_02_sorcerers_east_01.sunits:item(1);
chs_boss_02 = ga_ai_chs_wave_02_sorcerers_east_02.sunits:item(1);
chs_boss_03 = ga_ai_chs_wave_02_sorcerers_west_01.sunits:item(1);
chs_boss_04 = ga_ai_chs_wave_02_sorcerers_west_02.sunits:item(1);
chs_archaon = ga_ai_chs_wave_02_south.sunits:item(1);

--Skaven Assassins
skv_assassin_01 = ga_ai_skv_wave_03_lords_01.sunits:item(1)
skv_assassin_02 = ga_ai_skv_wave_03_lords_02.sunits:item(1)
skv_assassin_03 = ga_ai_skv_wave_03_lords_03.sunits:item(1)

--Tomb Kings
settra_character = ga_ai_tmb_wave_04_main.sunits:item(1)
settra_priest_01 = ga_ai_tmb_wave_04_south.sunits:item(1)
settra_priest_02 = ga_ai_tmb_wave_04_east.sunits:item(1)
settra_priest_03 = ga_ai_tmb_wave_04_west.sunits:item(1)

-------------------------------
----------SPAWN ZONES----------
-------------------------------
--Wave 02 Reinforce
chs_west = bm:get_spawn_zone_collection_by_name("chs_west");
chs_east = bm:get_spawn_zone_collection_by_name("chs_east");
chs_south = bm:get_spawn_zone_collection_by_name("chs_south");
dae_west = bm:get_spawn_zone_collection_by_name("dae_west");
dae_east = bm:get_spawn_zone_collection_by_name("dae_east");

--Wave 03 Reinforce
skv_main = bm:get_spawn_zone_collection_by_name("skv_main");
skv_north = bm:get_spawn_zone_collection_by_name("skv_north");

--Wave 04 Reinforce
south_main = bm:get_spawn_zone_collection_by_name("south_main");
south_west = bm:get_spawn_zone_collection_by_name("south_west");
south_east = bm:get_spawn_zone_collection_by_name("south_east");

--Wave 02 - Chaos & Daemons
ga_ai_chs_wave_02_south:assign_to_spawn_zone_from_collection_on_message("start", chs_south, false);

ga_ai_chs_wave_02_sorcerers_east_01:assign_to_spawn_zone_from_collection_on_message("start", chs_east, false);
ga_ai_chs_wave_02_sorcerers_east_02:assign_to_spawn_zone_from_collection_on_message("start", chs_east, false);
ga_ai_chs_wave_02_sorcerers_west_01:assign_to_spawn_zone_from_collection_on_message("start", chs_west, false);
ga_ai_chs_wave_02_sorcerers_west_02:assign_to_spawn_zone_from_collection_on_message("start", chs_west, false);

ga_ai_chs_wave_02_east:assign_to_spawn_zone_from_collection_on_message("start", dae_east, false);
ga_ai_chs_wave_02_east:message_on_number_deployed("wave_02_east_deployed", true, 1);
ga_ai_chs_wave_02_east:assign_to_spawn_zone_from_collection_on_message("wave_02_east_deployed", dae_east, false);

ga_ai_chs_wave_02_west:assign_to_spawn_zone_from_collection_on_message("start", dae_west, false);
ga_ai_chs_wave_02_west:message_on_number_deployed("wave_02_west_deployed", true, 1);
ga_ai_chs_wave_02_west:assign_to_spawn_zone_from_collection_on_message("wave_02_west_deployed", dae_west, false);

--Wave 03 - Skaven
ga_ai_skv_wave_03_lords_01:assign_to_spawn_zone_from_collection_on_message("start", skv_main, false);
ga_ai_skv_wave_03_lords_02:assign_to_spawn_zone_from_collection_on_message("start", skv_main, false);
ga_ai_skv_wave_03_lords_03:assign_to_spawn_zone_from_collection_on_message("start", skv_main, false);
ga_ai_skv_wave_03_main:assign_to_spawn_zone_from_collection_on_message("start", skv_main, false);
ga_ai_skv_wave_03_north:assign_to_spawn_zone_from_collection_on_message("start", skv_north, false);

--Wave 04 - Tomb Kings
ga_ai_tmb_wave_04_main:assign_to_spawn_zone_from_collection_on_message("start", south_main, false);
ga_ai_tmb_wave_04_main:message_on_number_deployed("wave_04_south_deployed", true, 1);
ga_ai_tmb_wave_04_main:assign_to_spawn_zone_from_collection_on_message("wave_04_south_deployed", south_main, false);

ga_ai_tmb_wave_04_south:assign_to_spawn_zone_from_collection_on_message("start", south_main, false);
ga_ai_tmb_wave_04_south:message_on_number_deployed("wave_04_main_deployed", true, 1);
ga_ai_tmb_wave_04_south:assign_to_spawn_zone_from_collection_on_message("wave_04_main_deployed", south_main, false);

ga_ai_tmb_wave_04_east:assign_to_spawn_zone_from_collection_on_message("start", south_east, false);
ga_ai_tmb_wave_04_east:message_on_number_deployed("wave_02_east_deployed", true, 1);
ga_ai_tmb_wave_04_east:assign_to_spawn_zone_from_collection_on_message("wave_02_east_deployed", south_east, false);

ga_ai_tmb_wave_04_west:assign_to_spawn_zone_from_collection_on_message("start", south_west, false);
ga_ai_tmb_wave_04_west:message_on_number_deployed("wave_04_west_deployed", true, 1);
ga_ai_tmb_wave_04_west:assign_to_spawn_zone_from_collection_on_message("wave_04_west_deployed", south_west, false);


--Reinforcement Lines
for i = 1, reinforcements:attacker_reinforcement_lines_count() do
	
	local line = reinforcements:attacker_reinforcement_line(i);
	
	if (line:script_id() == "dae_west") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "dae_east") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "skv_main") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "south_main") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "south_east") then
		line:enable_random_deployment_position();
	end

	if (line:script_id() == "south_west") then
		line:enable_random_deployment_position();		
	end
end;

-------------------------------------------
----------CAPTURE POINT LOCATIONS----------
-------------------------------------------
local main_cp = bm:capture_location_manager():capture_location_from_script_id("main_cp");

gb:message_on_capture_location_capture_completed("cp_main_stolen", "start", "main_cp", nil, nil, ga_ai_order_wave_01_main);

----------------------------------------------
---------------COMPOSITE SCENES---------------
----------------------------------------------
black_pyramid_01 = "composite_scene/wh3_vmp_nagash_black_pyramid_loop_01.csc";
black_pyramid_02 = "composite_scene/wh3_vmp_nagash_black_pyramid_loop_02.csc";
black_pyramid_03 = "composite_scene/wh3_vmp_nagash_black_pyramid_loop_03.csc";

--------------------------------------
----------HINTS & OBJECTIVES----------
--------------------------------------
-----OBJECTIVE 0-----
-- Nagash Must Survive
gb:set_locatable_objective_callback_on_message(
    "start",
    "wh3_dlc29_qb_nag_final_battle_objective_00",
    0,
    function()
        local sunit = ga_player_01.sunits:get_general_sunit();
        if sunit then
            local cam_targ = sunit.unit:position();
            local cam_pos = v_offset_by_bearing(
                cam_targ,
                get_bearing(cam_targ, bm:camera():position()),    -- horizontal bearing from camera target to current camera position
                75,                                               -- distance from camera position to camera target
                d_to_r(30)                                        -- vertical bearing from horizon to cam-targ/cam-pos line
            );
            return cam_pos, cam_targ;
        end;
    end,
    2
);

gb:complete_objective_on_message("waves_defeated", "wh3_dlc29_qb_nag_final_battle_objective_00");
gb:fail_objective_on_message("nagash_dead", "wh3_dlc29_qb_nag_final_battle_objective_00");

-----OBJECTIVE 1-----
-- Control the Ritual Site - Hold the area to allow the ritual to complete
gb:set_locatable_objective_on_message("objective_01", "wh3_dlc29_qb_nag_final_battle_objective_01", 0, v(0.0, 345.0, 175.0), v(0.0, 300.0, 80.0), 2, true);
gb:complete_objective_on_message("wave_03_defeated", "wh3_dlc29_qb_nag_final_battle_objective_01");
gb:fail_objective_on_message("cp_main_stolen", "wh3_dlc29_qb_nag_final_battle_objective_01");
gb:remove_objective_on_message("play_outro_cutscene", "wh3_dlc29_qb_nag_final_battle_objective_01", 100);

-----OBJECTIVE 2-----
-- Defeat the Forces of Order
gb:set_objective_with_leader_on_message("objective_02", "wh3_dlc29_qb_nag_final_battle_objective_02");
gb:complete_objective_on_message("wave_01_defeated", "wh3_dlc29_qb_nag_final_battle_objective_02");
gb:remove_objective_on_message("wave_01_defeated", "wh3_dlc29_qb_nag_final_battle_objective_02", 5000);

-----OBJECTIVE 3-----
-- Defeat the Warriors of Chaos - Defeat the Chaos Sorcerers to banish the Daemons
gb:set_objective_with_leader_on_message("objective_03", "wh3_dlc29_qb_nag_final_battle_objective_03");
gb:complete_objective_on_message("wave_02_defeated", "wh3_dlc29_qb_nag_final_battle_objective_03");
gb:remove_objective_on_message("wave_02_defeated", "wh3_dlc29_qb_nag_final_battle_objective_03", 5000);

-----OBJECTIVE 4-----
-- Stop the Assassination Plot - Defeat Snikch and the Verminlords to rout the Skaven
gb:set_objective_with_leader_on_message("objective_04", "wh3_dlc29_qb_nag_final_battle_objective_04");
gb:complete_objective_on_message("wave_03_defeated", "wh3_dlc29_qb_nag_final_battle_objective_04");
gb:remove_objective_on_message("play_outro_cutscene", "wh3_dlc29_qb_nag_final_battle_objective_04", 100);

-----OBJECTIVE 5-----
-- Defeat Settra the Imperishable
gb:set_locatable_objective_callback_on_message(
    "objective_05",
    "wh3_dlc29_qb_nag_final_battle_objective_05",
    0,
    function()
        local sunit = ga_ai_tmb_wave_04_main.sunits:item(1)
        if sunit then
            local cam_targ = sunit.unit:position();
            local cam_pos = v_offset_by_bearing(
                cam_targ,
                get_bearing(cam_targ, bm:camera():position()),    -- horizontal bearing from camera target to current camera position
                75,                                               -- distance from camera position to camera target
                d_to_r(30)                                        -- vertical bearing from horizon to cam-targ/cam-pos line
            );
            return cam_pos, cam_targ;
        end;
    end,
    2
);

gb:complete_objective_on_message("settra_perished", "wh3_dlc29_qb_nag_final_battle_objective_05");
gb:remove_objective_on_message("settra_perished", "wh3_dlc29_qb_nag_final_battle_objective_05", 100);

-----OBJECTIVE 6-----
-- Weaken Settra - Settra is empowered by his Priests, defeat them to make him vulnerable
local settra_vulnerable_time = 300
local update_value = 1

gb:add_listener(
    "objective_05",
	function()
		bm:repeat_callback(
			function()
				bm:set_objective("wh3_dlc29_qb_nag_final_battle_objective_06", settra_vulnerable_time)

				settra_vulnerable_time = settra_vulnerable_time - update_value

				if settra_vulnerable_time <= 0 then
					sm:trigger_message("settra_is_vulnerable")
					bm:remove_objective("wh3_dlc29_qb_nag_final_battle_objective_06")
					bm:remove_callback("end_objective_countdown")
					settra_character:set_invincible(false);
					settra_character:add_ping_icon(15);

					settra_priest_01:remove_ping_icon();
					settra_priest_02:remove_ping_icon();
					settra_priest_03:remove_ping_icon();
				end
			end, 
			1000,
			"end_objective_countdown"
		)
	end
)

-----HINTS-----
-- defeat the chaos sorcerers to close portals - The Chaos Sorcerers are the only thing capable of binding these daemons to the mortal realm, kill them to break their connection to the Chaos realms
gb:queue_help_on_message("start_wave_02", "wh3_dlc29_qb_nag_final_battle_hint_04");

-- the everchosen reinforces - The Everchosen has accepted his fate and seeks his death, let us not disappoint him
gb:queue_help_on_message("wave_02_south_in", "wh3_dlc29_qb_nag_final_battle_hint_05");

-- prevent the assassination plot - Sniktch has been sent to assassinate Nagash, push through the swarm and put an end to his assassination attempt
gb:queue_help_on_message("start_wave_03", "wh3_dlc29_qb_nag_final_battle_hint_06");

-- kill the big bad mechanic - Settra refuses to die, he can only maintain this level of power for a time, all to mimic a mere fraction of the power held by the Undying King, he will be unbound
gb:queue_help_on_message("start_wave_04", "wh3_dlc29_qb_nag_final_battle_hint_07");

-- settra vulnerable - The magic that binds Settra is unravelling before our eyes, he will serve or he will perish
gb:queue_help_on_message("settra_is_vulnerable", "wh3_dlc29_qb_nag_final_battle_hint_08");

-- nagash dies - Nagash has fallen in battle, the ritual can no longer continue
gb:queue_help_on_message("nagash_lost_hint", "wh3_dlc29_qb_nag_final_battle_hint_09");

-- ritual site lost - The Ritual Site has been captured and all progress has been lost!
gb:queue_help_on_message("pyramid_lost_hint", "wh3_dlc29_qb_nag_final_battle_hint_10");

----------------------------------
----------SPECIAL ORDERS----------
----------------------------------
local dae_wave_speed = 2500;

local perpetual = true;
local shattered_only = false;
local permit_rampaging = true;

gb:message_on_time_offset("start", 100);
gb:message_on_time_offset("start_offset", 200);
gb:message_on_time_offset("campaign_reinforce", 2500);
gb:message_on_time_offset("objective_01", 5000);
gb:message_on_time_offset("objective_02", 10000);
gb:message_on_time_offset("objective_03", 2500, "start_wave_02");
gb:message_on_time_offset("objective_04", 2500, "start_wave_03");
gb:message_on_time_offset("objective_05", 5000, "start_wave_04");

ga_player_01:message_on_commander_death("nagash_dead");

ga_player_01:add_winds_of_magic_on_message("start_wave_02", 15);
ga_player_01:add_winds_of_magic_on_message("start_wave_03", 15);
ga_player_01:add_winds_of_magic_on_message("start_wave_04", 15);

-------------------------------
----------ALLY ORDERS----------
-------------------------------
-- Mannfred Von Carstein
ga_ai_ally_vmp_start:attack_force_on_message("start", ga_ai_order_wave_01_west);
ga_ai_ally_vmp_start:defend_on_message("order_west_wave_01_defeated_offset", -295, 0, 100); 
ga_ai_ally_vmp_start:attack_force_on_message("wave_04_west_in", ga_ai_tmb_wave_04_west);

-- Arkhan the Black 
ga_ai_ally_tmb_start:attack_force_on_message("start", ga_ai_order_wave_01_east);
ga_ai_ally_tmb_start:defend_on_message("order_east_wave_01_defeated_offset", 295, 0, 100); 
ga_ai_ally_tmb_start:attack_force_on_message("wave_04_east_in", ga_ai_tmb_wave_04_east);

---------------------------------
----------WAVE 1 ORDERS----------
---------------------------------
ga_ai_order_wave_01_main:attack_force_on_message("start", ga_player_01);
ga_ai_order_wave_01_east:attack_force_on_message("start", ga_ai_ally_tmb_start);
ga_ai_order_wave_01_west:attack_force_on_message("start", ga_ai_ally_vmp_start);

ga_ai_order_wave_01_main:message_on_rout_proportion("order_main_wave_01_defeated",0.75);
ga_ai_order_wave_01_east:message_on_rout_proportion("order_east_wave_01_defeated",0.75);
ga_ai_order_wave_01_west:message_on_rout_proportion("order_west_wave_01_defeated",0.75);

ga_ai_order_wave_01_main:rout_over_time_on_message("order_main_wave_01_defeated", 30000);
ga_ai_order_wave_01_east:rout_over_time_on_message("order_east_wave_01_defeated", 30000);
ga_ai_order_wave_01_west:rout_over_time_on_message("order_west_wave_01_defeated", 30000);

gb:add_listener(
	"start_offset",
	function()
		ga_ai_order_wave_01_main.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_order_wave_01_east.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_order_wave_01_west.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);

		local function change_behavior(sunits, behavior, value)
			for i = 1, sunits:count() do
				local current_sunit = sunits:item(i)
				current_sunit.uc:change_behaviour_active(behavior, value)
			end
		end
		change_behavior(ga_ai_order_wave_01_main.sunits, "skirmish", false)
		change_behavior(ga_ai_order_wave_01_east.sunits, "skirmish", false)
		change_behavior(ga_ai_order_wave_01_west.sunits, "skirmish", false)
	end
);

gb:message_on_all_messages_received("wave_01_defeated","order_main_wave_01_defeated","order_east_wave_01_defeated","order_west_wave_01_defeated");


gb:message_on_time_offset("order_west_wave_01_defeated_offset", 15000, "order_west_wave_01_defeated");
gb:message_on_time_offset("order_main_wave_01_defeated_offset", 15000, "order_main_wave_01_defeated");
gb:message_on_time_offset("order_east_wave_01_defeated_offset", 15000, "order_east_wave_01_defeated");

--------------------------------------
----------WAVE 1 COMPLETION-----------
--------------------------------------
gb:message_on_time_offset("play_mid_01_cutscene", 7500, "wave_01_defeated");

gb:add_listener(
	"play_mid_01_cutscene",
	function()
		if ga_ai_order_wave_01_main.sunits:are_any_active_on_battlefield() == true then
			ga_ai_order_wave_01_main.sunits:kill_proportion_over_time(1.0, 100, false);
		end;

		if ga_ai_order_wave_01_east.sunits:are_any_active_on_battlefield() == true then
			ga_ai_order_wave_01_east.sunits:kill_proportion_over_time(1.0, 100, false);
		end;

		if ga_ai_order_wave_01_west.sunits:are_any_active_on_battlefield() == true then
			ga_ai_order_wave_01_west.sunits:kill_proportion_over_time(1.0, 100, false);
		end;
	end,
	true
);

gb:add_listener(
	"play_mid_01_cutscene",
	function()
		prepare_for_mid_01_cutscene()
	end,
	true
);

---------------------------------
----------WAVE 2 ORDERS----------
---------------------------------
gb:message_on_time_offset("start_wave_02", 1000, "mid_01_cutscene_end");

ga_ai_chs_wave_02_sorcerers_east_01:reinforce_on_message("start_wave_02");
ga_ai_chs_wave_02_sorcerers_east_02:reinforce_on_message("start_wave_02");
ga_ai_chs_wave_02_sorcerers_west_01:reinforce_on_message("start_wave_02");
ga_ai_chs_wave_02_sorcerers_west_02:reinforce_on_message("start_wave_02");
ga_ai_chs_wave_02_south:reinforce_on_message("chs_sorcerers_wave_02_weakened");

ga_ai_chs_wave_02_east:deploy_at_random_intervals_on_message(
	"start_wave_02", 			-- message
	1, 							-- min units
	1, 							-- max units
	dae_wave_speed, 			-- min period
	dae_wave_speed, 			-- max period
	"chs_sorcerers_east_wave_02_defeated", 	-- cancel message
	true,						-- spawn first wave immediately
	true,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_chs_wave_02_west:deploy_at_random_intervals_on_message(
	"start_wave_02", 			-- message
	1, 							-- min units
	1, 							-- max units
	dae_wave_speed, 			-- min period
	dae_wave_speed, 			-- max period
	"chs_sorcerers_west_wave_02_defeated", 	-- cancel message
	true,						-- spawn first wave immediately
	true,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_chs_wave_02_east:get_army():suppress_reinforcement_adc(1);
ga_ai_chs_wave_02_west:get_army():suppress_reinforcement_adc(1);

ga_ai_chs_wave_02_sorcerers_east_01:message_on_deployed("wave_02_01_sorcerers_east_in");
ga_ai_chs_wave_02_sorcerers_east_02:message_on_deployed("wave_02_02_sorcerers_east_in");
ga_ai_chs_wave_02_sorcerers_west_01:message_on_deployed("wave_02_01_sorcerers_west_in");
ga_ai_chs_wave_02_sorcerers_west_02:message_on_deployed("wave_02_02_sorcerers_west_in");

ga_ai_chs_wave_02_east:message_on_any_deployed("wave_02_east_in");
ga_ai_chs_wave_02_west:message_on_any_deployed("wave_02_west_in");
ga_ai_chs_wave_02_south:message_on_any_deployed("wave_02_south_in");

gb:message_on_all_messages_received("wave_02_sorcerers_east_in","wave_02_01_sorcerers_east_in","wave_02_02_sorcerers_east_in");
gb:message_on_all_messages_received("wave_02_sorcerers_west_in","wave_02_01_sorcerers_west_in","wave_02_02_sorcerers_west_in");

gb:message_on_time_offset("wave_02_sorcerers_east_in_offset", 2500, "wave_02_sorcerers_east_in");
gb:message_on_time_offset("wave_02_sorcerers_west_in_offset", 2500, "wave_02_sorcerers_west_in");

gb:add_listener(
	"wave_02_sorcerers_east_in_offset",
	function()
		chs_boss_01:add_ping_icon(15);
		chs_boss_02:add_ping_icon(15);
	end,
	true
);

gb:add_listener(
	"wave_02_sorcerers_west_in_offset",
	function()
		chs_boss_03:add_ping_icon(15);
		chs_boss_04:add_ping_icon(15);
	end,
	true
);

ga_ai_chs_wave_02_sorcerers_east_01:rush_on_message("wave_02_sorcerers_east_in");
ga_ai_chs_wave_02_sorcerers_east_02:rush_on_message("wave_02_sorcerers_east_in");
ga_ai_chs_wave_02_sorcerers_west_01:rush_on_message("wave_02_sorcerers_west_in");
ga_ai_chs_wave_02_sorcerers_west_02:rush_on_message("wave_02_sorcerers_west_in");

ga_ai_chs_wave_02_east:rush_on_message("wave_02_east_in");
ga_ai_chs_wave_02_west:rush_on_message("wave_02_west_in");
ga_ai_chs_wave_02_south:rush_on_message("wave_02_south_in");

ga_ai_chs_wave_02_sorcerers_east_01:message_on_rout_proportion("chs_sorcerers_east_wave_02_01_weakened",0.5);
ga_ai_chs_wave_02_sorcerers_east_02:message_on_rout_proportion("chs_sorcerers_east_wave_02_02_weakened",0.5);

gb:message_on_all_messages_received("chs_sorcerers_east_wave_02_weakened","chs_sorcerers_east_wave_02_01_weakened","chs_sorcerers_east_wave_02_02_weakened");

ga_ai_chs_wave_02_sorcerers_east_01:message_on_commander_dead_or_shattered("chs_sorcerers_east_wave_02_01_defeated");
ga_ai_chs_wave_02_sorcerers_east_02:message_on_commander_dead_or_shattered("chs_sorcerers_east_wave_02_02_defeated");

gb:message_on_all_messages_received("chs_sorcerers_east_wave_02_defeated","chs_sorcerers_east_wave_02_01_defeated","chs_sorcerers_east_wave_02_02_defeated");

ga_ai_chs_wave_02_sorcerers_west_01:message_on_rout_proportion("chs_sorcerers_west_wave_02_01_weakened",0.5);
ga_ai_chs_wave_02_sorcerers_west_02:message_on_rout_proportion("chs_sorcerers_west_wave_02_02_weakened",0.5);

gb:message_on_all_messages_received("chs_sorcerers_west_wave_02_weakened","chs_sorcerers_west_wave_02_01_weakened","chs_sorcerers_west_wave_02_02_weakened");

ga_ai_chs_wave_02_sorcerers_west_01:message_on_commander_dead_or_shattered("chs_sorcerers_west_wave_02_01_defeated");
ga_ai_chs_wave_02_sorcerers_west_02:message_on_commander_dead_or_shattered("chs_sorcerers_west_wave_02_02_defeated");

gb:message_on_all_messages_received("chs_sorcerers_west_wave_02_defeated","chs_sorcerers_west_wave_02_01_defeated","chs_sorcerers_west_wave_02_02_defeated");

ga_ai_chs_wave_02_south:message_on_rout_proportion("chs_south_wave_02_weak",0.4);
ga_ai_chs_wave_02_south:message_on_rout_proportion("chs_south_wave_02_defeated",0.95);

gb:message_on_any_message_received("chs_sorcerers_wave_02_weakened", "chs_sorcerers_east_wave_02_weakened","chs_sorcerers_west_wave_02_weakened");

gb:add_listener(
	"start_wave_02",
	function()
		ga_ai_chs_wave_02_sorcerers_east_01.sunits:set_stat_attribute("unbreakable", true);
		ga_ai_chs_wave_02_sorcerers_east_02.sunits:set_stat_attribute("unbreakable", true);
		ga_ai_chs_wave_02_sorcerers_west_01.sunits:set_stat_attribute("unbreakable", true);
		ga_ai_chs_wave_02_sorcerers_west_02.sunits:set_stat_attribute("unbreakable", true);

		chs_boss_01:set_always_visible_no_hidden(true);
		chs_boss_02:set_always_visible_no_hidden(true);
		chs_boss_03:set_always_visible_no_hidden(true);
		chs_boss_04:set_always_visible_no_hidden(true);
	end
);

gb:add_listener(
	"chs_sorcerers_east_wave_02_defeated",
	function()
		if ga_ai_chs_wave_02_east.sunits:are_any_active_on_battlefield() == true then
			ga_ai_chs_wave_02_east.sunits:kill_proportion_over_time(1.0, 5000, false);
		end;
	end,
	true
);

gb:add_listener(
	"chs_sorcerers_west_wave_02_defeated",
	function()
		if ga_ai_chs_wave_02_west.sunits:are_any_active_on_battlefield() == true then
			ga_ai_chs_wave_02_west.sunits:kill_proportion_over_time(1.0, 5000, false);
		end;
	end,
	true
);

gb:add_listener(
	"wave_02_south_in",
	function()
		chs_archaon:set_stat_attribute("unbreakable", true);
		ga_ai_chs_wave_02_south.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
	end,
	true
);

gb:message_on_all_messages_received("wave_02_defeated","chs_sorcerers_east_wave_02_defeated","chs_sorcerers_west_wave_02_defeated","chs_south_wave_02_defeated");

--------------------------------------
----------WAVE 2 COMPLETION-----------
--------------------------------------
gb:message_on_time_offset("start_wave_03_sorcerer", 30000, "chs_sorcerers_wave_02_weakened");
gb:message_on_time_offset("start_wave_03_main", 30000, "chs_south_wave_02_weak");

gb:add_listener(
	"wave_02_defeated",
	function()
		if ga_ai_chs_wave_02_south.sunits:are_any_active_on_battlefield() == true then
			ga_ai_chs_wave_02_south.sunits:rout_over_time(1000);
		end;

		if ga_ai_chs_wave_02_sorcerers_east_01.sunits:are_any_active_on_battlefield() == true then
			ga_ai_chs_wave_02_sorcerers_east_01.sunits:rout_over_time(1000);
		end;

		if ga_ai_chs_wave_02_sorcerers_east_02.sunits:are_any_active_on_battlefield() == true then
			ga_ai_chs_wave_02_sorcerers_east_02.sunits:rout_over_time(1000);
		end;

		if ga_ai_chs_wave_02_sorcerers_west_01.sunits:are_any_active_on_battlefield() == true then
			ga_ai_chs_wave_02_sorcerers_west_01.sunits:rout_over_time(1000);
		end;

		if ga_ai_chs_wave_02_sorcerers_west_02.sunits:are_any_active_on_battlefield() == true then
			ga_ai_chs_wave_02_sorcerers_west_02.sunits:rout_over_time(1000);
		end;

		if ga_ai_chs_wave_02_east.sunits:are_any_active_on_battlefield() == true then
			ga_ai_chs_wave_02_east.sunits:kill_proportion_over_time(1.0, 500, false);
		end;

		if ga_ai_chs_wave_02_west.sunits:are_any_active_on_battlefield() == true then
			ga_ai_chs_wave_02_west.sunits:kill_proportion_over_time(1.0, 500, false);
		end;
	end,
	true
);

---------------------------------
----------WAVE 3 ORDERS----------
---------------------------------
gb:message_on_any_message_received("start_wave_03", "start_wave_03_sorcerer","start_wave_03_main");

ga_ai_skv_wave_03_lords_01:reinforce_on_message("start_wave_03");
ga_ai_skv_wave_03_lords_02:reinforce_on_message("start_wave_03");
ga_ai_skv_wave_03_lords_03:reinforce_on_message("start_wave_03");

ga_ai_skv_wave_03_main:deploy_at_random_intervals_on_message(
	"start_wave_03", 			-- message
	2, 							-- min units
	2, 							-- max units
	2000, 						-- min period
	2000, 						-- max period
	nil, 						-- cancel message
	true,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_skv_wave_03_north:reinforce_on_message("start_wave_03");

ga_ai_skv_wave_03_lords_01:message_on_deployed("wave_03_01_lords_in");
ga_ai_skv_wave_03_lords_02:message_on_deployed("wave_03_02_lords_in");
ga_ai_skv_wave_03_lords_03:message_on_deployed("wave_03_03_lords_in");
ga_ai_skv_wave_03_main:message_on_deployed("wave_03_main_in");
ga_ai_skv_wave_03_north:message_on_any_deployed("wave_03_east_in");

gb:message_on_all_messages_received("wave_03_lords_in","wave_03_01_lords_in","wave_03_02_lords_in","wave_03_03_lords_in");

ga_ai_skv_wave_03_lords_01:attack_force_on_message("wave_03_01_lords_in", ga_player_01);
ga_ai_skv_wave_03_lords_02:attack_force_on_message("wave_03_02_lords_in", ga_player_01);
ga_ai_skv_wave_03_lords_03:attack_force_on_message("wave_03_03_lords_in", ga_player_01);
ga_ai_skv_wave_03_main:rush_on_message("wave_03_main_in");
ga_ai_skv_wave_03_north:rush_on_message("wave_03_east_in");

ga_ai_skv_wave_03_north:rout_over_time_on_message("skv_lords_wave_03_weakened", 60000);
ga_ai_skv_wave_03_north:rout_over_time_on_message("skv_lords_wave_03_defeated", 5000);
ga_ai_skv_wave_03_main:rout_over_time_on_message("skv_lords_wave_03_defeated", 5000);

ga_ai_skv_wave_03_lords_01:message_on_rout_proportion("skv_lords_wave_03_01_weakened",0.5);
ga_ai_skv_wave_03_lords_01:message_on_rout_proportion("skv_lords_wave_03_02_weakened",0.5);
ga_ai_skv_wave_03_lords_01:message_on_rout_proportion("skv_lords_wave_03_03_weakened",0.5);

gb:message_on_all_messages_received("skv_lords_wave_03_weakened","skv_lords_wave_03_01_weakened","skv_lords_wave_03_02_weakened","skv_lords_wave_03_03_weakened");

ga_ai_skv_wave_03_lords_01:message_on_commander_dead_or_shattered("skv_lords_wave_03_01_defeated");
ga_ai_skv_wave_03_lords_01:message_on_commander_dead_or_shattered("skv_lords_wave_03_02_defeated");
ga_ai_skv_wave_03_lords_01:message_on_commander_dead_or_shattered("skv_lords_wave_03_03_defeated");

gb:message_on_all_messages_received("skv_lords_wave_03_defeated","skv_lords_wave_03_01_defeated","skv_lords_wave_03_02_defeated","skv_lords_wave_03_03_defeated");

ga_ai_skv_wave_03_main:message_on_rout_proportion("skv_main_wave_03_defeated",0.95);
ga_ai_skv_wave_03_north:message_on_rout_proportion("skv_north_wave_03_defeated",0.95);

gb:message_on_time_offset("wave_03_lords_in_offset", 2500, "wave_03_lords_in");

gb:add_listener(
	"wave_03_lords_in_offset",
	function()
		skv_assassin_01:add_ping_icon(15);
		skv_assassin_02:add_ping_icon(15);
		skv_assassin_03:add_ping_icon(15);

		skv_assassin_01:set_stat_attribute("unbreakable", true);
		skv_assassin_02:set_stat_attribute("unbreakable", true);
		skv_assassin_03:set_stat_attribute("unbreakable", true);
	end,
	true
);

gb:add_listener(
	"start_wave_03",
	function()
		ga_ai_skv_wave_03_main.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_skv_wave_03_north.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
	end
);

gb:message_on_all_messages_received("wave_03_defeated","skv_lords_wave_03_defeated","skv_main_wave_03_defeated","skv_north_wave_03_defeated");

--------------------------------------
----------WAVE 3 COMPLETION-----------
--------------------------------------
gb:message_on_all_messages_received("waves_02_and_03_defeated","wave_02_defeated","wave_03_defeated");

gb:message_on_time_offset("play_outro_cutscene", 7500, "waves_02_and_03_defeated");

gb:add_listener(
	"play_outro_cutscene",
	function()
		if ga_ai_skv_wave_03_main.sunits:are_any_active_on_battlefield() == true then
			ga_ai_skv_wave_03_main.sunits:kill_proportion_over_time(1.0, 100, false);
		end;

		if ga_ai_skv_wave_03_north.sunits:are_any_active_on_battlefield() == true then
			ga_ai_skv_wave_03_north.sunits:kill_proportion_over_time(1.0, 100, false);
		end;

		main_cp:set_locked(true);
		main_cp:set_enabled(false);
	end,
	true
);

gb:add_listener(
	"play_outro_cutscene",
	function()
		prepare_for_outro_cutscene()
	end,
	true
);

gb:message_on_time_offset("start_wave_04", 100, "outro_cutscene_end");

---------------------------------
----------WAVE 4 ORDERS----------
---------------------------------
ga_ai_tmb_wave_04_main:deploy_at_random_intervals_on_message(
	"start_wave_04", 			-- message
	2, 							-- min units
	2, 							-- max units
	100, 						-- min period
	100, 						-- max period
	nil, 						-- cancel message
	true,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_tmb_wave_04_south:deploy_at_random_intervals_on_message(
	"start_wave_04", 			-- message
	2, 							-- min units
	2, 							-- max units
	100, 						-- min period
	100, 						-- max period
	nil, 						-- cancel message
	true,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_tmb_wave_04_east:deploy_at_random_intervals_on_message(
	"start_wave_04", 			-- message
	2, 							-- min units
	2, 							-- max units
	100, 						-- min period
	100, 						-- max period
	nil, 						-- cancel message
	true,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_tmb_wave_04_west:deploy_at_random_intervals_on_message(
	"start_wave_04", 			-- message
	2, 							-- min units
	2, 							-- max units
	100, 						-- min period
	100, 						-- max period
	nil, 						-- cancel message
	true,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_tmb_wave_04_main:message_on_any_deployed("wave_04_main_in");
ga_ai_tmb_wave_04_south:message_on_deployed("wave_04_south_in");
ga_ai_tmb_wave_04_east:message_on_deployed("wave_04_east_in");
ga_ai_tmb_wave_04_west:message_on_deployed("wave_04_west_in");

ga_ai_tmb_wave_04_main:attack_force_on_message("wave_04_main_in", ga_player_01);
ga_ai_tmb_wave_04_south:rush_on_message("wave_04_south_in");
ga_ai_tmb_wave_04_east:rush_on_message("wave_04_east_in");
ga_ai_tmb_wave_04_west:rush_on_message("wave_04_west_in");

ga_ai_tmb_wave_04_main:message_on_rout_proportion("tmb_main_wave_04_weakened",0.45);
ga_ai_tmb_wave_04_main:message_on_rout_proportion("tmb_main_wave_04_defeated",0.95);
ga_ai_tmb_wave_04_south:message_on_rout_proportion("tmb_south_wave_04_defeated",0.95);
ga_ai_tmb_wave_04_east:message_on_rout_proportion("tmb_east_wave_04_defeated",0.95);
ga_ai_tmb_wave_04_west:message_on_rout_proportion("tmb_west_wave_04_defeated",0.95);

local function track_unit_death(sunits, message, callback_name)
	bm:repeat_callback(
		function()
			local sunit = sunits:item(1)
			if sunit.unit:unary_hitpoints() <= 0 then
				sm:trigger_message(message)
				bm:remove_callback(callback_name)
			end
		end,
		1000,
		callback_name
	)
end

gb:add_listener(
	"start_wave_04",
	function()
		track_unit_death(ga_ai_tmb_wave_04_main.sunits, "settra_perished", "end_settra_tracker_countdown")
		track_unit_death(ga_ai_tmb_wave_04_south.sunits, "tmb_high_priest_dead", "end_south_tmb_tracker_countdown")
		track_unit_death(ga_ai_tmb_wave_04_east.sunits, "tmb_high_priest_dead", "end_east_tmb_tracker_countdown")
		track_unit_death(ga_ai_tmb_wave_04_west.sunits, "tmb_high_priest_dead", "end_west_tmb_tracker_countdown")
	end,
	true
)

gb:add_listener(
    "wave_04_main_in",
	function()
		settra_character:set_invincible(true);
		settra_character:set_stat_attribute("unbreakable", true);
    end,
	true
);

gb:message_on_time_offset("wave_04_south_in_offset", 2500, "wave_04_south_in");
gb:message_on_time_offset("wave_04_east_in_offset", 2500, "wave_04_east_in");
gb:message_on_time_offset("wave_04_west_in_offset", 2500, "wave_04_west_in");

gb:add_listener(
    "wave_04_south_in_offset",
	function()
		settra_priest_01:add_ping_icon(15);
    end,
	true
);

gb:add_listener(
    "wave_04_east_in_offset",
	function()
		settra_priest_02:add_ping_icon(15);
    end,
	true
);

gb:add_listener(
    "wave_04_west_in_offset",
	function()
		settra_priest_03:add_ping_icon(15);
    end,
	true
);

gb:add_listener(
	"settra_perished",
	function()
		if ga_ai_tmb_wave_04_east.sunits:are_any_active_on_battlefield() == true then
			ga_ai_tmb_wave_04_east.sunits:kill_proportion_over_time(1.0, 10000, false);
		end;

		if ga_ai_tmb_wave_04_west.sunits:are_any_active_on_battlefield() == true then
			ga_ai_tmb_wave_04_west.sunits:kill_proportion_over_time(1.0, 10000, false);
		end;

		if ga_ai_tmb_wave_04_south.sunits:are_any_active_on_battlefield() == true then
			ga_ai_tmb_wave_04_south.sunits:kill_proportion_over_time(1.0, 10000, false);
		end;

		if ga_ai_tmb_wave_04_main.sunits:are_any_active_on_battlefield() == true then
			ga_ai_tmb_wave_04_main.sunits:kill_proportion_over_time(1.0, 10000, false);
		end;
	end,
	true
);

gb:add_listener(
    "tmb_high_priest_dead",
	function()
		update_value = update_value + 1
    end,
	true
);

gb:message_on_all_messages_received("wave_04_defeated","tmb_main_wave_04_defeated","tmb_south_wave_04_defeated","tmb_east_wave_04_defeated","tmb_west_wave_04_defeated");

----------------------
-------END GAME-------
----------------------
ga_ai_order_wave_01_main:force_victory_on_message("nagash_dead", 5000);

ga_ai_order_wave_01_main:force_victory_on_message("cp_main_stolen", 5000);

gb:add_listener(
    "nagash_dead",
	function()
		if ga_player_01.sunits:are_any_active_on_battlefield() == true then
			ga_player_01.sunits:kill_proportion_over_time(1.0, 5000, false);
		end;

		if ga_ai_ally_vmp_start.sunits:are_any_active_on_battlefield() == true then
			ga_ai_ally_vmp_start.sunits:kill_proportion_over_time(1.0, 5000, false);
		end;

		if ga_ai_ally_tmb_start.sunits:are_any_active_on_battlefield() == true then
			ga_ai_ally_tmb_start.sunits:kill_proportion_over_time(1.0, 5000, false);
		end;

		if ga_ai_ally_vlad_reinforce.sunits:are_any_active_on_battlefield() == true then
			ga_ai_ally_vlad_reinforce.sunits:kill_proportion_over_time(1.0, 5000, false);
		end;

		if ga_ai_ally_luthor_reinforce.sunits:are_any_active_on_battlefield() == true then
			ga_ai_ally_luthor_reinforce.sunits:kill_proportion_over_time(1.0, 5000, false);
		end;

		if ga_ai_ally_neferata_reinforce.sunits:are_any_active_on_battlefield() == true then
			ga_ai_ally_neferata_reinforce.sunits:kill_proportion_over_time(1.0, 5000, false);
		end;

		sm:trigger_message("nagash_lost_hint");

		bm:setup_victory_callback(function() player_has_lost() end);
    end,
	true
)

gb:add_listener(
    "cp_main_stolen",
	function()
		if ga_player_01.sunits:are_any_active_on_battlefield() == true then
			ga_player_01.sunits:kill_proportion_over_time(1.0, 5000, false);
		end;

		if ga_ai_ally_vmp_start.sunits:are_any_active_on_battlefield() == true then
			ga_ai_ally_vmp_start.sunits:kill_proportion_over_time(1.0, 5000, false);
		end;

		if ga_ai_ally_tmb_start.sunits:are_any_active_on_battlefield() == true then
			ga_ai_ally_tmb_start.sunits:kill_proportion_over_time(1.0, 5000, false);
		end;

		if ga_ai_ally_vlad_reinforce.sunits:are_any_active_on_battlefield() == true then
			ga_ai_ally_vlad_reinforce.sunits:kill_proportion_over_time(1.0, 5000, false);
		end;

		if ga_ai_ally_luthor_reinforce.sunits:are_any_active_on_battlefield() == true then
			ga_ai_ally_luthor_reinforce.sunits:kill_proportion_over_time(1.0, 5000, false);
		end;

		if ga_ai_ally_neferata_reinforce.sunits:are_any_active_on_battlefield() == true then
			ga_ai_ally_neferata_reinforce.sunits:kill_proportion_over_time(1.0, 5000, false);
		end;
		
		sm:trigger_message("pyramid_lost_hint");

		bm:setup_victory_callback(function() player_has_lost() end);
    end,
	true
)

function player_has_lost()	
	bm:callback(
		function()	
			bm:end_battle();
			bm:change_victory_countdown_limit(0);
		end,
		1000
	);
end;

ga_player_01:force_victory_on_message("wave_04_defeated", 5000);

---------------------------------------------
-----CAMPAIGN MORTARCH VLAD VON CARSTEIN-----
---------------------------------------------

local vlad_present = core:svr_load_bool("vlad_mortarch")
 
function spawn_vlad_campaign_army()
	if vlad_present then
		ga_ai_ally_vlad_reinforce:rush_on_message("start"); 
		ga_ai_ally_vlad_reinforce:defend_on_message("order_west_wave_01_defeated_offset", -295, 0, 100); 
		ga_ai_ally_vlad_reinforce:attack_force_on_message("wave_04_west_in", ga_ai_tmb_wave_04_west);
		
	elseif not vlad_present then
		ga_ai_ally_vlad_reinforce.sunits:set_enabled(false);
	else
		ga_ai_ally_vlad_reinforce.sunits:set_enabled(false);
		bm:out("The Vlad von Carstein campaign to battle link is broken...");
	end
end

function spawn_vlad_frontend_army()
	ga_ai_ally_vlad_reinforce:rush_on_message("start"); 
	ga_ai_ally_vlad_reinforce:defend_on_message("order_west_wave_01_defeated_offset", -295, 0, 100); 
	ga_ai_ally_vlad_reinforce:attack_force_on_message("wave_04_west_in", ga_ai_tmb_wave_04_west);

	bm:out("Adding Vlad von Carstein to the front end battle");
end

-----------------------------------------
-----CAMPAIGN MORTARCH LUTHOR HARKON-----
-----------------------------------------

local luthor_present = core:svr_load_bool("luthor_mortarch")
 
function spawn_luthor_campaign_army()
	if luthor_present then
		ga_ai_ally_luthor_reinforce:rush_on_message("start"); 
		ga_ai_ally_luthor_reinforce:defend_on_message("order_main_wave_01_defeated_offset", 0, -115.0, 100); 
		ga_ai_ally_luthor_reinforce:attack_force_on_message("wave_04_south_in", ga_ai_tmb_wave_04_south);
		
	elseif not luthor_present then
		ga_ai_ally_luthor_reinforce.sunits:set_enabled(false);
	else
		ga_ai_ally_luthor_reinforce.sunits:set_enabled(false);
		bm:out("The Luthor Harkon campaign to battle link is broken...");
	end
end

function spawn_luthor_frontend_army()
	ga_ai_ally_luthor_reinforce:rush_on_message("start"); 
	ga_ai_ally_luthor_reinforce:defend_on_message("order_main_wave_01_defeated_offset", 0, -115.0, 100); 
	ga_ai_ally_luthor_reinforce:attack_force_on_message("wave_04_south_in", ga_ai_tmb_wave_04_south);

	bm:out("Adding Luthor Harkon to the front end battle");
end

------------------------------------
-----CAMPAIGN MORTARCH NEFERATA-----
------------------------------------

local neferata_present = core:svr_load_bool("neferata_mortarch")
 
function spawn_neferata_campaign_army()
	if neferata_present then
		ga_ai_ally_neferata_reinforce:rush_on_message("start"); 
		ga_ai_ally_neferata_reinforce:defend_on_message("order_east_wave_01_defeated_offset", 295, 0, 100); 
		ga_ai_ally_neferata_reinforce:attack_force_on_message("wave_04_east_in", ga_ai_tmb_wave_04_east);
		
	elseif not neferata_present then
		ga_ai_ally_neferata_reinforce.sunits:set_enabled(false);
	else
		ga_ai_ally_neferata_reinforce.sunits:set_enabled(false);
		bm:out("The Neferata campaign to battle link is broken...");
	end
end

function spawn_neferata_frontend_army()
	ga_ai_ally_neferata_reinforce:rush_on_message("start"); 
	ga_ai_ally_neferata_reinforce:defend_on_message("order_east_wave_01_defeated_offset", 295, 0, 100); 
	ga_ai_ally_neferata_reinforce:attack_force_on_message("wave_04_east_in", ga_ai_tmb_wave_04_east);

	bm:out("Adding Neferata to the front end battle");
end

-------------------------------------
----------INTRO CUTSCENE VO----------
-------------------------------------
local sfx_cutscene_sweetener_intro_play = new_sfx("Play_Movie_WH3_DLC29_FB_Nagash_Intro", true, false)
local sfx_cutscene_sweetener_intro_stop = new_sfx("Stop_Movie_WH3_DLC29_FB_Nagash_Intro", false, false)

-------------------------------------
----------MID CUTSCENE VO----------
-------------------------------------
local sfx_cutscene_sweetener_mid_play = new_sfx("Play_Movie_WH3_DLC29_FB_Nagash_Mid", true, false)
local sfx_cutscene_sweetener_mid_stop = new_sfx("Stop_Movie_WH3_DLC29_FB_Nagash_Mid", false, false)

-------------------------------------
----------OUTRO CUTSCENE VO----------
-------------------------------------
local sfx_cutscene_sweetener_outro_play = new_sfx("Play_Movie_WH3_DLC29_FB_Nagash_Outro", true, false)
local sfx_cutscene_sweetener_outro_stop = new_sfx("Stop_Movie_WH3_DLC29_FB_Nagash_Outro", false, false)

-- -----------------------------------
-- ----------CINEMATIC FILES----------
-- -----------------------------------
intro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\nag_fb_intro_m01.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);

mid_cinematic_file_01 = "script\\battle\\quest_battles\\_cutscene\\managers\\nag_fb_mid_m01.CindySceneManager";
outro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\nag_fb_outro_m01.CindySceneManager";

gb:set_cutscene_during_deployment(true);

-----------------------------------
----------INTRO CINEMATIC----------
-----------------------------------
function play_intro_cutscene()
	
	local cam = bm:camera();
	
	local cutscene_intro = cutscene:new_from_cindyscene(
        -- unique string name for cutscene
        "cutscene_intro",
        -- unitcontroller or scriptunits collection over player's army
        ga_player_01.sunits,
        -- end callback
        function() end_intro_cutscene() end,
        -- path to cindy scene
        intro_cinematic_file,
        -- optional fade in/fade out durations
        1,
        1
	);

	-- skip callback
	cutscene_intro:set_skippable(
		true, 
		function()
			local cam = bm:camera();
			cam:fade(true, 0);
			bm:stop_cindy_playback(true);
						
			bm:callback(function() cam:fade(false, 0.5) end, 500);
			bm:hide_subtitles();
		end
	);

	-- set up subtitles
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();
	
	-- Campaign/Frontend Contexts
	cutscene_intro:action(
		function() 
		if bm:is_from_campaign() then
			spawn_vlad_campaign_army()
			spawn_luthor_campaign_army()
			spawn_neferata_campaign_army()
		else
			spawn_vlad_frontend_army()
			spawn_luthor_frontend_army()
			spawn_neferata_frontend_army()

			bm:out("---------- Adding front end armies ----------");
		end
	end, 
	100
	);

	cutscene_intro:action(
		function() 	
			ga_player_01.sunits:set_invisible_to_all(true);
		end, 
		10
	);

	-- Voiceover and Subtitles --
	cutscene_intro:action(function() cutscene_intro:play_sound(sfx_cutscene_sweetener_intro_play) end, 100);
	
	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc29_nag_nagash_undeath_to_all_01", 
			function()
				--cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_nag_nagash_undeath_to_all_01"));
				bm:show_subtitle("wh3_dlc29_nag_nagash_final_battle_intro_01", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc29_nag_nagash_undeath_to_all_02", 
			function()
				--cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_nag_nagash_undeath_to_all_02"));
				bm:show_subtitle("wh3_dlc29_nag_nagash_final_battle_intro_02", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc29_nag_nagash_undeath_to_all_03", 
			function()
				--cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_nag_nagash_undeath_to_all_03"));
				bm:show_subtitle("wh3_dlc29_nag_nagash_final_battle_intro_03", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc29_nag_nagash_undeath_to_all_04", 
			function()
				--cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_nag_nagash_undeath_to_all_04"));
				bm:show_subtitle("wh3_dlc29_nag_nagash_final_battle_intro_04", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc29_nag_nagash_undeath_to_all_05", 
			function()
				--cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_nag_nagash_undeath_to_all_05"));
				bm:show_subtitle("wh3_dlc29_nag_nagash_final_battle_intro_05", false, true);
			end
	);
	
	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc29_nag_nagash_undeath_to_all_06", 
			function()
				--cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_nag_nagash_undeath_to_all_06"));
				bm:show_subtitle("wh3_dlc29_nag_nagash_final_battle_intro_06", false, true);
			end
	);
	
	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc29_nag_nagash_undeath_to_all_07", 
			function()
				--cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_nag_nagash_undeath_to_all_07"));
				bm:show_subtitle("wh3_dlc29_nag_nagash_final_battle_intro_07", false, true);
			end
	);

	cutscene_intro:start();
end;

function end_intro_cutscene()
	bm:start_terrain_composite_scene(black_pyramid_01, nil, 0);

	bm:camera():fade(false, 1.0)

	ga_player_01.sunits:set_invisible_to_all(false);

	play_sound_2D(sfx_cutscene_sweetener_intro_stop)

	gb.sm:trigger_message("intro_cutscene_end");

	bm:hide_subtitles();
	bm:cindy_preload(mid_cinematic_file_01);
end;

------------------------------------
----------MID 01 CINEMATIC----------
------------------------------------
function prepare_for_mid_01_cutscene()
    bm:camera():fade(true, 0.5)	
    bm:callback(function() play_mid_01_cutscene() end, 500)
end

function play_mid_01_cutscene()
	
	local cam = bm:camera();
	
	local cutscene_mid_01 = cutscene:new_from_cindyscene(
        -- unique string name for cutscene
        "cutscene_mid_01",
        -- unitcontroller or scriptunits collection over player's army
        ga_player_01.sunits,
        -- end callback
        function() end_mid_cutscene() end,
        -- path to cindy scene
        mid_cinematic_file_01,
        -- optional fade in/fade out durations
        1,
        1
	);
	
	cam:fade(false, 1);
	bm:stop_terrain_composite_scene(black_pyramid_01);

	-- skip callback
	cutscene_mid_01:set_skippable(
		true, 
		function()
			local cam = bm:camera();
			cam:fade(true, 0);
			bm:stop_cindy_playback(true);
						
			bm:callback(function() cam:fade(false, 0.5) end, 500);
			bm:hide_subtitles();
		end
	);

	-- set up subtitles
	local subtitles = cutscene_mid_01:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();
		
	-- Voiceover and Subtitles --
	cutscene_mid_01:action(function() cutscene_mid_01:play_sound(sfx_cutscene_sweetener_mid_play) end, 100);
	
	cutscene_mid_01:add_cinematic_trigger_listener(
		"Play_wh3_dlc29_nag_nagash_undeath_to_all_mid_01", 
			function()
				cutscene_mid_01:play_sound(new_sfx("Play_wh3_dlc29_nag_nagash_undeath_to_all_mid_01"));
				bm:show_subtitle("wh3_dlc29_nag_nagash_final_battle_mid_01", false, true);
			end
	);

	cutscene_mid_01:add_cinematic_trigger_listener(
		"Play_wh3_dlc29_nag_nagash_undeath_to_all_mid_02", 
			function()
				cutscene_mid_01:play_sound(new_sfx("Play_wh3_dlc29_nag_nagash_undeath_to_all_mid_02"));
				bm:show_subtitle("wh3_dlc29_nag_nagash_final_battle_mid_02", false, true);
			end
	);

	cutscene_mid_01:add_cinematic_trigger_listener(
		"Play_wh3_dlc29_nag_nagash_undeath_to_all_mid_03", 
			function()
				cutscene_mid_01:play_sound(new_sfx("Play_wh3_dlc29_nag_nagash_undeath_to_all_mid_03"));
				bm:show_subtitle("wh3_dlc29_nag_nagash_final_battle_mid_03", false, true);
			end
	);

	cutscene_mid_01:start();
end;

function end_mid_cutscene()
	bm:start_terrain_composite_scene(black_pyramid_02, nil, 0);

	bm:camera():fade(false, 1.0)

	play_sound_2D(sfx_cutscene_sweetener_mid_stop)
	
	gb.sm:trigger_message("mid_01_cutscene_end");

	bm:hide_subtitles();
	bm:cindy_preload(outro_cinematic_file);
end;

-----------------------------------
----------OUTRO CINEMATIC----------
-----------------------------------
function prepare_for_outro_cutscene()
    bm:camera():fade(true, 0.5)
    bm:callback(function() play_outro_cutscene() end, 500)
end

function play_outro_cutscene()
	
	local cam = bm:camera();
	
	local cutscene_outro = cutscene:new_from_cindyscene(
        -- unique string name for cutscene
        "outro_cutscene_end",
        -- unitcontroller or scriptunits collection over player's army
        ga_player_01.sunits,
        -- end callback
        function() end_outro_cutscene() end,
        -- path to cindy scene
        outro_cinematic_file,
        -- optional fade in/fade out durations
        0,
        0
	);

	cam:fade(false, 1);
	bm:stop_terrain_composite_scene(black_pyramid_02);

	-- skip callback
	cutscene_outro:set_skippable(
		true, 
		function()
			local cam = bm:camera();
			cam:fade(true, 0);
			bm:stop_cindy_playback(true);
						
			bm:callback(function() cam:fade(false, 0.5) end, 500);
			bm:hide_subtitles();
		end
	);

	-- set up subtitles
	local subtitles = cutscene_outro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();
	
	-- Voiceover and Subtitles --
	cutscene_outro:action(function() cutscene_outro:play_sound(sfx_cutscene_sweetener_outro_play) end, 100);

	cutscene_outro:add_cinematic_trigger_listener(
		"Play_wh3_dlc29_nag_nagash_undeath_to_all_outro_01", 
			function()
				--cutscene_outro:play_sound(new_sfx("Play_wh3_dlc29_nag_nagash_undeath_to_all_outro_01"));
				bm:show_subtitle("wh3_dlc29_nag_nagash_final_battle_outro_01", false, true);
			end
	);

	cutscene_outro:add_cinematic_trigger_listener(
		"Play_wh3_dlc29_nag_nagash_undeath_to_all_outro_02", 
			function()
				--cutscene_outro:play_sound(new_sfx("Play_wh3_dlc29_nag_nagash_undeath_to_all_outro_02"));
				bm:show_subtitle("wh3_dlc29_nag_nagash_final_battle_outro_02", false, true);
			end
	);

	cutscene_outro:add_cinematic_trigger_listener(
		"Play_wh3_dlc29_nag_nagash_undeath_to_all_outro_03", 
			function()
				--cutscene_outro:play_sound(new_sfx("Play_wh3_dlc29_nag_nagash_undeath_to_all_outro_03"));
				bm:show_subtitle("wh3_dlc29_nag_nagash_final_battle_outro_03", false, true);
			end
	);

	cutscene_outro:add_cinematic_trigger_listener(
		"Play_wh3_dlc29_nag_nagash_undeath_to_all_outro_04", 
			function()
				--cutscene_outro:play_sound(new_sfx("Play_wh3_dlc29_nag_nagash_undeath_to_all_outro_04"));
				bm:show_subtitle("wh3_dlc29_nag_nagash_final_battle_outro_04", false, true);
			end
	);

	cutscene_outro:add_cinematic_trigger_listener(
		"Play_wh3_dlc29_tmb_settra_undeath_to_all_outro_05", 
			function()
				--cutscene_outro:play_sound(new_sfx("Play_wh3_dlc29_nag_nagash_undeath_to_all_outro_05"));
				bm:show_subtitle("wh3_dlc29_nag_nagash_final_battle_outro_05", false, true);
			end
	);

	cutscene_outro:add_cinematic_trigger_listener(
		"Play_wh3_dlc29_tmb_settra_undeath_to_all_outro_06", 
			function()
				--cutscene_outro:play_sound(new_sfx("Play_wh3_dlc29_nag_nagash_undeath_to_all_outro_06"));
				bm:show_subtitle("wh3_dlc29_nag_nagash_final_battle_outro_06", false, true);
			end
	);

	cutscene_outro:add_cinematic_trigger_listener(
		"Play_wh3_dlc29_nag_nagash_undeath_to_all_outro_07", 
			function()
				--cutscene_outro:play_sound(new_sfx("Play_wh3_dlc29_nag_nagash_undeath_to_all_outro_07"));
				bm:show_subtitle("wh3_dlc29_nag_nagash_final_battle_outro_07", false, true);
			end
	);

	cutscene_outro:start();
end;

function end_outro_cutscene()
	bm:start_terrain_composite_scene(black_pyramid_03, nil, 0);

	bm:camera():fade(false, 1.0)

	play_sound_2D(sfx_cutscene_sweetener_outro_stop)

	gb.sm:trigger_message("outro_cutscene_end");

	bm:hide_subtitles();
end;