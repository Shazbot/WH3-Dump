load_script_libraries()

bm = battle_manager:new(empire_battle:new())

bm:camera():fade(true, 0)

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	true,                                     	-- prevent deployment for ai
	function() play_intro_cutscene() end,      -- intro cutscene function -- nil, --
	false                                      	-- debug mode
)

-------------------------------------------------------------------------------------------------
-------------------------------------------ARMY SETUP--------------------------------------------
-------------------------------------------------------------------------------------------------

--Player Army
ga_player = gb:get_army(gb:get_player_alliance_num(), 1, "")
--Enemy Armies
ga_enemy_nemesis_crown = gb:get_army(gb:get_non_player_alliance_num(), "enemy_nemesis_crown")
ga_enemy_monsters_1 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_monsters_1")
ga_enemy_monsters_2 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_monsters_2")
ga_enemy_spiders_1 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_spiders_1")
ga_enemy_spiders_2 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_spiders_2")
ga_enemy_night_goblins_1 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_night_goblins_1")
ga_enemy_night_goblins_2 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_night_goblins_2")

-------------------------------------------------------------------------------------------------
----------------------------------- INTRO CUTSCENE VARIATION ------------------------------------
-------------------------------------------------------------------------------------------------

--There is a default line for in cutscene that assumes at least 1 Warboss is alive
--We check if all Warbosses were killed and substitute in an alternate line which acknowledges all Warbosses killed prior to battle
local subtitle_line_2 = "wh3_dlc25_nemesis_crown_final_battle_02_default"
local sfx_line_2 = "Play_wh3_dlc25_nemesis_crown_final_battle_02_default"

local all_warbosses_killed_in_campaign = false 

--If the string is set to 1 the warbosses were killed during the campaign
local nc_night_goblins_killed = tonumber(core:svr_load_string("nemesis_crown_night_goblins_killed"))
local nc_spiders_killed = tonumber(core:svr_load_string("nemesis_crown_spiders_killed"))
local nc_monsters_killed = tonumber(core:svr_load_string("nemesis_crown_monsters_killed"))

--If all of the Nemesis Crown lords were killed in campaign prior to battle, play the alternate subtitle
if (nc_night_goblins_killed == 1) and (nc_spiders_killed == 1) and (nc_monsters_killed == 1) then
	all_warbosses_killed_in_campaign = true
	subtitle_line_2 = "wh3_dlc25_nemesis_crown_final_battle_02_alternate"
	sfx_line_2 = "Play_wh3_dlc25_nemesis_crown_final_battle_02_alternate"
end

wh3_intro_sfx_01 = new_sfx("Play_wh3_dlc25_nemesis_crown_final_battle_01_elspeth")
wh3_intro_sfx_02 = new_sfx(sfx_line_2)
wh3_intro_sfx_03 = new_sfx("Play_wh3_dlc25_nemesis_crown_final_battle_03")
wh3_intro_sfx_04 = new_sfx("Play_wh3_dlc25_nemesis_crown_final_battle_04")
wh3_intro_sfx_05 = new_sfx("Play_wh3_dlc25_nemesis_crown_final_battle_05")
wh3_intro_sfx_06 = new_sfx("Play_wh3_dlc25_nemesis_crown_final_battle_06_elspeth")

gb:set_cutscene_during_deployment(true)

-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO CUTSCENE -----------------------------------------
-------------------------------------------------------------------------------------------------

