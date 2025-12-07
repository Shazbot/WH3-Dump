load_script_libraries();

local gc = generated_cutscene:new(true);

gb = generated_battle:new(
                false,                          -- screen starts black
                false,                          -- prevent deployment for player
                true,                          -- prevent deployment for ai
				function() play_intro_cutscene() end,      -- intro cutscene function -- nil, --
                false                           -- debug mode
);

---------------------------
----HARD SCRIPT VERSION----
---------------------------
local sm = get_messager();

------------------------------
----------ARMY SETUP----------
------------------------------
ga_player_01 = gb:get_army(gb:get_player_alliance_num());
--Khorne Daemons
ga_ai_kho_start = gb:get_army(gb:get_non_player_alliance_num(), "kho_start");
ga_ai_kho_reinforce = gb:get_army(gb:get_non_player_alliance_num(), "kho_reinforce");
ga_ai_kho_daemon_lord = gb:get_army(gb:get_non_player_alliance_num(), "kho_daemon_lord");
ga_ai_kho_daemon_lord_reinforce = gb:get_army(gb:get_non_player_alliance_num(), "kho_daemon_lord_reinforce");
--Nurgle Daemons
ga_ai_nur_start = gb:get_army(gb:get_non_player_alliance_num(), "nur_start");
ga_ai_nur_reinforce = gb:get_army(gb:get_non_player_alliance_num(), "nur_reinforce");
ga_ai_nur_daemon_lord = gb:get_army(gb:get_non_player_alliance_num(), "nur_daemon_lord");
ga_ai_nur_daemon_lord_reinforce = gb:get_army(gb:get_non_player_alliance_num(), "nur_daemon_lord_reinforce");
--Slaanesh Daemons
ga_ai_sla_start = gb:get_army(gb:get_non_player_alliance_num(), "sla_start");
ga_ai_sla_reinforce = gb:get_army(gb:get_non_player_alliance_num(), "sla_reinforce");
ga_ai_sla_daemon_lord = gb:get_army(gb:get_non_player_alliance_num(), "sla_daemon_lord");
ga_ai_sla_daemon_lord_reinforce = gb:get_army(gb:get_non_player_alliance_num(), "sla_daemon_lord_reinforce");
--Tzeentch Daemons
ga_ai_tze_start = gb:get_army(gb:get_non_player_alliance_num(), "tze_start");
ga_ai_tze_reinforce = gb:get_army(gb:get_non_player_alliance_num(), "tze_reinforce");
ga_ai_tze_daemon_lord = gb:get_army(gb:get_non_player_alliance_num(), "tze_daemon_lord");
ga_ai_tze_daemon_lord_reinforce = gb:get_army(gb:get_non_player_alliance_num(), "tze_daemon_lord_reinforce");

sayl_lord = ga_player_01.sunits:item(1);
kho_boss = ga_ai_kho_daemon_lord.sunits:item(1);
nur_boss = ga_ai_nur_daemon_lord.sunits:item(1);
sla_boss = ga_ai_sla_daemon_lord.sunits:item(1);
tze_boss = ga_ai_tze_daemon_lord.sunits:item(1);

-------------------------------
----------SPAWN ZONES----------
-------------------------------
local reinforcements = bm:reinforcements();

--Attackers Reinforce
daemons_reinforce = bm:get_spawn_zone_collection_by_name("dae_reinforce");
kho_lord_reinforce = bm:get_spawn_zone_collection_by_name("kho_lord_reinforce");
nur_lord_reinforce = bm:get_spawn_zone_collection_by_name("nur_lord_reinforce");
sla_lord_reinforce = bm:get_spawn_zone_collection_by_name("sla_lord_reinforce");
tze_lord_reinforce = bm:get_spawn_zone_collection_by_name("tze_lord_reinforce");

