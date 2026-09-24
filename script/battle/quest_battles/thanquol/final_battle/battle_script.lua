-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Thanquol
-- By Hristo Enev
-- Fall of Chaos Moon

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries();

bm = battle_manager:new(empire_battle:new());

--bm:camera():fade(true, 0);

gb = generated_battle:new(
                false,                         		 -- screen starts black
                false,                         		 -- prevent deployment for player
                false,                         		 -- prevent deployment for ai
				function() 
					play_intro_cutscene() 

					ga_ai_hef_main:set_visible_to_all(true);
					ga_ai_dwf_main:set_visible_to_all(true);
					ga_ai_emp_main:set_visible_to_all(true);
				end,-- intro cutscene function -- nil, --
                false                          		 -- debug mode
);


local countdown_length = 7.5*60*1000
local first_half_timer = countdown_length
local last_countdown_length = 0.5*60*1000
local second_half_timer = last_countdown_length
local wave_speed = countdown_length*0.5;

capture_location_position_x = 114;
capture_location_position_y = 482;

---------------------------------------
----------SKV REINS FROM CAM-----------
---------------------------------------
local skv_eshin_support_active = tonumber(core:svr_load_string("wh3_dlc29_skv_final_battle_support_eshin"))
local skv_mors_support_active = tonumber(core:svr_load_string("wh3_dlc29_skv_final_battle_support_mors"))
local skv_moulder_support_active = tonumber(core:svr_load_string("wh3_dlc29_skv_final_battle_support_moulder"))
local skv_pestilens_support_active = tonumber(core:svr_load_string("wh3_dlc29_skv_final_battle_support_pestilens"))
local skv_rictus_support_active = tonumber(core:svr_load_string("wh3_dlc29_skv_final_battle_support_rictus"))
local skv_skryre_support_active = tonumber(core:svr_load_string("wh3_dlc29_skv_final_battle_support_skryre"))
--[[
out(skv_eshin_support_active)
out(skv_mors_support_active)
out(skv_moulder_support_active)
out(skv_pestilens_support_active)
out(skv_rictus_support_active)
out(skv_skryre_support_active)]]
------------------------------
----------ARMY SETUP----------
------------------------------
ga_player = gb:get_army(gb:get_player_alliance_num());

ga_player_support_base = gb:get_army(gb:get_player_alliance_num(), "skv_base");
ga_player_support_base_frontend = gb:get_army(gb:get_player_alliance_num(), "skv_base_frontend");

if bm:is_from_campaign() then
	for i = 1, ga_player_support_base_frontend.sunits:count() do
		local current_sunit = ga_player_support_base_frontend.sunits:item(i);
		bm:reinforcements():set_unit_locked_until_event("permanent_lock", current_sunit.unit);
	end
else
	wave_speed=wave_speed*1.5
	for i = 1, ga_player_support_base.sunits:count() do
		local current_sunit = ga_player_support_base.sunits:item(i);
		bm:reinforcements():set_unit_locked_until_event("permanent_lock", current_sunit.unit);
	end
end

--Allied skaven support forces from campaign aid forces
ga_player_skv_eshin_support = gb:get_army(gb:get_player_alliance_num(), "skv_eshin");
if skv_eshin_support_active == 0 or bm:is_from_campaign() == false then 
	for i = 1, ga_player_skv_eshin_support.sunits:count() do
		local current_sunit = ga_player_skv_eshin_support.sunits:item(i);
		bm:reinforcements():set_unit_locked_until_event("permanent_lock", current_sunit.unit);
	end
end

ga_player_skv_mors_support = gb:get_army(gb:get_player_alliance_num(), "skv_mors");
if skv_mors_support_active == 0 or bm:is_from_campaign() == false then 
	for i = 1, ga_player_skv_mors_support.sunits:count() do
		local current_sunit = ga_player_skv_mors_support.sunits:item(i);
		bm:reinforcements():set_unit_locked_until_event("permanent_lock", current_sunit.unit);
	end
end

ga_player_skv_moulder_support = gb:get_army(gb:get_player_alliance_num(), "skv_moulder");
if skv_moulder_support_active == 0 or bm:is_from_campaign() == false then 
	for i = 1, ga_player_skv_moulder_support.sunits:count() do
		local current_sunit = ga_player_skv_moulder_support.sunits:item(i);
		bm:reinforcements():set_unit_locked_until_event("permanent_lock", current_sunit.unit);
	end
end

ga_player_skv_pestilens_support = gb:get_army(gb:get_player_alliance_num(), "skv_pestilens");
if skv_pestilens_support_active == 0 or bm:is_from_campaign() == false then 
	for i = 1, ga_player_skv_pestilens_support.sunits:count() do
		local current_sunit = ga_player_skv_pestilens_support.sunits:item(i);
		bm:reinforcements():set_unit_locked_until_event("permanent_lock", current_sunit.unit);
	end
