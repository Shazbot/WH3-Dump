-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- The Changeling
-- The Trickster's Staff
-- Karak Eight Peaks
-- Attacker

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries()

-- bm:camera():fade(true, 0)

gb = generated_battle:new(
	false,                                      		-- screen starts black
	false,                                      		-- prevent deployment for player
	true,                                      			-- prevent deployment for ai
	function() end_deployment_phase() end,          	-- intro cutscene function
	false                                      			-- debug mode
);

local sm = get_messager();

gb:set_cutscene_during_deployment(true);

-- preload stuttering fix
intro_cinematic_file = "script/battle/quest_battles/_cutscene/managers/tze_tricksters_staff.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);

-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh3_main_sfx_00 = new_sfx("Play_Movie_WH3_DLC24_QB_The_Tricksters_Staff_Sweetener");

wh3_main_sfx_01 = new_sfx("Play_wh3_dlc24_qb_tze_the_changeling_the_tricksters_staff_01");
wh3_main_sfx_02 = new_sfx("Play_wh3_dlc24_qb_tze_the_changeling_the_tricksters_staff_02");
wh3_main_sfx_03 = new_sfx("Play_wh3_dlc24_qb_tze_the_changeling_the_tricksters_staff_03");
wh3_main_sfx_04 = new_sfx("Play_wh3_dlc24_qb_tze_the_changeling_the_tricksters_staff_04");
wh3_main_sfx_05 = new_sfx("Play_wh3_dlc24_qb_tze_the_changeling_the_tricksters_staff_05");
wh3_main_sfx_06 = new_sfx("Play_wh3_dlc24_qb_tze_the_changeling_the_tricksters_staff_06");

-------------------------------------------------------------------------------------------------
------------------------------------------- CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------

function end_deployment_phase()
bm:out("\tend_deployment_phase() called");
		
local cam = bm:camera();
		
local cutscene_intro = cutscene:new_from_cindyscene(
    -- unique string name for cutscene
    "cutscene_intro",
    -- unitcontroller or scriptunits collection over player's army
    ga_player_01.sunits,
    -- end callback
    function() intro_cutscene_end() end,
    -- path to cindy scene
    intro_cinematic_file,
    -- optional fade in/fade out durations
    0,
    0
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
			local cam = bm:camera();
			cam:fade(true, 0);
			bm:stop_cindy_playback(true);
						
			bm:callback(function() cam:fade(false, 0.5) end, 500);
			bm:hide_subtitles();
		end
	);
	
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000);
	cutscene_intro:action(function() 
		witch_hunter:set_invisible_to_all(true)
		end, 
		1000
	);

	-- Voiceover and Subtitles --
	cutscene_intro:action(function() cutscene_intro:play_sound(wh3_main_sfx_00) end, 100);
	
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc24_qb_tze_the_changeling_the_tricksters_staff_01", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc24_qb_tze_the_changeling_the_tricksters_staff_01"));
				bm:show_subtitle("wh3_dlc24_qb_tze_the_changeling_the_tricksters_staff_pt_01", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc24_qb_tze_the_changeling_the_tricksters_staff_02", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc24_qb_tze_the_changeling_the_tricksters_staff_02"));
				bm:show_subtitle("wh3_dlc24_qb_tze_the_changeling_the_tricksters_staff_pt_02", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc24_qb_tze_the_changeling_the_tricksters_staff_03", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc24_qb_tze_the_changeling_the_tricksters_staff_03"));
				bm:show_subtitle("wh3_dlc24_qb_tze_the_changeling_the_tricksters_staff_pt_03", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc24_qb_tze_the_changeling_the_tricksters_staff_04", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc24_qb_tze_the_changeling_the_tricksters_staff_04"));
				bm:show_subtitle("wh3_dlc24_qb_tze_the_changeling_the_tricksters_staff_pt_04", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc24_qb_tze_the_changeling_the_tricksters_staff_05", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc24_qb_tze_the_changeling_the_tricksters_staff_05"));
				bm:show_subtitle("wh3_dlc24_qb_tze_the_changeling_the_tricksters_staff_pt_05", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc24_qb_tze_the_changeling_the_tricksters_staff_06", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc24_qb_tze_the_changeling_the_tricksters_staff_06"));
				bm:show_subtitle("wh3_dlc24_qb_tze_the_changeling_the_tricksters_staff_pt_06", false, true);
			end
	);

	cutscene_intro:start();
end;

function intro_cutscene_end()
	witch_hunter:set_invisible_to_all(false)
	gb.sm:trigger_message("01_intro_cutscene_end");
end;

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player_01 = gb:get_army(gb:get_player_alliance_num())
ga_player_ally = gb:get_army(gb:get_player_alliance_num(), "player_ally")

