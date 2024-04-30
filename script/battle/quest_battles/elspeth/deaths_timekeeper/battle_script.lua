-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Elspeth
-- By James Cox
-- Deaths Keeper

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries()

csl = bm:composite_scenes_system():terrain_composite_scenes()

gb = generated_battle:new(
	false,                                      	-- screen starts black
	false,                                      	-- prevent deployment for player
	true,                                      		-- prevent deployment for ai
	function() end_deployment_phase() end,          -- intro cutscene function
	false                                      		-- debug mode
)

gb:set_cutscene_during_deployment(true)

-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

local sfx_cutscene_sweetener_play = new_sfx("Play_Movie_WH3_DLC25_QB_Elspeth_Deaths_Timekeeper_Sweetener", true, false)
local sfx_cutscene_sweetener_stop = new_sfx("Stop_Movie_WH3_DLC25_QB_Elspeth_Deaths_Timekeeper_Sweetener", false, false)

-------------------------------------------------------------------------------------------------
------------------------------------------- CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------

function end_deployment_phase()
	bm:out("\tend_deployment_phase() called")
		
	local cam = bm:camera()
	
	-- REMOVE ME
	cam:fade(true, 0)
	
	-- declare cutscene
	local cutscene_intro = cutscene:new_from_cindyscene(
		"cutscene_intro", 																-- unique string name for cutscene
		ga_player.sunits,																-- unitcontroller over player's army
		function() intro_cutscene_end() end,											-- what to call when cutscene is finished
		"script/battle/quest_battles/_cutscene/managers/deaths_timekeeper_m01.CindySceneManager",			-- path to cindyscene
		0,																				-- blend in time (s)
		0																				-- blend out time (s)
	)
	
	local player_units_hidden = false
	
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
				ga_player:set_enabled(false)
			end
						
			bm:callback(function() cam:fade(false, 0.5) end, 500)
			bm:hide_subtitles()
		end
	)
	
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000)

	cutscene_intro:action(
		function()
			player_units_hidden = false
		end, 
		200
	)

	-- Voiceover and Subtitles --
	
	cutscene_intro:action(function() cutscene_intro:play_sound(sfx_cutscene_sweetener_play) end, 1100)
	
	cutscene_intro:add_cinematic_trigger_listener(
		"play_wh3_dlc25_qb_emp_elspeth_deaths_timekeeper_01", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_dlc25_qb_emp_elspeth_deaths_timekeeper_01"))
				bm:show_subtitle("wh3_dlc25_qb_emp_elspeth_deaths_timekeeper_01", false, true)
			end
	)

	cutscene_intro:add_cinematic_trigger_listener(
		"play_wh3_dlc25_qb_emp_elspeth_deaths_timekeeper_02", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_dlc25_qb_emp_elspeth_deaths_timekeeper_02"))
				bm:show_subtitle("wh3_dlc25_qb_emp_elspeth_deaths_timekeeper_02", false, true)
			end
	)

	cutscene_intro:add_cinematic_trigger_listener(
		"play_wh3_dlc25_qb_emp_elspeth_deaths_timekeeper_03", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_dlc25_qb_emp_elspeth_deaths_timekeeper_03"))
				bm:show_subtitle("wh3_dlc25_qb_emp_elspeth_deaths_timekeeper_03", false, true)
			end
	)

	cutscene_intro:add_cinematic_trigger_listener(
		"play_wh3_dlc25_qb_emp_elspeth_deaths_timekeeper_04", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_dlc25_qb_emp_elspeth_deaths_timekeeper_04"))
				bm:show_subtitle("wh3_dlc25_qb_emp_elspeth_deaths_timekeeper_04", false, true)
			end
	)

	cutscene_intro:add_cinematic_trigger_listener(
		"play_wh3_dlc25_qb_emp_elspeth_deaths_timekeeper_05", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_dlc25_qb_emp_elspeth_deaths_timekeeper_05"))
				bm:show_subtitle("wh3_dlc25_qb_emp_elspeth_deaths_timekeeper_05", false, true)
			end
	)

	cutscene_intro:add_cinematic_trigger_listener(
		"play_wh3_dlc25_qb_emp_elspeth_deaths_timekeeper_06", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_dlc25_qb_emp_elspeth_deaths_timekeeper_06"))
				bm:show_subtitle("wh3_dlc25_qb_emp_elspeth_deaths_timekeeper_06", false, true)
			end
	)

	cutscene_intro:start()
