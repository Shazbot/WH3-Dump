-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Drycha
-- Coeddil Unchained
-- Attacker

--players army = player_army_drycha
--enemy main army = enemy_army_cythral
--enemy main army patrol = enemy_army_cythral_patrol
--enemy reinforcement army = enemy_reinforcement_cythral
--ally reinforcement army #1 = ally_reinforcements_anmyr
--ally reinforcement army #2 = ally_reinforcements_modryn
--ally reinforcement army #3 = ally_reinforcements_coeddil

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------
load_script_libraries();
bm = battle_manager:new(empire_battle:new());

local cam = bm:camera()
local cutscene_queue = {}

bm:camera():fade(true, 0);

gb = generated_battle:new(
	true,                                      		    -- screen starts black
	true,                                      		-- prevent deployment for player
	true,                                      		    -- prevent deployment for ai
	function() end_deployment_phase() end,          	-- intro cutscene function
	false                                      			-- debug mode
);

--preload stuttering fix
intro_cinematic_file = "script/battle/quest_battles/_cutscene/managers/coeddil.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);

-------------------------------------------------------------------------------------------------
---------------------------------------- VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

--Intro Drycha's Speech
wh2_main_sfx_01 = new_sfx("Play_wh2_dlc16_Drycha_quest_battle_pt_01"); -- I am here, Coeddil! The time has come. Your freedom is at hand.
wh2_main_sfx_02 = new_sfx("Play_wh2_dlc16_Drycha_quest_battle_pt_02"); -- The Wildwood Rangers approach. The foolish saplings dare to try and stop us.
wh2_main_sfx_03 = new_sfx("Play_wh2_dlc16_Drycha_quest_battle_pt_03"); -- In the hallowed name of every Tree Spirit that has fallen due to Asrai negligence, the dirt shall be fertilised with Elven blood this day – I will make sure of it.
wh2_main_sfx_04 = new_sfx("Play_wh2_dlc16_Drycha_quest_battle_pt_04"); -- We shall show them that we are the true keepers of the forest, not them!

-- In-Game Cutscene 1
wh2_drycha_igc01_sfx_01 = new_sfx("Play_wh2_dlc16_Drycha_quest_battle_IGC01_01"); -- Ahh Yes! - 3s
wh2_drycha_igc01_sfx_02 = new_sfx("Play_wh2_dlc16_Drycha_quest_battle_IGC01_02"); -- Forest spirits, come! - 5
wh2_drycha_igc01_sfx_03 = new_sfx("Play_wh2_dlc16_Drycha_quest_battle_IGC01_03"); -- Soon they will taste the vengeance of our fallen sisters. - ??s

-- In-Game Cutscene 2
wh2_drycha_igc02_sfx_01 = new_sfx("Play_wh2_dlc16_Drycha_quest_battle_IGC02_01"); -- Aid me Forest Spirits! - 2s
wh2_drycha_igc02_sfx_02 = new_sfx("Play_wh2_dlc16_Drycha_quest_battle_IGC02_02"); -- I speak for the Tree of Woe! - ??s
wh2_drycha_igc02_sfx_03 = new_sfx("Play_wh2_dlc16_Drycha_quest_battle_IGC02_03"); -- We are strong! - 3s
wh2_drycha_igc02_sfx_04 = new_sfx("Play_wh2_dlc16_Drycha_quest_battle_IGC02_04"); -- Let us rend them asunder! - 4s

-- In-Game Cutscene 3
wh2_drycha_igc03_sfx_01 = new_sfx("Play_wh2_dlc16_Drycha_quest_battle_IGC03_01"); -- Coeddil comes! - 4s
wh2_drycha_igc03_sfx_02 = new_sfx("Play_wh2_dlc16_Drycha_quest_battle_IGC03_02"); -- and our vengeance now awaits! - 3s
wh2_drycha_igc03_sfx_03 = new_sfx("Play_wh2_dlc16_Drycha_quest_battle_IGC03_03"); -- All will suffer our... - 4s
wh2_drycha_igc03_sfx_04 = new_sfx("Play_wh2_dlc16_Drycha_quest_battle_IGC03_04"); -- Ancient! - 3s
wh2_drycha_igc03_sfx_05 = new_sfx("Play_wh2_dlc16_Drycha_quest_battle_IGC03_05"); -- Vengeful! - 3s
wh2_drycha_igc03_sfx_06 = new_sfx("Play_wh2_dlc16_Drycha_quest_battle_IGC03_06"); -- Wrath! - 3s

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------
bm:out("## ARMY SETUP INITIALISED ##");
ga_drycha = gb:get_army(gb:get_player_alliance_num(), 1, "");
ga_reinforcements_anmyr = gb:get_army(gb:get_player_alliance_num(), "ally_reinforcements_anmyr");
ga_reinforcements_modryn = gb:get_army(gb:get_player_alliance_num(), "ally_reinforcements_modryn");
ga_reinforcements_coeddil = gb:get_army(gb:get_player_alliance_num(),"player_reinforcements_coeddil");
ga_reinforcements_coeddil_2 = gb:get_army(gb:get_player_alliance_num(),"player_reinforcements_coeddil_2");
ga_reinforcements_anmyr_fly = gb:get_army(gb:get_player_alliance_num(), "ally_reinforcements_anmyr_fly");
ga_reinforcements_modryn_fly = gb:get_army(gb:get_player_alliance_num(), "ally_reinforcements_modryn_fly");

ga_enemy_army_cythral = gb:get_army(gb:get_non_player_alliance_num(), "enemy_army_cythral");
ga_enemy_army_cythral_archers_1 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_army_cythral_archers_1");
ga_enemy_army_cythral_archers_2 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_army_cythral_archers_2");
ga_enemy_army_cythral_archers_3 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_army_cythral_archers_3");

--Waystone Ambush Forces
ga_enemy_army_cythral_waystone_guard_1 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_army_cythral_waystone_guard_1");
ga_enemy_army_cythral_waystone_guard_2 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_army_cythral_waystone_guard_2");
ga_enemy_army_cythral_waystone_ambush_1 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_army_cythral_waystone_ambush_1");
ga_enemy_army_cythral_waystone_ambush_2 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_army_cythral_waystone_ambush_2");
ga_enemy_army_cythral_waystone_ambush_2a = gb:get_army(gb:get_non_player_alliance_num(), "enemy_army_cythral_waystone_ambush_2a");

--Midfield Patrols
ga_enemy_army_cythral_patrol_1 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_army_cythral_patrol_1");
ga_enemy_army_cythral_patrol_2 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_army_cythral_patrol_2");
ga_enemy_army_cythral_patrol_3 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_army_cythral_patrol_3");

-- Midfield Ambush Forces
ga_enemy_army_cythral_midfield_ambush_1 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_army_cythral_midfield_ambush_1");
ga_enemy_army_cythral_midfield_ambush_2 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_army_cythral_midfield_ambush_2");

-- Hill Ambush Forces
ga_enemy_army_cythral_hill_ambush_1 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_army_cythral_hill_ambush_1");
ga_enemy_army_cythral_hill_ambush_2 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_army_cythral_hill_ambush_2");

-- Enemy Reinforcements
ga_enemy_reinforcements_cythral_1 = gb:get_army(gb:get_non_player_alliance_num(),"enemy_reinforcements_cythral_1");
ga_enemy_reinforcements_cythral_2 = gb:get_army(gb:get_non_player_alliance_num(),"enemy_reinforcements_cythral_2");
bm:out("## ARMY SETUP COMPLETE ##");

-------------------------------------------------------------------------------------------------
---------------------------------------- ARMY Teleport ------------------------------------------
-------------------------------------------------------------------------------------------------

function battle_start_teleport_units()
	bm:out("\tbattle_start_teleport_units() called");
	bm:out("## ARMY TELEPORT INITIALISED ##");

-- Main Force --
	--Nettle
	ga_enemy_army_cythral.sunits:item(1).uc:teleport_to_location(v(-34, 150), 0, 1);
	--Bendwynn
	ga_enemy_army_cythral.sunits:item(2).uc:teleport_to_location(v(-24, 150), 0, 40);
	--Eternal Guard
	ga_enemy_army_cythral.sunits:item(3).uc:teleport_to_location(v(-70, 190), 0, 40);
	ga_enemy_army_cythral.sunits:item(4).uc:teleport_to_location(v(0, 190), 0, 40);
	--Wildwood Rangers
	ga_enemy_army_cythral.sunits:item(5).uc:teleport_to_location(v(-86.23, 150), 0, 40);
	ga_enemy_army_cythral.sunits:item(6).uc:teleport_to_location(v(-57.46, 170), 0, 40);
	ga_enemy_army_cythral.sunits:item(7).uc:teleport_to_location(v(-7.23, 170), 0, 40);
	ga_enemy_army_cythral.sunits:item(8).uc:teleport_to_location(v(20.73, 150), 0, 40);
	--Zoats
	ga_enemy_army_cythral.sunits:item(9).uc:teleport_to_location(v(-12.72, 110), 0, 27);
	ga_enemy_army_cythral.sunits:item(10).uc:teleport_to_location(v(-53.36, 110), 0, 27);

-- Reinforcements - Shannyn --
	ga_enemy_reinforcements_cythral_1.sunits:item(1).uc:teleport_to_location(v(-259, 445), 180, 1);
	ga_enemy_reinforcements_cythral_1.sunits:item(2).uc:teleport_to_location(v(-257, 446), 180, 20);
	ga_enemy_reinforcements_cythral_1.sunits:item(3).uc:teleport_to_location(v(-256, 447), 180, 20);
	ga_enemy_reinforcements_cythral_1.sunits:item(4).uc:teleport_to_location(v(-255, 443), 180, 20);
	ga_enemy_reinforcements_cythral_1.sunits:item(5).uc:teleport_to_location(v(-254, 442), 180, 20);
	ga_enemy_reinforcements_cythral_1.sunits:item(6).uc:teleport_to_location(v(-253, 441), 180, 20);