--Daemon Lords Teleporting
ga_ai_kho_daemon_lord:assign_to_spawn_zone_from_collection_on_message("objective_01", kho_lord_reinforce, false);
ga_ai_kho_daemon_lord_reinforce:assign_to_spawn_zone_from_collection_on_message("objective_01", kho_lord_reinforce, false);
ga_ai_nur_daemon_lord:assign_to_spawn_zone_from_collection_on_message("objective_01", nur_lord_reinforce, false);
ga_ai_nur_daemon_lord_reinforce:assign_to_spawn_zone_from_collection_on_message("objective_01", nur_lord_reinforce, false);
ga_ai_sla_daemon_lord:assign_to_spawn_zone_from_collection_on_message("objective_01", sla_lord_reinforce, false);
ga_ai_sla_daemon_lord_reinforce:assign_to_spawn_zone_from_collection_on_message("objective_01", sla_lord_reinforce, false);
ga_ai_tze_daemon_lord:assign_to_spawn_zone_from_collection_on_message("objective_01", tze_lord_reinforce, false);
ga_ai_tze_daemon_lord_reinforce:assign_to_spawn_zone_from_collection_on_message("objective_01", tze_lord_reinforce, false);

--Khorne Daemons Teleporting
ga_ai_kho_reinforce:assign_to_spawn_zone_from_collection_on_message("objective_01", daemons_reinforce, false);
ga_ai_kho_reinforce:message_on_number_deployed("kho_daemons_deployed", true, 1);
ga_ai_kho_reinforce:assign_to_spawn_zone_from_collection_on_message("kho_daemons_deployed", daemons_reinforce, false);

--Nurgle Daemons Teleporting
ga_ai_nur_reinforce:assign_to_spawn_zone_from_collection_on_message("objective_01", daemons_reinforce, false);
ga_ai_nur_reinforce:message_on_number_deployed("nur_daemons_deployed", true, 1);
ga_ai_nur_reinforce:assign_to_spawn_zone_from_collection_on_message("nur_daemons_deployed", daemons_reinforce, false);

--Slaanesh Daemons Teleporting
ga_ai_sla_reinforce:assign_to_spawn_zone_from_collection_on_message("objective_01", daemons_reinforce, false);
ga_ai_sla_reinforce:message_on_number_deployed("sla_daemons_deployed", true, 1);
ga_ai_sla_reinforce:assign_to_spawn_zone_from_collection_on_message("sla_daemons_deployed", daemons_reinforce, false);

--Tzeentch Daemons Teleporting
ga_ai_tze_reinforce:assign_to_spawn_zone_from_collection_on_message("objective_01", daemons_reinforce, false);
ga_ai_tze_reinforce:message_on_number_deployed("tze_daemons_deployed", true, 1);
ga_ai_tze_reinforce:assign_to_spawn_zone_from_collection_on_message("tze_daemons_deployed", daemons_reinforce, false);

for i = 1, reinforcements:attacker_reinforcement_lines_count() do
	
	local line = reinforcements:attacker_reinforcement_line(i);

	if (line:script_id() == "dae_reinforce") then
		line:enable_random_deployment_position();		
	end
end;