end

function intro_cutscene_end()
	play_sound_2D(sfx_cutscene_sweetener_stop)
	gb.sm:trigger_message("01_intro_cutscene_end")
	gb:message_on_time_offset("start", 100)

	
end

gb:add_listener(
	"start",
	function()
		update_ritual_objectives()
		setup_army_attack_proximities()
		setup_army_casualty_watchers()
		start_fury_spawn_waves()
	end
)

-------------------------------------------------------------------------------------------------
------------------------------------------- VARIABLES -------------------------------------------
-------------------------------------------------------------------------------------------------

god_ids = {
	"khorne",
	"slaanesh",
	"tzeentch",
	"nurgle"
}

rituals = {
	khorne = {complete = false, timer = 250, objective = "wh3_dlc25_qb_emp_elspeth_deaths_timekeeper_khorne_timer", portal = csl:search_by_script_id("khorne_summon_portal"), explosion = csl:search_by_script_id("khorne_kill_sacrifices")},
	slaanesh = {complete = false, timer = 380, objective = "wh3_dlc25_qb_emp_elspeth_deaths_timekeeper_slaanesh_timer", portal = csl:search_by_script_id("slaanesh_summon_portal"), explosion = csl:search_by_script_id("slaanesh_kill_sacrifices")},
	tzeentch = {complete = false, timer = 550, objective = "wh3_dlc25_qb_emp_elspeth_deaths_timekeeper_tzeentch_timer", portal = csl:search_by_script_id("tzeentch_summon_portal"), explosion = csl:search_by_script_id("tzeentch_kill_sacrifices")},
	nurgle = {complete = false, timer = 550, objective = "wh3_dlc25_qb_emp_elspeth_deaths_timekeeper_nurgle_timer", portal = csl:search_by_script_id("nurgle_summon_portal"), explosion = csl:search_by_script_id("nurgle_kill_sacrifices")}
}

fury_spawn_count = {
	khorne = {current = 0, max = 1},
	slaanesh = {current = 0, max = 1},
	tzeentch = {current = 0, max = 2},
	nurgle = {current = 0, max = 2}
}

enemy_script_ids = {
	"sacrifice_khorne",
	"sacrifice_slaanesh",
	"sacrifice_tzeentch",
	"sacrifice_nurgle",
	"khorne_defenders",
	"khorne_cultist",
	"khorne_summon",
	"khorne_failed_summon",
	"khorne_furies",
	"slaanesh_defenders",
	"slaanesh_cultist",
	"slaanesh_summon",
	"slaanesh_failed_summon",
	"slaanesh_furies",
	"nurgle_defenders",
	"nurgle_cultist",
	"nurgle_summon",
	"nurgle_failed_summon",
	"nurgle_furies",
	"tzeentch_defenders",
	"tzeentch_cultist",
	"tzeentch_summon",
	"tzeentch_failed_summon",
	"tzeentch_furies",
	"undivided_lord",
	"undivided_lower_1",
	"undivided_lower_2",
	"undivided_upper_1",
	"undivided_upper_2",
	"undivided_chosen",
	"undivided_giants",
	"undivided_cannons"
}

ally_script_ids = {
	"sacrifice_khorne",
	"sacrifice_slaanesh",
	"sacrifice_tzeentch",
	"sacrifice_nurgle"
}

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

--Player Army
ga_player = gb:get_army(gb:get_player_alliance_num(), 1, "")

--Player Ally
allied_armies = {
	sacrifice_khorne = {army = gb:get_army(gb:get_player_alliance_num(), "sacrifice_khorne"), starts_enabled = false, unbreakable = true},
	sacrifice_slaanesh = {army = gb:get_army(gb:get_player_alliance_num(), "sacrifice_slaanesh"), starts_enabled = false, unbreakable = true},
	sacrifice_tzeentch = {army = gb:get_army(gb:get_player_alliance_num(), "sacrifice_tzeentch"), starts_enabled = false, unbreakable = true},
	sacrifice_nurgle = {army = gb:get_army(gb:get_player_alliance_num(), "sacrifice_nurgle"), starts_enabled = false, unbreakable = true}
}