-- Reinforcements - Georgiana --
	ga_enemy_reinforcements_cythral_2.sunits:item(1).uc:teleport_to_location(v(137, 445), 180, 1);
	ga_enemy_reinforcements_cythral_2.sunits:item(2).uc:teleport_to_location(v(137, 446), 180, 20);
	ga_enemy_reinforcements_cythral_2.sunits:item(3).uc:teleport_to_location(v(137, 447), 180, 20);
	ga_enemy_reinforcements_cythral_2.sunits:item(4).uc:teleport_to_location(v(137, 443), 180, 20);
	ga_enemy_reinforcements_cythral_2.sunits:item(5).uc:teleport_to_location(v(137, 442), 180, 20);
	ga_enemy_reinforcements_cythral_2.sunits:item(6).uc:teleport_to_location(v(137, 441), 180, 20);

-- Archers --
	-- Waystone 1 (West)
	ga_enemy_army_cythral_archers_1.sunits:item(1).uc:teleport_to_location(v(-144.52, -235.15), 90, 40);
	
	-- Waystone 2 (East)
	ga_enemy_army_cythral_archers_2.sunits:item(1).uc:teleport_to_location(v(83.41, -256.84), 230, 40);
	
	-- Waystone 3 (North)
	ga_enemy_army_cythral_archers_3.sunits:item(1).uc:teleport_to_location(v(57.96, 98.68), 180, 40);
	ga_enemy_army_cythral_archers_3.sunits:item(2).uc:teleport_to_location(v(11.61, 72.80), 180, 40);
	ga_enemy_army_cythral_archers_3.sunits:item(3).uc:teleport_to_location(v(-55.63, 70.16), 180, 40);
	ga_enemy_army_cythral_archers_3.sunits:item(4).uc:teleport_to_location(v(-116.88, 98.46), 180, 40);

-- Waystone Guard --
	-- Waystone 1 (West)
	ga_enemy_army_cythral_waystone_guard_1.sunits:item(1).uc:teleport_to_location(v(-168, -313), 100, 25);
	ga_enemy_army_cythral_waystone_guard_1.sunits:item(2).uc:teleport_to_location(v(-174, -351), 100, 25);
	
	ga_enemy_army_cythral_waystone_ambush_1.sunits:item(1).uc:teleport_to_location(v(-302, -405), 0, 40);
	ga_enemy_army_cythral_waystone_ambush_1.sunits:item(2).uc:teleport_to_location(v(-302, -404), 0, 40);
	ga_enemy_army_cythral_waystone_ambush_1.sunits:item(3).uc:teleport_to_location(v(-362, -298), 90, 40);

	-- Waystone 2 (East)
	ga_enemy_army_cythral_waystone_guard_2.sunits:item(1).uc:teleport_to_location(v(207, -237), 200, 25);
	ga_enemy_army_cythral_waystone_guard_2.sunits:item(2).uc:teleport_to_location(v(251, -254), 200, 25);

	ga_enemy_army_cythral_waystone_ambush_2a.sunits:item(1).uc:teleport_to_location(v(239, -108), 180, 1);
	ga_enemy_army_cythral_waystone_ambush_2.sunits:item(1).uc:teleport_to_location(v(239, -109), 180, 40);
	ga_enemy_army_cythral_waystone_ambush_2.sunits:item(2).uc:teleport_to_location(v(310, -214), -30, 40);
	
-- Patrols --
	ga_enemy_army_cythral_patrol_1.sunits:item(1).uc:teleport_to_location(v(-50.22, -8.01), 180, 25);
	ga_enemy_army_cythral_patrol_2.sunits:item(1).uc:teleport_to_location(v(190, 158), 180, 25);
	ga_enemy_army_cythral_patrol_3.sunits:item(1).uc:teleport_to_location(v(-236, 270), 180, 25);

-- Ambushes --
	-- Midfield Ambushers (West)
	ga_enemy_army_cythral_midfield_ambush_1.sunits:item(1).uc:teleport_to_location(v(-289, -65), 185, 45);
	ga_enemy_army_cythral_midfield_ambush_1.sunits:item(2).uc:teleport_to_location(v(-408, -105), 125, 45);

	-- Midfield Ambushers (East)
	ga_enemy_army_cythral_midfield_ambush_2.sunits:item(1).uc:teleport_to_location(v(30, -59), 140, 40);
	ga_enemy_army_cythral_midfield_ambush_2.sunits:item(2).uc:teleport_to_location(v(166, -13), 230, 40);

	--Hill Ambush (West) - Great Stag Knights
	ga_enemy_army_cythral_hill_ambush_1.sunits:item(1).uc:teleport_to_location(v(-271.35, 256.82), 150, 40);

	--Hill Ambush (East) - Great Stag Knights
	ga_enemy_army_cythral_hill_ambush_2.sunits:item(1).uc:teleport_to_location(v(199.86, 230.43), 250, 40);

	--Reinforcements Anmyr
	ga_reinforcements_anmyr.sunits:item(1).uc:teleport_to_location(v(182, -599), 57, 2);
	ga_reinforcements_anmyr.sunits:item(2).uc:teleport_to_location(v(-469.81, -475.71), 57, 33);
	ga_reinforcements_anmyr.sunits:item(3).uc:teleport_to_location(v(-443.91, -466.09), 57, 9);
	ga_reinforcements_anmyr.sunits:item(4).uc:teleport_to_location(v(-456.71, -456.47), 57, 9);
	ga_reinforcements_anmyr.sunits:item(5).uc:teleport_to_location(v(-489.13, -493.57), 57, 28);
	ga_reinforcements_anmyr.sunits:item(6).uc:teleport_to_location(v(-479.48, -473.70), 57, 20);
	ga_reinforcements_anmyr.sunits:item(7).uc:teleport_to_location(v(-468.84, -488.80), 57, 20);
	ga_reinforcements_anmyr.sunits:item(8).uc:teleport_to_location(v(-494.70, -496.13), 57, 20);
	ga_reinforcements_anmyr_fly.sunits:item(1).uc:teleport_to_location(v(-465.52, -465.38), 57, 10);
	ga_reinforcements_anmyr_fly.sunits:item(2).uc:teleport_to_location(v(-457.20, -474.19), 57, 10);
	ga_reinforcements_anmyr_fly.sunits:item(3).uc:teleport_to_location(v(-462.15, -469.29), 57, 33);

	--Reinforcements modryn
	ga_reinforcements_modryn.sunits:item(1).uc:teleport_to_location(v(425.72, -145.42), 270, 2);
	ga_reinforcements_modryn.sunits:item(2).uc:teleport_to_location(v(431.32, -144.68), 270, 17);
	ga_reinforcements_modryn.sunits:item(3).uc:teleport_to_location(v(454.14, -142.00), 270, 17);
	ga_reinforcements_modryn.sunits:item(4).uc:teleport_to_location(v(457.50, -143.59), 270, 20);
	ga_reinforcements_modryn.sunits:item(5).uc:teleport_to_location(v(478.57, -141.98), 270, 20);
	ga_reinforcements_modryn.sunits:item(6).uc:teleport_to_location(v(443.70, -143.34), 270, 7);
	ga_reinforcements_modryn.sunits:item(7).uc:teleport_to_location(v(447.48, -152.65), 270, 2);
	ga_reinforcements_modryn.sunits:item(8).uc:teleport_to_location(v(439.73, -136.14), 270, 2);
	ga_reinforcements_modryn_fly.sunits:item(1).uc:teleport_to_location(v(412.24, -146.82), 270, 17);
	ga_reinforcements_modryn_fly.sunits:item(2).uc:teleport_to_location(v(413.03, -146.58), 270, 13);
	ga_reinforcements_modryn_fly.sunits:item(3).uc:teleport_to_location(v(413.77, -145.56), 270, 17);


-- Set Unit Attributes --
	bm:set_stat_attribute("wallbreaker", true)

	bm:out("## ARMY TELEPORT COMPLETE ##");

	start_patrol_1();
	start_patrol_2();
	start_patrol_3()
end;

-------------------------------------------------------------------------------------------------
------------------------------------------- CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------
function end_deployment_phase()
	bm:out("\tend_deployment_phase() called");

	-- teleport units into their desired positions
	battle_start_teleport_units();
	--bm:modify_battle_speed(0);
		
	local cam = bm:camera();
	
	-- REMOVE ME
	cam:fade(true, 0);
	
	-- declare cutscene
	local cutscene_intro = cutscene:new(
		"cutscene_intro", 						-- unique string name for cutscene
		ga_drycha.sunits,					-- unitcontroller over player's army
		41800, 									-- duration of cutscene in ms
		function() intro_cutscene_end() end		-- what to call when cutscene is finished
	);
	
	local player_units_hidden = false;
	
	-- set up subtitles
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();
	
	-- cutscene_intro:set_post_cutscene_fade_time(0);
	
	-- skip callback
	cutscene_intro:set_skippable(
		true, 
		function()
			local cam = bm:camera();
			cam:fade(true, 0);
			bm:stop_cindy_playback(true);
			
			if player_units_hidden then
				ga_drycha:set_enabled(true)
			end;
						
			bm:callback(function() cam:fade(false, 0.5) end, 500);
		end
	);
	
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000);
	
	-- cutscene_intro:action(function() cam:move_to(v(-781.747, 84.081, 5.09), v(-770.503, 81.635, 21.587), 0, false, 30) end, 0);	

	cutscene_intro:action(function() bm:cindy_playback("script/battle/quest_battles/_cutscene/managers/coeddil.CindySceneManager", 0, 2) end, 200);
	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_drycha:set_enabled(true) 
		end, 
		200
	);	
	
	-- Voiceover and Subtitle Timings --
--wh2_dlc16_Drycha_quest_battle_pt_01 - 7.1
--wh2_dlc16_Drycha_quest_battle_pt_02 - 7.6
--wh2_dlc16_Drycha_quest_battle_pt_03 - 8.5
--wh2_dlc16_Drycha_quest_battle_pt_04 - 5.6
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 3000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc16_Drycha_Coeddil_Unchained_pt_01", "subtitle_with_frame", 0.1) end, 3000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 12100);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 13100);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc16_Drycha_Coeddil_Unchained_pt_02", "subtitle_with_frame", 0.1) end, 13100);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 22700);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 23700);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc16_Drycha_Coeddil_Unchained_pt_03", "subtitle_with_frame", 0.1) end, 23700);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 34200);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_04) end, 35200);
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc16_Drycha_Coeddil_Unchained_pt_04", "subtitle_with_frame", 0.1) end, 35200);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 41800);

	cutscene_intro:start();
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
	start_ambush_monitors();