function play_intro_cutscene()
	
	local cam = bm:camera()

	cam:fade(false, 1)

	ga_player.sunits:item(1).uc:teleport_to_location(v(-309.1, -380.4), 45, 1.5) -- Lord

	ga_player.sunits:set_always_visible_no_hidden_no_leave_battle(true)
	ga_enemy_nemesis_crown.sunits:set_always_visible_no_hidden_no_leave_battle(true)
	ga_enemy_monsters_2.sunits:set_always_visible_no_hidden_no_leave_battle(true)
	ga_enemy_spiders_2.sunits:set_always_visible_no_hidden_no_leave_battle(true)
	ga_enemy_night_goblins_2.sunits:set_always_visible_no_hidden_no_leave_battle(true)

	
	local cutscene_intro = cutscene:new_from_cindyscene(
        -- unique string name for cutscene
        "cutscene_intro",
        -- unitcontroller or scriptunits collection over player's army
        ga_player.sunits,
        -- end callback
        function() intro_cutscene_end() end,
        -- path to cindy scene
        "script\\battle\\quest_battles\\_cutscene\\managers\\nemesis_crown_elspeth_m01.CindySceneManager",
        -- optional fade in/fade out durations
        0,
        2
	)

	-- skip callback
	cutscene_intro:set_skippable(
		true, 
		function()
			bm:stop_cindy_playback(true)
		end
	)

	-- set up subtitles
	local subtitles = cutscene_intro:subtitles()
	subtitles:set_alignment("bottom_centre")
	subtitles:clear()
	
	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc25_nemesis_crown_final_battle_01_elspeth", 
			function()
				cutscene_intro:play_sound(wh3_intro_sfx_01)
				bm:show_subtitle("wh3_dlc25_nemesis_crown_final_battle_01_elspeth", false, true)
			end
	)

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc25_nemesis_crown_final_battle_02_default", 
			function()
				cutscene_intro:play_sound(wh3_intro_sfx_02)
				bm:show_subtitle(subtitle_line_2, false, true)
			end
	)

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc25_nemesis_crown_final_battle_03", 
			function()
				cutscene_intro:play_sound(wh3_intro_sfx_03)
				bm:show_subtitle("wh3_dlc25_nemesis_crown_final_battle_03", false, true)
			end
	)

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc25_nemesis_crown_final_battle_04", 
			function()
				cutscene_intro:play_sound(wh3_intro_sfx_04)
				bm:show_subtitle("wh3_dlc25_nemesis_crown_final_battle_04", false, true)
			end
	)

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc25_nemesis_crown_final_battle_05", 
			function()
				cutscene_intro:play_sound(wh3_intro_sfx_05)
				bm:show_subtitle("wh3_dlc25_nemesis_crown_final_battle_05", false, true)
			end
	)
	
	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc25_nemesis_crown_final_battle_06_elspeth", 
			function()
				cutscene_intro:play_sound(wh3_intro_sfx_06)
				bm:show_subtitle("wh3_dlc25_nemesis_crown_final_battle_06_elspeth", false, true)
			end
	)

	cutscene_intro:start()
end

function intro_cutscene_end()
	bm:hide_subtitles()
end


---------------------------------
---- CAMPAIGN NIGHT GOBLINS -----
---------------------------------
 
function nemesis_crown_night_goblins_setup()
	if nc_night_goblins_killed == 1 then
		ga_enemy_night_goblins_1.sunits:set_invisible_to_all(true)
		ga_enemy_night_goblins_1.sunits:kill_proportion(1, false, true)
		ga_enemy_nemesis_crown.sunits:item(1).unit:disable_special_ability("wh3_dlc25_lord_passive_vessel_of_malice_icky", true)
		
		bm:out("Removing Night Goblin units")
	else
		ga_enemy_night_goblins_1.sunits:set_always_visible_no_hidden_no_leave_battle(true)
		gb:message_on_time_offset("nc_night_goblins_alive_campaign", 100)
		bm:out("Not removing Night Goblin units")
		rout_on_warboss_death(ga_enemy_night_goblins_1, {ga_enemy_night_goblins_1, ga_enemy_night_goblins_2}, "night_goblin_warboss_killed", {"release_night_goblins"})

		gb:add_listener(
			"night_goblin_warboss_killed",
			function()
				ga_enemy_nemesis_crown.sunits:item(1).unit:disable_special_ability("wh3_dlc25_lord_passive_vessel_of_malice_icky", true)
			end,
			true
		)

		--Night Goblin - Defend Position
		ga_enemy_night_goblins_1:defend_on_message("post_deployment_timer", -300, 290, 60)
		ga_enemy_night_goblins_1:message_on_rout_proportion("release_night_goblins", 0.8)		
		ga_enemy_night_goblins_1:release_on_message("release_night_goblins")

		ga_enemy_night_goblins_1:rush_on_message("reinforce_night_goblins")
		ga_enemy_night_goblins_2:message_on_rout_proportion("reinforce_night_goblins", 0.4)	
	end