--Enemy Armies
enemy_armies = {
	sacrifice_khorne = {army = gb:get_army(gb:get_non_player_alliance_num(), "sacrifice_khorne"), starts_enabled = true, unbreakable = true, proximity = nil},
	sacrifice_slaanesh = {army = gb:get_army(gb:get_non_player_alliance_num(), "sacrifice_slaanesh"), starts_enabled = true, unbreakable = true, proximity = nil},
	sacrifice_tzeentch = {army = gb:get_army(gb:get_non_player_alliance_num(), "sacrifice_tzeentch"), starts_enabled = true, unbreakable = true, proximity = nil},
	sacrifice_nurgle = {army = gb:get_army(gb:get_non_player_alliance_num(), "sacrifice_nurgle"), starts_enabled = true, unbreakable = true, proximity = nil},

	khorne_defenders = {army = gb:get_army(gb:get_non_player_alliance_num(), "khorne_defenders"), starts_enabled = true, unbreakable = false, proximity = 75},
	khorne_cultist = {army = gb:get_army(gb:get_non_player_alliance_num(), "khorne_cultist"), starts_enabled = true, unbreakable = true, proximity = nil},
	khorne_summon = {army = gb:get_army(gb:get_non_player_alliance_num(), "khorne_summon"), starts_enabled = false, unbreakable = true, proximity = 0},
	khorne_failed_summon = {army = gb:get_army(gb:get_non_player_alliance_num(), "khorne_failed_summon"), starts_enabled = false, unbreakable = false, proximity = 0},
	khorne_furies = {army = gb:get_army(gb:get_non_player_alliance_num(), "khorne_furies"), starts_enabled = false, unbreakable = false, proximity = 0},

	slaanesh_defenders = {army = gb:get_army(gb:get_non_player_alliance_num(), "slaanesh_defenders"), starts_enabled = true, unbreakable = false, proximity = 75},
	slaanesh_cultist = {army = gb:get_army(gb:get_non_player_alliance_num(), "slaanesh_cultist"), starts_enabled = true, unbreakable = true, proximity = nil},
	slaanesh_summon = {army = gb:get_army(gb:get_non_player_alliance_num(), "slaanesh_summon"), starts_enabled = false, unbreakable = true, proximity = 0},
	slaanesh_failed_summon = {army = gb:get_army(gb:get_non_player_alliance_num(), "slaanesh_failed_summon"), starts_enabled = false, unbreakable = false, proximity = 0},
	slaanesh_furies = {army = gb:get_army(gb:get_non_player_alliance_num(), "slaanesh_furies"), starts_enabled = false, unbreakable = false, proximity = 0},

	nurgle_defenders = {army = gb:get_army(gb:get_non_player_alliance_num(), "nurgle_defenders"), starts_enabled = true, unbreakable = false, proximity = 75},
	nurgle_cultist = {army = gb:get_army(gb:get_non_player_alliance_num(), "nurgle_cultist"), starts_enabled = true, unbreakable = true, proximity = nil},
	nurgle_summon = {army = gb:get_army(gb:get_non_player_alliance_num(), "nurgle_summon"), starts_enabled = false, unbreakable = true, proximity = 0},
	nurgle_failed_summon = {army = gb:get_army(gb:get_non_player_alliance_num(), "nurgle_failed_summon"), starts_enabled = false, unbreakable = false, proximity = 0},
	nurgle_furies = {army = gb:get_army(gb:get_non_player_alliance_num(), "nurgle_furies"), starts_enabled = false, unbreakable = false, proximity = 0},

	tzeentch_defenders = {army = gb:get_army(gb:get_non_player_alliance_num(), "tzeentch_defenders"), starts_enabled = true, unbreakable = false, proximity = 75},
	tzeentch_cultist = {army = gb:get_army(gb:get_non_player_alliance_num(), "tzeentch_cultist"), starts_enabled = true, unbreakable = true, proximity = nil},
	tzeentch_summon = {army = gb:get_army(gb:get_non_player_alliance_num(), "tzeentch_summon"), starts_enabled = false, unbreakable = true, proximity = 0},
	tzeentch_failed_summon = {army = gb:get_army(gb:get_non_player_alliance_num(), "tzeentch_failed_summon"), starts_enabled = false, unbreakable = false, proximity = 0},
	tzeentch_furies = {army = gb:get_army(gb:get_non_player_alliance_num(), "tzeentch_furies"), starts_enabled = false, unbreakable = false, proximity = 0},

	undivided_lord = {army = gb:get_army(gb:get_non_player_alliance_num(), "undivided_lord"), starts_enabled = true, unbreakable = false, proximity = 150},
	undivided_lower_1 = {army = gb:get_army(gb:get_non_player_alliance_num(), "undivided_lower_1"), starts_enabled = true, unbreakable = false, proximity = 100},
	undivided_lower_2 = {army = gb:get_army(gb:get_non_player_alliance_num(), "undivided_lower_2"), starts_enabled = true, unbreakable = false, proximity = 100},
	undivided_upper_1 = {army = gb:get_army(gb:get_non_player_alliance_num(), "undivided_upper_1"), starts_enabled = true, unbreakable = false, proximity = 100},
	undivided_upper_2 = {army = gb:get_army(gb:get_non_player_alliance_num(), "undivided_upper_2"), starts_enabled = true, unbreakable = false, proximity = 100},
	undivided_chosen = {army = gb:get_army(gb:get_non_player_alliance_num(), "undivided_chosen"), starts_enabled = true, unbreakable = false, proximity = 150},
	undivided_giants = {army = gb:get_army(gb:get_non_player_alliance_num(), "undivided_giants"), starts_enabled = true, unbreakable = false, proximity = 50},
	undivided_cannons = {army = gb:get_army(gb:get_non_player_alliance_num(), "undivided_cannons"), starts_enabled = true, unbreakable = false, proximity = 50}
}