end;

-------------------------------------------------------------------------------------------------
------------------------------------------- BUILDINGS -------------------------------------------
-------------------------------------------------------------------------------------------------

-- Name of waystone building
-- (change to suit)
waystone_building_name = "wef_large_waystone_01_qb";


-- List of positions near to each waystone
-- (change keys and positions here to desired values)
waystone_positions = {
	waystone_1 = v(-289.4, -324),
	waystone_2 = v(256, -166),
	waystone_3 = v(-155.4, 387),
	waystone_4 = v(27.5, 387)
};


-- Function to get key of position in supplied list that's closest to the supplied target position
function get_closest_position_key(position_list, target_position)
	local closest_position;
	local closest_distance = 200;
	
	for position_key, position in pairs(position_list) do
		local current_distance = position:distance(target_position);
		
		if current_distance < closest_distance then
			closest_position = position_key;
			closest_distance = current_distance;
		end;
	end;
	
	return closest_position;
end;

-- Building destroyed listener
core:add_listener(
	"waystone_destroyed_listener",
	"BattleUnitDestroysBuilding",
	function(context) 
		bm:out("*** BattleUnitDestroysBuilding event received, building name is " .. tostring(context:battle_building():name()))
		return context:battle_building():name() == waystone_building_name 
	end,
	function(context)
		local waystone_position = context:battle_building():central_position();
		local waystone_key = get_closest_position_key(waystone_positions, waystone_position);
		
		if not waystone_key then
			script_error("ERROR: waystone destroyed but could not determine its name? How can this be?");
			return false;
		end;
		
		local message = waystone_key .. "_destroyed";
		
		bm:out("*** Waystone building " .. waystone_key .. " at position " .. v_to_s(waystone_position) .. " destroyed, triggering message " .. message);
		
		gb.sm:trigger_message(message);	
	end,
	true
);

-- Build a list of waystone buildings now so we can make them invulnerable during cutscenes
bm:out("");

local waystone_buildings = {};

local buildings = bm:buildings();
for i = 1, buildings:count() do
	local building = buildings:item(i);
	if building:name() == waystone_building_name then
		table.insert(waystone_buildings, building);
		bm:out("Found waystone building at position " .. v_to_s(building:central_position()));
	end;
end;
bm:out("");

function set_waystone_buildings_invulnerable(value)
	for i = 1, #waystone_buildings do
		waystone_buildings[i]:change_is_destructible(not value);
	end;
end;





-- Generates "coeddil_unchained" message when Waystones 3 and 4 are destroyed in order to feed into Coeddil reinforcement trigger
gb:message_on_all_messages_received("coeddil_unchained", "waystone_3_destroyed", "waystone_4_destroyed")

-------------------------------------------------------------------------------------------------
-------------------------------------------- PATROL ---------------------------------------------
-------------------------------------------------------------------------------------------------
function start_patrol_1()
	local player_armies = bm:alliances():item(gb:get_player_alliance_num()):armies();
--	bm:out("It's workiiiing");
	for i = 1, ga_enemy_army_cythral_patrol_1.sunits:count() do
		local current_sunit = ga_enemy_army_cythral_patrol_1.sunits:item(i);

		--set up patrol manager here, one for each sunit
		local pm = patrol_manager:new(current_sunit.name .. "_wef_patrol_01", current_sunit, player_armies, 40);
		--pm:set_debug();
		pm:add_waypoint(v(45, 3), true);
		pm:add_waypoint(v(120, -84), true);
		pm:add_waypoint(v(-55, -160), true);
		pm:add_waypoint(v(-142, -87), true);
		pm:add_waypoint(v(-142, -1), true);
		pm:loop(true);
		pm:set_stop_on_intercept(true);
		pm:set_stop_on_rout(true);
		pm:start();
	end;
end;

function start_patrol_2()
	local player_armies = bm:alliances():item(gb:get_player_alliance_num()):armies();
--	bm:out("It's workiiiing");
	for i = 1, ga_enemy_army_cythral_patrol_2.sunits:count() do
		local current_sunit = ga_enemy_army_cythral_patrol_2.sunits:item(i);

		--set up patrol manager here, one for each sunit
		local pm = patrol_manager:new(current_sunit.name .. "_wef_patrol_01", current_sunit, player_armies, 40);
		--pm:set_debug();
		pm:add_waypoint(v(85, -3), true);
		pm:add_waypoint(v(200, 120), true);
		pm:add_waypoint(v(142, 287), true);
		pm:add_waypoint(v(200, 120), true);
		pm:loop(true);
		pm:set_stop_on_intercept(true);
		pm:set_stop_on_rout(true);
		pm:start();
	end;
end;

function start_patrol_3()
	local player_armies = bm:alliances():item(gb:get_player_alliance_num()):armies();
--	bm:out("It's workiiiing");
	for i = 1, ga_enemy_army_cythral_patrol_3.sunits:count() do
		local current_sunit = ga_enemy_army_cythral_patrol_3.sunits:item(i);

		--set up patrol manager here, one for each sunit
		local pm = patrol_manager:new(current_sunit.name .. "_wef_patrol_01", current_sunit, player_armies, 40);
		--pm:set_debug();
		pm:add_waypoint(v(-264, 234), true);
		pm:add_waypoint(v(-368, 49), true);
		pm:add_waypoint(v(-332, -130), true);
		pm:add_waypoint(v(-143, -50), true);
		pm:loop(true);
		pm:set_stop_on_intercept(true);
		pm:set_stop_on_rout(true);
		pm:start();
	end;
end;

-------------------------------------------------------------------------------------------------
-------------------------------------------- AMBUSH MANAGER -------------------------------------
-------------------------------------------------------------------------------------------------

-- The following block of script excludes the player's flying units from the following positional proximity triggers
ambush_positions = {
	{
		pos 		= v(-170, 32, -330),
		radius		= 50,
		msg			= "player_in_proximity_of_waystone_guard_1"
	},
	{
		pos 		= v(224, 40, -268),
		radius		= 50,
		msg			= "player_in_proximity_of_waystone_guard_2"
	},
	{
		pos 		= v(-289.4, 60, -324),
		radius		= 40,
		msg			= "player_attacking_waystone_1"
	},
	{
		pos 		= v(256, 60, -166),
		radius		= 40,
		msg			= "player_attacking_waystone_2"
	},
	{
		pos 		= v(-353, 22, -144),
		radius		= 60,
		msg			= "start_ambush_west"
	},
	{
		pos 		= v(100, 20, -70),
		radius		= 60,
		msg			= "start_ambush_east"
	},
	{
		pos 		= v(-362, 32, 4),
		radius		= 60,
		msg			= "start_ambush_hill_west"
	},
	{
		pos 		= v(-198, 34, 22),
		radius		= 60,
		msg			= "start_ambush_hill_west"
	},
	{
		pos 		= v(176, 28, 111),
		radius		= 60,
		msg			= "start_ambush_hill_east"
	},
	{
		pos 		= v(-155.4, 42, 387),
		radius		= 60,
		msg			= "northern_waystones_under_attack"
	},
	{
		pos 		= v(27.5, 42, 387),
		radius		= 60,
		msg			= "northern_waystones_under_attack"
	},
	{
		pos 		= v(-155.4, 42, 387),
		radius		= 90,
		msg			= "northern_waystones_under_attack"
	},
};

function start_ambush_monitors()
	local sunits = ga_drycha.sunits;

	for i = 1, #ambush_positions do
		local current_ambush_record = ambush_positions[i];

		bm:watch(
			function()
				local unit, dist, sunit = get_closest_unit(
					sunits,
					current_ambush_record.pos, 
					true, 
					function(unit, sunit)
						return not unit:is_currently_flying()
					end
				);
				if unit:position():distance_xz(current_ambush_record.pos) < current_ambush_record.radius then
					bm:out(" *** Triggering ambush message " .. current_ambush_record.msg .. " as unit " .. sunit.name .. " at position " .. v_to_s(unit:position()) .. " has come within " .. current_ambush_record.radius .. "m of ambush position " .. v_to_s(current_ambush_record.pos));
					return true;
				end;
			end,
			0,
			function()
				gb.sm:trigger_message(current_ambush_record.msg);
			end,
			"ambush_monitor_" .. current_ambush_record.msg
		);
	end;
end;

-------------------------------------------------------------------------------------------------
----------------------------------------- INITIAL ORDERS ----------------------------------------
-------------------------------------------------------------------------------------------------
--Stopping player from firing until the cutscene is done
ga_drycha:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_drycha:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);
ga_reinforcements_anmyr:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_reinforcements_modryn:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
--ga_reinforcements_coeddil:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);

-- Enemy Initialisation
ga_enemy_army_cythral:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);

-------------------------------------------------------------------------------------------------
--------------------------------------- MAIN ENEMY ORDERS ---------------------------------------
-------------------------------------------------------------------------------------------------

--ga_enemy_army_cythral:message_on_under_attack("defend_waystones")
--ga_enemy_army_cythral:defend_on_message("defend_waystones", -50, 234, 130)

ga_reinforcements_anmyr:message_on_proximity_to_position("northern_waystones_under_attack", v(-155.4, 42, 387), 60)
ga_reinforcements_modryn:message_on_proximity_to_position("northern_waystones_under_attack", v(-155.4, 42, 387), 60)
ga_reinforcements_anmyr:message_on_proximity_to_position("northern_waystones_under_attack", v(27.5, 42, 387), 60)
ga_reinforcements_modryn:message_on_proximity_to_position("northern_waystones_under_attack", v(27.5, 42, 387), 60)

ga_reinforcements_anmyr:message_on_proximity_to_position("northern_waystones_under_attack", v(-34, 42, 150), 90)
ga_reinforcements_modryn:message_on_proximity_to_position("northern_waystones_under_attack", v(-34, 42, 150), 90)

--bm:debug_drawing():draw_white_circle_on_terrain(v(-34, 42, 150), 90, 100000000);
ga_enemy_army_cythral:set_enabled(false)
ga_enemy_army_cythral:set_enabled_on_message("northern_waystones_under_attack", true)
ga_enemy_army_cythral:release_on_message("northern_waystones_under_attack", 1000);
gb:add_ping_icon_on_message("northern_waystones_under_attack", v(-34, 60, 150), 11, 1000, 10000)
--bm:debug_drawing():draw_white_circle_on_terrain(v(-155.4, 42, 387), 60, 100000000)
--bm:debug_drawing():draw_white_circle_on_terrain(v(27.5, 42, 387), 60, 100000000)
--bm:debug_drawing():draw_white_circle_on_terrain(v(166, 43, 219), 60, 100000000)