end

---------------------------
---- CAMPAIGN SPIDERS -----
---------------------------

function nemesis_crown_spiders_setup()
	if nc_spiders_killed == 1 then		
		ga_enemy_spiders_1.sunits:set_invisible_to_all(true)
		ga_enemy_spiders_1.sunits:kill_proportion(1, false, true)
		ga_enemy_nemesis_crown.sunits:item(1).unit:disable_special_ability("wh3_dlc25_lord_passive_vessel_of_malice_gnashrak", true)

		bm:out("Removing Spider units")
	else
		ga_enemy_spiders_1.sunits:set_always_visible_no_hidden_no_leave_battle(true)
		gb:message_on_time_offset("nc_spiders_alive_campaign", 100)
		bm:out("Not removing Spider units")
		rout_on_warboss_death(ga_enemy_spiders_1, {ga_enemy_spiders_1, ga_enemy_spiders_2}, "spider_warboss_killed", {"release_spiders"})

		gb:add_listener(
			"spider_warboss_killed",
			function()
				ga_enemy_nemesis_crown.sunits:item(1).unit:disable_special_ability("wh3_dlc25_lord_passive_vessel_of_malice_gnashrak", true)
			end,
			true
		)

		--Spider Warboss - Defend Position
		ga_enemy_spiders_1:defend_on_message("post_deployment_timer", 240, -255, 60)
		ga_enemy_spiders_1:message_on_rout_proportion("release_spiders", 0.8)		
		ga_enemy_spiders_1:release_on_message("release_spiders")

		ga_enemy_spiders_1:rush_on_message("reinforce_spiders")
		ga_enemy_spiders_2:message_on_rout_proportion("reinforce_spiders", 0.4)	
	end
end

----------------------------
---- CAMPAIGN MONSTERS -----
----------------------------
 
function nemesis_crown_monsters_setup()
	if nc_monsters_killed == 1 then
		ga_enemy_monsters_1.sunits:set_invisible_to_all(true)
		ga_enemy_monsters_1.sunits:kill_proportion(1, false, true)
		ga_enemy_nemesis_crown.sunits:item(1).unit:disable_special_ability("wh3_dlc25_lord_passive_vessel_of_malice_luggn", true)

		bm:out("Removing Monster units")
	else
		ga_enemy_monsters_1.sunits:set_always_visible_no_hidden_no_leave_battle(true)
		gb:message_on_time_offset("nc_monsters_alive_campaign", 100)
		bm:out("Not removing Monsters units")
		rout_on_warboss_death(ga_enemy_monsters_1, {ga_enemy_monsters_1, ga_enemy_monsters_2}, "monster_warboss_killed", {"release_monsters"})

		gb:add_listener(
			"monster_warboss_killed",
			function()
				ga_enemy_nemesis_crown.sunits:item(1).unit:disable_special_ability("wh3_dlc25_lord_passive_vessel_of_malice_luggn", true)
			end,
			true
		)

		ga_enemy_monsters_1:rush_on_message("post_deployment_timer", 500)
		ga_enemy_monsters_1:message_on_rout_proportion("release_monsters", 0.8)		
		ga_enemy_monsters_1:release_on_message("release_monsters", 1000)
	end
end

--------------------------------
---- ROUT ON WARBOSS DEATH -----
--------------------------------

function rout_on_warboss_death(warboss, armies_to_rout, message_on_warboss_death, messages_to_block)
	warboss:message_on_commander_dead_or_shattered(message_on_warboss_death)
	
	for i = 1, #armies_to_rout do
		armies_to_rout[i]:rout_over_time_on_message(message_on_warboss_death, 500)
	end

	for j = 1, #messages_to_block do
		gb:block_message_on_message(messages_to_block[j], message_on_warboss_death, true)
	end
end

---------------
-----SETUP-----
---------------
--The battle_started gb message has some quirks so its safer to use a new message triggered from message_on_time_offset
--This message is used for any AI commands intended to be sent just after deploymeny has ended
gb:message_on_time_offset("post_deployment_timer", 100)

