-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Skulltaker
-- Weapon
-- The Slayer Sword
-- Attacker

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries()

bm:camera():fade(true, 0)

gb = generated_battle:new(
	true,                                      			-- screen starts black
	false,                                      		-- prevent deployment for player
	true,                                      			-- prevent deployment for ai
	function() deployment_cutscene() end,       	   	-- intro cutscene function
	false                                      			-- debug mode
)

gb:set_cutscene_during_deployment(true)

-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

local sfx_cutscene_sweetener_intro_play = new_sfx("Play_Movie_WH3_DLC26_QB_Skulltaker_Slayer_Sword_Intro", true, false)
local sfx_cutscene_sweetener_intro_stop = new_sfx("Stop_Movie_WH3_DLC26_QB_Skulltaker_Slayer_Sword_Intro", false, false)

-------------------------------------------------------------------------------------------------
------------------------------------------- CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------

function deployment_cutscene()
	bm:out("\tdeployment_cutscene() called")

	local cam = bm:camera()

	cam:fade(true, 0)

	-- declare cutscene
	local cutscene_intro = cutscene:new_from_cindyscene(
		"cutscene_intro", 																				-- unique string name for cutscene
		ga_player.sunits,																				-- unitcontroller over player's army
		function() intro_cutscene_end() end,															-- what to call when cutscene is finished
		"script/battle/quest_battles/_cutscene/managers/skulltaker_qb_wh3_space.CindySceneManager",		-- path to cindyscene
		0,																								-- blend in time (s)
		0																								-- blend out time (s)
	)

	local player_units_hidden = false;

	-- set up subtitles
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
					
			bm:callback(function() cam:fade(false, 0.5) end, 500)
			bm:hide_subtitles()

			sm:trigger_message("post_intro_sound_01")
		end
	)
	
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 200)

	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_player:set_enabled(true)
		end, 
		10
	)

	-- Voiceover and Subtitles --
	
	cutscene_intro:action(function() cutscene_intro:play_sound(sfx_cutscene_sweetener_intro_play) end, 0);
	
	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc26_qb_kho_skulltaker_01",
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc26_qb_kho_skulltaker_01"))
				bm:show_subtitle("wh3_dlc26_qb_kho_skulltaker_slayer_sword_01", false, true)
			end
	)

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc26_qb_kho_skulltaker_02",
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc26_qb_kho_skulltaker_02"))
				bm:show_subtitle("wh3_dlc26_qb_kho_skulltaker_slayer_sword_02", false, true)
			end
	)

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc26_qb_kho_skulltaker_03",
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc26_qb_kho_skulltaker_03"))
				bm:show_subtitle("wh3_dlc26_qb_kho_skulltaker_slayer_sword_03", false, true)
			end
	)

	cutscene_intro:start()
end

function intro_cutscene_end()
	play_sound_2D(sfx_cutscene_sweetener_intro_stop)
	ga_player:set_enabled(true)
	sm:trigger_message("post_intro_sound_01")
	ga_ai_dwf_main.sunits:set_always_visible(true);
	ga_ai_dwf_01.sunits:set_always_visible(true);
	ga_ai_dwf_02.sunits:set_always_visible(true);
end

gb:play_sound_on_message("post_intro_sound_01", new_sfx("Play_wh3_dlc26_qb_kho_skulltaker_04", false, false), nil, 1000, "post_intro_sound_02")
gb:play_sound_on_message("post_intro_sound_02", new_sfx("Play_wh3_dlc26_qb_kho_skulltaker_05", false, false), nil, 1000)

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player = gb:get_army(gb:get_player_alliance_num())

ga_ai_dwf_main = gb:get_army(gb:get_non_player_alliance_num(), "dwf_main")
ga_ai_dwf_main_reinforce = gb:get_army(gb:get_non_player_alliance_num(), "dwf_main_reinforce")
ga_ai_dwf_01 = gb:get_army(gb:get_non_player_alliance_num(), "dwf_emplacement_01")
ga_ai_dwf_02 = gb:get_army(gb:get_non_player_alliance_num(), "dwf_emplacement_02")
ga_ai_emp_reinforce = gb:get_army(gb:get_non_player_alliance_num(), "emp_reinforce")

dwf_lord_01 = ga_ai_dwf_main.sunits:item(1);
dwf_lord_02 = ga_ai_dwf_main.sunits:item(2);
dwf_lord_03 = ga_ai_dwf_main.sunits:item(3);
dwf_lord_04 = ga_ai_dwf_01.sunits:item(1);
dwf_lord_05 = ga_ai_dwf_02.sunits:item(1);

-------------------------------------------------------------------------------------------------
----------------------------------------- SPAWN ZONES -------------------------------------------
-------------------------------------------------------------------------------------------------

rear_reinforce_01 = bm:get_spawn_zone_collection_by_name("rear_reinforce")