gb:message_on_any_message_received("start_ambush_west", "waystone_3_destroyed", "waystone_4_destroyed", "enemy_send_help_soon")
gb:message_on_any_message_received("start_ambush_east", "waystone_3_destroyed", "waystone_4_destroyed", "enemy_send_help_soon")
gb:message_on_any_message_received("start_hill_ambush_west", "waystone_3_destroyed", "waystone_4_destroyed", "enemy_send_help_soon")
gb:message_on_any_message_received("start_hill_ambush_east", "waystone_3_destroyed", "waystone_4_destroyed", "enemy_send_help_soon")
gb:message_on_any_message_received("release_archers", "waystone_3_destroyed", "waystone_4_destroyed", "enemy_send_help_soon")
ga_enemy_army_cythral_archers_1:release_on_message("release_archers")
ga_enemy_army_cythral_archers_2:release_on_message("release_archers")
ga_enemy_army_cythral_archers_3:release_on_message("release_archers")

-------------------------------------------------------------------------------------------------
---------------------------------------- AMBUSH ORDERS ------------------------------------------
-------------------------------------------------------------------------------------------------

-- Waystone Guard West
ga_enemy_army_cythral_waystone_guard_1:set_enabled(false)
ga_enemy_army_cythral_waystone_guard_1:set_enabled_on_message("player_in_proximity_of_waystone_guard_1", true)
ga_enemy_army_cythral_waystone_guard_1:attack_on_message("player_in_proximity_of_waystone_guard_1");
ga_enemy_army_cythral_waystone_guard_1.sunits:prevent_rallying_if_routing(true);
ga_enemy_army_cythral_waystone_guard_1:message_on_rout_proportion("waystone_guard_1_defeated", 1);
gb:add_ping_icon_on_message("player_in_proximity_of_waystone_guard_1", v(-174, 30, -331), 11, 0, 15000)

-- Waystone Ambush West
ga_enemy_army_cythral_waystone_ambush_1:set_enabled(false)
ga_enemy_army_cythral_waystone_ambush_1:set_enabled_on_message("player_attacking_waystone_1", true)
ga_enemy_army_cythral_waystone_ambush_1:attack_on_message("player_attacking_waystone_1");
gb:add_ping_icon_on_message("player_attacking_waystone_1", v(-302, 30, -406), 11, 0, 15000)
gb:add_ping_icon_on_message("player_attacking_waystone_1", v(-362, 30, -298), 11, 0, 15000)
ga_enemy_army_cythral_waystone_ambush_1.sunits:prevent_rallying_if_routing(true);

-- Waystone Guard East
ga_enemy_army_cythral_waystone_guard_2:set_enabled(false)
ga_enemy_army_cythral_waystone_guard_2:set_enabled_on_message("player_in_proximity_of_waystone_guard_2", true)
ga_enemy_army_cythral_waystone_guard_2:release_on_message("player_in_proximity_of_waystone_guard_2");
ga_enemy_army_cythral_waystone_guard_2.sunits:prevent_rallying_if_routing(true);
ga_enemy_army_cythral_waystone_guard_2:message_on_rout_proportion("waystone_guard_2_defeated", 1);
gb:add_ping_icon_on_message("player_in_proximity_of_waystone_guard_2", v(234, 30, -247), 11, 0, 15000)

-- Waystone Ambush East
ga_enemy_army_cythral_waystone_ambush_2:set_enabled(false)
ga_enemy_army_cythral_waystone_ambush_2:set_enabled_on_message("player_attacking_waystone_2", true)
ga_enemy_army_cythral_waystone_ambush_2:attack_on_message("player_attacking_waystone_2");
gb:add_ping_icon_on_message("player_attacking_waystone_2", v(239, 30, -109), 11, 0, 15000)
gb:add_ping_icon_on_message("player_attacking_waystone_2", v(310, 30, -214), 11, 0, 15000)
ga_enemy_army_cythral_waystone_ambush_2.sunits:prevent_rallying_if_routing(true);

-- Special setup for Waystalker so that he doesn't break the campaign
ga_enemy_army_cythral_waystone_ambush_2a:set_enabled(false)
ga_enemy_army_cythral_waystone_ambush_2a:set_enabled_on_message("player_attacking_waystone_2", true)
ga_enemy_army_cythral_waystone_ambush_2a:attack_on_message("player_attacking_waystone_2");
ga_enemy_army_cythral_waystone_ambush_2a.sunits:prevent_rallying_if_routing(true);


-- Midfield Ambush West
gb:message_on_time_offset("start_ambush_west", 45000, "waystone_1_destroyed");
ga_reinforcements_anmyr:message_on_proximity_to_position("start_ambush_west", v(-353, 22, -144), 60)
ga_reinforcements_modryn:message_on_proximity_to_position("start_ambush_west", v(-353, 22, -144), 60)
ga_enemy_army_cythral_midfield_ambush_1:set_enabled(false)
ga_enemy_army_cythral_midfield_ambush_1:set_enabled_on_message("start_ambush_west", true)
ga_enemy_army_cythral_midfield_ambush_1:release_on_message("start_ambush_west", 5000);
gb:add_ping_icon_on_message("start_ambush_west", v(-289, 30, -65), 11, 0, 15000)
gb:add_ping_icon_on_message("start_ambush_west", v(-408, 30, -105), 11, 0, 15000)
ga_enemy_army_cythral_midfield_ambush_1.sunits:prevent_rallying_if_routing(true);

-- Midfield Ambush East
gb:message_on_time_offset("start_ambush_east", 45000, "waystone_2_destroyed");
ga_reinforcements_anmyr:message_on_proximity_to_position("start_ambush_east", v(100, 20, -70), 60)
ga_reinforcements_modryn:message_on_proximity_to_position("start_ambush_east", v(100, 20, -70), 60)
ga_enemy_army_cythral_midfield_ambush_2:set_enabled(false)
ga_enemy_army_cythral_midfield_ambush_2:set_enabled_on_message("start_ambush_east", true)
ga_enemy_army_cythral_midfield_ambush_2:release_on_message("start_ambush_east", 5000);
gb:add_ping_icon_on_message("start_ambush_east", v(30, 30, -59), 11, 0, 15000)
gb:add_ping_icon_on_message("start_ambush_east", v(166, 30, -13), 11, 0, 15000)
ga_enemy_army_cythral_midfield_ambush_2.sunits:prevent_rallying_if_routing(true);

-- Ambush Override for Patrols
ga_enemy_army_cythral_patrol_1:message_on_casualties("patrol_under_attack", 0.05);
ga_enemy_army_cythral_patrol_2:message_on_casualties("patrol_under_attack", 0.05);
ga_enemy_army_cythral_patrol_3:message_on_casualties("patrol_under_attack", 0.05);
ga_enemy_army_cythral_patrol_1:attack_on_message("patrol_under_attack");
ga_enemy_army_cythral_patrol_2:attack_on_message("patrol_under_attack");
ga_enemy_army_cythral_patrol_3:attack_on_message("patrol_under_attack");
gb:message_on_time_offset("start_ambush_west", 20000,"patrol_under_attack");
gb:message_on_time_offset("start_ambush_east", 20000,"patrol_under_attack");
gb:message_on_time_offset("patrol_release", 20000,"patrol_under_attack");
ga_enemy_army_cythral_patrol_1:release_on_message("patrol_release");
ga_enemy_army_cythral_patrol_2:release_on_message("patrol_release");
ga_enemy_army_cythral_patrol_3:release_on_message("patrol_release");
ga_enemy_army_cythral_patrol_1.sunits:prevent_rallying_if_routing(true);
ga_enemy_army_cythral_patrol_2.sunits:prevent_rallying_if_routing(true);
ga_enemy_army_cythral_patrol_3.sunits:prevent_rallying_if_routing(true);

--Hill Ambush West
ga_reinforcements_anmyr:message_on_proximity_to_position("start_ambush_hill_west", v(-362, 32, 4), 60)
ga_reinforcements_anmyr:message_on_proximity_to_position("start_ambush_hill_west", v(-198, 34, 22), 60)
ga_reinforcements_modryn:message_on_proximity_to_position("start_ambush_hill_west", v(-362, 32, 4), 60)
ga_reinforcements_modryn:message_on_proximity_to_position("start_ambush_hill_west", v(-198, 34, 22), 60)
ga_enemy_army_cythral_hill_ambush_1:set_enabled(false)
ga_enemy_army_cythral_hill_ambush_1:set_enabled_on_message("start_ambush_hill_west", true)
ga_enemy_army_cythral_hill_ambush_1:move_to_position_on_message("start_ambush_hill_west", v(-198, 34, 22));
ga_enemy_army_cythral_hill_ambush_2:attack_on_message("start_ambush_hill_west", 8000);
ga_enemy_army_cythral_hill_ambush_1:set_enabled_on_message("player_attacking_waystone_3", true)
ga_enemy_army_cythral_hill_ambush_1:release_on_message("player_attacking_waystone_3", 5000);
gb:add_ping_icon_on_message("start_ambush_hill_west", v(-285, 60, 240), 11, 0, 15000)
ga_enemy_army_cythral_hill_ambush_1.sunits:prevent_rallying_if_routing(true);

--Hill Ambush East
ga_reinforcements_anmyr:message_on_proximity_to_position("start_ambush_hill_east", v(176, 28, 111), 60)
ga_reinforcements_modryn:message_on_proximity_to_position("start_ambush_hill_east", v(176, 28, 111), 60)
ga_enemy_army_cythral_hill_ambush_2:set_enabled(false)
ga_enemy_army_cythral_hill_ambush_2:set_enabled_on_message("start_ambush_hill_east", true)
ga_enemy_army_cythral_hill_ambush_2:attack_on_message("start_ambush_hill_east", 5000);
ga_enemy_army_cythral_hill_ambush_2:set_enabled_on_message("player_attacking_waystone_3", true)
ga_enemy_army_cythral_hill_ambush_2:release_on_message("player_attacking_waystone_3", 5000);
gb:add_ping_icon_on_message("start_ambush_hill_east", v(188, 60, 247), 11, 0, 15000)
ga_enemy_army_cythral_hill_ambush_2.sunits:prevent_rallying_if_routing(true);

