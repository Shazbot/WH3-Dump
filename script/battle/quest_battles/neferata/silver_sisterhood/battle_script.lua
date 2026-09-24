-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------
-- Neferata
-- By Aleksandar Radulov
-- Silver Sisterhood
-------------------------------------------------------------------------------------------------
------------------------------------------- HEADERS ---------------------------------------------	
-------------------------------------------------------------------------------------------------
load_script_libraries();                            -- Load all our script libraries so lua can access our battle logic
bm = battle_manager:new(empire_battle:new());       -- Create a battle manager. This is able to listen to the battle and send messages accordingly.
gb = generated_battle:new(                          -- Load a generated battle, used for scripted battles.
    false,                                          -- screen starts black
    false,                                          -- prevent Player deployment
	false,											-- prevent AI deployment
	function() play_intro_cutscene() end,           -- intro cutscene function
    false                                           -- debug mode
);

gb:set_cutscene_during_deployment(true)

-------------------------------------------------------------------------------------------------
------------------------------------------ CUTSCENE ---------------------------------------------	
-------------------------------------------------------------------------------------------------
function play_intro_cutscene()
    bm:out("\tplay_intro_cutscene() called")

    local cam = bm:camera()

    cam:fade(true, 0)

	local cutscene_intro = cutscene:new_from_cindyscene(
		"cutscene_intro", 																				-- unique string name for cutscene
		ga_player.sunits,																				-- unitcontroller over player's army
		function() intro_cutscene_end() end,															-- what to call when cutscene is finished
		"script/battle/quest_battles/_cutscene/managers/nef_ss_qb_preb.CindySceneManager",		    -- path to cindyscene
		0,																								-- blend in time (s)
		0																								-- blend out time (s)
    )

    local player_units_hidden = false

    --set up subtitles
    local subtitles = cutscene_intro:subtitles()
	subtitles:set_alignment("bottom_centre")
	subtitles:clear()

	-- skip callback
	cutscene_intro:set_skippable(
		true, 
		function()
			local cam = bm:camera()
			cam:fade(true, 0)
			bm:stop_cindy_playback(true)

			if player_units_hidden then
				ga_player:set_enabled(true)
			end;
					
			ga_brt_enemy:set_visible_to_all(false)

			bm:callback(function() cam:fade(false, 0.5) end, 500)
			bm:hide_subtitles()
		end
	)

	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000)

	cutscene_intro:action(function() cutscene_intro:play_sound(new_sfx("Play_Movie_WH3_DLC29_QB_Neferata_Intro", true, false)) end, 100);
	
	cutscene_intro:action(
		function()
			ga_brt_enemy:set_visible_to_all(true)
			ga_player.sunits:item(1):set_enabled(false)
		end,
		100
	)

	-- VO and Subtitles
	cutscene_intro:add_cinematic_trigger_listener(
	"Play_wh3_dlc29_vmp_neferata_silver_sisterhood_01", 
		function()
			cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_vmp_neferata_silver_sisterhood_01"));
			bm:show_subtitle("wh3_dlc29_qb_vmp_neferata_silver_sisterhood_intro_01", false, true);
		end	
	)

	cutscene_intro:add_cinematic_trigger_listener(
	"Play_wh3_dlc29_vmp_neferata_silver_sisterhood_02", 
		function()
			cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_vmp_neferata_silver_sisterhood_02"));
			bm:show_subtitle("wh3_dlc29_qb_vmp_neferata_silver_sisterhood_intro_02", false, true);
		end	
	)

	cutscene_intro:add_cinematic_trigger_listener(
	"Play_wh3_dlc29_vmp_neferata_silver_sisterhood_03", 
		function()
			cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_vmp_neferata_silver_sisterhood_03"));
			bm:show_subtitle("wh3_dlc29_qb_vmp_neferata_silver_sisterhood_intro_03", false, true);
		end	
	)

	cutscene_intro:add_cinematic_trigger_listener(
	"Play_wh3_dlc29_vmp_neferata_silver_sisterhood_04", 
		function()
			cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_vmp_neferata_silver_sisterhood_04"));
			bm:show_subtitle("wh3_dlc29_qb_vmp_neferata_silver_sisterhood_intro_04", false, true);
		end	
	)

	cutscene_intro:add_cinematic_trigger_listener(
	"Play_wh3_dlc29_vmp_neferata_silver_sisterhood_05", 
		function()
			cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_vmp_neferata_silver_sisterhood_05"));
			bm:show_subtitle("wh3_dlc29_qb_vmp_neferata_silver_sisterhood_intro_05", false, true);
		end	
	)

	cutscene_intro:add_cinematic_trigger_listener(
	"Play_wh3_dlc29_vmp_neferata_silver_sisterhood_06", 
		function()
			cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_vmp_neferata_silver_sisterhood_06"));
			bm:show_subtitle("wh3_dlc29_qb_vmp_neferata_silver_sisterhood_intro_06", false, true);
		end	
	)

	cutscene_intro:add_cinematic_trigger_listener(
	"Play_wh3_dlc29_vmp_neferata_silver_sisterhood_07", 
		function()
			cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_vmp_neferata_silver_sisterhood_07"));
			bm:show_subtitle("wh3_dlc29_qb_vmp_neferata_silver_sisterhood_intro_07", false, true);
		end	
	)


    cutscene_intro:start()