end

ga_player_skv_rictus_support = gb:get_army(gb:get_player_alliance_num(), "skv_rictus");
if skv_rictus_support_active == 0 or bm:is_from_campaign() == false then 
	for i = 1, ga_player_skv_rictus_support.sunits:count() do
		local current_sunit = ga_player_skv_rictus_support.sunits:item(i);
		bm:reinforcements():set_unit_locked_until_event("permanent_lock", current_sunit.unit);
	end
end

ga_player_skv_skryre_support = gb:get_army(gb:get_player_alliance_num(), "skv_skryre");
if skv_skryre_support_active == 0 or bm:is_from_campaign() == false then 
	for i = 1, ga_player_skv_skryre_support.sunits:count() do
		local current_sunit = ga_player_skv_skryre_support.sunits:item(i);
		bm:reinforcements():set_unit_locked_until_event("permanent_lock", current_sunit.unit);
	end
end

--Enemy Main forces
ga_ai_dwf_main = gb:get_army(gb:get_non_player_alliance_num(), "dwf_main");
ga_ai_emp_main = gb:get_army(gb:get_non_player_alliance_num(), "emp_main");
ga_ai_hef_main = gb:get_army(gb:get_non_player_alliance_num(), "hef_main");
ga_ai_lzd_main = gb:get_army(gb:get_non_player_alliance_num(), "lzd_main");
ga_ai_lzd_slann = gb:get_army(gb:get_non_player_alliance_num(), "lzd_slann");
lzd_slann_boss = ga_ai_lzd_slann.sunits:item(1);

--Enemy waves
ga_ai_dwf_wave = gb:get_army(gb:get_non_player_alliance_num(), "dwf_wave");
ga_ai_emp_wave = gb:get_army(gb:get_non_player_alliance_num(), "emp_wave");
ga_ai_hef_wave = gb:get_army(gb:get_non_player_alliance_num(), "hef_wave");
ga_ai_lzd_wave = gb:get_army(gb:get_non_player_alliance_num(), "lzd_wave");

-------------------------------------------------------------------------------------------------
---------------------------------------- REINFORCEMENTS -----------------------------------------
-------------------------------------------------------------------------------------------------

lzd_main_reinforcments = bm:get_spawn_zone_collection_by_name("lzd_main")
ga_ai_lzd_main:assign_to_spawn_zone_from_collection_on_message("start", lzd_main_reinforcments, false);
ga_ai_lzd_main:message_on_number_deployed("lzd_main_deployed", true, 1);

ga_ai_lzd_slann:assign_to_spawn_zone_from_collection_on_message("start", lzd_main_reinforcments, false);
ga_ai_lzd_slann:message_on_number_deployed("lzd_slann_deployed", true, 1);

--wave reinforcements

dwf_wave_line = bm:get_spawn_zone_collection_by_name("dwf_wave")
ga_ai_dwf_wave:assign_to_spawn_zone_from_collection_on_message("start", dwf_wave_line, false);
ga_ai_dwf_wave:message_on_number_deployed("dwf_wave_deployed", true, 1);

emp_wave_line = bm:get_spawn_zone_collection_by_name("emp_wave")
ga_ai_emp_wave:assign_to_spawn_zone_from_collection_on_message("start", emp_wave_line, false);
ga_ai_emp_wave:message_on_number_deployed("emp_wave_deployed", true, 1);

hef_wave_line = bm:get_spawn_zone_collection_by_name("hef_wave")
ga_ai_hef_wave:assign_to_spawn_zone_from_collection_on_message("start", hef_wave_line, false);
ga_ai_hef_wave:message_on_number_deployed("hef_wave_deployed", true, 1);

lzd_wave_line = bm:get_spawn_zone_collection_by_name("lzd_wave")
ga_ai_lzd_wave:assign_to_spawn_zone_from_collection_on_message("start", lzd_wave_line, false);
ga_ai_lzd_wave:message_on_number_deployed("lzd_wave_deployed", true, 1);

--------------------------------------
----------HINTS & OBJECTIVES----------
--------------------------------------

-----OBJECTIVE PERMANENT-----
-- gb:set_objective_on_message("intro_cutscene_end", "wh3_dlc29_qb_skv_thanquol_final_battle_objective_permanent", 1100);
gb:fail_objective_on_message("thanquol_dead", "wh3_dlc29_qb_skv_thanquol_final_battle_objective_permanent", 500);
gb:complete_objective_on_message("player_wins", "wh3_dlc29_qb_skv_thanquol_final_battle_objective_permanent", 1500);