ga_ai_start = gb:get_army(gb:get_non_player_alliance_num(), "start")
ga_ai_messenger_main = gb:get_army(gb:get_non_player_alliance_num(), "dwf_messenger_main")
ga_ai_messenger_force = gb:get_army(gb:get_non_player_alliance_num(), "dwf_messenger_force")
ga_ai_emp_reinforce = gb:get_army(gb:get_non_player_alliance_num(), "emp_reinforce")
ga_ai_cth_reinforce = gb:get_army(gb:get_non_player_alliance_num(), "cth_reinforce")
ga_ai_brt_reinforce = gb:get_army(gb:get_non_player_alliance_num(), "brt_reinforce")

witch_hunter = ga_player_ally.sunits:item(1);

messenger = ga_ai_messenger_main.sunits:item(1);
messenger_uc = messenger.uc;

-------------------------------------------------------------------------------------------------
---------------------------------------- REINFORCEMENTS -----------------------------------------
-------------------------------------------------------------------------------------------------

local reinforcements = bm:reinforcements();

messenger_reinforce = bm:get_spawn_zone_collection_by_name("messenger_reinforce");
messenger_main_reinforce = bm:get_spawn_zone_collection_by_name("messenger_main_reinforce");

cth_reinforce = bm:get_spawn_zone_collection_by_name("cth_reinforce");
brt_reinforce = bm:get_spawn_zone_collection_by_name("brt_reinforce");

ga_ai_messenger_main:assign_to_spawn_zone_from_collection_on_message("start", messenger_main_reinforce, false);

ga_ai_messenger_force:assign_to_spawn_zone_from_collection_on_message("start", messenger_reinforce, false);

ga_ai_cth_reinforce:assign_to_spawn_zone_from_collection_on_message("start", cth_reinforce, false);

ga_ai_brt_reinforce:assign_to_spawn_zone_from_collection_on_message("start", brt_reinforce, false);

---------------
-----SETUP-----
---------------

messenger_exit_reached = false

karak_waypoint = v(0.0, 553.0, 225.5);

gb:message_on_time_offset("start", 100);
gb:message_on_time_offset("hint_01", 1000);
gb:message_on_time_offset("objective_01", 5000);

-------------------------------------------------------------------------------------------------
------------------------------------------ALLY ORDERS--------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player_ally:attack_on_message("start");

-------------------------------------------------------------------------------------------------
------------------------------------------ENEMY ORDERS-------------------------------------------
-------------------------------------------------------------------------------------------------

ga_ai_start:rush_on_message("start");
ga_ai_start:message_on_rout_proportion("dwf_weak",0.4);
ga_ai_start:message_on_rout_proportion("dwf_dead",0.99);
ga_ai_start.sunits:set_always_visible_no_leave_battle(true);

ga_ai_messenger_main:reinforce_on_message("dwf_weak");
ga_ai_messenger_main:message_on_any_deployed("messenger_main_in");
ga_ai_messenger_main:message_on_casualties("messenger_dead",0.99);

ga_ai_messenger_force:reinforce_on_message("dwf_weak")
ga_ai_messenger_force:message_on_any_deployed("messenger_force_in");
ga_ai_messenger_force:rush_on_message("messenger_force_in");
ga_ai_messenger_force:message_on_rout_proportion("messenger_force_dead",0.99);

gb:add_listener(
	"messenger_main_in",
	function()
		messenger:set_stat_attribute("unbreakable", true);
		messenger:add_ping_icon(15);
		messenger_uc:take_control();
		messenger_uc:goto_location(karak_waypoint, true);

		move_messenger_when_idle()
	end,
	true
);

ga_ai_messenger_main:message_on_proximity_to_position("messenger_arrived", karak_waypoint, 25);
ga_ai_messenger_main:withdraw_on_message("messenger_arrived");

gb:message_on_time_offset("messenger_completed", 5000, "messenger_arrived");

gb:add_listener(
	"messenger_completed",
	function()
		messenger_exit_reached = true
		bm:fail_objective("wh3_dlc24_qb_tze_the_changeling_the_tricksters_staff_objective_02");
	end,
	true
);

ga_ai_emp_reinforce:reinforce_on_message("messenger_completed")
ga_ai_emp_reinforce:message_on_deployed("emp_reinforcements_arrived")
ga_ai_emp_reinforce:rush_on_message("emp_reinforcements_arrived")
ga_ai_emp_reinforce:message_on_rout_proportion("emp_dead",0.95);

gb:add_listener(
	"emp_reinforcements_arrived",
	function()
		ga_ai_emp_reinforce.sunits:set_always_visible_no_leave_battle(true);
	end
);

ga_ai_cth_reinforce:reinforce_on_message("emp_reinforcements_arrived")
ga_ai_cth_reinforce:message_on_deployed("cth_reinforcements_arrived")
ga_ai_cth_reinforce:rush_on_message("cth_reinforcements_arrived")
ga_ai_cth_reinforce:message_on_rout_proportion("cth_dead",0.95);

gb:add_listener(
	"cth_reinforcements_arrived",
	function()
		ga_ai_cth_reinforce.sunits:set_always_visible_no_leave_battle(true);
	end
);

ga_ai_brt_reinforce:reinforce_on_message("cth_reinforcements_arrived")
ga_ai_brt_reinforce:message_on_deployed("brt_reinforcements_arrived")
ga_ai_brt_reinforce:rush_on_message("brt_reinforcements_arrived")
ga_ai_brt_reinforce:message_on_rout_proportion("brt_dead",0.95);

