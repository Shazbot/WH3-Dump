-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------
-- Neferata
-- By Aleksandar Radulov
-- Dream of Lahmia
-------------------------------------------------------------------------------------------------
------------------------------------------- HEADERS ---------------------------------------------	
-------------------------------------------------------------------------------------------------
load_script_libraries()                            -- Load all our script libraries so lua can access our battle logic
bm = battle_manager:new(empire_battle:new())       -- Create a battle manager. This is able to listen to the battle and send messages accordingly.
gb = generated_battle:new(                          -- Load a generated battle, used for scripted battles.
    false,                                          -- screen starts black
    false,                                          -- prevent Player deployment
	true,											-- prevent AI deployment
	function() end_deployment_phase() end,          -- intro cutscene function
    false                                           -- debug mode
);

gb:set_cutscene_during_deployment(true)
bm:cindy_preload("script/battle/quest_battles/_cutscene/managers/wh3_neferata_fb_intro_01.CindySceneManager")

-------------------------------------------------------------------------------------------------
----------------------------------------- INTRO CUTSCENE ----------------------------------------
-------------------------------------------------------------------------------------------------
function end_deployment_phase()
    bm:out("\tend_deployment_phase() called")

    local cam = bm:camera()

    cam:fade(true, 0)

	local cutscene_intro = cutscene:new_from_cindyscene(
		"cutscene_intro", 																				-- unique string name for cutscene
		ga_player.sunits,																				-- unitcontroller over player's army
		function() intro_cutscene_end() end,															-- what to call when cutscene is finished
		"script/battle/quest_battles/_cutscene/managers/wh3_neferata_fb_intro_01.CindySceneManager",	-- path to cindyscene
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
			
			bm:stop_cindy_playback(true)

			if player_units_hidden then
				ga_player:set_enabled(true)
			end;

			--ga_brt_enemy:set_visible_to_all(false)
			cam:fade(true, 0)
			bm:callback(function() cam:fade(false, 0.5) end, 10)
			bm:hide_subtitles()
		end
	)

	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000)

	cutscene_intro:action(
	function() 
		ga_player.sunits:item(1):set_enabled(false)
	end, 
	100)	

	cutscene_intro:action(
		function() 
		if bm:is_from_campaign() then
			set_up_campaign_armies()
		else
			set_up_frontend_armies()
		end
	end, 
	100)	

	cutscene_intro:action(function() cutscene_intro:play_sound(new_sfx("Play_Movie_WH3_DLC29_FB_Neferata_Intro", true, false)) end, 100);

	cutscene_intro:action(
		function() ga_ogr_inf:set_visible_to_all(true) end, 
		10
	)

	cutscene_intro:add_cinematic_trigger_listener(
	"Play_wh3_dlc29_vmp_neferata_dream_of_lahmia_01", 
		function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_vmp_neferata_dream_of_lahmia_01"));
				bm:show_subtitle("wh3_dlc29_qb_vmp_neferata_dream_of_lahmia_intro_01", false, true);
			end	
	)

	cutscene_intro:add_cinematic_trigger_listener(
	"Play_wh3_dlc29_vmp_neferata_dream_of_lahmia_02", 
		function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_vmp_neferata_dream_of_lahmia_02"));
				bm:show_subtitle("wh3_dlc29_qb_vmp_neferata_dream_of_lahmia_intro_02", false, true);
			end	
	)

	cutscene_intro:add_cinematic_trigger_listener(
	"Play_wh3_dlc29_vmp_neferata_dream_of_lahmia_03", 
		function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_vmp_neferata_dream_of_lahmia_03"));
				bm:show_subtitle("wh3_dlc29_qb_vmp_neferata_dream_of_lahmia_intro_03", false, true);
			end	
	)

	cutscene_intro:add_cinematic_trigger_listener(
	"Play_wh3_dlc29_vmp_neferata_dream_of_lahmia_04", 
		function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_vmp_neferata_dream_of_lahmia_04"));
				bm:show_subtitle("wh3_dlc29_qb_vmp_neferata_dream_of_lahmia_intro_04", false, true);
			end	
	)
	
	cutscene_intro:add_cinematic_trigger_listener(	
	"Play_wh3_dlc29_vmp_neferata_dream_of_lahmia_05", 
		function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_vmp_neferata_dream_of_lahmia_05"));
				bm:show_subtitle("wh3_dlc29_qb_vmp_neferata_dream_of_lahmia_intro_05", false, true);
			end	
	)

	cutscene_intro:add_cinematic_trigger_listener(
	"Play_wh3_dlc29_vmp_neferata_dream_of_lahmia_06", 
		function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_vmp_neferata_dream_of_lahmia_06"));
			bm:show_subtitle("wh3_dlc29_qb_vmp_neferata_dream_of_lahmia_intro_06", false, true);
			end	
	)

	cutscene_intro:add_cinematic_trigger_listener(
	"Play_wh3_dlc29_vmp_neferata_dream_of_lahmia_07", 
		function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_vmp_neferata_dream_of_lahmia_07"));
				bm:show_subtitle("wh3_dlc29_qb_vmp_neferata_dream_of_lahmia_intro_07", false, true);
			end	
	)

	cutscene_intro:add_cinematic_trigger_listener(
	"Play_wh3_dlc29_vmp_neferata_dream_of_lahmia_08", 
		function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_vmp_neferata_dream_of_lahmia_08"));
				bm:show_subtitle("wh3_dlc29_qb_vmp_neferata_dream_of_lahmia_intro_08", false, true);
			end	
	)

    cutscene_intro:start()