ga_ai_dwf_main_reinforce:assign_to_spawn_zone_from_collection_on_message("start", rear_reinforce_01, false)
ga_ai_emp_reinforce:assign_to_spawn_zone_from_collection_on_message("start", rear_reinforce_01, false)

-------------------------------------------------------------------------------------------------
------------------------------------------- TELEPORT --------------------------------------------
-------------------------------------------------------------------------------------------------

dwf_lords_teleport_locations = {
	{x = 80.0, y = -43.0, orientation = 275.0}, --Dwarf Lord
	{x = 78.0, y = -51.0, orientation = 275.0}, --Master Engineer
	{x = 82.0, y = -35.0, orientation = 275.0}, --Dragon Slayer
}

function battle_start_teleport_dwf_lords()
	for i=1, ga_ai_dwf_main.sunits:count() do
		local sunit = ga_ai_dwf_main.sunits:item(i)
		local location = v(dwf_lords_teleport_locations[i].x, dwf_lords_teleport_locations[i].y)

		sunit.uc:teleport_to_location(location, dwf_lords_teleport_locations[i].orientation, 40)
	end
end

dwf_emplacement_01_teleport_locations = {
	{x = -230.61, y = 284.12, orientation = 235.0}, --Runelord

	{x = -196.44, y = 219.13, orientation = 235.0}, --Ironbreaker

	{x = -238.74, y = 275.84, orientation = 235.0}, --Longbeard
	{x = -242.07, y = 263.97, orientation = 235.0}, --Longbeard
	{x = -296.13, y = 317.10, orientation = 235.0}, --Longbeard

	{x = -199.44, y = 270.46, orientation = 235.0}, --Ranger
	{x = -244.81, y = 315.04, orientation = 235.0}, --Ranger

	{x = -167.18, y = 222.14, orientation = 235.0}, --Grudgethrower
	{x = -254.00, y = 307.16, orientation = 235.0}, --Grudgethrower
	-- {x = -274.72, y = 334.38, orientation = 235.0}, --Grudgethrower
	{x = -198.42, y = 257.70, orientation = 235.0} --Grudgethrower
}

function battle_start_teleport_dwf_01()
	for i=1, ga_ai_dwf_01.sunits:count() do
		local sunit = ga_ai_dwf_01.sunits:item(i)
		local location = v(dwf_emplacement_01_teleport_locations[i].x, dwf_emplacement_01_teleport_locations[i].y)

		sunit.uc:teleport_to_location(location, dwf_emplacement_01_teleport_locations[i].orientation, 40)
	end
end

dwf_emplacement_02_teleport_locations = {
	{x = -162.55, y = -276.23, orientation = 310.0}, --Daemon Slayer

	{x = -188.12, y = -256.16, orientation = 310.0}, --Doomseekers

	{x = -131.79, y = -184.23, orientation = 310.0}, --Slayers
	{x = -188.62, y = -309.28, orientation = 310.0}, --Slayers
	{x = -244.60, y = -327.96, orientation = 310.0}, --Slayers

	{x = -160.60, y = -220.94, orientation = 310.0}, --Slayer Pirates
	{x = -215.79, y = -291.26, orientation = 310.0}, --Slayer Pirates

	{x = -124.07, y = -269.79, orientation = 310.0}, --Grudgethrower
	{x = -168.66, y = -338.82, orientation = 310.0}, --Grudgethrower
	-- {x = -211.07, y = -345.86, orientation = 310.0}, --Grudgethrower
	{x = -153.50, y = -313.23, orientation = 310.0} --Grudgethrower
}

function battle_start_teleport_dwf_02()
	for i=1, ga_ai_dwf_02.sunits:count() do
		local sunit = ga_ai_dwf_02.sunits:item(i)
		local location = v(dwf_emplacement_02_teleport_locations[i].x, dwf_emplacement_02_teleport_locations[i].y)

		sunit.uc:teleport_to_location(location, dwf_emplacement_02_teleport_locations[i].orientation, 40)
	end
end

-------------------------------------------------------------------------------------------------
----------------------------------------- BATTLE SETUP ------------------------------------------
-------------------------------------------------------------------------------------------------

battle_start_teleport_dwf_lords()
battle_start_teleport_dwf_01()
battle_start_teleport_dwf_02()

gb:message_on_time_offset("start", 100);
gb:message_on_time_offset("hint_01", 200);
gb:message_on_time_offset("objective_01", 5200);

for i = 1, ga_ai_dwf_main.sunits:count() do
	ga_ai_dwf_main.sunits:item(i):set_stat_attribute("unbreakable", true)
	ga_ai_dwf_main.sunits:item(i):change_behaviour_active("skirmish", false);		
end

dwf_lord_04:set_stat_attribute("unbreakable", true)
dwf_lord_05:set_stat_attribute("unbreakable", true)

-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------