gb:add_listener(
	"brt_reinforcements_arrived",
	function()
		ga_ai_brt_reinforce.sunits:set_always_visible_no_leave_battle(true);
	end
);

gb:message_on_all_messages_received("merchants_dead", "emp_dead", "cth_dead", "brt_dead");

gb:add_listener(
    "messenger_completed",
	function()
		local cached_units = {}
		
		for i = 1, ga_player_ally.sunits:count() do
			local current_sunit = ga_player_ally.sunits:item(i)
			local current_sunit_unit = current_sunit.unit
			
			table.insert(
				cached_units,
				{
					hp = current_sunit:unary_hitpoints(),
					pos = current_sunit_unit:position(),
					bearing = current_sunit_unit:bearing(),
					width = current_sunit_unit:ordered_width()
				}
			)
			
			current_sunit:kill(true)
		end
		
		gb:add_listener(
			"emp_reinforcements_arrived",
			function()
				for i = 1, ga_ai_emp_reinforce.sunits:count() do
					local current_sunit = ga_ai_emp_reinforce.sunits:item(i)
					
					current_sunit:teleport_to_location(cached_units[i].pos, cached_units[i].bearing, cached_units[i].width)
					current_sunit:kill_proportion(1 - cached_units[i].hp, 0, true)
				end

				ga_ai_emp_reinforce.sunits:set_always_visible_no_leave_battle(true);
			end
		)
    end
);

gb:message_on_all_messages_received("easy_mode_won", "messenger_dead", "messenger_force_dead", "dwf_dead");
gb:message_on_all_messages_received("hard_mode_won", "messenger_completed", "messenger_force_dead", "dwf_dead", "emp_dead", "cth_dead", "brt_dead");

-------------------------------------------------------------------------------------------------
--------------------------------------- OBJECTIVES & HINTS --------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_with_leader_on_message("objective_01", "wh3_dlc24_qb_tze_the_changeling_the_tricksters_staff_objective_01");
gb:complete_objective_on_message("dwf_dead", "wh3_dlc24_qb_tze_the_changeling_the_tricksters_staff_objective_01");

gb:set_locatable_objective_callback_on_message(
    "messenger_main_in",
    "wh3_dlc24_qb_tze_the_changeling_the_tricksters_staff_objective_02",
    0,
    function()
        local sunit = ga_ai_messenger_main.sunits:item(1);
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

gb:complete_objective_on_message("messenger_dead", "wh3_dlc24_qb_tze_the_changeling_the_tricksters_staff_objective_02");
gb:remove_objective_on_message("messenger_dead", "wh3_dlc24_qb_tze_the_changeling_the_tricksters_staff_objective_02", 30000);
gb:remove_objective_on_message("messenger_completed", "wh3_dlc24_qb_tze_the_changeling_the_tricksters_staff_objective_02", 30000);

gb:set_objective_with_leader_on_message("messenger_completed", "wh3_dlc24_qb_tze_the_changeling_the_tricksters_staff_objective_03");
gb:complete_objective_on_message("merchants_dead", "wh3_dlc24_qb_tze_the_changeling_the_tricksters_staff_objective_03");

gb:block_message_on_message("messenger_dead", "emp_reinforcements_arrived", true);

gb:queue_help_on_message("hint_01", "wh3_dlc24_qb_tze_the_changeling_the_tricksters_staff_hint_01");
gb:queue_help_on_message("dwf_weak", "wh3_dlc24_qb_tze_the_changeling_the_tricksters_staff_hint_02");
gb:queue_help_on_message("emp_reinforcements_arrived", "wh3_dlc24_qb_tze_the_changeling_the_tricksters_staff_hint_03");

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

function move_messenger_when_idle()
	bm:watch(
		function()
			return true
		end,
		3000,
		function()
			local m_unit = ga_ai_messenger_main.sunits:get_unit_table()[1]
			
			if m_unit:is_in_melee() == false and m_unit:is_moving() == false then
				bm:out("gyro not moving or in melee")
				messenger_uc:goto_location(karak_waypoint, true)
			elseif(m_unit:is_in_melee() == true) then
				bm:out("is in melee")
			elseif(m_unit:is_moving() == true) then
				bm:out("is moving")
			end

			if messenger_exit_reached == false then
				move_messenger_when_idle()
			end
		end,
		"messenger_behaviour"
	)
end;

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------

gb:add_listener(
	"easy_mode_won",
	function()
		ga_ai_emp_reinforce.sunits:kill_proportion_over_time(1.0, 100, false);
		ga_ai_cth_reinforce.sunits:kill_proportion_over_time(1.0, 100, false);
		ga_ai_brt_reinforce.sunits:kill_proportion_over_time(1.0, 100, false);
	end
);

ga_player_01:force_victory_on_message("easy_mode_won", 5000);
ga_player_01:force_victory_on_message("hard_mode_won", 5000);