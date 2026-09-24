-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- The Glottkin
-- By Matthieu Bonnet-Mille
-- Final Battle: The Fall of Altdorf

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries()

-- bm:camera():fade(true, 0);

gb = generated_battle:new(
	false,                                      		-- screen starts black
	true,                                      		    -- prevent deployment for player
	true,                                      			-- prevent deployment for ai
	function() end_deployment_phase() end,          	-- intro cutscene function
	false                                      			-- debug mode
)

gb:set_cutscene_during_deployment(true)

	
-------------------------------------------------------------------------------------------------
------------------------------------------- PHASE 1 CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Cutscene SFX here
local sfx_cutscene_sweetener_intro_play = new_sfx("Play_Movie_WH3_DLC29_FB_Glottkin_Intro", true, false)
local sfx_cutscene_sweetener_intro_stop = new_sfx("Stop_Movie_WH3_DLC29_FB_Glottkin_Intro", false, false)
local sfx_cutscene_sweetener_mid_play = new_sfx("Play_Movie_WH3_DLC29_FB_Glottkin_Mid", true, false)
local sfx_cutscene_sweetener_mid_stop = new_sfx("Stop_Movie_WH3_DLC29_FB_Glottkin_Mid", false, false)

function end_deployment_phase()
	bm:out("\tend_deployment_phase() called")

	local cam = bm:camera();

	-- cutscene 1 phase 1
	local cutscene_intro = cutscene:new_from_cindyscene(
		"cutscene_intro", 																-- unique string name for cutscene
		ga_player.sunits,																-- unitcontroller over player's army
		function() intro_cutscene_end() end,											-- what to call when cutscene is finished
		"script/battle/quest_battles/_cutscene/managers/wh3_glottkin_fb_altdorf_intro_01.CindySceneManager",	-- path to cindyscene
		0,																				-- blend in time (s)
		0																				-- blend out time (s)
	);

	-- set up subtitles
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();

	-- skip callback
	cutscene_intro:set_skippable(
		true, 
		function()
			local cam = bm:camera();
			bm:stop_cindy_playback(true);
			cam:fade(true, 0);

			bm:callback(function() cam:fade(false, 0.2) end, 500);
			bm:hide_subtitles();
		end
	);

	-- ----------------------------- ACTIONS
	cutscene_intro:action(function() cam:fade(false, 1) end, 500);

	cutscene_intro:action(
		function() 	
			ga_player.sunits:item(1):set_invisible_to_all(true);
			ga_ai_reikland_main.sunits:set_always_visible_no_hidden_no_leave_battle(true);
			ga_ai_dwf_main.sunits:set_always_visible_no_hidden_no_leave_battle(true);
			ga_ai_reikland_stragglers.sunits:set_always_visible_no_hidden_no_leave_battle(true);
		end, 
		10
	);
	
	-- add listeners for sound & subs here
	cutscene_intro:action(function() cutscene_intro:play_sound(sfx_cutscene_sweetener_intro_play) end, 0);

	------------------------------
	
	-- Listeners here
	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc29_chs_glottkin_fall_of_altdorf_01", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_chs_glottkin_fall_of_altdorf_01"))
				bm:show_subtitle("wh3_dlc29_qb_chs_glottkin_fall_of_altdorf_intro_01", false, true)
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc29_chs_glottkin_fall_of_altdorf_02", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_chs_glottkin_fall_of_altdorf_02"))
				bm:show_subtitle("wh3_dlc29_qb_chs_glottkin_fall_of_altdorf_intro_02", false, true)
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc29_chs_glottkin_fall_of_altdorf_03", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_chs_glottkin_fall_of_altdorf_03"))
				bm:show_subtitle("wh3_dlc29_qb_chs_glottkin_fall_of_altdorf_intro_03", false, true)
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc29_chs_glottkin_fall_of_altdorf_04", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_chs_glottkin_fall_of_altdorf_04"))
				bm:show_subtitle("wh3_dlc29_qb_chs_glottkin_fall_of_altdorf_intro_04", false, true)
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc29_chs_glottkin_fall_of_altdorf_05", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_chs_glottkin_fall_of_altdorf_05"))
				bm:show_subtitle("wh3_dlc29_qb_chs_glottkin_fall_of_altdorf_intro_05", false, true)
			end
	);

	--------

	cutscene_intro:start();
end

function intro_cutscene_end()
	play_sound_2D(sfx_cutscene_sweetener_intro_stop)
	ga_player.sunits:item(1):set_invisible_to_all(false);
	ga_player.sunits:item(1):release_control();
	gb.sm:trigger_message("cutscene_intro_end")
	bm:hide_subtitles()
end;

-------------------------------------------------------------------------------------------------
----------------------------------------- PHASE 2 CUTSCENE ------------------------------------------
-------------------------------------------------------------------------------------------------