gb:set_locatable_objective_callback_on_message(
    "intro_cutscene_end",
    "wh3_dlc29_qb_skv_thanquol_final_battle_objective_permanent",
    1100,
    function()
        local sunit = ga_player.sunits:item(1)
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

gb:set_objective_on_message("intro_cutscene_end", "wh3_dlc29_qb_skv_thanquol_final_battle_obejctive_1", 1000);
gb:fail_objective_on_message("player_lost", "wh3_dlc29_qb_skv_thanquol_final_battle_obejctive_1", 500);
--gb:complete_objective_on_message("player_survived", "wh3_dlc29_qb_skv_thanquol_final_battle_obejctive_1", 1500);
--gb:remove_objective_on_message("player_survived", "wh3_dlc29_qb_skv_thanquol_final_battle_obejctive_1", 10000);

gb:add_listener(
    "start",
	function()
		bm:repeat_callback(
			function()
				first_half_timer = first_half_timer - 1000
				bm:set_objective("wh3_dlc29_qb_skv_thanquol_final_battle_obejctive_1", first_half_timer/1000, countdown_length/1000)
				if first_half_timer <= second_half_timer then 
					sm:trigger_message("player_survived")
					bm:remove_callback("end_countdown");
				end
				if first_half_timer == countdown_length/2 then -- play hint at halfway of the timer 
					bm:queue_help_message("wh3_dlc29_qb_skv_thanquol_final_battle_hint_1_timer", 10000, 2000)
					local timer_at_50_vo = new_sfx("Play_wh3_dlc29_skv_thanquol_fall_of_the_chaos_moon_objective_50_01", false, true);
					play_sound_2D(timer_at_50_vo);
				end
				if first_half_timer == second_half_timer+22000 then -- play hint just before second phase
					bm:queue_help_message("wh3_dlc29_qb_skv_thanquol_final_battle_hint_1_timer_2", 10000, 2000)
					local timer_at_90_vo = new_sfx("Play_wh3_dlc29_skv_thanquol_fall_of_the_chaos_moon_objective_90_01", false, true);
					play_sound_2D(timer_at_90_vo);
				end
			end, 
			1000,
			"end_countdown"
		)
	end
)

gb:queue_help_on_message("start", "wh3_dlc29_qb_skv_thanquol_final_battle_hint_1", 10000, 2000, 15000)

-----OBJECTIVE 2-----
gb:set_objective_on_message("mid_cutscene_end", "wh3_dlc29_qb_skv_thanquol_final_battle_objective_2", 5000);
gb:fail_objective_on_message("player_lost", "wh3_dlc29_qb_skv_thanquol_final_battle_objective_2", 500);
gb:add_listener(
	"mid_cutscene_end",
	function()
		bm:repeat_callback(
			function()
				if lzd_slann_boss.unit:unary_hitpoints() <= 0 then
				sm:trigger_message("slann_boss_dead")
				--ga_ai_lzd_slann.sunits:item(1):remove_ping_icon();
				end	
			end,
			100,
			"slann_boss_dead"
		)
	end
)
gb:message_on_time_offset("add_ping", 5000, "mid_cutscene_end")
gb:add_listener(
	"add_ping",
	function()
		lzd_slann_boss:add_ping_icon(15);
	end
);

gb:complete_objective_on_message("slann_boss_dead", "wh3_dlc29_qb_skv_thanquol_final_battle_objective_2", 2000);
gb:remove_objective_on_message("slann_boss_dead", "wh3_dlc29_qb_skv_thanquol_final_battle_objective_2", 5000);

gb:queue_help_on_message("mid_cutscene_end", "wh3_dlc29_qb_skv_thanquol_final_battle_hint_2", 10000, 2000, 10000)

-----OBJECTIVE 3-----
gb:remove_objective_on_message("slann_boss_dead", "wh3_dlc29_qb_skv_thanquol_final_battle_obejctive_1", 500);
gb:set_objective_on_message("slann_boss_dead", "wh3_dlc29_qb_skv_thanquol_final_battle_objective_3", 2000);
gb:fail_objective_on_message("player_lost", "wh3_dlc29_qb_skv_thanquol_final_battle_objective_3", 500);
gb:complete_objective_on_message("player_wins", "wh3_dlc29_qb_skv_thanquol_final_battle_objective_3", 1500);

gb:add_listener(
    "slann_boss_dead",
	function()
		bm:set_objective("wh3_dlc29_qb_skv_thanquol_final_battle_objective_3", countdown_length)
		bm:repeat_callback(
			function()
				second_half_timer = second_half_timer - 1000
				bm:set_objective("wh3_dlc29_qb_skv_thanquol_final_battle_objective_3", second_half_timer/1000, countdown_length/1000)
				if second_half_timer <= 1 then 
					sm:trigger_message("player_wins")
					bm:remove_callback("end_countdown");
				end
			end, 
			1000,
			"end_countdown"
		)
	end
)
-------------------------------------------------------------------------------------------------
--------------------------------------------- DEFEAT -------------------------------------------
-------------------------------------------------------------------------------------------------
ga_player:message_on_commander_dead_or_shattered("thanquol_dead");

ga_player:rout_over_time_on_message("thanquol_dead", 1000);
ga_player_support_base:rout_over_time_on_message("thanquol_dead", 1000);
ga_player_support_base_frontend:rout_over_time_on_message("thanquol_dead", 1000);
ga_player_skv_eshin_support:rout_over_time_on_message("thanquol_dead", 1000);
ga_player_skv_mors_support:rout_over_time_on_message("thanquol_dead", 1000);
ga_player_skv_moulder_support:rout_over_time_on_message("thanquol_dead", 1000);
ga_player_skv_pestilens_support:rout_over_time_on_message("thanquol_dead", 1000);
ga_player_skv_rictus_support:rout_over_time_on_message("thanquol_dead", 1000);
ga_player_skv_skryre_support:rout_over_time_on_message("thanquol_dead", 1000);

gb:message_on_capture_location_capture_completed("player_lost", true, "engine_capture_point", nil, nil, gb:get_non_player_alliance_num());
ga_player:message_on_casualties("player_lost", 0.95);

ga_ai_dwf_main:force_victory_on_message("player_lost", 5500);

ga_player:rout_over_time_on_message("player_lost", 2000);
ga_player_support_base:rout_over_time_on_message("player_lost", 2000);
ga_player_support_base_frontend:rout_over_time_on_message("player_lost", 2000);
ga_player_skv_eshin_support:rout_over_time_on_message("player_lost", 2000);
ga_player_skv_mors_support:rout_over_time_on_message("player_lost", 2000);
ga_player_skv_moulder_support:rout_over_time_on_message("player_lost", 2000);
ga_player_skv_pestilens_support:rout_over_time_on_message("player_lost", 2000);
ga_player_skv_rictus_support:rout_over_time_on_message("player_lost", 2000);
ga_player_skv_skryre_support:rout_over_time_on_message("player_lost", 2000);

--[[
gb:add_listener(
	"player_lost",
	function()
		bm:callback(
			function()
			bm:end_battle();
			bm:force_battle_end(gb.get_non_player_alliance_num(), "scripted", true, true)
			end,
			100
		);
	end
)
]]
-------------------------------------------------------------------------------------------------
------------------------------------------- VICTORY ---------------------------------------------
-------------------------------------------------------------------------------------------------
ga_ai_dwf_main:rout_over_time_on_message("player_wins", 1500);
ga_ai_emp_main:rout_over_time_on_message("player_wins", 1500);
ga_ai_hef_main:rout_over_time_on_message("player_wins", 1500);
ga_ai_lzd_main:rout_over_time_on_message("player_wins", 1500);
ga_ai_dwf_wave:rout_over_time_on_message("player_wins", 1500);
ga_ai_emp_wave:rout_over_time_on_message("player_wins", 1500);
ga_ai_hef_wave:rout_over_time_on_message("player_wins", 1500);
ga_ai_lzd_wave:rout_over_time_on_message("player_wins", 1500);

ga_player:force_victory_on_message("outro_cutscene_end", 1000);
gb:message_on_time_offset("force_battle_end",1000,"outro_cutscene_end");
gb:add_listener(
    "force_battle_end",
	function()
		bm:force_battle_end(gb:get_player_alliance_num(), "scripted", true, true)
	end
)

-------------------------------------------
----------CAPTURE POINT LOCATIONS----------
-------------------------------------------
local engine_capture_point = bm:capture_location_manager():capture_location_from_script_id("engine_capture_point");

engine_capture_point:change_holding_army(ga_player.army);
engine_capture_point:set_locked(false);

gb:add_listener(
    "thanquol_dead",
	function()
		engine_capture_point:change_holding_army(ga_ai_dwf_main.army);
		ga_player.sunits:item(2):kill(true);
	end
)

local reinforcements = bm:reinforcements();

for i = 1, reinforcements:defender_reinforcement_lines_count() do
	
	local line = reinforcements:defender_reinforcement_line(i);
	
	if (line:script_id() == "skv_support_location_1") then
		line:enable_random_deployment_position();		
	end
	if (line:script_id() == "skv_support_location_2") then
		line:enable_random_deployment_position();		
	end
	if (line:script_id() == "skv_support_location_3") then
		line:enable_random_deployment_position();		
	end
	if (line:script_id() == "skv_support_location_4") then
		line:enable_random_deployment_position();		
	end
end;

reinforcements:link_support_units_event_with_capture_point("unlock_support_units", engine_capture_point);

engine_capture_point:set_income_cap_for_alliance(bm:get_player_alliance(), 5000.0);

--reinforcements:set_cost_based_support_units_event("unlock_support_units", 0, 1499);

local message_for_supplies_has_triggered = false
gb:add_listener(
	"start",
	function()
		engine_capture_point:change_holding_army(ga_player.army);
		bm:repeat_callback(
			function()
				local army = bm:get_player_alliance():armies():item(1)
				local current_supplies = army:currency_amount("supplies_currency")
				if current_supplies >= 3000 then
					battle_ui_manager:highlight_supplies(true,nil,false)
					battle_ui_manager:highlight_survival_battle_specific_ui(true,nil,false)
					else
					battle_ui_manager:highlight_supplies(false,nil,false)
					battle_ui_manager:highlight_survival_battle_specific_ui(false,nil,false)
				end
				if current_supplies >= 6000 and message_for_supplies_has_triggered == false then
					bm:queue_help_message("wh3_dlc29_qb_skv_thanquol_final_battle_hint_supplies", 8000, 1000)
					message_for_supplies_has_triggered = true
				end
				if current_supplies <= 3000 and message_for_supplies_has_triggered == true then
					message_for_supplies_has_triggered = false
				end
			end,
			2000
		)
	end
);

----------------------------------
-----------BATTLE SETUP-----------
----------------------------------
gb:set_cutscene_during_deployment(true);

-- set the music to enter the bespoke state
bm:set_music_vm_variable("bespoke_battle_id", "thanquol_final_battle");

gb:message_on_time_offset("start", 100);

gb:message_on_time_offset("deploy_first_wave", wave_speed, "start");
gb:message_on_time_offset("phase_2_start", first_half_timer-second_half_timer, "start");

ga_player:add_winds_of_magic_reserve_on_message("start", 100);
ga_player:add_winds_of_magic_on_message("start", 18);
--play mid cutscene--
gb:block_message_on_message("player_lost","phase_2_start")
gb:add_listener(
	"phase_2_start",
	function()
		bm:callback(
			function()
			play_mid_cutscene()
			end,
			1000
		)
	end
)

--play outro cutscene--
gb:add_listener(
	"player_wins",
	function()
		play_outro_cutscene()
	end,
	true
)
-------------------------------
-------------ORDERS------------
-------------------------------
gb:message_on_time_offset("armies_rush", 3000, "start")

ga_ai_dwf_main:rush_position_on_message("armies_rush", -90, 306 , 30)
ga_ai_dwf_main:message_on_proximity_to_enemy("dwf_attack", 60)
ga_ai_dwf_main:rush_on_message("dwf_attack")

ga_ai_emp_main:rush_position_on_message("armies_rush", 300, 320 , 30)
ga_ai_emp_main:message_on_proximity_to_enemy("emp_attack", 40)
ga_ai_emp_main:rush_on_message("emp_attack")

ga_ai_hef_main:rush_position_on_message("armies_rush", capture_location_position_x, capture_location_position_y , 200)
ga_ai_hef_main:message_on_proximity_to_enemy("hef_attack", 50)
ga_ai_hef_main:rush_on_message("hef_attack")

ga_ai_lzd_main:deploy_at_random_intervals_on_message(
	"phase_2_start", 			-- message
	6, 							-- min units
	6, 							-- max units
	2000, 						-- min period
	3000, 						-- max period
	nil, 						-- cancel message
	true,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
	);

ga_ai_lzd_main:message_on_any_deployed("lzd_main_in");
ga_ai_lzd_main:rush_position_on_message("lzd_main_in", capture_location_position_x, capture_location_position_y , 200); 

ga_ai_lzd_slann:deploy_at_random_intervals_on_message(
	"phase_2_start", 			-- message
	6, 							-- min units
	6, 							-- max units
	2000, 						-- min period
	3000, 						-- max period
	nil, 						-- cancel message
	true,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
	);

ga_ai_lzd_slann:message_on_any_deployed("lzd_slann_in");
ga_ai_lzd_slann:defend_on_message("lzd_slann_in", 100, -130, 50); 
lzd_slann_boss:set_stat_attribute("unbreakable", true);

ga_ai_dwf_wave:deploy_at_random_intervals_on_message(
	"deploy_first_wave", 		-- message
	4, 							-- min units
	4, 							-- max units
	wave_speed, 				-- min period
	wave_speed, 				-- max period
	"player_wins", 				-- cancel message
	true,						-- spawn first wave immediately
	true,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
	);

ga_ai_dwf_wave:message_on_any_deployed("dwf_wave_in");
ga_ai_dwf_wave:rush_position_on_message("dwf_wave_in", capture_location_position_x, capture_location_position_y , 200); 

ga_ai_emp_wave:deploy_at_random_intervals_on_message(
	"deploy_first_wave", 		-- message
	4, 							-- min units
	4, 							-- max units
	wave_speed, 				-- min period
	wave_speed, 				-- max period
	"player_wins", 				-- cancel message
	true,						-- spawn first wave immediately
	true,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
	);

ga_ai_emp_wave:message_on_any_deployed("emp_wave_in");
ga_ai_emp_wave:rush_position_on_message("emp_wave_in", capture_location_position_x, capture_location_position_y , 200); 

ga_ai_hef_wave:deploy_at_random_intervals_on_message(
	"deploy_first_wave", 		-- message
	4, 							-- min units
	4, 							-- max units
	wave_speed, 				-- min period
	wave_speed, 				-- max period
	"player_wins", 				-- cancel message
	true,						-- spawn first wave immediately
	true,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
	);

ga_ai_hef_wave:message_on_any_deployed("hef_wave_in");
ga_ai_hef_wave:rush_position_on_message("hef_wave_in", capture_location_position_x, capture_location_position_y , 200); 

ga_ai_lzd_wave:deploy_at_random_intervals_on_message(
	"phase_2_start", 			-- message
	4, 							-- min units
	4, 							-- max units
	wave_speed, 				-- min period
	wave_speed, 				-- max period
	"player_wins", 						-- cancel message
	false,						-- spawn first wave immediately
	true,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
	);

ga_ai_lzd_wave:message_on_any_deployed("lzd_wave_in");
ga_ai_lzd_wave:rush_position_on_message("lzd_wave_in", capture_location_position_x, capture_location_position_y , 200); 

-------------------------------------
----------INTRO CUTSCENE VO----------
-------------------------------------
local sfx_cutscene_sweetener_intro_play = new_sfx("Play_Movie_WH3_DLC29_FB_Thanquol_Intro", true, false)
local sfx_cutscene_sweetener_intro_stop = new_sfx("Stop_Movie_WH3_DLC29_FB_Thanquol_Intro", false, false)
-------------------------------------
----------MID CUTSCENE VO----------
-------------------------------------
local sfx_cutscene_sweetener_mid_play = new_sfx("Play_Movie_WH3_DLC29_FB_Thanquol_Mid", true, false)
local sfx_cutscene_sweetener_mid_stop = new_sfx("Stop_Movie_WH3_DLC29_FB_Thanquol_Mid", false, false)
-------------------------------------
----------OUTRO CUTSCENE VO----------
-------------------------------------
local sfx_cutscene_sweetener_outro_play = new_sfx("Play_Movie_WH3_DLC29_FB_Thanquol_Outro", true, false)
local sfx_cutscene_sweetener_outro_stop = new_sfx("Stop_Movie_WH3_DLC29_FB_Thanquol_Outro", false, false)

-----------------------------------
----------INTRO CINEMATIC----------
-----------------------------------
function play_intro_cutscene()
	
	local cam = bm:camera();
	
	local cutscene_intro = cutscene:new_from_cindyscene(
		"cutscene_intro", 																				-- unique string name for cutscene
		ga_player.sunits,																				-- unitcontroller over player's army
		function() intro_cutscene_end() end,															-- what to call when cutscene is finished
		"script/battle/quest_battles/_cutscene/managers/wh3_thanquol_fb_intro_01.CindySceneManager",	-- path to cindyscene
		1,																								-- blend in time (s)
		0.5																								-- blend out time (s)
	)

	--ga_player_01.sunits:set_always_visible(true);

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
	
	-- disable unit visibility
	cutscene_intro:action(
		function()
		ga_player.sunits:take_control();
		ga_ai_dwf_main.sunits:take_control();
		ga_ai_emp_main.sunits:take_control();
		ga_ai_hef_main.sunits:take_control();
		end, 
		200
	)

	cutscene_intro:action(function() cam:fade(false, 1) end, 1000);
	
	-- Voiceover and Subtitles --
	
	cutscene_intro:action(function() cutscene_intro:play_sound(sfx_cutscene_sweetener_intro_play) end, 100);
	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc29_skv_thanquol_fall_of_the_chaos_moon_01", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_skv_thanquol_fall_of_the_chaos_moon_01"));
				bm:show_subtitle("wh3_dlc29_qb_skv_thanquol_final_battle_intro_01", false, true);
			end
	);
	
	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc29_skv_thanquol_fall_of_the_chaos_moon_02", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_skv_thanquol_fall_of_the_chaos_moon_02"));
				bm:show_subtitle("wh3_dlc29_qb_skv_thanquol_final_battle_intro_02", false, true);
			end
	);
	
	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc29_skv_thanquol_fall_of_the_chaos_moon_03", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_skv_thanquol_fall_of_the_chaos_moon_03"));
				bm:show_subtitle("wh3_dlc29_qb_skv_thanquol_final_battle_intro_03", false, true);
			end
	);
	
	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc29_skv_thanquol_fall_of_the_chaos_moon_04", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_skv_thanquol_fall_of_the_chaos_moon_04"));
				bm:show_subtitle("wh3_dlc29_qb_skv_thanquol_final_battle_intro_04", false, true);
			end
	);
	
	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc29_skv_thanquol_fall_of_the_chaos_moon_05", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_skv_thanquol_fall_of_the_chaos_moon_05"));
				bm:show_subtitle("wh3_dlc29_qb_skv_thanquol_final_battle_intro_05", false, true);
			end
	);
	
	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc29_skv_thanquol_fall_of_the_chaos_moon_06", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_skv_thanquol_fall_of_the_chaos_moon_06"));
				bm:show_subtitle("wh3_dlc29_qb_skv_thanquol_final_battle_intro_06", false, true);
			end
	);
	--cutscene_intro:set_music("wh3_dlc27_Battle_Intro_Aislinn", 0, 0)
	
	cutscene_intro:start();