ga_ai_dwf_main:defend_on_message("start", 85, -46, 20, 0, false)
ga_ai_dwf_main:message_on_proximity_to_enemy("player_approaching_far", 300);
ga_ai_dwf_main:message_on_proximity_to_enemy("player_approaching_near", 150);
ga_ai_dwf_main:message_on_under_attack("dwf_lords_attacked")
ga_ai_dwf_main:rush_on_message("dwf_lords_attacked")
ga_ai_dwf_main:message_on_rout_proportion("dwf_main_defeated", 0.95)

ga_ai_dwf_01:defend_on_message("start", -215, 300, 50, 0, false)
ga_ai_dwf_01:message_on_under_attack("dwf_01_attacked")
ga_ai_dwf_01:rush_on_message("dwf_01_attacked")
ga_ai_dwf_01:message_on_rout_proportion("dwf_01_wounded", 0.65)
ga_ai_dwf_01:message_on_rout_proportion("dwf_01_defeated", 0.95)
ga_ai_dwf_01:prevent_rallying_if_routing_on_message("dwf_01_wounded")

ga_ai_dwf_02:defend_on_message("start", -145, -290, 50, 0, false)
ga_ai_dwf_02:message_on_under_attack("dwf_02_attacked")
ga_ai_dwf_02:rush_on_message("dwf_02_attacked")
ga_ai_dwf_02:message_on_rout_proportion("dwf_02_wounded", 0.65)
ga_ai_dwf_02:message_on_rout_proportion("dwf_02_defeated", 0.95)
ga_ai_dwf_02:prevent_rallying_if_routing_on_message("dwf_02_wounded")

ga_ai_dwf_main_reinforce:reinforce_on_message("player_approaching_near")
ga_ai_dwf_main_reinforce:message_on_any_deployed("reinforce_03_in");
ga_ai_dwf_main_reinforce:defend_on_message("reinforce_03_in", 150, -80, 20, 0, false)
ga_ai_dwf_main_reinforce:message_on_under_attack("dwf_03_attacked")
ga_ai_dwf_main_reinforce:rush_on_message("dwf_03_attacked")
ga_ai_dwf_main_reinforce:message_on_rout_proportion("dwf_03_wounded", 0.65)
ga_ai_dwf_main_reinforce:message_on_rout_proportion("dwf_03_defeated", 0.95)
ga_ai_dwf_main_reinforce:prevent_rallying_if_routing_on_message("dwf_03_wounded")

ga_ai_emp_reinforce:reinforce_on_message("player_approaching_near")
gb:play_sound_on_message("player_approaching_near", new_sfx("Play_wh3_dlc26_qb_kho_skulltaker_06", false, true), nil, 2000)
ga_ai_emp_reinforce:message_on_any_deployed("emp_reinforce_in")
ga_ai_emp_reinforce:rush_on_message("emp_reinforce_in")
ga_ai_emp_reinforce:message_on_rout_proportion("emp_wounded", 0.65)
ga_ai_emp_reinforce:message_on_rout_proportion("emp_defeated", 0.95)
ga_ai_emp_reinforce:prevent_rallying_if_routing_on_message("emp_wounded")

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:message_on_time_offset("reinforce_objective", 2500, "emp_reinforce_in");

gb:message_on_all_messages_received("dwf_forces_defeated", "dwf_main_defeated", "dwf_01_defeated", "dwf_02_defeated", "dwf_03_defeated")
gb:message_on_all_messages_received("reinforcements_defeated", "emp_defeated", "dwf_03_defeated")

gb:set_objective_with_leader_on_message("objective_01", "wh3_dlc26_qb_kho_skulltaker_slayer_sword_objective_1");
gb:complete_objective_on_message("dwf_forces_defeated", "wh3_dlc26_qb_kho_skulltaker_slayer_sword_objective_1")

gb:set_objective_with_leader_on_message("reinforce_objective", "wh3_dlc26_qb_kho_skulltaker_slayer_sword_objective_2");
gb:complete_objective_on_message("reinforcements_defeated", "wh3_dlc26_qb_kho_skulltaker_slayer_sword_objective_2")

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("hint_01", "wh3_dlc26_qb_kho_skulltaker_slayer_sword_hint_1")
gb:queue_help_on_message("player_approaching_far", "wh3_dlc26_qb_kho_skulltaker_slayer_sword_hint_2")
gb:queue_help_on_message("emp_reinforce_in", "wh3_dlc26_qb_kho_skulltaker_slayer_sword_hint_3")

-------------------------------------------------------------------------------------------------
---------------------------------------- VICTORY / DEFEAT ---------------------------------------
-------------------------------------------------------------------------------------------------

ga_player:message_on_rout_proportion("player_gets_killed", 0.95)
ga_ai_dwf_main:force_victory_on_message("player_gets_killed", 5000)

ga_player:force_victory_on_message("emp_defeated", 5000)

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------