end

function intro_cutscene_end()
	play_sound_2D(new_sfx("Stop_Movie_WH3_DLC29_QB_Neferata_Intro", false, false))
	ga_brt_enemy:set_visible_to_all(false)
	ga_player.sunits:item(1):set_enabled(true)
end

-------------------------------------------------------------------------------------------------
----------------------------------------- MID CUTSCENE ------------------------------------------
-------------------------------------------------------------------------------------------------
function play_mid_cutscene()
	bm:camera():fade(true, 0.5)

	bm:callback(function() 
		local cam = bm:camera()
		
		-- REMOVE ME
		cam:fade(false, 2)

		local cutscene_mid = cutscene:new_from_cindyscene(
			"cutscene_mid", 																				-- unique string name for cutscene
			ga_player.sunits,																				-- unitcontroller over player's army
			function() mid_cutscene_end() end,																-- what to call when cutscene is finished
			"script/battle/quest_battles/_cutscene/managers/nef_ss_qb_mid_m01.CindySceneManager",		    -- path to cindyscene
			0,																								-- blend in time (s)
			0																								-- blend out time (s)
		)

		cutscene_mid:action(
			function() 	
				ga_player.sunits:set_enabled(false)

				ga_vmp_ally.sunits:set_enabled(false)
				ga_brt_enemy.sunits:set_enabled(false)
			end, 
			100
		)

		-- set up subtitles
		local subtitles = cutscene_mid:subtitles()
		subtitles:set_alignment("bottom_centre")
		subtitles:clear()
		
		-- skip callback
		cutscene_mid:set_skippable(
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
		cutscene_mid:action(function() cutscene_mid:play_sound(new_sfx("Play_Movie_WH3_DLC29_QB_Neferata_Mid", true, false)) end, 100);
		
		-- VO and Subtitles
		cutscene_mid:add_cinematic_trigger_listener(
		"Play_wh3_dlc29_vmp_neferata_silver_sisterhood_mid_01", 
			function()
				cutscene_mid:play_sound(new_sfx("Play_wh3_dlc29_vmp_neferata_silver_sisterhood_mid_01"));
				bm:show_subtitle("wh3_dlc29_qb_vmp_neferata_silver_sisterhood_mid_01", false, true);
			end	
		)

		cutscene_mid:add_cinematic_trigger_listener(
		"Play_wh3_dlc29_vmp_neferata_silver_sisterhood_mid_02", 
			function()
				cutscene_mid:play_sound(new_sfx("Play_wh3_dlc29_vmp_neferata_silver_sisterhood_mid_02"));
				bm:show_subtitle("wh3_dlc29_qb_vmp_neferata_silver_sisterhood_mid_02", false, true);
			end	
		)

		cutscene_mid:add_cinematic_trigger_listener(
		"Play_wh3_dlc29_vmp_neferata_silver_sisterhood_mid_03", 
			function()
				cutscene_mid:play_sound(new_sfx("Play_wh3_dlc29_vmp_neferata_silver_sisterhood_mid_03"));
				bm:show_subtitle("wh3_dlc29_qb_vmp_neferata_silver_sisterhood_mid_03", false, true);
			end	
		)

		cutscene_mid:add_cinematic_trigger_listener(
		"Play_wh3_dlc29_vmp_neferata_silver_sisterhood_mid_04", 
			function()
				cutscene_mid:play_sound(new_sfx("Play_wh3_dlc29_vmp_neferata_silver_sisterhood_mid_04"));
				bm:show_subtitle("wh3_dlc29_qb_vmp_neferata_silver_sisterhood_mid_04", false, true);
			end	
		)

		cutscene_mid:add_cinematic_trigger_listener(
		"Play_wh3_dlc29_vmp_neferata_silver_sisterhood_mid_05", 
			function()
				cutscene_mid:play_sound(new_sfx("Play_wh3_dlc29_vmp_neferata_silver_sisterhood_mid_05"));
				bm:show_subtitle("wh3_dlc29_qb_vmp_neferata_silver_sisterhood_mid_05", false, true);
			end	
		)

		cutscene_mid:add_cinematic_trigger_listener(
		"Play_wh3_dlc29_vmp_neferata_silver_sisterhood_mid_06", 
			function()
				cutscene_mid:play_sound(new_sfx("Play_wh3_dlc29_vmp_neferata_silver_sisterhood_mid_06"));
				bm:show_subtitle("wh3_dlc29_qb_vmp_neferata_silver_sisterhood_mid_06", false, true);
			end	
		)

		cutscene_mid:add_cinematic_trigger_listener(
		"Play_wh3_dlc29_vmp_neferata_silver_sisterhood_mid_07", 
			function()
				cutscene_mid:play_sound(new_sfx("Play_wh3_dlc29_vmp_neferata_silver_sisterhood_mid_07"));
				bm:show_subtitle("wh3_dlc29_qb_vmp_neferata_silver_sisterhood_mid_07", false, true);
			end	
		)

		cutscene_mid:start()
	end, 1000)
end

function mid_cutscene_end()
	army_alliance_switch()
	play_sound_2D(new_sfx("Stop_Movie_WH3_DLC29_QB_Neferata_Mid", false, false))
	
	sm:trigger_message("mid_cutscene_end")
	
	ga_player.sunits:set_enabled(true)

	ga_brt_ally.sunits:set_enabled(true)
	ga_vmp_enemy.sunits:set_enabled(true)	
end

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------
-- Player Army Setup
ga_player = gb:get_army(gb:get_player_alliance_num())

-- VMP Armies Setup
ga_vmp_ally = gb:get_army(gb:get_player_alliance_num(), "vmp_ally")
ga_vmp_enemy = gb:get_army(gb:get_non_player_alliance_num(), "vmp_enemy")
ga_vmp_enemy_reinf = gb:get_army(gb:get_non_player_alliance_num(), "vmp_enemy_reinf")

-- BRT Armies Setup
ga_brt_enemy = gb:get_army(gb:get_non_player_alliance_num(), "brt_enemy")
ga_brt_ally = gb:get_army(gb:get_player_alliance_num(), "brt_ally")

-------------------------------------------------------------------------------------------------
----------------------------------------- SPAWN ZONES -------------------------------------------
-------------------------------------------------------------------------------------------------
-- Get Spawn Zones
vmp_enemy_reinf_zone = bm:get_spawn_zone_collection_by_name("vmp_enemy_reinf")
vmp_ally_reinf_zone = bm:get_spawn_zone_collection_by_name("vmp_ally_reinf")

-- Assign Spawn Zones
ga_vmp_enemy_reinf:assign_to_spawn_zone_from_collection_on_message("start", vmp_enemy_reinf_zone, false)
ga_vmp_ally:assign_to_spawn_zone_from_collection_on_message("start", vmp_ally_reinf_zone, false)

-------------------------------------------------------------------------------------------------
----------------------------------------- BATTLE SETUP ------------------------------------------
-------------------------------------------------------------------------------------------------
gb:message_on_time_offset("start", 100);
gb:message_on_time_offset("hint", 30000);

gb:message_on_all_messages_received("end_countdown", "brt_army_damaged", "brt_lord_damaged")

gb:add_listener(
    "set_objective_2",
	function()
		bm:callback(
			function()
				play_mid_cutscene()
			end,
			5000
		)
    end
)

-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------
brt_lord = ga_brt_enemy.sunits:item(1);

brt_lord:set_stat_attribute("unbreakable", true);

-- Initial army orders
ga_vmp_ally:reinforce_on_message("start")
ga_vmp_ally:message_on_deployed("vmp_ally_deployed")
ga_vmp_ally:advance_on_message("vmp_ally_deployed")
ga_brt_enemy:defend_on_message("start", 70, 460, 200, 0, false)
ga_brt_enemy:message_on_casualties("brt_army_damaged", 0.35)

-- Order enemy vampire reinforcements
ga_vmp_enemy_reinf:reinforce_on_message("mid_cutscene_end", 3000)
ga_vmp_enemy_reinf:message_on_deployed("vmp_reinf_deployed")
ga_vmp_enemy_reinf:defend_on_message("vmp_reinf_deployed", 70, 460, 200, 0, false)

ga_brt_ally.sunits:set_enabled(false)
ga_vmp_enemy.sunits:set_enabled(false)

--  Teleporting these away as they cause UI problems when approached by the player
vmp_enemy_teleport_locations = {
	{x = 300.0, y = -700.0},
	{x = 280.0, y = -700.0},
	{x = 260.0, y = -700.0},
	{x = 240.0, y = -700.0},
	{x = 220.0, y = -700.0},
	{x = 200.0, y = -700.0},
	{x = 180.0, y = -700.0},
	{x = 160.0, y = -700.0},
	{x = 140.0, y = -700.0},
	{x = 120.0, y = -700.0},
	{x = 100.0, y = -700.0},
	{x = 80.0, y = -700.0},
	{x = 60.0, y = -700.0},
	{x = 40.0, y = -700.0},
	{x = 20.0, y = -700.0},
	{x = 0.0, y = -700.0},
	{x = -20.0, y = -700.0},
	{x = -40.0, y = -700.0},
	{x = -60.0, y = -700.0},
	{x = -80.0, y = -700.0}
}

function battle_start_teleport()
	for i=1, ga_vmp_enemy_reinf.sunits:count() do
		local sunit = ga_vmp_enemy_reinf.sunits:item(i)
		local location = v(vmp_enemy_teleport_locations[i].x, vmp_enemy_teleport_locations[i].y)

		sunit.uc:teleport_to_location(location, 180.0, 40)
	end
end
gb:add_listener(
	"start",  
	battle_start_teleport
)

-------------------------------------------------------------------------------------------------
-------------------------------------------- HINTS  ---------------------------------------------
-------------------------------------------------------------------------------------------------
gb:queue_help_on_message("hint", "wh3_dlc29_qb_vmp_neferata_silver_sisterhood_hint_1");

gb:add_listener(
	"brt_army_damaged",
	function()
		sm:trigger_message("brt_army_damaged_hint")
	end
)

gb:add_listener(
	"brt_lord_damaged",
	function()
		sm:trigger_message("brt_lord_damaged_hint")
	end
)

gb:queue_help_on_message("start", "wh3_dlc29_qb_vmp_silver_sisterhood_hint_01")

gb:queue_help_on_message("brt_lord_damaged_hint", "wh3_dlc29_qb_vmp_silver_sisterhood_hint_01_01")
gb:block_message_on_message("brt_lord_damaged_hint", "brt_army_damaged_hint")
gb:queue_help_on_message("brt_army_damaged_hint", "wh3_dlc29_qb_vmp_silver_sisterhood_hint_01_02")
gb:block_message_on_message("brt_army_damaged_hint", "brt_lord_damaged_hint")

gb:queue_help_on_message("mid_cutscene_end", "wh3_dlc29_qb_vmp_silver_sisterhood_hint_02", 2500)

-------------------------------------------------------------------------------------------------
------------------------------------- OBJECTIVE MANAGEMENT  -------------------------------------
-------------------------------------------------------------------------------------------------
local countdown_timer = 420
local countdown_current = 420

-- Objective 1 Setup
gb:set_objective_with_leader_on_message("start", "wh3_dlc29_qb_vmp_neferata_silver_sisterhood_objective_1")
gb:set_objective_on_message("start", "wh3_dlc29_qb_vmp_neferata_silver_sisterhood_objective_1_1", 4000)

gb:set_locatable_objective_callback_on_message(
    "start",
    "wh3_dlc29_qb_vmp_neferata_silver_sisterhood_objective_1_2",
    2000,
    function()
        local sunit = ga_brt_enemy.sunits:item(1)
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

-- Objective 1 Timer
gb:add_listener(
    "start",
	function()
		bm:repeat_callback(
			function()
				countdown_current = countdown_current - 1
				bm:set_objective("wh3_dlc29_qb_vmp_neferata_silver_sisterhood_objective_1", countdown_current, countdown_timer)

				if countdown_current <= 0 then
					sm:trigger_message("countdown_finished")
				end

				-- Check BRT Lord heatlh (victory condition)
				if ga_brt_enemy:get_first_scriptunit().unit:unary_hitpoints() <= 0.65 then
					sm:trigger_message("brt_lord_damaged")
				elseif ga_brt_enemy:get_first_scriptunit().unit:unary_hitpoints() <= 0 then
					sm:trigger_message("brt_lord_dead")
				end
			end,
			1000,
			"timer_callback"
		)
	end
)

gb:add_listener(
    "end_countdown",
	function()
		bm:remove_callback("timer_callback")
		sm:trigger_message("set_objective_2")
	end
)

-- Objective 1 Victory Conditions
gb:complete_objective_on_message("brt_lord_damaged", "wh3_dlc29_qb_vmp_neferata_silver_sisterhood_objective_1_2")
gb:complete_objective_on_message("brt_army_damaged", "wh3_dlc29_qb_vmp_neferata_silver_sisterhood_objective_1_1")
gb:complete_objective_on_message("end_countdown", "wh3_dlc29_qb_vmp_neferata_silver_sisterhood_objective_1")

gb:remove_objective_on_message("set_objective_2", "wh3_dlc29_qb_vmp_neferata_silver_sisterhood_objective_1_2", 5000);
gb:remove_objective_on_message("set_objective_2", "wh3_dlc29_qb_vmp_neferata_silver_sisterhood_objective_1_1", 5000);
gb:remove_objective_on_message("set_objective_2", "wh3_dlc29_qb_vmp_neferata_silver_sisterhood_objective_1", 5000);

-- Objective 1 Defeat Conditions
gb:set_victory_countdown_on_message("countdown_finished", 0)
gb:message_on_any_message_received("player_lost", "countdown_finished", "brt_lord_dead")
gb:add_listener(
	"player_lost",  
	function()
		bm:force_battle_end(gb:get_non_player_alliance_num(), "scripted", true, true)		-- Forces defeat on the player, end the battle immediately, force the player to be the loser
	end
)

-- Objective 2 Setup
gb:set_objective_with_leader_on_message("mid_cutscene_end", "wh3_dlc29_qb_vmp_neferata_silver_sisterhood_objective_2")

-- Objective 2 Victory Conditions
ga_vmp_enemy:message_on_commander_dead_or_routing("vmp_enemy_defeated")
ga_vmp_enemy_reinf:message_on_commander_dead_or_routing("vmp_reinf_defeated")
gb:message_on_all_messages_received("victory", "vmp_enemy_defeated", "vmp_reinf_defeated")
gb:complete_objective_on_message("victory", "wh3_dlc29_qb_vmp_neferata_silver_sisterhood_objective_2")
-- gb:add_listener(
-- 	"victory",  
-- 	function()
-- 		bm:force_battle_end(gb:get_player_alliance_num(), "scripted", true, true)		
-- 	end
-- )

-------------------------------------------------------------------------------------------------
------------------------------------- ARMY ALLIANCE SWITCH  -------------------------------------
-------------------------------------------------------------------------------------------------
--- This is where we handle the illusion of the lahiman and bretonnian lords switching alliances.
--- In truth, we will store their surviving units and their status, spawn identical armies of the 
--- opposite alliance, delete the obsolete units, and modify their stats. Then teleport them.
--- We will also delete the 'original' units from before the alliance switch.

function army_alliance_switch()
	-- Setup tables for collecting info for unit teleportation
	vmp_unit_info_collection = {}
	brt_unit_info_collection = {}

	-- Get Script Units Collecitons
	vmp_ally_sunits = ga_vmp_ally.sunits 				--bm:get_scriptunits_for_army(gb:get_player_alliance_num(), ga_vmp_ally:get_army():unique_id())
	brt_enemy_sunits = ga_brt_enemy.sunits 		

	-- New Script Units Collections for swapped alliance armies
	vmp_enemy_valid_sunits = script_units:new("vmp_enemy_valid_sunits", {})		
	brt_ally_valid_sunits = script_units:new("brt_ally_sunits", {})

	-- Loop through VMP army to store relevant data 
	for i = 1, vmp_ally_sunits:count() do
		local current_unit = vmp_ally_sunits:item(i) 
		if (current_unit.unit:is_routing() == false and current_unit.unit:is_shattered() == false and current_unit.unit:unary_hitpoints()>0.1) then
			vmp_enemy_valid_sunits:add_sunits(current_unit)

			local unit_key = current_unit.unit:type()
			local unit_position = current_unit.unit:position()
			local unit_bearing = current_unit.unit:bearing()
			local unit_health_unary = current_unit.unit:unary_hitpoints()

			if not vmp_unit_info_collection[unit_key] then
				vmp_unit_info_collection[unit_key] = {}
			end
			table.insert(vmp_unit_info_collection[unit_key], { unit_position, unit_bearing, unit_health_unary })
			--vmp_unit_info_collection[unit_key] = { unit_position, unit_bearing, unit_health_unary }
		end
	end

	-- Loop through BRT army to store relevant data 
	for i = 1, brt_enemy_sunits:count() do
		local current_unit = brt_enemy_sunits:item(i) 
		if (current_unit.unit:is_routing() == false and current_unit.unit:is_shattered() == false and current_unit.unit:unary_hitpoints()>0.1) then
			brt_ally_valid_sunits:add_sunits(current_unit)

			local unit_key = current_unit.unit:type()
			local unit_position = current_unit.unit:position()
			local unit_bearing = current_unit.unit:bearing()
			local unit_health_unary = current_unit.unit:unary_hitpoints()

			if not brt_unit_info_collection[unit_key] then
				brt_unit_info_collection[unit_key] = {}
			end
			table.insert(brt_unit_info_collection[unit_key], { unit_position, unit_bearing, unit_health_unary })
			--brt_unit_info_collection[unit_key] = { unit_position, unit_bearing, unit_health_unary }
		end
	end

	-- Kill original units in VMP ally
	ga_vmp_ally.sunits:kill(true)

	-- Kill original units in BRT enemy
	ga_brt_enemy.sunits:kill(true)

	ga_brt_ally.sunits:set_enabled(true)
	ga_vmp_enemy.sunits:set_enabled(true)

	-- Teleport VMP units and set their health
	for unit_key, tables in pairs(vmp_unit_info_collection) do
		for j, info_table in ipairs(tables) do
			local script_unit = ga_vmp_enemy.sunits:get_sunit_by_type(unit_key)
			script_unit:teleport_to_location(info_table[1], info_table[2], 40)
			script_unit.unit:reduce_hitpoints_unary(1 - info_table[3], true)
			ga_vmp_enemy.sunits:remove_sunit(script_unit)
		end
	end	
	
	for unit_key, tables in pairs(brt_unit_info_collection) do
		for j, info_table in ipairs(tables) do
			local script_unit = ga_brt_ally.sunits:get_sunit_by_type(unit_key)
			script_unit:teleport_to_location(info_table[1], info_table[2], 40)
			script_unit.unit:reduce_hitpoints_unary(1 - info_table[3], true)
			ga_brt_ally.sunits:remove_sunit(script_unit)
		end
	end	
	
	-- Remove excess units from VMP enemy army	
	for i = 1, ga_vmp_enemy.sunits:count() do
		ga_vmp_enemy.sunits:item(i):kill(true)
	end	

	-- Remove excess units from BRT ally army
	for i = 1, ga_brt_ally.sunits:count() do
		ga_brt_ally.sunits:item(i):kill(true)
	end	
end