-------------------------------------------------------------------------------------------------
-------------------------------------------- ARCHERS ORDERS -------------------------------------
-------------------------------------------------------------------------------------------------
ga_enemy_army_cythral_archers_1:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_enemy_army_cythral_archers_2:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_enemy_army_cythral_archers_3:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);

--Archers West
ga_enemy_army_cythral_archers_1:message_on_proximity_to_enemy("archers_1_under_attack", 150);
gb:message_on_time_offset("archers_1_under_attack", 1000,"player_in_proximity_of_waystone_guard_1");
ga_enemy_army_cythral_archers_1:message_on_under_attack("archers_1_under_attack")
ga_enemy_army_cythral_archers_1:change_behaviour_active_on_message("archers_1_under_attack", "fire_at_will", true, false);
ga_enemy_army_cythral_archers_1:attack_on_message("archers_1_under_attack");
ga_enemy_army_cythral_archers_1.sunits:prevent_rallying_if_routing(true);

--Archers East
ga_enemy_army_cythral_archers_2:message_on_proximity_to_enemy("archers_2_under_attack", 150);
gb:message_on_time_offset("archers_2_under_attack", 1000,"player_in_proximity_of_waystone_guard_2");
ga_enemy_army_cythral_archers_2:message_on_under_attack("archers_2_under_attack")
ga_enemy_army_cythral_archers_2:change_behaviour_active_on_message("archers_2_under_attack", "fire_at_will", true, false);
ga_enemy_army_cythral_archers_2:attack_on_message("archers_2_under_attack");
ga_enemy_army_cythral_archers_2.sunits:prevent_rallying_if_routing(true);

--Archers Central
ga_enemy_army_cythral_archers_3:change_behaviour_active_on_message("patrol_under_attack", "fire_at_will", true, false);
gb:message_on_time_offset("fly_trap", 20000, "patrol_under_attack")

-- Catches any pesky Eagles or Dragons trying to fly over the archers and tells them to open fire with the AA guns
ga_enemy_army_cythral_patrol_1:message_on_proximity_to_enemy("fly_trap", 50);
ga_enemy_army_cythral_patrol_2:message_on_proximity_to_enemy("fly_trap", 50);
ga_enemy_army_cythral_patrol_3:message_on_proximity_to_enemy("fly_trap", 50);
ga_enemy_army_cythral_archers_3:message_on_proximity_to_enemy("fly_trap", 140);
ga_enemy_army_cythral_archers_3:message_on_under_attack("fly_trap");
ga_enemy_army_cythral_archers_3:message_on_under_attack("defend_waystones");
ga_enemy_army_cythral_archers_3:change_behaviour_active_on_message("fly_trap", "fire_at_will", true, false);
--bm:debug_drawing():draw_white_circle_on_terrain(v(57.96, 10, 98.68), 140, 100000000)

-------------------------------------------------------------------------------------------------
------------------------------------ PLAYER REINFORCEMENTS --------------------------------------
-------------------------------------------------------------------------------------------------

-- Magic Giver
ga_drycha:add_winds_of_magic_on_message("cutscene_anmyr_reinforcements_end", 15)
ga_drycha:add_winds_of_magic_on_message("cutscene_modryn_reinforcements_end", 15)
ga_drycha:add_winds_of_magic_on_message("cutscene_coeddil_unchained_end", 30)

--Anmyr Controller
ga_reinforcements_anmyr:set_enabled(false)
ga_reinforcements_anmyr_fly:set_enabled(false)
ga_reinforcements_anmyr:set_enabled_on_message("spawn_anmyr", true)
ga_reinforcements_anmyr_fly:set_enabled_on_message("spawn_anmyr", true)

gb:message_on_time_offset("r1_move", 10000,"spawn_anmyr");
ga_reinforcements_anmyr:move_to_position_on_message("r1_move", v(-292, 33, -337));
ga_reinforcements_anmyr_fly:move_to_position_on_message("r1_move", v(-292, 33, -337));
gb:message_on_time_offset("r1_attack", 2000,"cutscene_anmyr_reinforcements_end");
ga_reinforcements_anmyr:release_on_message("r1_attack");
ga_reinforcements_anmyr_fly:release_on_message("r1_attack");

--Modryn Controller
ga_reinforcements_modryn:set_enabled(false)
ga_reinforcements_modryn_fly:set_enabled(false)
ga_reinforcements_modryn:set_enabled_on_message("spawn_modryn", true)
ga_reinforcements_modryn_fly:set_enabled_on_message("spawn_modryn", true)

gb:message_on_time_offset("r2_move", 10000,"spawn_modryn");
ga_reinforcements_modryn:move_to_position_on_message("r2_move", v(200, 31.6, -156));
ga_reinforcements_modryn_fly:move_to_position_on_message("r2_move", v(200, 31.6, -156));
gb:message_on_time_offset("r2_attack", 2000,"cutscene_modryn_reinforcements_end");
ga_reinforcements_modryn:release_on_message("r2_attack");
ga_reinforcements_modryn_fly:release_on_message("r2_attack");

--Coeddil Controller
ga_reinforcements_coeddil:reinforce_on_message("spawn_coeddil", 0);
ga_reinforcements_coeddil_2:reinforce_on_message("cutscene_coeddil_unchained_end", 0);
ga_reinforcements_coeddil:release_on_message("cutscene_coeddil_unchained_end", 1000);

-- Flash Coeddil's Unit Card
gb:message_on_time_offset("start_flashing_coeddil", 2000,"cutscene_coeddil_unchained_end");
gb:add_listener("start_flashing_coeddil", function() ga_reinforcements_coeddil.sunits:highlight_unit_cards(true, 10) end);
gb:message_on_time_offset("stop_flashing_coeddil", 10000,"start_flashing_coeddil");
gb:add_listener("stop_flashing_coeddil", function() ga_reinforcements_coeddil.sunits:highlight_unit_cards(false, 10) end);
gb:add_ping_icon_on_message("start_flashing_coeddil", v(-60.65, 60, 449.17), 11, 0, 8000)

-------------------------------------------------------------------------------------------------
------------------------------------- ENEMY REINFORCEMENTS --------------------------------------
-------------------------------------------------------------------------------------------------

-- Branching behaviour depending on player choice. If they choose to smash up the enemy instead of go for the waystones, there is a failsafe to trigger the reinforcements
-- 1st spawns help when enemy take 50% casualties and Coeddil is freed. 2nd spawns help when enemy take 70% casualties regardless of Coeddil's status
ga_enemy_army_cythral:message_on_casualties("enemy_send_help_soon", 0.5);
ga_enemy_army_cythral:message_on_casualties("enemy_send_help_now", 0.7);

-- Reinforcement message recievers/generators
gb:message_on_all_messages_received("enemy_send_help_now", "enemy_send_help_soon", "coeddil_unchained")
gb:message_on_time_offset("spawn_enemy_reinforcements", 15000, "enemy_send_help_now");

-- Enable Reinforcements
ga_enemy_reinforcements_cythral_1:set_enabled(false)
ga_enemy_reinforcements_cythral_1:set_enabled_on_message("spawn_enemy_reinforcements", true)
ga_enemy_reinforcements_cythral_2:set_enabled(false)
ga_enemy_reinforcements_cythral_2:set_enabled_on_message("spawn_enemy_reinforcements", true)

-- Release Reinforcements to the GTA
ga_enemy_reinforcements_cythral_1:release_on_message("spawn_enemy_reinforcements", 1000);
ga_enemy_reinforcements_cythral_2:release_on_message("spawn_enemy_reinforcements", 1000);
gb:add_ping_icon_on_message("spawn_enemy_reinforcements", v(-214, 60, 388), 11, 6000, 20000)
gb:add_ping_icon_on_message("spawn_enemy_reinforcements", v(90, 60, 388), 11, 6000, 20000)

-------------------------------------------------------------------------------------------------
------------------------------------ PLAYER FORCE DEFEATED --------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_locatable_objective_on_message("01_intro_cutscene_end", "wh2_dlc16_qb_wef_drycha_coeddil_unchained_objective_01", 5000, v(-250,104,-355.9),v(-458.9,-177.4,-133.4), 2);
gb:set_locatable_objective_on_message("01_intro_cutscene_end", "wh2_dlc16_qb_wef_drycha_coeddil_unchained_objective_02", 5000, v(225.2,107.6,-231.2),v(340.9,-174.7,50.5), 2);
gb:set_locatable_objective_on_message("01_intro_cutscene_end", "wh2_dlc16_qb_wef_drycha_coeddil_unchained_objective_03", 13000, v(-76.7,154.1,264.9),v(-76.6,-50.1,626.5), 2);
gb:set_objective_on_message("spawn_enemy_reinforcements", "wh2_dlc16_qb_wef_drycha_coeddil_unchained_objective_04", 6000);

gb:complete_objective_on_message("waystone_1_destroyed", "wh2_dlc16_qb_wef_drycha_coeddil_unchained_objective_01");
gb:complete_objective_on_message("waystone_2_destroyed", "wh2_dlc16_qb_wef_drycha_coeddil_unchained_objective_02");
gb:complete_objective_on_message("coeddil_unchained", "wh2_dlc16_qb_wef_drycha_coeddil_unchained_objective_03");
gb:complete_objective_on_message("enemy_defeated_1", "wh2_dlc16_qb_wef_drycha_coeddil_unchained_objective_04");

gb:add_ping_icon_on_message("01_intro_cutscene_end", v(-293.7, 75, -309), 15, 5000);
gb:add_ping_icon_on_message("01_intro_cutscene_end", v(256.7, 75, -167), 15, 5000);
gb:add_ping_icon_on_message("01_intro_cutscene_end", v(-155.4, 100, 387), 15, 13000);
gb:add_ping_icon_on_message("01_intro_cutscene_end", v(27.5, 100, 387), 15, 13000);

gb:remove_ping_icon_on_message("waystone_1_destroyed", v(-293.7, 75, -309));
gb:remove_ping_icon_on_message("waystone_2_destroyed", v(256.7, 75, -167));
gb:remove_ping_icon_on_message("waystone_3_destroyed", v(-155.4, 100, 387));
gb:remove_ping_icon_on_message("waystone_4_destroyed", v(27.5, 100, 387));

