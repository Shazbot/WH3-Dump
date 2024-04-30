-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Tamurkhan (werekin chieftain devoted battle)
-- Skraelsbane
-- central_chaos_wastes
-- Attacker

load_script_libraries()


gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	true,                                     	-- prevent deployment for ai
	function() play_intro_cutscene() end,      	-- intro cutscene function -- nil, --
	false                                      	-- debug mode
)

wh3_intro_sfx_01 = new_sfx("Play_wh3_dlc25_qb_nur_tamurkhan_chieftain_werekin")
gb:set_cutscene_during_deployment(true)

-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO CUTSCENE -----------------------------------------
-------------------------------------------------------------------------------------------------

function play_intro_cutscene()
	
	local cam = bm:camera()

	cam:fade(false, 1)
	
	ga_playerarmy.sunits:set_always_visible(true)
	ga_enemy1.sunits:set_always_visible(true)
	ga_enemy2.sunits:set_always_visible(true)
	ga_guards.sunits:set_always_visible(true)
	ga_jabber.sunits:set_always_visible(true)

	local cutscene_intro = cutscene:new_from_cindyscene(
        -- unique string name for cutscene
        "cutscene_intro",
        -- unitcontroller or scriptunits collection over player's army
        ga_playerarmy.sunits,
        -- end callback
        function() intro_cutscene_end() end,
        -- path to cindy scene
        "script\\battle\\quest_battles\\_cutscene\\managers\\skraelsbane_m01.CindySceneManager",
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
		"Play_wh3_dlc25_qb_nur_tamurkhan_chieftain_werekin", 
			function()
				cutscene_intro:play_sound(wh3_intro_sfx_01)
				bm:show_subtitle("wh3_dlc25_qb_nur_tamurkhan_chieftain_werekin", false, true)
			end
	)

	cutscene_intro:start()
end

function intro_cutscene_end()
	bm:hide_subtitles()
end

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------
jabber_waypoints = {
	{coords = v(413, 40, 295), complete = false},
	{coords = v(300, 44, 195), complete = false},
	{coords = v(290, 40, 78), complete = false},
	{coords = v(468, 42, 16), complete = false},
	{coords = v(385, 40, -72), complete = false},
	{coords = v(460, 45, -167), complete = false},
	{coords = v(270, 44, -182), complete = false},
	{coords = v(245, 45, -306), complete = false},
	{coords = v(342, 44, -408), complete = false}
}

--friendly factions
ga_playerarmy = gb:get_army(gb:get_player_alliance_num(), 1)
ga_ally = gb:get_army(gb:get_player_alliance_num(), "ally_1");

--enemy faction
ga_enemy1 = gb:get_army(gb:get_non_player_alliance_num(),"enemy_1")
ga_enemy2 = gb:get_army(gb:get_non_player_alliance_num(),"enemy_2")
ga_guards = gb:get_army(gb:get_non_player_alliance_num(),"guards")

--defining bosses in script
ga_jabber = gb:get_army(gb:get_non_player_alliance_num(), "jabberslythe")
skraelsbane = ga_jabber.sunits:item(1)

-------------------------------------------------------------------------------------------------
----------------------------------------- ARMY TELEPORT -----------------------------------------
-------------------------------------------------------------------------------------------------

skraelsbane.uc:teleport_to_location(v(250, 205), 90, 3.06)

ga_ally.sunits:item(1).uc:teleport_to_location(v(415, 295), 270, 40)
ga_ally.sunits:item(2).uc:teleport_to_location(v(470, 16), 270, 40)
ga_ally.sunits:item(3).uc:teleport_to_location(v(470, -170), 270, 40)
ga_ally.sunits:item(4).uc:teleport_to_location(v(355, -420), 270, 40)

ga_guards.sunits:item(1).uc:teleport_to_location(v(436, 267), 303, 33)
ga_guards.sunits:item(2).uc:teleport_to_location(v(483, 46), 206, 33)
ga_guards.sunits:item(3).uc:teleport_to_location(v(485, -206), 303, 33)
ga_guards.sunits:item(4).uc:teleport_to_location(v(374, -390), 217, 33)

-------------------------------------------------------------------------------------------------
---------------------------------- ORDERS & OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

--boss functions
gb:add_listener("battle_started", function() 
	ping1() 
	move_jabber()
end)