function play_phase_2_cutscene()
	-- bm:camera():fade(true, 0)
	bm:out("\tplay_phase_2_cutscene() called")

	local cam = bm:camera()

	local cutscene_phase_2 = cutscene:new_from_cindyscene(
		"cutscene_phase_2", 																				-- unique string name for cutscene
		ga_player.sunits,																				-- unitcontroller over player's army
		function() mid_cutscene_end() end,																-- what to call when cutscene is finished
		"script/battle/quest_battles/_cutscene/managers/wh3_glottkin_fb_altdorf_mid_01.CindySceneManager",		-- path to cindyscene
		0,																								-- blend in time (s)
		1																								-- blend out time (s)
	);

	-- set up subtitles
	local subtitles = cutscene_phase_2:subtitles()
	subtitles:set_alignment("bottom_centre")
	subtitles:clear()

	-- skip callback
	cutscene_phase_2:set_skippable(
		true, 
		function()
			local cam = bm:camera();
			bm:stop_cindy_playback(true);
			cam:fade(true, 0);

			bm:callback(function() cam:fade(false, 0.2) end, 500);
			bm:hide_subtitles();
		end
	);

	cutscene_phase_2:action(
		function() 	
			ga_player.sunits:item(1):set_invisible_to_all(true);
		end, 
		10
	);

	cutscene_phase_2:action(
		function()
			-- Vlad shows up
			sm:trigger_message("enable_zombies")
		end, 
	40000 -- time at which the action triggers
	);

	-- add listeners for sound & subs here
	cutscene_phase_2:action(function() cutscene_phase_2:play_sound(sfx_cutscene_sweetener_mid_play) end, 0);
	
	cutscene_phase_2:add_cinematic_trigger_listener(
	"Play_wh3_dlc29_chs_glottkin_fall_of_altdorf_mid_01", 
		function()
			cutscene_phase_2:play_sound(new_sfx("Play_wh3_dlc29_chs_glottkin_fall_of_altdorf_mid_01"))
			bm:show_subtitle("wh3_dlc29_qb_chs_glottkin_fall_of_altdorf_mid_01", false, true)
		end
	);

	cutscene_phase_2:add_cinematic_trigger_listener(
	"Play_wh3_dlc29_chs_glottkin_fall_of_altdorf_mid_02", 
		function()
			cutscene_phase_2:play_sound(new_sfx("Play_wh3_dlc29_chs_glottkin_fall_of_altdorf_mid_02"))
			bm:show_subtitle("wh3_dlc29_qb_chs_glottkin_fall_of_altdorf_mid_02", false, true)
		end
	);

	cutscene_phase_2:add_cinematic_trigger_listener(
	"Play_wh3_dlc29_chs_glottkin_fall_of_altdorf_mid_03", 
		function()
			cutscene_phase_2:play_sound(new_sfx("Play_wh3_dlc29_chs_glottkin_fall_of_altdorf_mid_03"))
			bm:show_subtitle("wh3_dlc29_qb_chs_glottkin_fall_of_altdorf_mid_03", false, true)
		end
	);
	-- -- Remove and put after cutscene
	-- cutscene_phase_2:add_cinematic_trigger_listener(
	-- "Play_wh3_dlc29_chs_glottkin_fall_of_altdorf_mid_04", 
	-- 	function()
	-- 		cutscene_phase_2:play_sound(new_sfx("Play_wh3_dlc29_chs_glottkin_fall_of_altdorf_mid_04"))
	-- 		bm:show_subtitle("wh3_dlc29_qb_chs_glottkin_fall_of_altdorf_after_mid_01", false, true)
	-- 	end
	-- );
	-- -- Remove and put after cutscene
	-- cutscene_phase_2:add_cinematic_trigger_listener(
	-- "Play_wh3_dlc29_chs_glottkin_fall_of_altdorf_mid_05", 
	-- 	function()
	-- 		cutscene_phase_2:play_sound(new_sfx("Play_wh3_dlc29_chs_glottkin_fall_of_altdorf_mid_05"))
	-- 		bm:show_subtitle("wh3_dlc29_qb_chs_glottkin_fall_of_altdorf_after_mid_02", false, true)
	-- 	end
	-- );

	------

	cutscene_phase_2:start();
end

function mid_cutscene_end()
	play_sound_2D(sfx_cutscene_sweetener_mid_stop)
	ga_player.sunits:item(1):set_invisible_to_all(false);
	ga_player.sunits:item(1):release_control();
	sm:trigger_message("enable_zombies")
	sm:trigger_message("phase_3_start")
	bm:hide_subtitles()
end;

-------------------------------------------------------------------------------------------------
------------------------------------------ LOCAL SETUP ------------------------------------------
-------------------------------------------------------------------------------------------------

local perpetual = true;
local shattered_only = false;
local permit_rampaging = true;

-- Reinforcement speeds
local speed_01 = 120000;
if bm:is_from_campaign() then
	speed_01 = 60000;
end

local sm = script_messager:new();

---------------------------------------
-----------CAMPAIGN EVENTS-------------
---------------------------------------

local cam_prevent_reinforcements = tonumber(core:svr_load_registry_string("enemy_cannot_reinforce_in_final_battle"))
local cam_enable_daemon_reins = tonumber(core:svr_load_registry_string("additional_daemonic_reinforce_in_final_battle"))
local cam_damage_army = tonumber(core:svr_load_registry_string("weaken_empire_forces_in_final_battle"))

bm:out("\n ========= prevent reins: " .. tostring(cam_prevent_reinforcements))
bm:out("\n ========= daemon reins: " .. tostring(cam_enable_daemon_reins))
bm:out("\n ========= damage army: " .. tostring(cam_damage_army))

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player = gb:get_army(gb:get_player_alliance_num())

-- THE EMPIRE
ga_ai_reikland_main = gb:get_army(gb:get_non_player_alliance_num(), "emp_main")
ga_ai_reikland_stragglers = gb:get_army(gb:get_non_player_alliance_num(), "emp_stragglers")
ga_ai_reikland_cannons = gb:get_army(gb:get_non_player_alliance_num(), "emp_cannons")
ga_ai_reikland_rein_1_endless = gb:get_army(gb:get_non_player_alliance_num(), "emp_endless")
ga_ai_reikland_rein_2 = gb:get_army(gb:get_non_player_alliance_num(), "emp_rein_elite")
ga_ai_reikland_generals = gb:get_army(gb:get_non_player_alliance_num(), "emp_generals")
--objective holder
ga_ai_reikland_karl_franz = gb:get_army(gb:get_non_player_alliance_num(), "emp_karl")

-- BRETONNIA
ga_ai_brt_rein_1 = gb:get_army(gb:get_non_player_alliance_num(), "brt_rein_1")
ga_ai_brt_rein_2 = gb:get_army(gb:get_non_player_alliance_num(), "brt_rein_2")
ga_ai_brt_rein_louen = gb:get_army(gb:get_non_player_alliance_num(), "brt_rein_louen")
-- bst_bray_shaman_unit = ga_ai_bst_allies.sunits:item(1);