--THIS IS A PING TEST THAT SPAWNS ALL OF THE DIFFERENT TYPES OF PINGS YOU CAN CREATE
--gb:add_ping_icon_on_message("01_intro_cutscene_end", v(0, 30, 0), 8, 5000);
--gb:add_ping_icon_on_message("01_intro_cutscene_end", v(-40, 30, 0), 9, 5000);
--gb:add_ping_icon_on_message("01_intro_cutscene_end", v(-80, 30, 0), 10, 5000);
--gb:add_ping_icon_on_message("01_intro_cutscene_end", v(-120, 30, 0), 11, 5000);
--gb:add_ping_icon_on_message("01_intro_cutscene_end", v(-160, 30, 0), 12, 5000);
--gb:add_ping_icon_on_message("01_intro_cutscene_end", v(-200, 30, 0), 13, 5000);
--gb:add_ping_icon_on_message("01_intro_cutscene_end", v(-240, 30, 0), 14, 5000);
--gb:add_ping_icon_on_message("01_intro_cutscene_end", v(-280, 30, 0), 15, 5000);
--gb:add_ping_icon_on_message("01_intro_cutscene_end", v(-320, 30, 0), 16, 5000);

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("01_intro_cutscene_end", "wh2_dlc16_qb_wef_drycha_coeddil_unchained_objective_overview", 6000, nil, 5000);
gb:queue_help_on_message("01_intro_cutscene_end", "wh2_dlc16_qb_wef_drycha_coeddil_unchained_objective_coeddil", 6000, nil, 13000);
gb:queue_help_on_message("01_intro_cutscene_end", "wh2_dlc16_qb_wef_drycha_coeddil_unchained_objective_patrols", 6000, nil, 21000);

--gb:queue_help_on_message("patrol_under_attack", "wh2_dlc16_qb_wef_drycha_coeddil_unchained_objective_patrols_spotted", 6000, nil, 5000);

gb:queue_help_on_message("waystone_1_destroyed", "wh2_dlc16_qb_wef_drycha_coeddil_unchained_objective_01_complete", 6000, nil, 0);
gb:queue_help_on_message("waystone_2_destroyed", "wh2_dlc16_qb_wef_drycha_coeddil_unchained_objective_02_complete", 6000, nil, 0);
gb:queue_help_on_message("coeddil_unchained", "wh2_dlc16_qb_wef_drycha_coeddil_unchained_objective_03_complete", 6000, nil, 0);

gb:queue_help_on_message("spawn_enemy_reinforcements", "wh2_dlc16_qb_wef_drycha_coeddil_unchained_objective_enemy_reinforcements", 6000, nil, 0);

-------------------------------------------------------------------------------------------------
-------------------------------------------- VICTORY --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Player Victory Conditions
ga_enemy_army_cythral:message_on_rout_proportion("main_army_routing", 0.95)
ga_enemy_reinforcements_cythral_1:message_on_rout_proportion("reinforcements_1_routing", 0.95)
ga_enemy_reinforcements_cythral_2:message_on_rout_proportion("reinforcements_2_routing", 0.95)
gb:message_on_all_messages_received("enemy_defeated_1", "main_army_routing", "reinforcements_1_routing", "reinforcements_2_routing", "coeddil_unchained")
gb:queue_help_on_message("enemy_defeated_1", "wh2_dlc16_qb_wef_drycha_coeddil_unchained_objective_04_complete", 6000, nil, 5000, true, "enemy_defeated_2");
ga_drycha:force_victory_on_message("enemy_defeated_2", 5000);

-- Enemy victory Conditions
ga_drycha:message_on_rout_proportion("player_defeated", 0.95);
ga_enemy_army_cythral:force_victory_on_message("player_defeated", 5000);

-------------------------------------------------------------------------------------------------
------------------------------- BAN DRYCHA'S SUMMON ARMY ABILITY --------------------------------
-------------------------------------------------------------------------------------------------

ga_drycha:use_army_special_ability_on_message("01_intro_cutscene_end", "wh2_dlc16_army_abilities_roused_to_wrath_3", v(-29, 30, -382), 0, 10, 0);
ga_drycha:use_army_special_ability_on_message("01_intro_cutscene_end", "wh2_dlc16_army_abilities_roused_to_wrath_3", v(-29, 30, -382), 0, 10, 0);
ga_drycha:use_army_special_ability_on_message("01_intro_cutscene_end", "wh2_dlc16_army_abilities_roused_to_wrath_3", v(-29, 30, -382), 0, 10, 0);


-------------------------------------------------------------------------------------------------
------------------------------------ CUTSCENE QUEUE SYSTEM --------------------------------------
-------------------------------------------------------------------------------------------------

function enqueue_cutscene(c)
    if bm:is_any_cutscene_running() then
        table.insert(cutscene_queue, c);
    else
        c:start();
    end;    
end;

function check_cutscene_queue()
    if #cutscene_queue > 0 then
        cutscene_queue[1]:start();
        table.remove(cutscene_queue, 1);
        return true;
    end;
    return false;
end;

-------------------------------------------------------------------------------------------------
----------------------------- CUTSCENE 1 - WAYSTONE EAST DESTROYED ------------------------------
-------------------------------------------------------------------------------------------------

cutscene_modryn_reinforcements = cutscene:new(
	"cutscene_modryn_reinforcements", 					-- unique string name for cutscene
	ga_drycha.sunits, 									-- unitcontroller over player's army
	25000,												-- duration of cutscene in ms
	function() 
		cutscene_modryn_reinforcements_end()
		check_cutscene_queue()
	end	-- what to call when cutscene is finished
);

cutscene_modryn_reinforcements:set_restore_cam(2, v(225.2,107.6,-231.2),v(340.9,-174.7,50.5), 2);
cutscene_modryn_reinforcements:set_close_advisor_on_end(false);
cutscene_modryn_reinforcements:set_post_cutscene_fade_time(0);
cutscene_modryn_reinforcements:set_should_disable_unit_ids(true);
cutscene_modryn_reinforcements:set_should_enable_cinematic_camera(false);
cutscene_modryn_reinforcements:set_skippable(false);

function play_cutscene_modryn_reinforcements()

--Make waystone buildings invulnerable
	set_waystone_buildings_invulnerable(true)