for _, key in ipairs(enemy_script_ids) do
	local armies = enemy_armies[key]
	local army = enemy_armies[key].army

	for i = 1, army.sunits:count() do
		army.sunits:item(i):take_control()
		army.sunits:item(i):prevent_rallying_if_routing()
	end

	if not armies.starts_enabled then
		army:set_enabled(false)
	end

	if armies.unbreakable then
		for i = 1, army.sunits:count() do
			army.sunits:item(i):set_stat_attribute("unbreakable", true)
		end
	end
end

for _, key in ipairs(ally_script_ids) do
	local armies = allied_armies[key]
	local army = allied_armies[key].army

	if not armies.starts_enabled then
		army:set_enabled(false)
	end

	if armies.unbreakable then
		for i = 1, army.sunits:count() do
			army.sunits:item(i):set_stat_attribute("unbreakable", true)
		end
	else
		for i = 1, army.sunits:count() do
			sunit = army.sunits:item(i)
			sunit:rout_on_casualties(0.2)
			sunit:prevent_rallying_if_routing(true)
		end
	end
end


-------------------------------------------------------------------------------------------------
----------------------------------------- ARMY TELEPORT -----------------------------------------
-------------------------------------------------------------------------------------------------


-- Undivided
enemy_armies.undivided_lord.army.sunits:item(1).uc:teleport_to_location(v(128, 245), 189, 3.06)

enemy_armies.undivided_lower_1.army.sunits:item(1).uc:teleport_to_location(v(-89, 71), 224, 41)
enemy_armies.undivided_lower_1.army.sunits:item(2).uc:teleport_to_location(v(-4, -16), 224, 41)
enemy_armies.undivided_lower_1.army.sunits:item(3).uc:teleport_to_location(v(-46, 27), 224, 41)

enemy_armies.undivided_lower_2.army.sunits:item(1).uc:teleport_to_location(v(285, -248), 253, 41)
enemy_armies.undivided_lower_2.army.sunits:item(2).uc:teleport_to_location(v(256, -168), 253, 41)
enemy_armies.undivided_lower_2.army.sunits:item(3).uc:teleport_to_location(v(274, -206), 253, 41)

enemy_armies.undivided_upper_1.army.sunits:item(1).uc:teleport_to_location(v(-32, 251), 245, 41)
enemy_armies.undivided_upper_1.army.sunits:item(2).uc:teleport_to_location(v(-50, 291), 245, 41)