end;

function intro_cutscene_end()
	--camera position to move at the end of cutscene 
	camera_target=v(110, 533, 245, -1)
	camera_position=v(110, 630, 400, -1)
	bm:scroll_camera_with_cutscene(
		camera_position,
		camera_target,
		0.5
		)
	ga_player.sunits:release_control();
	--ga_ai_dwf_main.sunits:release_control();
	--ga_ai_emp_main.sunits:release_control();
	--ga_ai_hef_main.sunits:release_control();
	--play_sound_2d(sfx_cutscene_sweetener_intro_stop);
	gb.sm:trigger_message("intro_cutscene_end");
	cam:fade(false, 0.5)
end;

---------------------------------
----------MID CINEMATIC----------
---------------------------------
function play_mid_cutscene()

	bm:callback(function() 
		local cam = bm:camera()
		
		-- REMOVE ME
		--cam:fade(false, 2)

		local cutscene_mid = cutscene:new_from_cindyscene(
			"cutscene_mid", 																				-- unique string name for cutscene
			ga_player.sunits,																				-- unitcontroller over player's army
			function() mid_cutscene_end() end,																-- what to call when cutscene is finished
			"script/battle/quest_battles/_cutscene/managers/wh3_thanquol_fb_middle_01.CindySceneManager",		-- path to cindyscene
			0,																								-- blend in time (s)
			0																								-- blend out time (s)
		)

		ga_ai_dwf_wave.sunits:set_invisible_to_all(true);
		ga_ai_emp_wave.sunits:set_invisible_to_all(true);
		ga_ai_hef_wave.sunits:set_invisible_to_all(true);
		ga_ai_lzd_main.sunits:set_invisible_to_all(true);
		ga_ai_lzd_slann.sunits:set_invisible_to_all(true);

		-- set up subtitles
		local subtitles = cutscene_mid:subtitles()
		subtitles:set_alignment("bottom_centre")
		subtitles:clear()
		
		-- skip callback
		cutscene_mid:set_skippable(
			true, 
			function()
				local cam = bm:camera()
				cam:fade(true, 0.5)
				bm:stop_cindy_playback(true)
				bm:callback(function() cam:fade(false, 0.5) end, 500)
				bm:hide_subtitles()
			end
		)
		
		-- set up actions on cutscene
		cutscene_mid:action(
			function() 
				cam:fade(false, 1) 
			end, 
		1000)

		-- Voiceover and Subtitles --
		cutscene_mid:action(function() cutscene_mid:play_sound(sfx_cutscene_sweetener_mid_play) end, 0);
		
		cutscene_mid:add_cinematic_trigger_listener(
			"Play_wh3_dlc29_skv_thanquol_fall_of_the_chaos_moon_mid_01", 
				function()
					cutscene_mid:play_sound(new_sfx("Play_wh3_dlc29_skv_thanquol_fall_of_the_chaos_moon_mid_01"))
					bm:show_subtitle("wh3_dlc29_qb_skv_thanquol_final_battle_mid_01", false, true)
				end
		)

		cutscene_mid:add_cinematic_trigger_listener(
			"Play_wh3_dlc29_skv_thanquol_fall_of_the_chaos_moon_mid_02", 
				function()
					cutscene_mid:play_sound(new_sfx("Play_wh3_dlc29_skv_thanquol_fall_of_the_chaos_moon_mid_02"))
					bm:show_subtitle("wh3_dlc29_qb_skv_thanquol_final_battle_mid_02", false, true)
				end
		)

		cutscene_mid:add_cinematic_trigger_listener(
			"Play_wh3_dlc29_skv_thanquol_fall_of_the_chaos_moon_mid_03", 
				function()
					cutscene_mid:play_sound(new_sfx("Play_wh3_dlc29_skv_thanquol_fall_of_the_chaos_moon_mid_03"))
					bm:show_subtitle("wh3_dlc29_qb_skv_thanquol_final_battle_mid_03", false, true)
				end
		)

		cutscene_mid:action(function() 
				cam:fade(true, 1) 
			end, 30000);
		
		cutscene_mid:start()
	end, 100)