--Turn Invincibility On and Morale Losses Off
--Player + Allies
	ga_drycha.sunits:invincible_if_standing(true)
	ga_reinforcements_anmyr.sunits:invincible_if_standing(false)
	ga_reinforcements_modryn.sunits:invincible_if_standing(false)
	ga_reinforcements_coeddil.sunits:invincible_if_standing(true)
	ga_reinforcements_coeddil_2.sunits:invincible_if_standing(true)
	ga_reinforcements_anmyr_fly.sunits:invincible_if_standing(false)
	ga_reinforcements_modryn_fly.sunits:invincible_if_standing(false)

	cutscene_modryn_reinforcements:action(function() gb.sm:trigger_message("spawn_modryn") end, 0);
	cutscene_modryn_reinforcements:action(function() cam:move_to(v(225.2,107.6,-231.2),v(340.9,-174.7,50.5), 2, false, 50) end, 0);
	cutscene_modryn_reinforcements:action(function() cam:move_to(v(300.972,109.994,-211.838),v(101.354,-201.505,-23.276), 5, false, 50) end, 2000);
		
	cutscene_modryn_reinforcements:action(
		function()
			cam:fade(true, 1);
		end,
		8000
	);
	cutscene_modryn_reinforcements:action(
		function()
			cam:fade(false, 1);
			cam:move_to(v(303.352,74.993,-203.453),v(341.799,74.587,-137.875), 0, false, 50);
			cam:move_to(v(355.091553,45.609287,-128.947464),v(753.831299,17.678942,-241.400299), 10, false, 30);
		end,
		10000
	);

	cutscene_modryn_reinforcements:action(
		function()
			cam:fade(true, 1);
		end,
		22000
	);

	cutscene_modryn_reinforcements:action(
		function()
			ga_reinforcements_modryn:halt()
			ga_reinforcements_modryn_fly:halt()
			ga_reinforcements_modryn.sunits:item(1).uc:teleport_to_location(v(305.63, -159.49), 270, 4);
			ga_reinforcements_modryn.sunits:item(2).uc:teleport_to_location(v(322.90, -177.92), 270, 17);
			ga_reinforcements_modryn.sunits:item(3).uc:teleport_to_location(v(322.23, -158.33), 270, 17);
			ga_reinforcements_modryn.sunits:item(4).uc:teleport_to_location(v(321.57, -138.74), 270, 17);
			ga_reinforcements_modryn.sunits:item(5).uc:teleport_to_location(v(354.56, -170.34), 270, 17);
			ga_reinforcements_modryn.sunits:item(6).uc:teleport_to_location(v(352.96, -141.33), 270, 17);
			ga_reinforcements_modryn.sunits:item(7).uc:teleport_to_location(v(313.45, -149.06), 270, 4);
			ga_reinforcements_modryn.sunits:item(8).uc:teleport_to_location(v(313.26, -170.31), 270, 4);
			ga_reinforcements_modryn_fly.sunits:item(1).uc:teleport_to_location(v(333.62, -178.70), 270, 17);
			ga_reinforcements_modryn_fly.sunits:item(2).uc:teleport_to_location(v(332.19, -158.75), 270, 17);
			ga_reinforcements_modryn_fly.sunits:item(3).uc:teleport_to_location(v(330.76, -138.81), 270, 17);
		end,
		24000
	);

	cutscene_modryn_reinforcements:action(
		function()
			cam:fade(false, 1);
			cam:move_to(v(225.2,107.6,-231.2),v(340.9,-174.7,50.5), 0, true, 50);
		end,
		24500
	);

	cutscene_modryn_reinforcements:action(function() cutscene_modryn_reinforcements:play_sound(wh2_drycha_igc01_sfx_01) end, 1000);
	cutscene_modryn_reinforcements:action(function() cutscene_modryn_reinforcements:play_sound(wh2_drycha_igc01_sfx_02) end, 3500);
	cutscene_modryn_reinforcements:action(function() cutscene_modryn_reinforcements:play_sound(wh2_drycha_igc01_sfx_03) end, 11000);
	cutscene_modryn_reinforcements:action(function() cutscene_modryn_reinforcements:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc16_Drycha_Coeddil_Unchained_IGC01_01", "subtitle_with_frame", 0.1) end, 1000);	
	cutscene_modryn_reinforcements:action(function() cutscene_modryn_reinforcements:hide_custom_cutscene_subtitles() end, 8000);
	cutscene_modryn_reinforcements:action(function() cutscene_modryn_reinforcements:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc16_Drycha_Coeddil_Unchained_IGC01_02", "subtitle_with_frame", 0.1) end, 11000);
	cutscene_modryn_reinforcements:action(function() cutscene_modryn_reinforcements:hide_custom_cutscene_subtitles() end, 22000);

	enqueue_cutscene(cutscene_modryn_reinforcements);
end;
function cutscene_modryn_reinforcements_end()

--Make waystone buildings vulnerable again
	set_waystone_buildings_invulnerable(false)
--Turn Invincibility Off
--Player + Allies
	ga_drycha.sunits:set_invincible(false)
	ga_reinforcements_anmyr.sunits:set_invincible(false)
	ga_reinforcements_modryn.sunits:set_invincible(false)
	ga_reinforcements_coeddil.sunits:set_invincible(false)
	ga_reinforcements_coeddil_2.sunits:set_invincible(false)
	ga_reinforcements_anmyr_fly.sunits:set_invincible(false)
	ga_reinforcements_modryn_fly.sunits:set_invincible(false)

--Turn Morale Losses Back On
--Player + Allies
	ga_drycha.sunits:morale_behavior_default_if_standing(true)
	ga_reinforcements_anmyr.sunits:morale_behavior_default_if_standing(true)
	ga_reinforcements_modryn.sunits:morale_behavior_default_if_standing(true)
	ga_reinforcements_coeddil.sunits:morale_behavior_default_if_standing(true)
	ga_reinforcements_coeddil_2.sunits:morale_behavior_default_if_standing(true)
	ga_reinforcements_anmyr_fly.sunits:morale_behavior_default_if_standing(true)
	ga_reinforcements_modryn_fly.sunits:morale_behavior_default_if_standing(true)

	gb.sm:trigger_message("cutscene_modryn_reinforcements_end")
end;

-------------------------------------------------------------------------------------------------
----------------------------- CUTSCENE 2 - WAYSTONE WEST DESTROYED ------------------------------
-------------------------------------------------------------------------------------------------

cutscene_anmyr_reinforcements = cutscene:new(
	"cutscene_anmyr_reinforcements", 					-- unique string name for cutscene
	ga_drycha.sunits, 									-- unitcontroller over player's army
	25000,												-- duration of cutscene in ms
	function() 
		cutscene_anmyr_reinforcements_end() 
		check_cutscene_queue()
	end	-- what to call when cutscene is finished
);

cutscene_anmyr_reinforcements:set_restore_cam(2, v(-250,104,-355.9),v(-458.9,-177.4,-133.4), 2);
cutscene_anmyr_reinforcements:set_close_advisor_on_end(false);
cutscene_anmyr_reinforcements:set_post_cutscene_fade_time(0);
cutscene_anmyr_reinforcements:set_should_disable_unit_ids(true);
cutscene_anmyr_reinforcements:set_should_enable_cinematic_camera(false);
cutscene_anmyr_reinforcements:set_skippable(false);

function play_cutscene_anmyr_reinforcements()

--Make waystone buildings invulnerable
	set_waystone_buildings_invulnerable(true)
--Turn Invincibility On and Morale Losses Off
--Player + Allies
	ga_drycha.sunits:invincible_if_standing(true)
	ga_reinforcements_anmyr.sunits:invincible_if_standing(false)
	ga_reinforcements_modryn.sunits:invincible_if_standing(false)
	ga_reinforcements_coeddil.sunits:invincible_if_standing(true)
	ga_reinforcements_coeddil_2.sunits:invincible_if_standing(true)
	ga_reinforcements_anmyr_fly.sunits:invincible_if_standing(false)
	ga_reinforcements_modryn_fly.sunits:invincible_if_standing(false)

	cutscene_anmyr_reinforcements:action(function() gb.sm:trigger_message("spawn_anmyr") end, 0);
	cutscene_anmyr_reinforcements:action(function() cam:move_to(v(-250,104,-355.9),v(-458.9,-177.4,-133.4), 2, false, 50) end, 0);
	cutscene_anmyr_reinforcements:action(function() cam:move_to(v(-245.967,104.589,-265.657),v(-472.728,-176.810,-469.922), 5, false, 50) end, 2000);
		
	cutscene_anmyr_reinforcements:action(
		function()
			cam:fade(true, 1);
		end,
		8000
	);
	cutscene_anmyr_reinforcements:action(
		function()
			ga_reinforcements_anmyr.sunits:item(1).uc:teleport_to_location(v(-458.34, -468.80), 57, 2);
			cam:fade(false, 1);
			cam:move_to(v(-296.292,95.354,-334.154),v(-579.084,-94.480,-571.465), 0, false, 50);
			cam:move_to(v(-412.781,40.993,-430.409),v(-742.94,10.789,-677.779), 10, false, 30);
		end,
		10000
	);

	cutscene_anmyr_reinforcements:action(
		function()
			cam:fade(true, 1);
		end,
		22000
	);

	cutscene_anmyr_reinforcements:action(
		function()
			ga_reinforcements_anmyr:halt()
			ga_reinforcements_anmyr_fly:halt()
			ga_reinforcements_anmyr.sunits:item(1).uc:teleport_to_location(v(-316.66, -346.52), 41, 2);
			ga_reinforcements_anmyr.sunits:item(2).uc:teleport_to_location(v(-361.03, -332.14), 41, 23);
			ga_reinforcements_anmyr.sunits:item(3).uc:teleport_to_location(v(-341.42, -349.74), 41, 23);
			ga_reinforcements_anmyr.sunits:item(4).uc:teleport_to_location(v(-322.82, -366.44), 41, 23);
			ga_reinforcements_anmyr.sunits:item(5).uc:teleport_to_location(v(-304.21, -383.14), 41, 23);
			ga_reinforcements_anmyr.sunits:item(6).uc:teleport_to_location(v(-373.61, -365.30), 41, 20);
			ga_reinforcements_anmyr.sunits:item(7).uc:teleport_to_location(v(-355.22, -380.72), 41, 20);
			ga_reinforcements_anmyr.sunits:item(8).uc:teleport_to_location(v(-336.83, -396.14), 41, 20);
			ga_reinforcements_anmyr_fly.sunits:item(1).uc:teleport_to_location(v(-358.42, -347.51), 41, 25);
			ga_reinforcements_anmyr_fly.sunits:item(2).uc:teleport_to_location(v(-337.89, -366.55), 41, 25);
			ga_reinforcements_anmyr_fly.sunits:item(3).uc:teleport_to_location(v(-317.35, -385.59), 41, 25);
		end,
		24000
	);

	cutscene_anmyr_reinforcements:action(
		function()
			cam:fade(false, 1);
			cam:move_to(v(-250,104,-355.9),v(-458.9,-177.4,-133.4), 0, true, 50);
		end,
		24500
	);

	cutscene_anmyr_reinforcements:action(function() cutscene_anmyr_reinforcements:play_sound(wh2_drycha_igc02_sfx_01) end, 1000);
	cutscene_anmyr_reinforcements:action(function() cutscene_anmyr_reinforcements:play_sound(wh2_drycha_igc02_sfx_02) end, 3000);
	cutscene_anmyr_reinforcements:action(function() cutscene_anmyr_reinforcements:play_sound(wh2_drycha_igc02_sfx_03) end, 11000);
	cutscene_anmyr_reinforcements:action(function() cutscene_anmyr_reinforcements:play_sound(wh2_drycha_igc02_sfx_04) end, 14000);
	cutscene_anmyr_reinforcements:action(function() cutscene_anmyr_reinforcements:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc16_Drycha_Coeddil_Unchained_IGC02_01", "subtitle_with_frame", 0.1) end, 1000);	
	cutscene_anmyr_reinforcements:action(function() cutscene_anmyr_reinforcements:hide_custom_cutscene_subtitles() end, 8000);
	cutscene_anmyr_reinforcements:action(function() cutscene_anmyr_reinforcements:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc16_Drycha_Coeddil_Unchained_IGC02_02", "subtitle_with_frame", 0.1) end, 11000);
	cutscene_anmyr_reinforcements:action(function() cutscene_anmyr_reinforcements:hide_custom_cutscene_subtitles() end, 22000);


	enqueue_cutscene(cutscene_anmyr_reinforcements);
end;
function cutscene_anmyr_reinforcements_end()

--Make waystone buildings vulnerable again
	set_waystone_buildings_invulnerable(false)
--Turn Invincibility Off
--Player + Allies
	ga_drycha.sunits:set_invincible(false)
	ga_reinforcements_anmyr.sunits:set_invincible(false)
	ga_reinforcements_modryn.sunits:set_invincible(false)
	ga_reinforcements_coeddil.sunits:set_invincible(false)
	ga_reinforcements_coeddil_2.sunits:set_invincible(false)
	ga_reinforcements_anmyr_fly.sunits:set_invincible(false)
	ga_reinforcements_modryn_fly.sunits:set_invincible(false)

--Turn Morale Losses Back On
--Player + Allies
	ga_drycha.sunits:morale_behavior_default_if_standing(true)
	ga_reinforcements_anmyr.sunits:morale_behavior_default_if_standing(true)
	ga_reinforcements_modryn.sunits:morale_behavior_default_if_standing(true)
	ga_reinforcements_coeddil.sunits:morale_behavior_default_if_standing(true)
	ga_reinforcements_coeddil_2.sunits:morale_behavior_default_if_standing(true)
	ga_reinforcements_anmyr_fly.sunits:morale_behavior_default_if_standing(true)
	ga_reinforcements_modryn_fly.sunits:morale_behavior_default_if_standing(true)

	gb.sm:trigger_message("cutscene_anmyr_reinforcements_end")
end;

-------------------------------------------------------------------------------------------------
-------------------------------- CUTSCENE 3 - COEDDIL UNCHAINED ---------------------------------
-------------------------------------------------------------------------------------------------

cutscene_coeddil_unchained = cutscene:new(
	"cutscene_coeddil_unchained", 					-- unique string name for cutscene
	ga_drycha.sunits, 									-- unitcontroller over player's army
	33000,												-- duration of cutscene in ms
	function() 
		cutscene_coeddil_unchained_end()
		check_cutscene_queue()
	end	-- what to call when cutscene is finished
);

cutscene_coeddil_unchained:set_restore_cam(2, v(28.440529,155.72699,286.913818),v(-22.908581,94.146317,338.341248), 2);
cutscene_coeddil_unchained:set_close_advisor_on_end(false);
cutscene_coeddil_unchained:set_post_cutscene_fade_time(0);
cutscene_coeddil_unchained:set_should_disable_unit_ids(true);
cutscene_coeddil_unchained:set_should_enable_cinematic_camera(false);
cutscene_coeddil_unchained:set_skippable(false);

function play_cutscene_coeddil_unchained()

--Make waystone buildings invulnerable
	set_waystone_buildings_invulnerable(true)
--Turn Invincibility On and Morale Losses Off
--Player + Allies
	ga_drycha.sunits:invincible_if_standing(true)
	ga_reinforcements_anmyr.sunits:invincible_if_standing(false)
	ga_reinforcements_modryn.sunits:invincible_if_standing(false)
	ga_reinforcements_coeddil.sunits:invincible_if_standing(true)
	ga_reinforcements_coeddil_2.sunits:invincible_if_standing(true)
	ga_reinforcements_anmyr_fly.sunits:invincible_if_standing(false)
	ga_reinforcements_modryn_fly.sunits:invincible_if_standing(false)

	cutscene_coeddil_unchained:action(function() cam:move_to(v(-211.97728,113.463394,326.158112),v(-154.433975,68.543488,387.350555), 2, false, 50) end, 0);
	cutscene_coeddil_unchained:action(function() cam:move_to(v(-60.408909,132.255707,212.63208),v(-63.517624,104.509293,303.701721), 3, false, 50) end, 2000);
	cutscene_coeddil_unchained:action(function() cam:move_to(v(96.867462,110.201157,321.393677),v(31.904831,76.4366,382.33667), 3, false, 50) end, 4500);
		
	cutscene_coeddil_unchained:action(
		function()
			cam:fade(true, 1);
		end,
		8000
	);

	cutscene_coeddil_unchained:action(function() gb.sm:trigger_message("spawn_coeddil") end, 8500);

	cutscene_coeddil_unchained:action(
		function()
			cam:fade(false, 1);
			cam:move_to(v(3.42758,66.290192,378.023834),v(-43.123981,83.438362,459.338715), 0, false, 50);
			--cam:move_to(v(-108.060242,79.894379,331.789917),v(-72.148041,43.784306,412.288086), 0, false, 50);
			cam:move_to(v(-48.290253,57.691185,421.270386),v(-49.003139,60,516.516113), 8, false, 30);
		end,
		9000
	);

	cutscene_coeddil_unchained:action(
		function()
			cam:fade(true, 1);
		end,
		19500
	);
--Coeddil Snap 1
	cutscene_coeddil_unchained:action(
		function()
			ga_reinforcements_coeddil.sunits:item(1).uc:teleport_to_location(v(-60.65, 449.17), 180, 4);
			cam:fade(false, 0.5);
			cam:move_to(v(-64.352989,57.26046,440.832916),v(52.099457,96.673294,686.620056), 0, false, 50)
		end,
		20500
	);
--Coeddil Snap 2
	cutscene_coeddil_unchained:action(
		function()
			cam:move_to(v(-55.810925,56.585915,443.272125),v(-115.144974,83.354088,512.817444), 0, false, 50)
			--cam:move_to(v(-53.783543,58.940182,441.569946),v(-116.406174,54.200047,514.12616), 0, false, 50)
		end,
		23500
	);
--Coeddil Snap 3
	cutscene_coeddil_unchained:action(
		function()
			cam:move_to(v(-58.354626,64.578751,416.414215),v(-63.468315,38.168495,508.526398), 0, false, 50)
			cam:move_to(v(-60.441322,59.5,444.490265),v(-67.123779,57.593697,540.186401), 2, false, 45)
		end,
		26500
	);	

	cutscene_coeddil_unchained:action(
		function()
			cam:fade(true, 1);
		end,
		30500
	);

	cutscene_coeddil_unchained:action(
		function()
			cam:fade(false, 1);
			cam:move_to(v(28.440529,155.72699,286.913818),v(-22.908581,94.146317,338.341248), 0, true, 50);
		end,
		32000
	);

	cutscene_coeddil_unchained:action(function() cutscene_coeddil_unchained:play_sound(wh2_drycha_igc03_sfx_01) end, 1000);
	cutscene_coeddil_unchained:action(function() cutscene_coeddil_unchained:play_sound(wh2_drycha_igc03_sfx_02) end, 4000);
	cutscene_coeddil_unchained:action(function() cutscene_coeddil_unchained:play_sound(wh2_main_sfx_04) end, 9000);
	cutscene_coeddil_unchained:action(function() cutscene_coeddil_unchained:play_sound(wh2_drycha_igc03_sfx_03) end, 16500);
	cutscene_coeddil_unchained:action(function() cutscene_coeddil_unchained:play_sound(wh2_drycha_igc03_sfx_04) end, 20500);
	cutscene_coeddil_unchained:action(function() cutscene_coeddil_unchained:play_sound(wh2_drycha_igc03_sfx_05) end, 23500);
	cutscene_coeddil_unchained:action(function() cutscene_coeddil_unchained:play_sound(wh2_drycha_igc03_sfx_06) end, 26500);
	cutscene_coeddil_unchained:action(function() cutscene_coeddil_unchained:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc16_Drycha_Coeddil_Unchained_IGC03_01", "subtitle_with_frame", 0.1) end, 1000);	
	cutscene_coeddil_unchained:action(function() cutscene_coeddil_unchained:hide_custom_cutscene_subtitles() end, 9000);
	cutscene_coeddil_unchained:action(function() cutscene_coeddil_unchained:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc16_Drycha_Coeddil_Unchained_IGC03_02", "subtitle_with_frame", 0.1) end, 9000);
	cutscene_coeddil_unchained:action(function() cutscene_coeddil_unchained:hide_custom_cutscene_subtitles() end, 20000);
	cutscene_coeddil_unchained:action(function() cutscene_coeddil_unchained:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc16_Drycha_Coeddil_Unchained_IGC03_03", "subtitle_with_frame", 0.1) end, 20500);
	cutscene_coeddil_unchained:action(function() cutscene_coeddil_unchained:hide_custom_cutscene_subtitles() end, 23000);
	cutscene_coeddil_unchained:action(function() cutscene_coeddil_unchained:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc16_Drycha_Coeddil_Unchained_IGC03_04", "subtitle_with_frame", 0.1) end, 23500);
	cutscene_coeddil_unchained:action(function() cutscene_coeddil_unchained:hide_custom_cutscene_subtitles() end, 26000);
	cutscene_coeddil_unchained:action(function() cutscene_coeddil_unchained:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc16_Drycha_Coeddil_Unchained_IGC03_05", "subtitle_with_frame", 0.1) end, 26500);
	cutscene_coeddil_unchained:action(function() cutscene_coeddil_unchained:hide_custom_cutscene_subtitles() end, 30000);

	enqueue_cutscene(cutscene_coeddil_unchained);
end;
function cutscene_coeddil_unchained_end()

--Make waystone buildings vulnerable again
	set_waystone_buildings_invulnerable(false)
--Turn Invincibility Off
--Player + Allies
	ga_drycha.sunits:set_invincible(false)
	ga_reinforcements_anmyr.sunits:set_invincible(false)
	ga_reinforcements_modryn.sunits:set_invincible(false)
	ga_reinforcements_coeddil.sunits:set_invincible(false)
	ga_reinforcements_coeddil_2.sunits:set_invincible(false)
	ga_reinforcements_anmyr_fly.sunits:set_invincible(false)
	ga_reinforcements_modryn_fly.sunits:set_invincible(false)

--Turn Morale Losses Back On
--Player + Allies
	ga_drycha.sunits:morale_behavior_default_if_standing(true)
	ga_reinforcements_anmyr.sunits:morale_behavior_default_if_standing(true)
	ga_reinforcements_modryn.sunits:morale_behavior_default_if_standing(true)
	ga_reinforcements_coeddil.sunits:morale_behavior_default_if_standing(true)
	ga_reinforcements_coeddil_2.sunits:morale_behavior_default_if_standing(true)
	ga_reinforcements_anmyr_fly.sunits:morale_behavior_default_if_standing(true)
	ga_reinforcements_modryn_fly.sunits:morale_behavior_default_if_standing(true)

	gb.sm:trigger_message("cutscene_coeddil_unchained_end")
end;

-------------------------------------------------------------------------------------------------
--------------------------------------- CUTSCENE TRIGGERS ---------------------------------------
-------------------------------------------------------------------------------------------------

-- Trigger Cutscene 1 (This is Cutscene 1, even though it's in response to Waystone 2's destruction)
gb:message_on_time_offset("trigger_modryn_cutscene", 0, "waystone_2_destroyed")
gb:add_listener("trigger_modryn_cutscene", function() play_cutscene_modryn_reinforcements() end);

-- Trigger Cutscene 2 (This is Cutscene 2, even though it's in response to Waystone 1's destruction)
gb:message_on_time_offset("trigger_anmyr_cutscene", 0, "waystone_1_destroyed")
gb:add_listener("trigger_anmyr_cutscene", function() play_cutscene_anmyr_reinforcements() end);

-- Trigger Cutscene 3 (Big Bad Coeddil comin'!)
gb:message_on_time_offset("trigger_coeddil_cutscene", 0, "coeddil_unchained")
gb:add_listener("trigger_coeddil_cutscene", function() play_cutscene_coeddil_unchained() end);

--Debug Triggers for Cutscenes
--gb:message_on_time_offset("trigger_modryn_cutscene", 2000, "01_intro_cutscene_end")
--gb:message_on_time_offset("trigger_anmyr_cutscene", 2000, "01_intro_cutscene_end")
--gb:message_on_time_offset("trigger_coeddil_cutscene", 2000, "01_intro_cutscene_end")