enemy_armies.undivided_upper_2.army.sunits:item(1).uc:teleport_to_location(v(348, 25), 203, 41)
enemy_armies.undivided_upper_2.army.sunits:item(2).uc:teleport_to_location(v(246, 78), 210, 41)
enemy_armies.undivided_upper_2.army.sunits:item(3).uc:teleport_to_location(v(297, 49), 205, 41)

enemy_armies.undivided_chosen.army.sunits:item(1).uc:teleport_to_location(v(157, 247), 157, 30)
enemy_armies.undivided_chosen.army.sunits:item(2).uc:teleport_to_location(v(102, 256), 230, 30)

enemy_armies.undivided_giants.army.sunits:item(1).uc:teleport_to_location(v(-147, 169), 188, 2.60)
enemy_armies.undivided_giants.army.sunits:item(2).uc:teleport_to_location(v(86, -64), 188, 2.60)

enemy_armies.undivided_cannons.army.sunits:item(1).uc:teleport_to_location(v(-139, 157), 185, 2.60)
enemy_armies.undivided_cannons.army.sunits:item(2).uc:teleport_to_location(v(97, -79), 240, 2.60)

-- Khorne
enemy_armies.khorne_cultist.army.sunits:item(1).uc:teleport_to_location(v(-264, 221), 336, 1)

enemy_armies.khorne_defenders.army.sunits:item(1).uc:teleport_to_location(v(-239, 173), 169, 40)
enemy_armies.khorne_defenders.army.sunits:item(2).uc:teleport_to_location(v(-314, 181), 198, 40)
enemy_armies.khorne_defenders.army.sunits:item(3).uc:teleport_to_location(v(-256, 303), 199, 40)

enemy_armies.khorne_summon.army.sunits:item(1).uc:teleport_to_location(v(-268, 245), 139, 1)

enemy_armies.khorne_failed_summon.army.sunits:item(1).uc:teleport_to_location(v(-258, 238), 136, 35)

enemy_armies.khorne_furies.army.sunits:item(1).uc:teleport_to_location(v(-278, 247), 152, 40)

-- Slaanesh
enemy_armies.slaanesh_cultist.army.sunits:item(1).uc:teleport_to_location(v(126, -32), 47, 1)

enemy_armies.slaanesh_defenders.army.sunits:item(1).uc:teleport_to_location(v(202, -68), 146, 40)
enemy_armies.slaanesh_defenders.army.sunits:item(2).uc:teleport_to_location(v(86, -1), 268, 40)
enemy_armies.slaanesh_defenders.army.sunits:item(3).uc:teleport_to_location(v(216, 20), 72, 40)

enemy_armies.slaanesh_summon.army.sunits:item(1).uc:teleport_to_location(v(144, -17), 221, 1)

enemy_armies.slaanesh_failed_summon.army.sunits:item(1).uc:teleport_to_location(v(132, -28), 225, 35)

enemy_armies.slaanesh_furies.army.sunits:item(1).uc:teleport_to_location(v(144, -17), 221, 40)


-- tzeentch
enemy_armies.tzeentch_cultist.army.sunits:item(1).uc:teleport_to_location(v(7, 368), 285, 1)

enemy_armies.tzeentch_defenders.army.sunits:item(1).uc:teleport_to_location(v(71, 372), 106, 40)
enemy_armies.tzeentch_defenders.army.sunits:item(2).uc:teleport_to_location(v(-14, 325), 171, 40)
enemy_armies.tzeentch_defenders.army.sunits:item(3).uc:teleport_to_location(v(38, 334), 170, 40)

enemy_armies.tzeentch_summon.army.sunits:item(1).uc:teleport_to_location(v(-7, 369), 127, 4)

enemy_armies.tzeentch_failed_summon.army.sunits:item(1).uc:teleport_to_location(v(6, 359), 138, 35)

enemy_armies.tzeentch_furies.army.sunits:item(1).uc:teleport_to_location(v(5, 366), 119, 32)
enemy_armies.tzeentch_furies.army.sunits:item(2).uc:teleport_to_location(v(5, 366), 119, 32)