-- DWARFS
ga_ai_dwf_main = gb:get_army(gb:get_non_player_alliance_num(), "dwf_main")

-- VAMPIRE COUNTS
ga_ai_vmp_rein = gb:get_army(gb:get_non_player_alliance_num(), "vmp_rein")
ga_ai_vmp_rein_zombies = gb:get_army(gb:get_non_player_alliance_num(), "vmp_rein_zombies")

-- DAEMONS OF NURGLE ALLIES
ga_player_daemons_rein = gb:get_army(gb:get_player_alliance_num(), "player_daemons_rein")

-------------------------------------------------------------------------------------------------
---------------------------------------- REINFORCEMENTS -----------------------------------------
-------------------------------------------------------------------------------------------------

local reinforcements = bm:reinforcements();

-- Assign bretonnians to reinforcement zones
brt_reinforcement_1 = bm:get_spawn_zone_collection_by_name("brt_reinforcement_1");
brt_reinforcement_2 = bm:get_spawn_zone_collection_by_name("brt_reinforcement_2");
brt_reinforcement_3 = bm:get_spawn_zone_collection_by_name("brt_reinforcement_3"); -- Not used for now, louen will come from behind
ga_ai_brt_rein_1:assign_to_spawn_zone_from_collection_on_message("start", brt_reinforcement_1, false);
ga_ai_brt_rein_2:assign_to_spawn_zone_from_collection_on_message("start", brt_reinforcement_2, false);
ga_ai_brt_rein_louen:assign_to_spawn_zone_from_collection_on_message("start", brt_reinforcement_1, false);

-- Assign reikland to reinforcement zones
emp_reinforcement_1 = bm:get_spawn_zone_collection_by_name("emp_reinforcement_1");
emp_reinforcement_2 = bm:get_spawn_zone_collection_by_name("emp_reinforcement_2");
ga_ai_reikland_rein_1_endless:assign_to_spawn_zone_from_collection_on_message("start", emp_reinforcement_1, false);
ga_ai_reikland_rein_2:assign_to_spawn_zone_from_collection_on_message("start", emp_reinforcement_2, false);

-- Assign vampires to reinforcement zones
vmp_reinforcement_1 = bm:get_spawn_zone_collection_by_name("vmp_reinforcement_1"); -- not used, vlad comes from a different angle
ga_ai_vmp_rein:assign_to_spawn_zone_from_collection_on_message("start", brt_reinforcement_2, false);
-- ga_ai_vmp_rein_zombies:assign_to_spawn_zone_from_collection_on_message("start", emp_reinforcement_2, true);

-- Assign Nur allies to reinforcement zones
daemons_teleport_rein = bm:get_spawn_zone_collection_by_name("daemons_ally_teleport_rein");
ga_player_daemons_rein:assign_to_spawn_zone_from_collection_on_message("start", daemons_teleport_rein, false);

-------------------------------------------------------------------------------------------------
------------------------------------------- TELEPORT --------------------------------------------
-------------------------------------------------------------------------------------------------

--Reikland Generals fixed setup
reikland_generals_teleport_locations = {
	{x = -549, y = -171, orientation = 90.0}, -- Empire general
	{x = -549, y = -146, orientation = 90.0}, -- Arch Lector
	{x = -549, y = -196, orientation = 90.0}, -- Master Engineer
}
function battle_start_teleport_reikland_generals()
	for i=1, ga_ai_reikland_generals.sunits:count() do
		local sunit = ga_ai_reikland_generals.sunits:item(i)
		local location = v(reikland_generals_teleport_locations[i].x, reikland_generals_teleport_locations[i].y)

		sunit.uc:teleport_to_location(location, reikland_generals_teleport_locations[i].orientation, 40)
	end
	-- and place KF on top of where the emp general is
	local kf = ga_ai_reikland_karl_franz.sunits:item(1)
	local location = v(-549, -172)
	kf.uc:teleport_to_location(location, 90.0, 40)
end


--Reikland scattered troops fixed setup
reikland_stragglers_teleport_locations = {
	{x = -240, y = -80, orientation = 90.0}, -- Carroburg Greatswords
	{x = -222, y = -294, orientation = 90.0}, -- Carroburg Greatswords
	{x = -192, y = 153, orientation = -90.0}, -- Halberdiers
	{x = 28, y = 176, orientation = 90.0}, -- Spearmen (Shields)
	{x = 121, y = 292, orientation = 65.0}, -- Spearmen (Shields)
	{x = 80, y = 118, orientation = 0.0}, -- Spearmen (Shields)
	{x = 224, y = 60, orientation = 45.0}, -- Swordsmen
	{x = 276, y = -6, orientation = 90.0}, -- Swordsmen
}
function battle_start_teleport_reikland_stragglers()
	for i=1, ga_ai_reikland_stragglers.sunits:count() do
		local sunit = ga_ai_reikland_stragglers.sunits:item(i)
		local location = v(reikland_stragglers_teleport_locations[i].x, reikland_stragglers_teleport_locations[i].y)

		sunit.uc:teleport_to_location(location, reikland_stragglers_teleport_locations[i].orientation, 40)
	end
end
reikland_stragglers_teleport_locations_campaign = {
	{x = 28, y = 176, orientation = 90.0}, -- Spearmen (Shields)
	{x = 121, y = 292, orientation = 65.0}, -- Spearmen (Shields)
	{x = 80, y = 118, orientation = 0.0}, -- Spearmen (Shields)
	{x = -192, y = 153, orientation = -90.0}, -- Halberdiers
	{x = 224, y = 60, orientation = 45.0}, -- Swordsmen
	{x = 276, y = -6, orientation = 90.0}, -- Swordsmen
	{x = -240, y = -80, orientation = 90.0}, -- Carroburg Greatswords
	{x = -222, y = -294, orientation = 90.0}, -- Carroburg Greatswords
}
function battle_start_teleport_reikland_stragglers_campaign()
	for i=1, ga_ai_reikland_stragglers.sunits:count() do
		local sunit = ga_ai_reikland_stragglers.sunits:item(i)
		local location = v(reikland_stragglers_teleport_locations_campaign[i].x, reikland_stragglers_teleport_locations_campaign[i].y)

		sunit.uc:teleport_to_location(location, reikland_stragglers_teleport_locations_campaign[i].orientation, 40)
	end