end

function mid_cutscene_end()
	--camera position to move at the end of cutscene 
	lzd_slann_boss:teleport_to_location(v(100,556,-140) , 0, 3);
	ga_ai_lzd_slann:defend_on_message("lzd_slann_in", 100, -130, 50); 
	camera_target=v(110, 533, 245, -1)
	camera_position=v(110, 630, 400, -1)
	bm:scroll_camera_with_cutscene(
		camera_position,
		camera_target,
		0.5
		)
		ga_ai_dwf_wave.sunits:set_invisible_to_all(false);
		ga_ai_emp_wave.sunits:set_invisible_to_all(false);
		ga_ai_hef_wave.sunits:set_invisible_to_all(false);
		ga_ai_lzd_main.sunits:set_invisible_to_all(false);
		ga_ai_lzd_slann.sunits:set_invisible_to_all(false);

	cam:fade(false, 0.5);
	--play_sound_2D(sfx_cutscene_sweetener_mid_stop)
	gb.sm:trigger_message("mid_cutscene_end")
end

-----------------------------------
----------OUTRO CINEMATIC----------
-----------------------------------

function play_outro_cutscene()
	--bm:camera():fade(true, 0.5)

	bm:callback(function() 
		local cam = bm:camera()
		
		-- REMOVE ME
		--cam:fade(false, 2)

		local cutscene_outro = cutscene:new_from_cindyscene(
			"cutscene_outro", 																				-- unique string name for cutscene
			ga_player.sunits,																				-- unitcontroller over player's army
			function() outro_cutscene_end() end,															-- what to call when cutscene is finished
			"script/battle/quest_battles/_cutscene/managers/wh3_thanquol_fb_outro_01.CindySceneManager",	-- path to cindyscene
			0,																								-- blend in time (s)
			0																								-- blend out time (s)
		)
		--hide armies
		ga_player.sunits:set_enabled(false);
		ga_ai_dwf_main.sunits:set_invisible_to_all(true);
		ga_ai_emp_main.sunits:set_invisible_to_all(true);
		ga_ai_hef_main.sunits:set_invisible_to_all(true);
		ga_ai_lzd_main.sunits:set_invisible_to_all(true);
		ga_ai_dwf_wave.sunits:set_invisible_to_all(true);
		ga_ai_emp_wave.sunits:set_invisible_to_all(true);
		ga_ai_hef_wave.sunits:set_invisible_to_all(true);
		ga_ai_lzd_wave.sunits:set_invisible_to_all(true);

		-- set up subtitles
		local subtitles = cutscene_outro:subtitles()
		subtitles:set_alignment("bottom_centre")
		subtitles:clear()
		
		-- skip callback
		cutscene_outro:set_skippable(
			true, 
			function()
				local cam = bm:camera()
				cam:fade(true, 0)
				bm:stop_cindy_playback(true)
				bm:callback(function() cam:fade(false, 0.5) end, 500)
				bm:hide_subtitles()
			end
		)
		
		-- set up actions on cutscene
		cutscene_outro:action(function() cam:fade(false, 1) end, 1000)
		
		-- Voiceover and Subtitles --
		cutscene_outro:action(function() cutscene_outro:play_sound(sfx_cutscene_sweetener_outro_play) end, 0);
		
		cutscene_outro:add_cinematic_trigger_listener(
			"Play_wh3_dlc29_skv_thanquol_fall_of_the_chaos_moon_post_01", 
				function()
					cutscene_outro:play_sound(new_sfx("Play_wh3_dlc29_skv_thanquol_fall_of_the_chaos_moon_post_01"))
					bm:show_subtitle("wh3_dlc29_qb_skv_thanquol_final_battle_outro_01", false, true)
				end
		)

		cutscene_outro:add_cinematic_trigger_listener(
			"Play_wh3_dlc29_skv_thanquol_fall_of_the_chaos_moon_post_02", 
				function()
					cutscene_outro:play_sound(new_sfx("Play_wh3_dlc29_skv_thanquol_fall_of_the_chaos_moon_post_02"))
					bm:show_subtitle("wh3_dlc29_qb_skv_thanquol_final_battle_outro_02", false, true)
				end
		)

		cutscene_outro:start()
	end, 1000)
end

function outro_cutscene_end()
	--camera position
	camera_target=v(100, 533, 100, -1)
	camera_position=v(155, 630, 285, -1)
	bm:scroll_camera_with_cutscene(
		camera_position,
		camera_target,
		0.5
		)
	cam:fade(true, 1, true);
	--play_sound_2D(sfx_cutscene_sweetener_outro_stop)
	gb.sm:trigger_message("outro_cutscene_end")
end

gb:add_listener(
	"outro_cutscene_end",
	function()
		bm:callback(
			function()
			bm:end_battle()
			end,
			100
		);
	end
);