--------------------------------------
----------HINTS & OBJECTIVES----------
--------------------------------------
-----OBJECTIVE 0-----
--Keep Sayl Alive
gb:set_locatable_objective_callback_on_message(
    "start",
    "wh3_dlc27_nor_sayl_final_battle_objective_00",
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

-----OBJECTIVE 1-----
--Defeat the Chaos Mortals
gb:set_objective_with_leader_on_message("objective_01", "wh3_dlc27_nor_sayl_final_battle_objective_01");
gb:complete_objective_on_message("mortals_defeated", "wh3_dlc27_nor_sayl_final_battle_objective_01");
gb:fail_objective_on_message("sayl_dead", "wh3_dlc27_nor_sayl_final_battle_objective_01");
gb:remove_objective_on_message("mortals_defeated", "wh3_dlc27_nor_sayl_final_battle_objective_01", 10000);

gb:queue_help_on_message("start", "wh3_dlc27_nor_sayl_final_battle_hint_01");

-----OBJECTIVE 2-----
--Bind the Exalted Daemons - Defeat the Daemon lords to bind their souls to the ritual
gb:set_objective_with_leader_on_message("daemons_arrived", "wh3_dlc27_nor_sayl_final_battle_objective_02");
gb:message_on_time_offset("objective_02a", 2500, "daemons_arrived");
gb:set_objective_on_message("objective_02a", "wh3_dlc27_nor_sayl_final_battle_objective_02", 0, 0, 4);
gb:set_objective_on_message("one_daemon_dead", "wh3_dlc27_nor_sayl_final_battle_objective_02", 0, 1, 4);
gb:set_objective_on_message("two_daemons_dead", "wh3_dlc27_nor_sayl_final_battle_objective_02", 0, 2, 4);
gb:set_objective_on_message("three_daemons_dead", "wh3_dlc27_nor_sayl_final_battle_objective_02", 0, 3, 4);
gb:set_objective_on_message("all_daemons_dead", "wh3_dlc27_nor_sayl_final_battle_objective_02", 0, 4, 4);

gb:complete_objective_on_message("all_daemons_dead", "wh3_dlc27_nor_sayl_final_battle_objective_02");
gb:fail_objective_on_message("sayl_dead", "wh3_dlc27_nor_sayl_final_battle_objective_02");
gb:remove_objective_on_message("all_daemons_dead", "wh3_dlc27_nor_sayl_final_battle_objective_02", 10000);

num_daemons_killed = 0;
required_daemons_kills = 4;

gb:add_listener(
	"enemy_daemon_dead",
	function()
		num_daemons_killed = num_daemons_killed + 1;
		
		print("Daemon Killed - Total Daemons Killed: " .. num_daemons_killed);
		
		if num_daemons_killed == 1 then
			sm:trigger_message("one_daemon_dead");
		elseif num_daemons_killed == 2 then
			sm:trigger_message("two_daemons_dead");
		elseif num_daemons_killed == 3 then
			sm:trigger_message("three_daemons_dead");
		elseif num_daemons_killed == 4 then
			sm:trigger_message("all_daemons_dead");
			gb:remove_listener("enemy_daemon_dead");
		end
	end,
	true
);

gb:queue_help_on_message("daemons_arrival", "wh3_dlc27_nor_sayl_final_battle_hint_02");

----------------------------------
----------SPECIAL ORDERS----------
----------------------------------
local reinforce_speed = 40000;
local reinforce_units = 1;

local perpetual = true;
local shattered_only = false;
local permit_rampaging = true;

gb:message_on_time_offset("start", 100);
gb:message_on_time_offset("objective_01", 5000);

gb:message_on_all_messages_received("mortals_defeated", "chs_kho_dead", "chs_nur_dead", "chs_sla_dead", "chs_tze_dead")
gb:message_on_all_messages_received("daemons_arrived", "kho_dae_lord_in", "nur_dae_lord_in", "sla_dae_lord_in", "tze_dae_lord_in")

ga_ai_kho_reinforce:get_army():suppress_reinforcement_adc(1);
ga_ai_nur_reinforce:get_army():suppress_reinforcement_adc(1);
ga_ai_sla_reinforce:get_army():suppress_reinforcement_adc(1);
ga_ai_tze_reinforce:get_army():suppress_reinforcement_adc(1);

ga_player_01:message_on_commander_dead_or_shattered("sayl_dead");
ga_ai_kho_start:force_victory_on_message("sayl_dead", 5000);
ga_player_01:force_victory_on_message("outro_cutscene_end");

ga_player_01:add_winds_of_magic_on_message("start", 50)
ga_player_01:add_winds_of_magic_reserve_on_message("start", 50);
ga_player_01:add_winds_of_magic_on_message("mortals_defeated", 50)
ga_player_01:add_winds_of_magic_reserve_on_message("mortals_defeated", 50);

----------------------------------
----------PHASE 1 ORDERS----------
----------------------------------
gb:add_listener(
	"start",
	function()
		ga_ai_kho_start.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_nur_start.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_sla_start.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_tze_start.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
	end
);

ga_ai_kho_start:rush_on_message("start");
ga_ai_nur_start:rush_on_message("start");
ga_ai_sla_start:rush_on_message("start");
ga_ai_tze_start:rush_on_message("start");

ga_ai_kho_start:message_on_rout_proportion("chs_kho_dead",0.95);
ga_ai_nur_start:message_on_rout_proportion("chs_nur_dead",0.95);
ga_ai_sla_start:message_on_rout_proportion("chs_sla_dead",0.95);
ga_ai_tze_start:message_on_rout_proportion("chs_tze_dead",0.95);

gb:add_listener(
	"mortals_defeated",
	function()
		if ga_ai_kho_start.sunits:are_any_active_on_battlefield() == true then
			ga_ai_kho_start.sunits:kill_proportion_over_time(1.0, 500, false);
		end;

		if ga_ai_nur_start.sunits:are_any_active_on_battlefield() == true then
			ga_ai_nur_start.sunits:kill_proportion_over_time(1.0, 500, false);
		end;

		if ga_ai_sla_start.sunits:are_any_active_on_battlefield() == true then
			ga_ai_sla_start.sunits:kill_proportion_over_time(1.0, 500, false);
		end;

		if ga_ai_tze_start.sunits:are_any_active_on_battlefield() == true then
			ga_ai_tze_start.sunits:kill_proportion_over_time(1.0, 500, false);
		end;
	end,
	true
);

gb:message_on_time_offset("play_mid_cutscene", 5000, "mortals_defeated");

gb:add_listener(
	"play_mid_cutscene",
	function()
		play_mid_cutscene()
	end,
	true
);

----------------------------------
----------PHASE 2 ORDERS----------
----------------------------------
gb:message_on_time_offset("daemons_arrival", 2500, "mid_cutscene_end");

ga_ai_kho_daemon_lord:reinforce_on_message("daemons_arrival")
ga_ai_kho_daemon_lord:message_on_any_deployed("kho_dae_lord_in");
ga_ai_kho_daemon_lord:rush_on_message("kho_dae_lord_in");

gb:message_on_time_offset("kho_dae_lord_reinforce", 2500, "kho_dae_lord_in");

ga_ai_kho_daemon_lord_reinforce:reinforce_on_message("kho_dae_lord_reinforce")
ga_ai_kho_daemon_lord_reinforce:message_on_any_deployed("kho_dae_lord_reinforce_in");
ga_ai_kho_daemon_lord_reinforce:rush_on_message("kho_dae_lord_reinforce_in");

ga_ai_nur_daemon_lord:reinforce_on_message("daemons_arrival")
ga_ai_nur_daemon_lord:message_on_any_deployed("nur_dae_lord_in");
ga_ai_nur_daemon_lord:rush_on_message("nur_dae_lord_in");

gb:message_on_time_offset("nur_dae_lord_reinforce", 2500, "nur_dae_lord_in");

ga_ai_nur_daemon_lord_reinforce:reinforce_on_message("nur_dae_lord_reinforce")
ga_ai_nur_daemon_lord_reinforce:message_on_any_deployed("nur_dae_lord_reinforce_in");
ga_ai_nur_daemon_lord_reinforce:rush_on_message("nur_dae_lord_reinforce_in");

ga_ai_sla_daemon_lord:reinforce_on_message("daemons_arrival")
ga_ai_sla_daemon_lord:message_on_any_deployed("sla_dae_lord_in");
ga_ai_sla_daemon_lord:rush_on_message("sla_dae_lord_in");

gb:message_on_time_offset("sla_dae_lord_reinforce", 2500, "sla_dae_lord_in");

ga_ai_sla_daemon_lord_reinforce:reinforce_on_message("sla_dae_lord_reinforce")
ga_ai_sla_daemon_lord_reinforce:message_on_any_deployed("sla_dae_lord_reinforce_in");
ga_ai_sla_daemon_lord_reinforce:rush_on_message("sla_dae_lord_reinforce_in");

ga_ai_tze_daemon_lord:reinforce_on_message("daemons_arrival")
ga_ai_tze_daemon_lord:message_on_any_deployed("tze_dae_lord_in");
ga_ai_tze_daemon_lord:rush_on_message("tze_dae_lord_in");

gb:message_on_time_offset("tze_dae_lord_reinforce", 2500, "tze_dae_lord_in");

ga_ai_tze_daemon_lord_reinforce:reinforce_on_message("tze_dae_lord_reinforce")
ga_ai_tze_daemon_lord_reinforce:message_on_any_deployed("tze_dae_lord_reinforce_in");
ga_ai_tze_daemon_lord_reinforce:rush_on_message("tze_dae_lord_reinforce_in");

ga_ai_kho_daemon_lord:message_on_rout_proportion("exalted_kho_dead",0.99);
ga_ai_nur_daemon_lord:message_on_rout_proportion("exalted_nur_dead",0.99);
ga_ai_sla_daemon_lord:message_on_rout_proportion("exalted_sla_dead",0.99);
ga_ai_tze_daemon_lord:message_on_rout_proportion("exalted_tze_dead",0.99);

ga_ai_kho_daemon_lord:message_on_rout_proportion("enemy_daemon_dead",0.95);
ga_ai_nur_daemon_lord:message_on_rout_proportion("enemy_daemon_dead",0.95);
ga_ai_sla_daemon_lord:message_on_rout_proportion("enemy_daemon_dead",0.95);
ga_ai_tze_daemon_lord:message_on_rout_proportion("enemy_daemon_dead",0.95);

gb:add_listener(
	"objective_02a",
	function()
		kho_boss:add_ping_icon(15);
		nur_boss:add_ping_icon(15);
		sla_boss:add_ping_icon(15);
		tze_boss:add_ping_icon(15);
	end,
	true
);

ga_ai_kho_reinforce:deploy_at_random_intervals_on_message(
	"daemons_arrived", 			-- message
	reinforce_units, 			-- min units
	reinforce_units, 			-- max units
	reinforce_speed, 			-- min period
	reinforce_speed, 			-- max period
	"exalted_kho_dead", 		-- cancel message
	nil,						-- spawn first wave immediately
	true,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	true						-- show debug output
);

ga_ai_kho_reinforce:message_on_any_deployed("kho_dae_in");
ga_ai_kho_reinforce:rush_on_message("kho_dae_in");

ga_ai_nur_reinforce:deploy_at_random_intervals_on_message(
	"daemons_arrived", 			-- message
	reinforce_units, 			-- min units
	reinforce_units, 			-- max units
	reinforce_speed, 			-- min period
	reinforce_speed, 			-- max period
	"exalted_nur_dead", 		-- cancel message
	nil,						-- spawn first wave immediately
	true,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	true						-- show debug output
);

ga_ai_nur_reinforce:message_on_any_deployed("nur_dae_in");
ga_ai_nur_reinforce:rush_on_message("nur_dae_in");

ga_ai_sla_reinforce:deploy_at_random_intervals_on_message(
	"daemons_arrived", 			-- message
	reinforce_units, 			-- min units
	reinforce_units, 			-- max units
	reinforce_speed, 			-- min period
	reinforce_speed, 			-- max period
	"exalted_sla_dead", 		-- cancel message
	nil,						-- spawn first wave immediately
	true,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	true						-- show debug output
);

ga_ai_sla_reinforce:message_on_any_deployed("sla_dae_in");
ga_ai_sla_reinforce:rush_on_message("sla_dae_in");

ga_ai_tze_reinforce:deploy_at_random_intervals_on_message(
	"daemons_arrived", 			-- message
	reinforce_units, 			-- min units
	reinforce_units, 			-- max units
	reinforce_speed, 			-- min period
	reinforce_speed, 			-- max period
	"exalted_tze_dead", 		-- cancel message
	nil,						-- spawn first wave immediately
	true,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	true						-- show debug output
);

ga_ai_tze_reinforce:message_on_any_deployed("tze_dae_in");
ga_ai_tze_reinforce:rush_on_message("tze_dae_in");

gb:add_listener(
	"exalted_kho_dead",
	function()
		if ga_ai_kho_reinforce.sunits:are_any_active_on_battlefield() == true then
			ga_ai_kho_reinforce.sunits:kill_proportion_over_time(1.0, 5000, false);
		end;

		if ga_ai_kho_daemon_lord_reinforce.sunits:are_any_active_on_battlefield() == true then
			ga_ai_kho_daemon_lord_reinforce.sunits:kill_proportion_over_time(1.0, 5000, false);
		end;
	end,
	true
);

gb:add_listener(
	"exalted_nur_dead",
	function()
		if ga_ai_nur_reinforce.sunits:are_any_active_on_battlefield() == true then
			ga_ai_nur_reinforce.sunits:kill_proportion_over_time(1.0, 5000, false);
		end;

		if ga_ai_nur_daemon_lord_reinforce.sunits:are_any_active_on_battlefield() == true then
			ga_ai_nur_daemon_lord_reinforce.sunits:kill_proportion_over_time(1.0, 5000, false);
		end;
	end,
	true
);

gb:add_listener(
	"exalted_sla_dead",
	function()
		if ga_ai_sla_reinforce.sunits:are_any_active_on_battlefield() == true then
			ga_ai_sla_reinforce.sunits:kill_proportion_over_time(1.0, 5000, false);
		end;

		if ga_ai_sla_daemon_lord_reinforce.sunits:are_any_active_on_battlefield() == true then
			ga_ai_sla_daemon_lord_reinforce.sunits:kill_proportion_over_time(1.0, 5000, false);
		end;
	end,
	true
);

gb:add_listener(
	"exalted_tze_dead",
	function()
		if ga_ai_tze_reinforce.sunits:are_any_active_on_battlefield() == true then
			ga_ai_tze_reinforce.sunits:kill_proportion_over_time(1.0, 5000, false);
		end;

		if ga_ai_tze_daemon_lord_reinforce.sunits:are_any_active_on_battlefield() == true then
			ga_ai_tze_daemon_lord_reinforce.sunits:kill_proportion_over_time(1.0, 5000, false);
		end;
	end,
	true
);

gb:message_on_time_offset("play_outro_cutscene", 5000, "all_daemons_dead");

gb:add_listener(
	"play_outro_cutscene",
	function()
		play_outro_cutscene()
	end,
	true
);

-------------------------------------
----------INTRO CUTSCENE VO----------
-------------------------------------
local sfx_cutscene_sweetener_intro_play = new_sfx("Play_Movie_WH3_DLC27_QB_Sayl_The_Night_of_Revelation_Intro", true, false)
local sfx_cutscene_sweetener_intro_stop = new_sfx("Stop_Movie_WH3_DLC27_QB_Sayl_The_Night_of_Revelation_Intro", false, false)
-------------------------------------
----------MID CUTSCENE 1 VO----------
-------------------------------------
local sfx_cutscene_sweetener_mid_play = new_sfx("Play_Movie_WH3_DLC27_QB_Sayl_The_Night_of_Revelation_Mid", true, false)
local sfx_cutscene_sweetener_mid_stop = new_sfx("Stop_Movie_WH3_DLC27_QB_Sayl_The_Night_of_Revelation_Mid", false, false)
-------------------------------------
----------MID CUTSCENE 2 VO----------
-------------------------------------
local sfx_cutscene_sweetener_outro_play = new_sfx("Play_Movie_WH3_DLC27_QB_Sayl_The_Night_of_Revelation_Outro", true, false)
local sfx_cutscene_sweetener_outro_stop = new_sfx("Stop_Movie_WH3_DLC27_QB_Sayl_The_Night_of_Revelation_Outro", false, false)
-----------------------------------
----------CINEMATIC FILES----------
-----------------------------------
intro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\wh3_sayl_fb_intro_m01.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);