end

function intro_cutscene_end()
	play_sound_2D(new_sfx("Stop_Movie_WH3_DLC29_FB_Neferata_Intro", false, false))
	ga_ogr_inf:set_visible_to_all(true)
	ga_player.sunits:item(1):set_enabled(true)

	--camera position
    camera_target=v(68, 72, -37, -1)
    camera_position=v(278, 160, -37, -1)
    bm:scroll_camera_with_cutscene(
        camera_position,
        camera_target,
        0.5
        )
	
end
-------------------------------------------------------------------------------------------------
------------------------------------------ MID CUTSCENE -----------------------------------------
-------------------------------------------------------------------------------------------------
gb:add_listener(
	"deploy_tmb_khalidas_army",
	function()
		bm:callback(
			function ()
				play_mid_cutscene()
				khalidas_army_teleport()
			end,
			5000
		)
	end
)

function play_mid_cutscene()
	bm:camera():fade(true, 0.5)

	local cam = bm:camera()
	
	-- REMOVE ME
	cam:fade(false, 2)

	local cutscene_mid = cutscene:new_from_cindyscene(
		"cutscene_mid", 																				-- unique string name for cutscene
		ga_player.sunits,																				-- unitcontroller over player's army
		function() mid_cutscene_end() end,																-- what to call when cutscene is finished
		"script/battle/quest_battles/_cutscene/managers/wh3_neferata_fb_middle_01.CindySceneManager",	-- path to cindyscene
		0,																								-- blend in time (s)
		0																								-- blend out time (s)
	)

	cutscene_mid:action(
		function() 	
			ga_player.sunits:set_enabled(false)
			ga_ogr_inf.sunits:set_enabled(false)
			ga_ogr_cav.sunits:set_enabled(false)
			ga_ogr_stonehorns.sunits:set_enabled(false)
			ga_emp_inf_01.sunits:set_enabled(false)
			ga_emp_inf_02.sunits:set_enabled(false)
			ga_emp_art_01.sunits:set_enabled(false)
			ga_emp_art_02.sunits:set_enabled(false)
			ga_emp_outriders_01.sunits:set_enabled(false)
			ga_emp_outriders_02.sunits:set_enabled(false)
			ga_tmb_khalidas_army.sunits:set_enabled(false)

			if bm:is_from_campaign() then
				hide_campaign_vmp_armies()
			else
				hide_frontend_vmp_armies()
			end
		end, 
		10
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
	cutscene_mid:action(function() cutscene_mid:play_sound(new_sfx("Play_Movie_WH3_DLC29_FB_Neferata_Mid", true, false)) end, 100)


	cutscene_mid:add_cinematic_trigger_listener(
	"Play_wh3_dlc29_vmp_neferata_dream_of_lahmia_mid_01", 
		function()
			cutscene_mid:play_sound(new_sfx("Play_wh3_dlc29_vmp_neferata_dream_of_lahmia_mid_01"))
			bm:show_subtitle("wh3_dlc29_qb_vmp_neferata_dream_of_lahmia_mid_01", false, true)
		end	
	)

	cutscene_mid:add_cinematic_trigger_listener(
	"Play_wh3_dlc29_vmp_neferata_dream_of_lahmia_mid_02", 
		function()
			cutscene_mid:play_sound(new_sfx("Play_wh3_dlc29_vmp_neferata_dream_of_lahmia_mid_02"))
			bm:show_subtitle("wh3_dlc29_qb_vmp_neferata_dream_of_lahmia_mid_02", false, true)
		end	
	)

	cutscene_mid:add_cinematic_trigger_listener(
	"Play_wh3_dlc29_vmp_neferata_dream_of_lahmia_mid_03", 
		function()
			cutscene_mid:play_sound(new_sfx("Play_wh3_dlc29_vmp_neferata_dream_of_lahmia_mid_03"))
			bm:show_subtitle("wh3_dlc29_qb_vmp_neferata_dream_of_lahmia_mid_03", false, true)
		end	
	)

	cutscene_mid:add_cinematic_trigger_listener(
	"Play_wh3_dlc29_vmp_neferata_dream_of_lahmia_mid_04", 
		function()
			cutscene_mid:play_sound(new_sfx("Play_wh3_dlc29_vmp_neferata_dream_of_lahmia_mid_04"))
			bm:show_subtitle("wh3_dlc29_qb_vmp_neferata_dream_of_lahmia_mid_04", false, true)
		end	
	)

	cutscene_mid:add_cinematic_trigger_listener(
	"Play_wh3_dlc29_vmp_neferata_dream_of_lahmia_mid_05", 
		function()
			cutscene_mid:play_sound(new_sfx("Play_wh3_dlc29_vmp_neferata_dream_of_lahmia_mid_05"))
			bm:show_subtitle("wh3_dlc29_qb_vmp_neferata_dream_of_lahmia_mid_05", false, true)
		end	
	)

	cutscene_mid:add_cinematic_trigger_listener(
	"Play_wh3_dlc29_vmp_neferata_dream_of_lahmia_mid_06", 
		function()
			cutscene_mid:play_sound(new_sfx("Play_wh3_dlc29_vmp_neferata_dream_of_lahmia_mid_06"))
			bm:show_subtitle("wh3_dlc29_qb_vmp_neferata_dream_of_lahmia_mid_06", false, true)
		end	
	)

	cutscene_mid:start()
end

function mid_cutscene_end()
	play_sound_2D(new_sfx("Stop_Movie_WH3_DLC29_FB_Neferata_Mid", false, false))

	ga_player.sunits:set_enabled(true)
	ga_tmb_khalidas_army.sunits:set_enabled(true)

	if bm:is_from_campaign() then
		show_campaign_vmp_armies()
	else
		show_frontend_vmp_armies()
	end

	sm:trigger_message("mid_cutscene_end")
end

---------------------------------------
-----------CAMPAIGN EVENTS-------------
---------------------------------------
local cam_mannfred_present = tonumber(core:svr_load_string("mannfred_final_battle_support"))
local cam_vlad_isabella_present = tonumber(core:svr_load_string("vlad_isabella_final_battle_support"))

bm:out("\n ========= mannfred reinf: " .. tostring(cam_mannfred_present))
bm:out("\n ========= vlad and isabella reinf: " .. tostring(cam_vlad_isabella_present))

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------
-- Player Army Setup
ga_player = gb:get_army(gb:get_player_alliance_num())

-- Allied Armies Setup
ga_brt = gb:get_army(gb:get_player_alliance_num(), "brt_army")

-- Enemy Armies Setup
ga_ogr_inf = gb:get_army(gb:get_non_player_alliance_num(), "ogr_infantry")
ga_ogr_cav = gb:get_army(gb:get_non_player_alliance_num(), "ogr_cavalry")
ga_ogr_stonehorns = gb:get_army(gb:get_non_player_alliance_num(), "ogr_stonehorns")

ga_emp_outriders_01 = gb:get_army(gb:get_non_player_alliance_num(), "emp_outriders_01")
ga_emp_outriders_02 = gb:get_army(gb:get_non_player_alliance_num(), "emp_outriders_02")
ga_emp_art_01 = gb:get_army(gb:get_non_player_alliance_num(), "emp_artillery_01")
ga_emp_art_02 = gb:get_army(gb:get_non_player_alliance_num(), "emp_artillery_02")
ga_emp_inf_01 = gb:get_army(gb:get_non_player_alliance_num(), "emp_infantry_01")
ga_emp_inf_02 = gb:get_army(gb:get_non_player_alliance_num(), "emp_infantry_02")

--ga_tmb_khalida_solo = gb:get_army(gb:get_non_player_alliance_num(), "tmb_khalida_solo")
ga_tmb_khalidas_army = gb:get_army(gb:get_non_player_alliance_num(), "tmb_khalidas_army")
ga_tmb_khalidas_reinf = gb:get_army(gb:get_non_player_alliance_num(), "tmb_khalidas_reinforcements")

-------------------------------------------------------------------------------------------------
------------------------------------- CAMPAIGN ARMY SETUP ---------------------------------------
-------------------------------------------------------------------------------------------------
-- Campaign Army Reinforcement Setup
	ga_vmp_vlad_isabella = gb:get_army(gb:get_player_alliance_num(), "vlad_isabella_reinf")
	ga_vmp_mannfred = gb:get_army(gb:get_player_alliance_num(), "mannfred_reinf")

-- Campaign Army Management
function set_up_campaign_armies()
	if cam_mannfred_present == 1 then
		ga_vmp_mannfred:rush_on_message("start")
	elseif cam_mannfred_present == 0 then
		ga_vmp_mannfred.sunits:set_enabled(false)
	else
		ga_vmp_mannfred.sunits:set_enabled(false)
		bm:out("========= problems with Mannfred army from campaign")
	end

	if cam_vlad_isabella_present == 1 then
		ga_vmp_vlad_isabella:rush_on_message("start")
	elseif cam_vlad_isabella_present == 0 then
		ga_vmp_vlad_isabella.sunits:set_enabled(false)
	else
		ga_vmp_vlad_isabella.sunits:set_enabled(false)
		bm:out("========= problems with Vlad army from campaign")
	end
end

function set_up_frontend_armies()
	ga_vmp_mannfred:rush_on_message("start")
	ga_vmp_vlad_isabella:rush_on_message("start")

	bm:out("========= Adding both confederated lords to the front end battle");
end

function hide_campaign_vmp_armies()
	if cam_mannfred_present == 1 then
		ga_vmp_mannfred.sunits:set_enabled(false)
	elseif cam_mannfred_present == 0 then
		bm:out("========= Not hiding hiding Mannfred");
	else
		bm:out("========= Something broke hiding Mannfred");
	end

	if cam_vlad_isabella_present == 1 then
		ga_vmp_vlad_isabella.sunits:set_enabled(false)
	elseif cam_vlad_isabella_present == 0 then
		bm:out("========= Not hiding Vlad/Isabella");
	else
		bm:out("========= Something broke hiding Vlad/Isabella");
	end
end

function hide_frontend_vmp_armies()
	ga_vmp_mannfred.sunits:set_enabled(false)
	ga_vmp_vlad_isabella.sunits:set_enabled(false)
end

function show_campaign_vmp_armies()
	if cam_mannfred_present == 1 then
		ga_vmp_mannfred.sunits:set_enabled(true)
		ga_vmp_mannfred:rush_on_message("mid_cutscene_end", 1000)
	elseif cam_mannfred_present == 0 then
		bm:out("========= Not showing hiding Mannfred");
	else
		bm:out("========= Something broke showing Mannfred");
	end

	if cam_vlad_isabella_present == 1 then
		ga_vmp_vlad_isabella.sunits:set_enabled(true)
		ga_vmp_vlad_isabella:rush_on_message("mid_cutscene_end", 1000)
	elseif cam_vlad_isabella_present == 0 then
		bm:out("========= Not showing Vlad/Isabella");
	else
		bm:out("========= Something broke showing Vlad/Isabella");
	end
end

function show_frontend_vmp_armies()
	ga_vmp_mannfred.sunits:set_enabled(true)
	ga_vmp_vlad_isabella.sunits:set_enabled(true)
	
	ga_vmp_mannfred:rush_on_message("mid_cutscene_end", 1000)
	ga_vmp_vlad_isabella:rush_on_message("mid_cutscene_end", 1000)
end

-------------------------------------------------------------------------------------------------
----------------------------------------- SPAWN ZONES -------------------------------------------
-------------------------------------------------------------------------------------------------
-- Get Spawn Zones
brt_reinf_zone = bm:get_spawn_zone_collection_by_name("brt_army_reinf")

ogr_cav_reinf_zone = bm:get_spawn_zone_collection_by_name("ogr_cavalry_reinf")

emp_art_01_reinf_zone = bm:get_spawn_zone_collection_by_name("emp_artillery_01_reinf")
emp_art_02_reinf_zone = bm:get_spawn_zone_collection_by_name("emp_artillery_02_reinf")
emp_inf_01_reinf_zone = bm:get_spawn_zone_collection_by_name("emp_infantry_01_reinf")
emp_outriders_reinf_zone = bm:get_spawn_zone_collection_by_name("emp_outriders_reinf")

cth_tigers_reinf_zone = bm:get_spawn_zone_collection_by_name("cth_tiger_warrior_reinf")
tmb_reinf_zone = bm:get_spawn_zone_collection_by_name("tmb_reinf_zone")

-- Assign Spawn Zones
ga_brt:assign_to_spawn_zone_from_collection_on_message("deployment_started", brt_reinf_zone, false)

ga_ogr_cav:assign_to_spawn_zone_from_collection_on_message("deployment_started", ogr_cav_reinf_zone, false)

ga_emp_outriders_01:assign_to_spawn_zone_from_collection_on_message("deployment_started", emp_outriders_reinf_zone, false)
ga_emp_outriders_02:assign_to_spawn_zone_from_collection_on_message("deployment_started", cth_tigers_reinf_zone, false)
ga_emp_art_01:assign_to_spawn_zone_from_collection_on_message("deployment_started", emp_art_01_reinf_zone, false)
ga_emp_art_02:assign_to_spawn_zone_from_collection_on_message("deployment_started", emp_art_02_reinf_zone, false)
ga_emp_inf_01:assign_to_spawn_zone_from_collection_on_message("deployment_started", emp_inf_01_reinf_zone, false)
ga_emp_inf_02:assign_to_spawn_zone_from_collection_on_message("deployment_started", emp_art_02_reinf_zone, false)

ga_tmb_khalidas_reinf:assign_to_spawn_zone_from_collection_on_message("deployment_started", tmb_reinf_zone, false)

-------------------------------------------------------------------------------------------------
--------------------------------------- TELEPORT SETUP ------------------------------------------
-------------------------------------------------------------------------------------------------
ogr_stonehorn_teleport_locations = {
	{x = -48, y = 107, orientation = 120},
	{x = -23, y = -180, orientation = 120}
}

tmb_khalidas_army_teleport_locations = {
	{x = -200, y = -20, orientation = 120},
	--{x = -230, y = 0, orientation = 120},
	{x = -100, y = 60, orientation = 120},
	{x = -100, y = 30, orientation = 120},
	{x = -100, y = -30, orientation = 120},
	{x = -100, y = -60, orientation = 120},
	{x = -220, y = 60, orientation = 120},
	{x = -220, y = 30, orientation = 120},
	{x = -220, y = -30, orientation = 120},
	{x = -220, y = -60, orientation = 120},
	{x = 150, y = 60, orientation = 120},
	{x = 150, y = 30, orientation = 120},
	{x = 150, y = -30, orientation = 120},
	{x = 150, y = -60, orientation = 120},
	{x = 200, y = 120, orientation = 120},
	{x = 200, y = -120, orientation = 120},
	{x = -140, y = 20, orientation = 120},
	{x = -140, y = -60, orientation = 120},
	{x = -300, y = -20, orientation = 120},
	{x = -300, y = 20, orientation = 120},
	{x = -200, y = 20, orientation = 120},
	{x = -350, y = 0, orientation = 120},
}

function stonehorn_teleport()
	for i=1, ga_ogr_stonehorns.sunits:count() do
		local sunit = ga_ogr_stonehorns.sunits:item(i)
		local location = v(ogr_stonehorn_teleport_locations[i].x, ogr_stonehorn_teleport_locations[i].y)
		local bearing = ogr_stonehorn_teleport_locations[i].orientation

		sunit.uc:teleport_to_location(location, bearing, 40)
	end
end

function khalidas_army_teleport()
	for i=1, ga_tmb_khalidas_army.sunits:count() do
		local sunit = ga_tmb_khalidas_army.sunits:item(i)
		local location = v(tmb_khalidas_army_teleport_locations[i].x, tmb_khalidas_army_teleport_locations[i].y)
		local bearing = tmb_khalidas_army_teleport_locations[i].orientation

		sunit.uc:teleport_to_location(location, bearing, 40)
	end
end

-------------------------------------------------------------------------------------------------
-------------------------------------------- PHASES ---------------------------------------------
-------------------------------------------------------------------------------------------------
local perpetual = true;
local shattered_only = false;
local permit_rampaging = true;

gb:message_on_time_offset("start", 100)
gb:message_on_time_offset("start_delay", 5000)

-- Phase I	
	-- Deploy & Teleport Stonehorns
	gb:add_listener("start", function() stonehorn_teleport() end)
	ga_ogr_stonehorns:rush_on_message("start")

	-- Deploy & Teleport Ogre Infantry
	ga_ogr_inf:rush_on_message("start")

	-- Deploy Empire Artilleries
	ga_emp_art_01:reinforce_on_message("start")
	ga_emp_art_01:defend(60, -435, 40)

	ga_emp_art_02:reinforce_on_message("start")
	ga_emp_art_02:defend(150, 420, 40)

	-- Deploy Empire Outriders
	ga_emp_outriders_01:reinforce_on_message("start")
	ga_emp_outriders_01:message_on_deployed("outriders_01_deployed")
	ga_emp_outriders_01:rush_on_message("outriders_01_deployed")

	ga_emp_outriders_02:reinforce_on_message("start")
	ga_emp_outriders_02:message_on_deployed("outriders_02_deployed")
	ga_emp_outriders_02:rush_on_message("outriders_02_deployed")

gb:add_listener(
    "start_delay",
	function()
		ga_emp_art_01.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_emp_art_02.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_emp_outriders_01.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_emp_outriders_02.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
    end,
	true
);

-- Phase II 
	-- Deploy Ogre Cavalry
	ga_ogr_cav:reinforce_on_message("deploy_ogr_cavalry")
	ga_ogr_cav:message_on_deployed("ogr_cav_deployed")
	ga_ogr_cav:rush_on_message("ogr_cav_deployed")

	-- Deploy Empire Infantry 01
	ga_emp_art_01:message_on_proximity_to_enemy("emp_art_01_proximity", 100)
	ga_emp_art_01:message_on_rout_proportion("emp_art_01_damaged", 0.5)
	gb:message_on_any_message_received("deploy_emp_inf_01", "emp_art_01_proximity", "emp_art_01_damaged" )

	ga_emp_inf_01:reinforce_on_message("deploy_emp_inf_01")
	ga_emp_inf_01:message_on_any_deployed("emp_inf_01_in");
	ga_emp_inf_01:rush_on_message("start")

	gb:add_listener(
		"emp_inf_01_in",
		function()
			ga_emp_inf_01.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		end,
		true
	);

	-- Deploy Empire Infantry 02
	ga_emp_art_02:message_on_proximity_to_enemy("emp_art_02_proximity", 100)
	ga_emp_art_02:message_on_rout_proportion("emp_art_02_damaged", 0.5)
	gb:message_on_any_message_received("deploy_emp_inf_02", "emp_art_02_proximity", "emp_art_02_damaged")

	ga_emp_inf_02:reinforce_on_message("deploy_emp_inf_02")
	ga_emp_inf_02:message_on_any_deployed("emp_inf_02_in");
	ga_emp_inf_02:rush_on_message("emp_inf_02_in")

	gb:add_listener(
		"emp_inf_02_in",
		function()
			ga_emp_inf_02.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		end,
		true
	);

	-- Manage Ogre Routing
	ga_ogr_inf:message_on_rout_proportion("deploy_ogr_cavalry", 0.35)
	ga_ogr_inf:message_on_rout_proportion("ogr_inf_damaged", 0.75)
	ga_ogr_inf:rout_over_time_on_message("ogr_inf_damaged", 10000)
	ga_ogr_inf:message_on_rout_proportion("ogr_inf_all_routed", 1)

	ga_ogr_cav:message_on_rout_proportion("ogr_cav_damaged", 0.75)
	ga_ogr_cav:rout_over_time_on_message("ogr_cav_damaged", 10000)
	ga_ogr_cav:message_on_rout_proportion("ogr_cav_all_routed", 1)

	ga_ogr_stonehorns:message_on_rout_proportion("ogr_stonehorns_all_routed", 1)

	gb:add_listener(
		"ogr_cav_deployed",
		function()
			ga_ogr_inf.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
			ga_ogr_cav.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
			ga_ogr_stonehorns.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		end,
		true
	);

	gb:message_on_all_messages_received("all_ogres_routed", "ogr_inf_all_routed", "ogr_cav_all_routed", "ogr_stonehorns_all_routed")

	-- Manage Empire Routing
	ga_emp_art_01:message_on_rout_proportion("emp_art_01_all_routed", 1)
	ga_emp_inf_01:message_on_rout_proportion("emp_inf_01_all_routed", 1)

	ga_emp_art_02:message_on_rout_proportion("emp_art_02_all_routed", 1)
	ga_emp_inf_02:message_on_rout_proportion("emp_inf_02_all_routed", 1)
	
	ga_emp_outriders_01:message_on_rout_proportion("emp_outriders_01_all_routed", 1)
	ga_emp_outriders_02:message_on_rout_proportion("emp_outriders_02_all_routed", 1)

	gb:message_on_all_messages_received("all_empire_routed", "emp_inf_02_all_routed", "emp_inf_01_all_routed", "emp_art_02_all_routed", "emp_art_01_all_routed", "emp_outriders_02_all_routed", "emp_outriders_01_all_routed")

-- Phase III 
	-- Deploy & Teleport Khalida's Army
	ga_tmb_khalidas_army.sunits:set_enabled(false)
	gb:message_on_all_messages_received("deploy_tmb_khalidas_army", "all_ogres_routed", "all_empire_routed")
	-- gb:add_listener("deploy_tmb_khalidas_army", function() khalidas_army_teleport() end)
	ga_tmb_khalidas_army:rush_on_message("mid_cutscene_end", 1500)
	
	-- Deploy & Khalida's Reinforcements
	ga_tmb_khalidas_reinf:reinforce_on_message("mid_cutscene_end", 2500)
	ga_tmb_khalidas_reinf:message_on_deployed("khalidas_reinforcements_deployed")
	ga_tmb_khalidas_reinf:rush_on_message("khalidas_reinforcements_deployed")
	ga_tmb_khalidas_reinf:message_on_rout_proportion("tmb_khalidas_reinforcements_routed", 0.9)

	-- Deploy Bretonnian
	ga_brt:reinforce_on_message("mid_cutscene_end")

	--Defeat Khalida's Army
	ga_tmb_khalidas_army:message_on_rout_proportion("tmb_khalidas_army_routed", 0.95)

	gb:add_listener(
	"mid_cutscene_end",
	function()
		bm:repeat_callback(
			function()
				if ga_tmb_khalidas_army.sunits:item(1).unit:unary_hitpoints() <= 0 then
					sm:trigger_message("tmb_khalida_defeated")
					bm:remove_callback("end_khalida_tracker")
				end
			end,
			1000,
			"end_khalida_tracker"
		)
		end,
	true
)

-------------------------------------------------------------------------------------------------
------------------------------------- OBJECTIVE MANAGEMENT  -------------------------------------
-------------------------------------------------------------------------------------------------
local mercs_defeated = 0

-- Objective 1 
-- gb:set_objective_with_leader_on_message("start", "wh3_dlc29_qb_vmp_neferata_dream_of_lahmia_objective_1")
gb:set_objective_on_message("start", "wh3_dlc29_qb_vmp_neferata_dream_of_lahmia_objective_1_1", 2500)
gb:set_objective_on_message("start", "wh3_dlc29_qb_vmp_neferata_dream_of_lahmia_objective_1_2",3000)
gb:complete_objective_on_message("all_ogres_routed", "wh3_dlc29_qb_vmp_neferata_dream_of_lahmia_objective_1_1")
gb:complete_objective_on_message("all_empire_routed", "wh3_dlc29_qb_vmp_neferata_dream_of_lahmia_objective_1_2")

gb:add_listener(
	"all_ogres_routed",
	function()
		mercs_defeated = mercs_defeated + 1

		bm:set_objective("wh3_dlc29_qb_vmp_neferata_dream_of_lahmia_objective_1", mercs_defeated, 2)
	end
);

gb:add_listener(
	"all_empire_routed",
	function()
		mercs_defeated = mercs_defeated + 1

		bm:set_objective("wh3_dlc29_qb_vmp_neferata_dream_of_lahmia_objective_1", mercs_defeated, 2)
	end
);

-- Merc Counter
gb:add_listener(
    "start",
	function()
		bm:repeat_callback(
			function()
				bm:set_objective("wh3_dlc29_qb_vmp_neferata_dream_of_lahmia_objective_1", mercs_defeated, 2)

				if mercs_defeated == 2 then
					sm:trigger_message("countdown_finished")
					bm:remove_callback("merc_counter")
				end
			end,
			1000,
			"merc_counter"
		)
	end
)

gb:remove_objective_on_message("deploy_tmb_khalidas_army", "wh3_dlc29_qb_vmp_neferata_dream_of_lahmia_objective_1", 5000);
gb:remove_objective_on_message("deploy_tmb_khalidas_army", "wh3_dlc29_qb_vmp_neferata_dream_of_lahmia_objective_1_1", 5000);
gb:remove_objective_on_message("deploy_tmb_khalidas_army", "wh3_dlc29_qb_vmp_neferata_dream_of_lahmia_objective_1_2", 5000);

-- Objective 2
gb:message_on_all_messages_received("tmb_defeated", "tmb_khalida_defeated", "tmb_khalidas_army_routed", "tmb_khalidas_reinforcements_routed")

gb:set_objective_on_message("mid_cutscene_end", "wh3_dlc29_qb_vmp_neferata_dream_of_lahmia_objective_2_1", 5000)
gb:complete_objective_on_message("tmb_khalida_defeated", "wh3_dlc29_qb_vmp_neferata_dream_of_lahmia_objective_2")
gb:complete_objective_on_message("tmb_defeated", "wh3_dlc29_qb_vmp_neferata_dream_of_lahmia_objective_2_1")

gb:set_locatable_objective_callback_on_message(
    "mid_cutscene_end",
    "wh3_dlc29_qb_vmp_neferata_dream_of_lahmia_objective_2",
    2500,
    function()
        local sunit = ga_tmb_khalidas_army.sunits:item(1)
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

-- Hints
gb:queue_help_on_message("start_delay", "wh3_dlc29_qb_vmp_neferata_dream_of_lahmia_hint_01")
gb:queue_help_on_message("deploy_emp_inf_01", "wh3_dlc29_qb_vmp_neferata_dream_of_lahmia_hint_02")
gb:queue_help_on_message("deploy_ogr_cavalry", "wh3_dlc29_qb_vmp_neferata_dream_of_lahmia_hint_03")
gb:queue_help_on_message("mid_cutscene_end", "wh3_dlc29_qb_vmp_neferata_dream_of_lahmia_hint_04", 2500)

-------------------------------------------------------------------------------------------------
-------------------------------------- WIN/LOSE CONDITION ---------------------------------------
-------------------------------------------------------------------------------------------------
gb:message_on_all_messages_received("battle_won", "tmb_khalidas_army_routed", "tmb_khalidas_reinforcements_routed")

ga_player:force_victory_on_message("battle_won", 5000)

ga_player:message_on_rout_proportion("neferata_defeated", 1)
gb:add_listener(
	"neferata_defeated",
	function()
		bm:force_battle_end(gb:get_non_player_alliance_num(), "scripted", true, true)		-- Forces defeat on the player, end the battle immediately, force the player to be the loser
	end
)