nemesis_crown_night_goblins_setup()
nemesis_crown_spiders_setup()
nemesis_crown_monsters_setup()


-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------
--Nemesis Crown Lord - Defend Position
ga_enemy_nemesis_crown:defend_on_message("post_deployment_timer", 150, 190, 60)
ga_enemy_nemesis_crown:message_on_rout_proportion("release_nemesis_crown_main", 0.4)
ga_enemy_nemesis_crown:release_on_message("release_nemesis_crown_main")
gb:message_on_all_messages_received("release_nemesis_crown_main", "release_night_goblins", "release_spiders", "release_monsters")
gb:message_on_all_messages_received("release_nemesis_crown_main", "night_goblin_warboss_killed", "spider_warboss_killed", "monster_warboss_killed")


--Nemesis Crown Lord - Forces Rout on Death
local all_enemy_armies = {ga_enemy_nemesis_crown, ga_enemy_night_goblins_1, ga_enemy_night_goblins_2, ga_enemy_spiders_1, ga_enemy_spiders_2, ga_enemy_monsters_1, ga_enemy_monsters_2}
rout_on_warboss_death(ga_enemy_nemesis_crown, all_enemy_armies, "nemesis_crown_killed", {"release_nemesis_crown_main", "release_night_goblins", "release_spiders", "release_monsters"})

--Night Goblins Forces - Rush Player
ga_enemy_night_goblins_2:rush_on_message("post_deployment_timer", 500)
ga_enemy_night_goblins_2:message_on_rout_proportion("release_night_goblin_rush", 0.8)
ga_enemy_night_goblins_2:release_on_message("release_night_goblin_rush", 1000)

--Spider Forces - Rush Player
ga_enemy_spiders_2:rush_on_message("post_deployment_timer", 500)
ga_enemy_spiders_2:message_on_rout_proportion("release_spider_rush", 0.8)
ga_enemy_spiders_2:release_on_message("release_spider_rush", 1000)

--Monster forces - Rush Player
ga_enemy_monsters_2:rush_on_message("post_deployment_timer", 500)
ga_enemy_monsters_2:message_on_rout_proportion("release_monster_rush", 0.8)
ga_enemy_monsters_2:release_on_message("release_monster_rush", 1000)

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

--Nemesis Crown Lord
gb:set_objective_on_message("post_deployment_timer", "wh3_dlc25_nemesis_crown_final_battle_objective_01")
gb:complete_objective_on_message("nemesis_crown_killed", "wh3_dlc25_nemesis_crown_final_battle_objective_01", 100)

--Monsters Warboss
gb:set_objective_on_message("nc_monsters_alive_campaign", "wh3_dlc25_nemesis_crown_final_battle_objective_02")
gb:complete_objective_on_message("monster_warboss_killed", "wh3_dlc25_nemesis_crown_final_battle_objective_02", 200)

--Night Goblin Warboss
gb:set_objective_on_message("nc_night_goblins_alive_campaign", "wh3_dlc25_nemesis_crown_final_battle_objective_03")
gb:complete_objective_on_message("night_goblin_warboss_killed", "wh3_dlc25_nemesis_crown_final_battle_objective_03", 300)

--Spiders Warboss
gb:set_objective_on_message("nc_spiders_alive_campaign", "wh3_dlc25_nemesis_crown_final_battle_objective_04")
gb:complete_objective_on_message("spider_warboss_killed", "wh3_dlc25_nemesis_crown_final_battle_objective_04", 400)


-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------
if all_warbosses_killed_in_campaign == false then
	gb:queue_help_on_message("post_deployment_timer", "wh3_dlc25_nemesis_crown_final_battle_hint_01", 7000, 2000, 0)
	gb:queue_help_on_message("post_deployment_timer", "wh3_dlc25_nemesis_crown_final_battle_hint_02", 7000, 2000, 7000)
end

gb:queue_help_on_message("post_deployment_timer", "wh3_dlc25_nemesis_crown_final_battle_hint_03", 7000, 2000, 7000)