mid_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\wh3_sayl_fb_mid_m01.CindySceneManager";
outro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\wh3_sayl_fb_outro_m01.CindySceneManager";

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
        0,
        0
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

	-- Voiceover and Subtitles --
	
	-- set up subtitles
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();
		
	cutscene_intro:action(function() cutscene_intro:play_sound(sfx_cutscene_sweetener_intro_play) end, 100);
	
	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_nor_sayl_final_battle_intro_01", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc27_nor_sayl_final_battle_intro_01"));
				bm:show_subtitle("wh3_dlc27_nor_sayl_final_battle_intro_01", false, true);
			end
	);
	
	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_nor_sayl_final_battle_intro_02", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc27_nor_sayl_final_battle_intro_02"));
				bm:show_subtitle("wh3_dlc27_nor_sayl_final_battle_intro_02", false, true);
			end
	);
	
	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_nor_sayl_final_battle_intro_03", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc27_nor_sayl_final_battle_intro_03"));
				bm:show_subtitle("wh3_dlc27_nor_sayl_final_battle_intro_03", false, true);

				ga_ai_kho_start.sunits:set_always_visible(true);
				ga_ai_nur_start.sunits:set_always_visible(true);
				ga_ai_sla_start.sunits:set_always_visible(true);
				ga_ai_tze_start.sunits:set_always_visible(true);

			end
	);
	
	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_nor_sayl_final_battle_intro_04", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc27_nor_sayl_final_battle_intro_04"));
				bm:show_subtitle("wh3_dlc27_nor_sayl_final_battle_intro_04", false, true);
			end
	);
	
	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_nor_sayl_final_battle_intro_05", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc27_nor_sayl_final_battle_intro_05"));
				bm:show_subtitle("wh3_dlc27_nor_sayl_final_battle_intro_05", false, true);
			end
	);
	
	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_nor_sayl_final_battle_intro_06", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc27_nor_sayl_final_battle_intro_06"));
				bm:show_subtitle("wh3_dlc27_nor_sayl_final_battle_intro_06", false, true);
			end
	);
	
	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_nor_sayl_final_battle_intro_07", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc27_nor_sayl_final_battle_intro_07"));
				bm:show_subtitle("wh3_dlc27_nor_sayl_final_battle_intro_07", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_nor_sayl_final_battle_intro_08", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc27_nor_sayl_final_battle_intro_08"));
				bm:show_subtitle("wh3_dlc27_nor_sayl_final_battle_intro_08", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_nor_sayl_final_battle_intro_09", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc27_nor_sayl_final_battle_intro_09"));
				bm:show_subtitle("wh3_dlc27_nor_sayl_final_battle_intro_09", false, true);
			end
	);

	cutscene_intro:set_music("wh3_dlc27_Battle_Intro_Sayl", 0, 0)

	cutscene_intro:start();