end

--Reikland hidden cannons fixed setup
reikland_cannons_teleport_locations = {
	{x = -270, y = -80, orientation = 90.0}, -- Great Cannons
	{x = 20, y = -294, orientation = 0.0}, -- Great Cannons
}
function battle_start_teleport_reikland_cannons()
	for i=1, ga_ai_reikland_cannons.sunits:count() do
		local sunit = ga_ai_reikland_cannons.sunits:item(i)
		local location = v(reikland_cannons_teleport_locations[i].x, reikland_cannons_teleport_locations[i].y)

		sunit.uc:teleport_to_location(location, reikland_cannons_teleport_locations[i].orientation, 40)
	end
end


--Reikland main fixed setup
reikland_main_teleport_locations = {
	{x = 1, y = 54, orientation = 90.0}, -- Gold wizard
	{x = 111, y = 53, orientation = -90.0}, -- Greatswords
	{x = 50, y = 53, orientation = 30.0}, -- Greatswords
	{x = -34, y = 88, orientation = 180.0}, -- Greatswords
	{x = 101, y = -2, orientation = 90.0}, -- Halberdiers
	{x = 80, y = 66, orientation = 0.0}, -- Halberdiers
	{x = -55, y = 54, orientation = -90.0}, -- Halberdiers
	{x = 76, y = 19, orientation = 90.0}, -- Halberdiers
	{x = 83, y = -41, orientation = 0.0}, -- Nuln Ironsides
	{x = 16, y = 21, orientation = 45.0}, -- Nuln Ironsides
	{x = -17, y = 16, orientation = 0.0}, -- Nuln Ironsides
	{x = 1, y = -50, orientation = 0.0}, -- Crossbowmen
	{x = -23, y = 54, orientation = -90.0}, -- Crossbowmen
	{x = -24, y = -64, orientation = 0.0}, -- Handgunners
	{x = 20, y = 51, orientation = 85.0}, -- The Emperor's Wrath
	{x = 56, y = 17, orientation = 30.0}, -- Steam Tank (Volleygun)
	{x = 2, y = -13, orientation = 0.0}, -- Celestial Hurricanum
	{x = 83, y = -116, orientation = 0.0}, -- Hellblaster Volley Gun
	{x = -47, y = -18, orientation = 45.0}, -- Hellblaster Volley Gun
	{x = 54, y = -12, orientation = 15.0}, -- Luminark of Hysh
}
function battle_start_teleport_reikland_main()
	for i=1, ga_ai_reikland_main.sunits:count() do
		local sunit = ga_ai_reikland_main.sunits:item(i)
		local location = v(reikland_main_teleport_locations[i].x, reikland_main_teleport_locations[i].y)

		sunit.uc:teleport_to_location(location, reikland_main_teleport_locations[i].orientation, 40)
	end
end


--Dwarf support troops fixed setup
dwarf_support_teleport_locations = {
	{x = 189, y = -71, orientation = 0.0}, -- Dwf Lord
	{x = 191, y = -53, orientation = 0.0}, -- Ironbreakers
	{x = 231, y = -53, orientation = 0.0}, -- Longbeards
	{x = 269, y = -53, orientation = 0.0}, -- Longbeards
	{x = 184, y = -91, orientation = 0.0}, -- Thunderers (Grudge-rakers)
	{x = 235, y = -71, orientation = -10.0}, -- Thunderers
	{x = 283, y = -80, orientation = -15.0}, -- Quarellers
	{x = 186, y = -140, orientation = 0.0}, -- Organ Guns
	{x = 186, y = -110, orientation = 0.0}, -- Organ Guns
}
function battle_start_teleport_dwarf_support()
	for i=1, ga_ai_dwf_main.sunits:count() do
		local sunit = ga_ai_dwf_main.sunits:item(i)
		local location = v(dwarf_support_teleport_locations[i].x, dwarf_support_teleport_locations[i].y)

		sunit.uc:teleport_to_location(location, dwarf_support_teleport_locations[i].orientation, 40)
	end
end


--Player troops fixed setup
player_units_teleport_locations = {
	{x = 300, y = 207, orientation = -90.0}, -- Glottkin
	{x = 229, y = 293, orientation = -90.0}, -- Bloab
	{x = 296, y = 147, orientation = -90.0}, -- Orghotts
	{x = 308, y = 145, orientation = -90.0}, -- Morbidex
	{x = 281, y = 203, orientation = -130.0}, -- Gutrot
	{x = 270, y = 209, orientation = -90.0}, -- Blightkings
	{x = 301, y = 145, orientation = -90.0}, -- Blightkings
	{x = 349, y = 130, orientation = 180.0}, -- Blightkings
	{x = 307, y = 209, orientation = -90.0}, -- Blightkings - DW
	{x = 349, y = 145, orientation = 180.0}, -- Blightkings - DW
	{x = 240, y = 297, orientation = -90.0}, -- Blightkings - GW
	{x = 285, y = 209, orientation = -90.0}, -- Blightkings - GW
	{x = 306, y = 311, orientation = -90.0}, -- Chaos knights
	{x = 351, y = 240, orientation = 180.0}, -- Chaos knights
	{x = 216, y = 330, orientation = -90.0}, -- Basilisk
	{x = 325, y = 144, orientation = -135.0}, -- Siege Giant
	{x = 316, y = 206, orientation = -90.0}, -- Siege Giant
	{x = 236, y = 330, orientation = -90.0}, -- Dragon Ogres
	{x = 350, y = 170, orientation = 180.0}, -- Dragon Ogres
	{x = 257, y = 316, orientation = -90.0}, -- Shaggoth
}
function battle_start_teleport_player_units()
	for i=1, ga_player.sunits:count() do
		local sunit = ga_player.sunits:item(i)
		local location = v(player_units_teleport_locations[i].x, player_units_teleport_locations[i].y)

		sunit.uc:teleport_to_location(location, player_units_teleport_locations[i].orientation, 40)
	end