-- nurgle
enemy_armies.nurgle_cultist.army.sunits:item(1).uc:teleport_to_location(v(244, 223), 34, 1)

enemy_armies.nurgle_defenders.army.sunits:item(1).uc:teleport_to_location(v(208, 249), 242, 40)
enemy_armies.nurgle_defenders.army.sunits:item(2).uc:teleport_to_location(v(290, 191), 187, 40)
enemy_armies.nurgle_defenders.army.sunits:item(3).uc:teleport_to_location(v(326, 314), 218, 40)

enemy_armies.nurgle_summon.army.sunits:item(1).uc:teleport_to_location(v(266, 251), 214, 4.5)

enemy_armies.nurgle_failed_summon.army.sunits:item(1).uc:teleport_to_location(v(262, 245), 210, 37)

enemy_armies.nurgle_furies.army.sunits:item(1).uc:teleport_to_location(v(251, 239), 217, 40)
enemy_armies.nurgle_furies.army.sunits:item(2).uc:teleport_to_location(v(251, 239), 217, 40)

-- sacrifices
-- Khorne
enemy_armies.sacrifice_khorne.army.sunits:item(1).uc:teleport_to_location(v(-274, 243), 331, 22)
-- Slaanesh
enemy_armies.sacrifice_slaanesh.army.sunits:item(1).uc:teleport_to_location(v(145, -14), 40, 22)
-- Tzeentch
enemy_armies.sacrifice_tzeentch.army.sunits:item(1).uc:teleport_to_location(v(-14, 377), 300, 22)
-- Nurgle
enemy_armies.sacrifice_nurgle.army.sunits:item(1).uc:teleport_to_location(v(261, 249), 36, 22)

-------------------------------------------------------------------------------------------------
----------------------------------------- SUMMONING RITUALS ---------------------------------------------
-------------------------------------------------------------------------------------------------

enemy_armies.sacrifice_khorne.army:message_on_casualties("khorne_interrupted", 0.95)
enemy_armies.sacrifice_slaanesh.army:message_on_casualties("slaanesh_interrupted", 0.95)
enemy_armies.sacrifice_tzeentch.army:message_on_casualties("tzeentch_interrupted", 0.95)
enemy_armies.sacrifice_nurgle.army:message_on_casualties("nurgle_interrupted", 0.95)

enemy_armies.khorne_cultist.army:message_on_casualties("khorne_stopped", 0.95)
enemy_armies.slaanesh_cultist.army:message_on_casualties("slaanesh_stopped", 0.95)
enemy_armies.tzeentch_cultist.army:message_on_casualties("tzeentch_stopped", 0.95)
enemy_armies.nurgle_cultist.army:message_on_casualties("nurgle_stopped", 0.95)