end;

function end_intro_cutscene()
	play_sound_2D(sfx_cutscene_sweetener_intro_stop)
	ga_player_01.sunits:set_invisible_to_all(false);
	ga_player_01.sunits:release_control();

	ga_ai_kho_start.sunits:set_always_visible(false);
	ga_ai_nur_start.sunits:set_always_visible(false);
	ga_ai_sla_start.sunits:set_always_visible(false);
	ga_ai_tze_start.sunits:set_always_visible(false);

	gb.sm:trigger_message("intro_cutscene_end");

	bm:cindy_preload(mid_cinematic_file);
	bm:hide_subtitles();
end;

---------------------------------
----------MID CINEMATIC----------
---------------------------------
function play_mid_cutscene()
	
	local cam = bm:camera();
	
	local cutscene_mid = cutscene:new_from_cindyscene(
        -- unique string name for cutscene
        "cutscene_mid",
        -- unitcontroller or scriptunits collection over player's army
        ga_player_01.sunits,
        -- end callback
        function() end_mid_cutscene() end,
        -- path to cindy scene
        mid_cinematic_file,
        -- optional fade in/fade out durations
        0,
        0
	);

	-- skip callback
	cutscene_mid:set_skippable(
		true, 
		function()
			local cam = bm:camera();
			cam:fade(true, 0);
			bm:stop_cindy_playback(true);
						
			bm:callback(function() cam:fade(false, 0.5) end, 500);
			bm:hide_subtitles();
		end
	);
	
	-- Voiceover and Subtitles --
	
	-- set up subtitles
	local subtitles = cutscene_mid:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();
		
	cutscene_mid:action(function() cutscene_mid:play_sound(sfx_cutscene_sweetener_mid_play) end, 100);
	
	cutscene_mid:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_nor_sayl_final_battle_middle_01", 
			function()
				cutscene_mid:play_sound(new_sfx("Play_wh3_dlc27_nor_sayl_final_battle_middle_01"));
				bm:show_subtitle("wh3_dlc27_nor_sayl_final_battle_middle_01", false, true);
			end
	);
	
	cutscene_mid:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_nor_sayl_final_battle_middle_02", 
			function()
				cutscene_mid:play_sound(new_sfx("Play_wh3_dlc27_nor_sayl_final_battle_middle_02"));
				bm:show_subtitle("wh3_dlc27_nor_sayl_final_battle_middle_02", false, true);
			end
	);
	
	cutscene_mid:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_nor_sayl_final_battle_middle_03", 
			function()
				cutscene_mid:play_sound(new_sfx("Play_wh3_dlc27_nor_sayl_final_battle_middle_03"));
				bm:show_subtitle("wh3_dlc27_nor_sayl_final_battle_middle_03", false, true);
			end
	);
	
	cutscene_mid:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_nor_sayl_final_battle_middle_04", 
			function()
				cutscene_mid:play_sound(new_sfx("Play_wh3_dlc27_nor_sayl_final_battle_middle_04"));
				bm:show_subtitle("wh3_dlc27_nor_sayl_final_battle_middle_04", false, true);
			end
	);

	cutscene_mid:set_music("wh3_dlc27_Battle_Middle_Sayl", 0, 0)

	cutscene_mid:start();