end


-- Mid battle zombies teleport
zombies_rein_teleport_locations = {
	{x = 90, y = 50, orientation = -140.0}, -- Zombies
	{x = 78, y = -59, orientation = -65.0}, -- Zombies
	{x = 65, y = -122, orientation = -55.0}, -- Zombies
	{x = -8, y = -106, orientation = 5.0}, -- Zombies
	{x = -93, y = -53, orientation = 85.0}, -- Zombies
	{x = -41, y = 1, orientation = 130.0}, -- Zombies
	{x = 34, y = -71, orientation = -90.0}, -- Zombies
}
function battle_start_teleport_vmp_zombies_units()
	for i=1, ga_ai_vmp_rein_zombies.sunits:count() do
		local sunit = ga_ai_vmp_rein_zombies.sunits:item(i)
		local location = v(zombies_rein_teleport_locations[i].x, zombies_rein_teleport_locations[i].y)

		sunit.uc:teleport_to_location(location, zombies_rein_teleport_locations[i].orientation, 40)
	end
end

-------------------------------------------------------------------------------------------------
----------------------------------------- BATTLE SETUP ------------------------------------------
-------------------------------------------------------------------------------------------------

--Unco if above is unco
if bm:is_from_campaign() then
	battle_start_teleport_reikland_stragglers_campaign()
else
	battle_start_teleport_reikland_stragglers()
end
battle_start_teleport_reikland_generals()
battle_start_teleport_reikland_cannons()
battle_start_teleport_reikland_main()
battle_start_teleport_dwarf_support()
battle_start_teleport_player_units()
battle_start_teleport_vmp_zombies_units()

gb:message_on_time_offset("start", 100);
-- gb:message_on_time_offset("hint_01", 500, "01_intro_cutscene_end");
gb:message_on_time_offset("objective_01", 5500, "start");
gb:message_on_time_offset("objective_02", 3500, "phase_3_start");

gb:add_listener(
    "phase_2_cutscene",
	function()
		bm:callback(
			function()
				play_phase_2_cutscene()
			end,
			2000
		)
    end
)

-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------

-- Reikland main orders
ga_ai_reikland_main:message_on_rout_proportion("phase_2_start", 0.2);
ga_ai_reikland_main:message_on_rout_proportion("reikland_main_defeated", 0.7);
-- ga_ai_reikland_main:defend_on_message("start",-258,-309,75);
ga_ai_reikland_main:message_on_proximity_to_enemy("reikland_main_counter_attack", 50); -- When the player is close to the army, they will react
ga_ai_reikland_main:rush_on_message("reikland_main_counter_attack");
ga_ai_reikland_main:prevent_rallying_if_routing_on_message("reikland_main_defeated");

-- Reikland Stragglers
ga_ai_reikland_stragglers:rush_on_message("emp_rein_2_in");
gb:add_listener(
	"start",
	function()
		ga_ai_reikland_stragglers.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_reikland_stragglers.sunits:set_always_visible_no_hidden_no_leave_battle(true);
		ga_ai_reikland_cannons.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_reikland_main.sunits:set_always_visible_no_hidden_no_leave_battle(true);
		ga_ai_dwf_main.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end
);
gb:add_listener(
	"reikland_main_defeated",
	function()
		-- Rout all but the carroburg
		ga_ai_reikland_stragglers.sunits:item(3):kill_proportion(0.01);
		ga_ai_reikland_stragglers.sunits:item(3):rout_on_casualties(1);
		ga_ai_reikland_stragglers.sunits:item(4):kill_proportion(0.01);
		ga_ai_reikland_stragglers.sunits:item(4):rout_on_casualties(1);
		ga_ai_reikland_stragglers.sunits:item(5):kill_proportion(0.01);
		ga_ai_reikland_stragglers.sunits:item(5):rout_on_casualties(1);
		ga_ai_reikland_stragglers.sunits:item(6):kill_proportion(0.01);
		ga_ai_reikland_stragglers.sunits:item(6):rout_on_casualties(1);
		ga_ai_reikland_stragglers.sunits:item(7):kill_proportion(0.01);
		ga_ai_reikland_stragglers.sunits:item(7):rout_on_casualties(1);
		ga_ai_reikland_stragglers.sunits:item(8):kill_proportion(0.01);
		ga_ai_reikland_stragglers.sunits:item(8):rout_on_casualties(1);
	end
);

-- Reikland Cannons orders
ga_ai_reikland_cannons:get_unitcontroller():fire_at_will(false);
ga_ai_reikland_cannons:message_on_proximity_to_enemy("emp_cannons_counter_attack", 100);
gb:message_on_any_message_received("activate_cannons", "phase_2_start", "emp_cannons_counter_attack");

gb:add_listener(
	"start",
	function()
		for i = 1, ga_ai_reikland_cannons.sunits:count() do
			ga_ai_reikland_cannons.sunits:item(i):set_stat_attribute("stalk", true)
		end
	end
);
gb:add_listener(
	"activate_cannons",
	function()
		for i = 1, ga_ai_reikland_cannons.sunits:count() do
			ga_ai_reikland_cannons.sunits:item(i):set_stat_attribute("stalk", false)
		end
		ga_ai_reikland_cannons:get_unitcontroller():fire_at_will(true)
	end
);