for _, id in ipairs(god_ids) do
	gb:add_listener(
		id.."_stopped",
		function()
			local ritual = rituals[id]
			if ritual.complete == false then
				ritual.complete = true

				enemy_armies[id.."_failed_summon"].army.sunits:item(1):kill(true)
				enemy_armies[id.."_summon"].army.sunits:item(1):kill(true)
				enemy_armies[id.."_cultist"].army.sunits:item(1):kill(false)

				-- despawn the enemy sacrifice and replace it with an allied one in the same position
				local pos = enemy_armies["sacrifice_"..id].army.sunits:centre_point()
				local bearing = enemy_armies["sacrifice_"..id].army.sunits:average_bearing()
				local width = enemy_armies["sacrifice_"..id].army.sunits:width()
				enemy_armies["sacrifice_"..id].army.sunits:item(1):kill(true)
				
				allied_armies["sacrifice_"..id].army.sunits:item(1).uc:teleport_to_location(pos, bearing, width)
				allied_armies["sacrifice_"..id].army:set_enabled(true)
				allied_armies["sacrifice_"..id].army:attack()

				kill_unspawned_furies(id)

				-- Now that the ritual is over, set all remaining units from this god to attack
				bm:callback(function()
					enemy_armies[id.."_defenders"].army:attack()
				end, 5000)

				gb:queue_help_on_message("ritual_stopped", "wh3_dlc25_qb_emp_elspeth_deaths_timekeeper_hint_05", 3000)
				sm:trigger_message("ritual_stopped")

				bm:complete_objective(ritual.objective)
				remove_objective_after_delay(ritual.objective, 5)
			end
		end
	)
	
	gb:add_listener(
		id.."_interrupted",
		function()
			local ritual = rituals[id]
			if ritual.complete == false then
				ritual.complete = true

				
				enemy_armies[id.."_summon"].army.sunits:item(1):kill(true)
				enemy_armies["sacrifice_"..id].army.sunits:item(1):kill()
				allied_armies["sacrifice_"..id].army.sunits:item(1):kill(true)
				kill_unspawned_furies(id)

				enemy_armies[id.."_failed_summon"].army:set_enabled(true)

				-- Now that the ritual is over, set all remaining units from this god to attack
				bm:callback(function()
					enemy_armies[id.."_failed_summon"].army:attack()
					enemy_armies[id.."_defenders"].army:attack()
					enemy_armies[id.."_cultist"].army:attack()
				end, 5000)


				-- delaying the portal slightly as the summons seem to take a few seconds to appear
				play_composite_scene(ritual.portal, 5, 2)

				gb:queue_help_on_message("ritual_interrupted", "wh3_dlc25_qb_emp_elspeth_deaths_timekeeper_hint_04", 3000)
				sm:trigger_message("ritual_interrupted")

				bm:complete_objective(ritual.objective)
				remove_objective_after_delay(ritual.objective, 5)
			end
		end
	)

	gb:add_listener(
		id.."_complete",
		function()
			local ritual = rituals[id]

			enemy_armies["sacrifice_"..id].army.sunits:item(1):kill()
			enemy_armies[id.."_failed_summon"].army.sunits:item(1):kill(true)
			allied_armies["sacrifice_"..id].army.sunits:item(1):kill(true)

			enemy_armies[id.."_summon"].army:set_enabled(true)

			-- Now that the ritual is over, set all remaining units from this god to attack
			bm:callback(function()
				enemy_armies[id.."_summon"].army:attack()
				enemy_armies[id.."_defenders"].army:attack()
				enemy_armies[id.."_cultist"].army:attack()
			end, 5000)	

			play_composite_scene(ritual.explosion, 2)
			-- delaying the portal slightly as the summons seem to take a few seconds to appear
			play_composite_scene(ritual.portal, 5, 2)

			gb:queue_help_on_message("ritual_complete", "wh3_dlc25_qb_emp_elspeth_deaths_timekeeper_hint_03", 3000)
			sm:trigger_message("ritual_complete")
		end
	)
end


function start_fury_spawn_waves()
	for _, id in ipairs(god_ids) do
		-- periodically spawn furies from each portal
		-- We take the total ritual time and divide it by the max furies + 1 to stagger the spawns of the furies over the max timer duration (and leaves a buffer at the end for the final big summon)
		local fury_spawn_timer = rituals[id].timer / (fury_spawn_count[id].max + 1)

		bm:repeat_callback(
			function()
				if fury_spawn_count[id].current < fury_spawn_count[id].max then
					fury_spawn_count[id].current = fury_spawn_count[id].current + 1

					play_composite_scene(rituals[id].portal, 5, 2)

					enemy_armies[id.."_furies"].army.sunits:item(fury_spawn_count[id].current):set_enabled(true)
					enemy_armies[id.."_furies"].army:halt()

					bm:callback(function()
						enemy_armies[id.."_furies"].army:attack()
					end, 5000)
				end
			end,
			fury_spawn_timer * 1000
		)
	end
end


function kill_unspawned_furies(id)
	-- kill any remaining unspawned furies for the provided god
	local next_fury = fury_spawn_count[id].current + 1

	for i = next_fury, fury_spawn_count[id].max do
		out.design("killing: "..id.."_furies number: "..i)
		enemy_armies[id.."_furies"].army.sunits:item(i):kill(true)
	end

	fury_spawn_count[id].current = fury_spawn_count[id].max
end


function play_composite_scene(scene, seconds, delay)
	delay = delay or 0
	bm:callback(function()
		scene:enable(true, true)

		if is_number(seconds) and seconds > 0 then
			bm:callback(function()
				scene:enable(false, true)
			end, (seconds * 1000))
		end
	end, (delay * 1000))
end