end;

function end_mid_cutscene()
	play_sound_2D(sfx_cutscene_sweetener_mid_stop)
	gb.sm:trigger_message("mid_cutscene_end");
	
	bm:cindy_preload(outro_cinematic_file);
	bm:hide_subtitles();
end;

--prevent traditional battle countdown
bm:setup_victory_callback(function() check_win() end)
function check_win()
	if bm:victorious_alliance() == gb:get_player_alliance_num() then
		gb:stop_end_battle(true)
	else
		bm:end_battle()
	end
end
-----------------------------------
----------OUTRO CINEMATIC----------
-----------------------------------
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
	
	-- Voiceover and Subtitles --
	
	-- set up subtitles
	local subtitles = cutscene_outro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();
	
	cutscene_outro:action(function() cutscene_outro:play_sound(sfx_cutscene_sweetener_outro_play) end, 100);
	
	cutscene_outro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_nor_sayl_final_battle_outro_01", 
			function()
				cutscene_outro:play_sound(new_sfx("Play_wh3_dlc27_nor_sayl_final_battle_outro_01"));
				bm:show_subtitle("wh3_dlc27_nor_sayl_final_battle_outro_01", false, true);
			end
	);
	
	cutscene_outro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_nor_sayl_final_battle_outro_02", 
			function()
				cutscene_outro:play_sound(new_sfx("Play_wh3_dlc27_nor_sayl_final_battle_outro_02"));
				bm:show_subtitle("wh3_dlc27_nor_sayl_final_battle_outro_02", false, true);
			end
	);
	
	cutscene_outro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_nor_sayl_final_battle_outro_03", 
			function()
				cutscene_outro:play_sound(new_sfx("Play_wh3_dlc27_nor_sayl_final_battle_outro_03"));
				bm:show_subtitle("wh3_dlc27_nor_sayl_final_battle_outro_03", false, true);
			end
	);
	
	cutscene_outro:add_cinematic_trigger_listener(
		"Play_wh3_dlc27_nor_sayl_final_battle_outro_04", 
			function()
				cutscene_outro:play_sound(new_sfx("Play_wh3_dlc27_nor_sayl_final_battle_outro_04"));
				bm:show_subtitle("wh3_dlc27_nor_sayl_final_battle_outro_04", false, true);
			end
	);

	cutscene_outro:set_music("wh3_dlc27_Battle_Outro_Sayl", 0, 0)

	cutscene_outro:start();
end;

function end_outro_cutscene()
	play_sound_2D(sfx_cutscene_sweetener_outro_stop)
	gb.sm:trigger_message("outro_cutscene_end");

	bm:hide_subtitles();
end;