-- Reikland generals orders
ga_ai_reikland_generals:halt();
ga_ai_reikland_karl_franz:halt();
ga_ai_reikland_generals:rush_on_message("vmp_in_combat");
ga_ai_reikland_karl_franz:rush_on_message("vmp_in_combat");
ga_ai_reikland_generals:message_on_commander_dead_or_shattered("generals_routed", 0.99);
ga_ai_reikland_generals:message_on_rout_proportion("generals_routed", 0.7);
gb:add_listener(
	"objective_01",
	function()
		ga_ai_reikland_generals.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_reikland_generals.sunits:set_always_visible_no_hidden_no_leave_battle(true);
		ga_ai_reikland_karl_franz.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end
);

-- Reikland Elite orders
ga_ai_reikland_rein_2:reinforce_on_message("phase_3_start", 1000)
ga_ai_reikland_rein_2:message_on_any_deployed("emp_rein_2_in")
ga_ai_reikland_rein_2:advance_on_message("emp_rein_2_in")
ga_ai_reikland_rein_2:rush_on_message("vmp_in_combat")

-- Karaz-a-Karak orders
ga_ai_dwf_main:message_on_rout_proportion("dwarf_main_defeated", 0.7);
-- ga_ai_dwf_main:defend_on_message("start",-58,-332,50);
ga_ai_dwf_main:halt();
ga_ai_dwf_main:message_on_proximity_to_enemy("dwarf_main_counter_attack", 30);
ga_ai_dwf_main:rush_on_message("dwarf_main_counter_attack");
ga_ai_dwf_main:rush_on_message("phase_2_start");
ga_ai_dwf_main:prevent_rallying_if_routing_on_message("dwarf_main_defeated");
ga_ai_dwf_main:get_unitcontroller():fire_at_will(false)
gb:add_listener(
	"cutscene_intro_end",
	function()
		ga_ai_dwf_main:get_unitcontroller():fire_at_will(true)
	end
);

-- Karl Franz
ga_ai_reikland_karl_franz:message_on_rout_proportion("emperor_attacked", 0.10);
ga_ai_reikland_karl_franz:message_on_proximity_to_enemy("emperor_attacked", 30);
ga_ai_reikland_karl_franz:message_on_commander_dead_or_shattered("emperor_defeated", 1);
-- ga_ai_reikland_karl_franz:message_on_rout_proportion("emperor_defeated", 0.99);
-- Behaviour that triggers all phases if the player hits the emperor for 10% hp
gb:message_on_all_messages_received("phase_2_cutscene", "emperor_attacked");


-- Bretonnia orders
ga_ai_brt_rein_1:message_on_rout_proportion("brt_rein_1_defeated", 0.2);
ga_ai_brt_rein_1:reinforce_on_message("phase_2_start", 1000)
ga_ai_brt_rein_1:message_on_any_deployed("brt_rein_1_in")
ga_ai_brt_rein_1:rush_on_message("brt_rein_1_in")
ga_ai_brt_rein_1:prevent_rallying_if_routing_on_message("brt_rein_1_defeated");

ga_ai_brt_rein_2:reinforce_on_message("phase_2_start", 1000)
ga_ai_brt_rein_2:message_on_any_deployed("brt_rein_2_in")
ga_ai_brt_rein_2:rush_on_message("brt_rein_2_in")

ga_ai_brt_rein_louen:reinforce_on_message("phase_3_start", 1000)
ga_ai_brt_rein_louen:message_on_any_deployed("brt_rein_3_in")
ga_ai_reikland_rein_2:advance_on_message("brt_rein_3_in")
ga_ai_brt_rein_louen:rush_on_message("vmp_in_combat")
ga_ai_brt_rein_louen:message_on_commander_dead_or_routing("louen_defeated");

-- Vampire Count orders
-- ga_ai_vmp_rein:reinforce_on_message("phase_3_start", 1000)
function spawn_vmp_main_units()
	ga_ai_vmp_rein:deploy_at_random_intervals_on_message(
		"phase_3_start", 				-- message
		1, 							-- min units
		1, 							-- max units
		3000, 					-- min period
		3000, 					-- max period
		"stop_vmp_reins", 		-- cancel message
		true,						-- spawn first wave immediately
		false,						-- allow respawning
		nil,						-- survival battle wave index
		nil,						-- is final survival wave
		false						-- show debug output
	);
end
spawn_vmp_main_units()
ga_ai_vmp_rein:message_on_any_deployed("vmp_rein_in")
ga_ai_vmp_rein:rush_on_message("vmp_rein_in")
ga_ai_vmp_rein:message_on_proximity_to_enemy("vmp_in_combat", 30); -- When the player is close to the army, they will react
ga_ai_vmp_rein:message_on_commander_dead_or_shattered("vlad_defeated", 0.99);
ga_ai_vmp_rein:rout_over_time_on_message("vlad_defeated", 5000);
gb:add_listener(
	"start",
	function()
		ga_ai_vmp_rein.sunits:set_always_visible_no_hidden_no_leave_battle(true);
		ga_ai_brt_rein_1.sunits:set_always_visible_no_hidden_no_leave_battle(true);
		ga_ai_brt_rein_2.sunits:set_always_visible_no_hidden_no_leave_battle(true);
		ga_ai_brt_rein_louen.sunits:set_always_visible_no_hidden_no_leave_battle(true);
		ga_ai_brt_rein_louen.sunits:item(1):set_stat_attribute("unbreakable", true);
		ga_ai_reikland_rein_2.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end
);

-- Spawn zombies at vlad's arrival
ga_ai_vmp_rein_zombies.sunits:set_enabled(false);
ga_ai_vmp_rein_zombies:attack_force_on_message("phase_3_start", ga_player, 100)
gb:add_listener(
	"enable_zombies",
	function()
		ga_ai_vmp_rein_zombies.sunits:release_control();
		ga_ai_vmp_rein_zombies.sunits:set_enabled(true);
		ga_ai_vmp_rein_zombies.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end
);