-------------------------------------------------------------------------------------------------
------------------------------------------- GENERAL BEHAVIOURS ------------------------------------------
-------------------------------------------------------------------------------------------------

function setup_army_attack_proximities()
	-- Switch each army to attack once their individual proximity is breeched
	for _, key in ipairs(enemy_script_ids) do
		local armies = enemy_armies[key]
		local army = enemy_armies[key].army

		-- set proximity to nil if you never want the units to attack
		-- set proximity to 0 if you want them to attack from spawn
		if armies.proximity and armies.proximity > 0 then
			army:message_on_proximity_to_enemy(key.."_proximity", armies.proximity)

			gb:add_listener(
				key.."_proximity",
				function()
					army:attack()
				end
			)
		elseif(armies.proximity and armies.proximity == 0 and armies.starts_enabled) then
			army:attack()
		end
	end
end

function setup_army_casualty_watchers()
	-- If a scripted army takes 50% damage, switch them to attack. This stops armies going from 100->0 from artillery while just standing there.
	for _, key in ipairs(enemy_script_ids) do
		local armies = enemy_armies[key]
		local army = enemy_armies[key].army

		if(armies.proximity ~= nil and armies.proximity > 0) then
			army:message_on_casualties(key.."_casualties", 0.4)

			gb:add_listener(
				key.."_casualties",
				function()
					army:attack()
				end
			)
		end

		for i = 1, army.sunits:count() do 
			unit_routing_check(army.sunits:item(i))
		end
	end
end

function unit_routing_check(sunit)
	bm:watch(
		function()
			return true
		end,
		5000,
		function()
			if sunit.unit:is_routing() then
				sunit:kill_proportion_over_time(1, 10000)
			else
				unit_routing_check(sunit)
			end
		end
	)
end


-------------------------------------------------------------------------------------------------
------------------------------------ OBJECTIVES & HINTS -----------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("start", "wh3_dlc25_qb_emp_elspeth_deaths_timekeeper_hint_01")

function update_ritual_timers()
	for _, id in ipairs(god_ids) do
		local ritual = rituals[id]

		if ritual.complete == false and ritual.timer >= 0 then
			bm:set_objective(ritual.objective, ritual.timer)

			ritual.timer = ritual.timer - 1

			if ritual.timer == 30 then
				gb:queue_help_on_message("time_warning", "wh3_dlc25_qb_emp_elspeth_deaths_timekeeper_hint_02", 3000)
				sm:trigger_message("time_warning")
			end
		elseif ritual.complete == false then
			ritual.complete = true

			bm:fail_objective(ritual.objective)

			sm:trigger_message(id.."_complete")

			remove_objective_after_delay(ritual.objective, 5)
		end
	end
end

function update_ritual_objectives()
	local final_attack_order_given = false

	bm:repeat_callback(
		function()
			update_ritual_timers()

			if rituals.nurgle.complete and rituals.khorne.complete and rituals.slaanesh.complete and rituals.tzeentch.complete and final_attack_order_given == false then
				final_attack_order_given = true
				bm:set_objective("wh3_dlc25_qb_emp_elspeth_deaths_timekeeper_core")

				-- All rituals are over, set all enemies to attack
				for _, key in ipairs(enemy_script_ids) do
					local army = enemy_armies[key].army

					army:attack()
				end
			end
		end, 
		1000
	)
end

function remove_objective_after_delay(objective, seconds)
	bm:callback(function()
		bm:remove_objective(objective)
	end, seconds * 1000)
end


-------------------------------------------------------------------------------------------------
--------------------------------------------- DEFEAT --------------------------------------------
-------------------------------------------------------------------------------------------------


-- The player only loses if they actually get defeated.
ga_player:message_on_casualties("player_dead", 0.99)
ga_player:message_on_shattered_proportion("player_dead", 0.99, true)

gb:add_listener(
    "player_dead",
	function()
		bm:out("Player has died")

		bm:callback(
			function()
				-- end the battle after a short delay
				out.design("end battle")
				sm:trigger_message("end_battle_defeat")
			end,
			5000
		)
    end
)

enemy_armies.undivided_lord.army:force_victory_on_message("end_battle_defeat", 3)

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------

--The player wins when defeating all enemy forces

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