function ping1()
	skraelsbane:add_ping_icon(15)
	bm:set_objective("wh3_dlc25_qb_nur_tamurkhan_chieftain_werekin_objective_02")
	bm:queue_help_message("wh3_dlc25_qb_nur_tamurkhan_chieftain_werekin_hint_01", 8000, 2000)
	
	bm:out(">>>PING1<<<")
end

--boss killed function
if skraelsbane then
	bm:watch(
		function()
			return is_shattered_or_dead(skraelsbane)
		end,
		0,
		function()
			bm:out("*** skraelsbane is shattered or dead! ***")
			gb.sm:trigger_message("victory")
			ga_playerarmy:play_sound_charge()	--adds a charge/cheer sound effect when the unit dies
			bm:queue_help_message("wh3_dlc25_qb_nur_tamurkhan_chieftain_werekin_hint_04", 8000, 2000)
		end
	)
end

--release armies and make enemy charge player
gb:message_on_time_offset("battle_started", 1000)

skraelsbane:take_control()

for i = 1, ga_ally.sunits:count() do
	local sunit = ga_ally.sunits:item(i)
	sunit:take_control()
	sunit:set_stat_attribute("unbreakable", true)
end

for i = 1, ga_guards.sunits:count() do
	ga_guards.sunits:item(i):take_control()
end

ga_enemy1:attack_force_on_message("battle_started", ga_playerarmy, 1000)
ga_enemy2:attack_force_on_message("battle_started", ga_playerarmy, 1000)

function move_jabber()
	bm:watch(
		function()
			return true
		end,
		3000,
		function()
			local attacking_target = false

			for k, v in ipairs(jabber_waypoints) do
				if v.complete == false then
					for i = 1, ga_ally.sunits:count() do
						local sunit = ga_ally.sunits:item(i)

						if is_routing_or_dead(sunit) == false and skraelsbane.unit:unit_distance(sunit.unit) < 50 then
							attacking_target = true

							skraelsbane.uc:attack_unit(sunit.unit, true, true)
							break
						else
							attacking_target = false
							
							for j = 1, ga_ally.sunits:count() do
								if is_routing_or_dead(ga_ally.sunits:item(j)) then
									ga_guards.sunits:item(j).uc:release_control()
								end
							end
						end
					end
					
					if attacking_target == false then
						skraelsbane.uc:goto_location(v.coords, false)
					end

					break
				end
			end

			if jabber_waypoints[#jabber_waypoints].complete == false then
				move_jabber()
			else
				ga_jabber:release()
			end
		end,
		"payload_behaviour"
	)
end

for k, v in ipairs(jabber_waypoints) do
	ga_jabber:message_on_proximity_to_position("waypoint_"..k, v.coords, 20)
	gb:add_listener("waypoint_"..k, function() v.complete = true end)
end



-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------

--victory
gb:set_objective_on_message("battle_started", "wh3_dlc25_qb_nur_tamurkhan_chieftain_werekin_objective_02")
gb:set_objective_on_message("battle_started", "wh3_dlc25_qb_nur_tamurkhan_chieftain_survive_objective_01")
gb:set_objective_on_message("battle_started", "wh3_dlc25_qb_nur_tamurkhan_chieftain_werekin_objective_01")

ga_playerarmy:force_victory_on_message("victory", 30000)
ga_enemy1:rout_over_time_on_message("victory", 30000)
ga_enemy2:rout_over_time_on_message("victory", 30000)
gb:complete_objective_on_message("victory", "wh3_dlc25_qb_nur_tamurkhan_chieftain_werekin_objective_02", 1000)


--defeat
ga_playerarmy:message_on_commander_death("lord_dead", 1)
ga_playerarmy:message_on_casualties("lord_dead", 1)
ga_playerarmy:rout_over_time_on_message("lord_dead", 10000)
gb:fail_objective_on_message("lord_dead","wh3_dlc25_qb_nur_tamurkhan_chieftain_survive_objective_01")
ga_enemy1:force_victory_on_message("lord_dead", 10000)

ga_ally:message_on_casualties("ally_defeated", 0.99);
gb:fail_objective_on_message("ally_defeated", "wh3_dlc25_qb_nur_tamurkhan_chieftain_werekin_objective_01")
ga_enemy1:force_victory_on_message("ally_defeated", 3000)
gb:add_listener("ally_defeated", function() 
	bm:queue_help_message("wh3_dlc25_qb_nur_tamurkhan_chieftain_werekin_hint_05", 8000, 2000)
end)