-- Start phase 3
gb:message_on_all_messages_received("phase_2_cutscene", "reikland_main_defeated", "dwarf_main_defeated", "brt_rein_1_defeated"); -- When dwf and emp main armies are low health start phase 3
gb:add_listener(
	"phase_3_start",
	function()
		ga_ai_brt_rein_1.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_reikland_main.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
	end
);

-- Battle won, all generals defeated
gb:message_on_all_messages_received("all_generals_defeated", "emperor_defeated", "louen_defeated", "vlad_defeated");

----------------------------------------
--- Deploy Reikland endless reinforcements #1
----------------------------------------
function spawn_reikland_1_units_wave()
	ga_ai_reikland_rein_1_endless:deploy_at_random_intervals_on_message(
		"phase_2_start", 				-- message
		2, 							-- min units
		2, 							-- max units
		speed_01, 					-- min period
		speed_01, 					-- max period
		"emperor_defeated", 		-- cancel message
		true,						-- spawn first wave immediately
		true,						-- allow respawning
		nil,						-- survival battle wave index
		nil,						-- is final survival wave
		false						-- show debug output
	);
end
--if non bool then
if cam_prevent_reinforcements ~= 1 then spawn_reikland_1_units_wave() end
ga_ai_reikland_rein_1_endless:message_on_any_deployed("01_in")
ga_ai_reikland_rein_1_endless:rush_on_message("01_in")
ga_ai_reikland_rein_1_endless:get_army():suppress_reinforcement_adc(1);

gb:add_listener(
	"01_in",
	function()
		ga_ai_reikland_rein_1_endless.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_reikland_rein_1_endless.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end
);


-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_on_message("objective_01","wh3_dlc29_qb_chs_glottkin_war_in_the_darkwald_glottkin_alive")
gb:set_objective_with_leader_on_message("objective_01","wh3_dlc29_qb_chs_glottkin_final_battle_objective_1")
gb:set_objective_on_message("objective_01","wh3_dlc29_qb_chs_glottkin_final_battle_objective_2")
gb:set_objective_with_leader_on_message("brt_rein_1_in","wh3_dlc29_qb_chs_glottkin_final_battle_objective_3", 10000)
gb:set_objective_with_leader_on_message("objective_02","wh3_dlc29_qb_chs_glottkin_final_battle_objective_4")
gb:set_objective_with_leader_on_message("objective_02","wh3_dlc29_qb_chs_glottkin_war_in_the_darkwald_glottkin_alive")
-- gb:add_ping_icon_on_message("objective_03", shrine_capture_point:position(), 13);
-- gb:remove_ping_icon_on_message("shrine_disabled", shrine_capture_point:position());

gb:complete_objective_on_message("reikland_main_defeated", "wh3_dlc29_qb_chs_glottkin_final_battle_objective_1")
gb:complete_objective_on_message("dwarf_main_defeated", "wh3_dlc29_qb_chs_glottkin_final_battle_objective_2")
gb:complete_objective_on_message("brt_rein_1_defeated", "wh3_dlc29_qb_chs_glottkin_final_battle_objective_3")
gb:complete_objective_on_message("all_generals_defeated", "wh3_dlc29_qb_chs_glottkin_final_battle_objective_4")
gb:complete_objective_on_message("all_generals_defeated", "wh3_dlc29_qb_chs_glottkin_war_in_the_darkwald_glottkin_alive")

gb:remove_objective_on_message("phase_2_cutscene", "wh3_dlc29_qb_chs_glottkin_final_battle_objective_1", 2000)
gb:remove_objective_on_message("phase_2_cutscene", "wh3_dlc29_qb_chs_glottkin_final_battle_objective_2", 2000)
gb:remove_objective_on_message("phase_2_cutscene", "wh3_dlc29_qb_chs_glottkin_final_battle_objective_3", 2000)
gb:remove_objective_on_message("phase_2_cutscene", "wh3_dlc29_qb_chs_glottkin_war_in_the_darkwald_glottkin_alive", 2000)

local generals_count = 0
-- Add a ping on top of the generals to locate them easily
gb:add_listener(
	"objective_02",
	function()
		-- removed from the main objective
		-- ga_ai_reikland_generals.sunits:item(1):add_ping_icon(15);
		-- ga_ai_reikland_generals.sunits:item(2):add_ping_icon(15);
		-- ga_ai_reikland_generals.sunits:item(3):add_ping_icon(15);
		ga_ai_brt_rein_louen.sunits:item(1):add_ping_icon(15);
		ga_ai_vmp_rein.sunits:item(1):add_ping_icon(15);
		ga_ai_reikland_karl_franz.sunits:item(1):add_ping_icon(15);

		gen_1_dead = 0;
		gen_2_dead = 0;
		gen_3_dead = 0;
		gen_4_dead = 0;
		gen_5_dead = 0;
		gen_6_dead = 0;

		gb:add_listener(
			"louen_defeated",
			function()
				ga_ai_brt_rein_louen.sunits:item(1):remove_ping_icon();
				gen_2_dead=1;
			end
		);

		bm:set_objective("wh3_dlc29_qb_chs_glottkin_final_battle_objective_4", generals_count, 3)
        bm:repeat_callback(
            function()
                bm:set_objective("wh3_dlc29_qb_chs_glottkin_final_battle_objective_4", generals_count, 3)
                if ga_ai_reikland_karl_franz.sunits:item(1).unit:unary_hitpoints() <= 0 and gen_1_dead == 0 then
                    sm:trigger_message("emperor_defeated")
					gen_1_dead=1;
                end
				if ga_ai_brt_rein_louen.sunits:item(1).unit:unary_hitpoints() <= 0 and gen_2_dead == 0 then
                    sm:trigger_message("louen_defeated")
					gen_2_dead=1;
                end
				if ga_ai_vmp_rein.sunits:item(1).unit:unary_hitpoints() <= 0 and gen_3_dead == 0 then
                    sm:trigger_message("vlad_defeated")
					gen_3_dead=1;
                end
				-- removed from the main objective
				-- if ga_ai_reikland_generals.sunits:item(1).unit:unary_hitpoints() <= 0 and gen_4_dead == 0 then
                --     sm:trigger_message("emp_gen_dead")
				-- 	gen_4_dead=1;
                -- end
				-- if ga_ai_reikland_generals.sunits:item(2).unit:unary_hitpoints() <= 0 and gen_5_dead == 0 then
                --     sm:trigger_message("emp_gen_2_dead")
				-- 	gen_5_dead=1;
                -- end
				-- if ga_ai_reikland_generals.sunits:item(3).unit:unary_hitpoints() <= 0 and gen_6_dead == 0 then
                --     sm:trigger_message("emp_gen_3_dead")
				-- 	gen_6_dead=1;
                -- end
				generals_count = gen_1_dead + gen_2_dead + gen_3_dead + gen_4_dead + gen_5_dead + gen_6_dead;
            end,
            1000,
            "end_countdown"
        )
	end
);
gb:add_listener(
	"generals_defeated",
	function()
		-- ga_ai_reikland_generals:remove_ping_icon();
		ga_ai_brt_rein_louen.sunits:item(1):remove_ping_icon();
		ga_ai_vmp_rein.sunits:item(1):remove_ping_icon();
		ga_ai_reikland_karl_franz.sunits:item(1):remove_ping_icon();
        bm:remove_callback("end_countdown");
	end
);


-------------------------------------------------------------------------------------------------
------------------------------------------- HINTS -----------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("objective_01", "wh3_dlc29_qb_chs_glottkin_final_battle_hint_1", 10000, 2000, 15000)
gb:queue_help_on_message("reikland_main_defeated", "wh3_dlc29_qb_chs_glottkin_final_battle_hint_2", 10000, 2000, 20000)
gb:queue_help_on_message("hint_03", "wh3_dlc29_qb_chs_glottkin_final_battle_hint_3", 10000, 2000, 10000)


-- Mid battle VO
local sfx_mid_battle_01 = new_sfx("Play_wh3_dlc29_chs_glottkin_fall_of_altdorf_mid_04", false, true)
local sfx_mid_battle_02 = new_sfx("Play_wh3_dlc29_chs_glottkin_fall_of_altdorf_mid_05", false, true)

gb:play_sound_on_message("objective_02", sfx_mid_battle_01)
gb:queue_help_on_message("objective_02", "wh3_dlc29_qb_chs_glottkin_fall_of_altdorf_after_mid_01", 2800, 1000, 0)
gb:message_on_time_offset("VO_02", 4800, "objective_02"); -- move to the next line after 2.8s+2s

gb:play_sound_on_message("VO_02", sfx_mid_battle_02)
gb:queue_help_on_message("VO_02", "wh3_dlc29_qb_chs_glottkin_fall_of_altdorf_after_mid_02", 12300, 1000, 0)
gb:message_on_time_offset("hint_03", 16300, "VO_02"); -- move to the hint after 12.3s+4s


-------------------------------------------------------------------------------------------------
--------------------------------- CAMPAIGN NARRATIVE VARS ---------------------------------------
-------------------------------------------------------------------------------------------------

-- OPTIONAL NARRATIVE 1 - Damage initial reikland forces
if cam_damage_army == 1 then
	ga_ai_reikland_stragglers:kill_proportion_over_time_on_message(1, 4000, true, "start")
	ga_ai_reikland_main:kill_proportion_over_time_on_message(1, 4000, true, "start")
	gb:message_on_time_offset("stop_damaging", 1000, "start"); 
	ga_ai_reikland_stragglers:stop_kill_proportion_over_time_on_message("stop_damaging")
	ga_ai_reikland_main:stop_kill_proportion_over_time_on_message("stop_damaging")
end

-- OPTIONAL NARRATIVE 2 - NUR Daemons rein
gb:message_on_all_messages_received("nur_rein_wave", "vmp_in_combat", "player_rein_enabled"); -- When dwf and emp main armies are low health start phase 3

if cam_enable_daemon_reins == 1 then gb:message_on_time_offset("player_rein_enabled", 10000, "start"); end


function spawn_daemon_reins()
	ga_player_daemons_rein:deploy_at_random_intervals_on_message(
		"nur_rein_wave", 			-- message
		1, 							-- min units
		1, 							-- max units
		3000, 				-- min period
		3000, 				-- max period
		"stop_daemon_rein", 		-- cancel message
		true,						-- spawn first wave immediately
		false,						-- allow respawning
		nil,						-- survival battle wave index
		nil,						-- is final survival wave
		false						-- show debug output
	);
end
spawn_daemon_reins() 
ga_player_daemons_rein:message_on_any_deployed("nur_rein_in")

-- Throw hint message 2s after daemons join the battle
gb:queue_help_on_message("nur_rein_in", "wh3_dlc29_qb_chs_glottkin_final_battle_hint_4", 10000, 2000, 2000)

-- OPTIONAL NARRATIVE 3 - Prevent Reinforcements
-- Disabled endless reins at the army setup stage


-------------------------------------------------------------------------------------------------
---------------------------------------- DEFEAT -------------------------------------------------
-------------------------------------------------------------------------------------------------

-- -- Keep Glottkin alive objective failed
ga_player:message_on_commander_dead_or_shattered("lord_dead")
ga_ai_reikland_main:force_victory_on_message("lord_dead", 16000)
gb:fail_objective_on_message("lord_dead", "wh3_dlc29_qb_chs_glottkin_war_in_the_darkwald_glottkin_alive", 3000) 


-------------------------------------------------------------------------------------------------
---------------------------------------- VICTORY ------------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player:force_victory_on_message("all_generals_defeated", 16000) -- Victory over the the enemy after objective x is complete

gb:message_on_time_offset("force_victory", 10000, "all_generals_defeated");
gb:add_listener(
	"force_victory",
	function()
		ga_player:get_alliance():force_battle_victory();
	end
);