-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Nagash
-- By Aleksandar Radulov
-- Nagash Must Die


-------------------------------------------------------------------------------------------------
------------------------------------------- HEADERS ---------------------------------------------	
-------------------------------------------------------------------------------------------------

load_script_libraries();                            -- Load all our script libraries so lua can access our battle logic
bm = battle_manager:new(empire_battle:new());       -- Create a battle manager. This is able to listen to the battle and send messages accordingly.
gb = generated_battle:new(                          -- Load a generated battle, used for scripted battles.
    false,                                          -- screen starts black
    false,                                          -- prevent Player deployment
	false,											-- prevent AI deployment
	function() end_deployment_phase() end,          -- intro cutscene function
    false                                           -- debug mode
);
gb:set_cutscene_during_deployment(true)

gb:message_on_time_offset("start", 100)

-------------------------------------
----------INTRO CUTSCENE VO----------
-------------------------------------
local sfx_cutscene_sweetener_intro_play = new_sfx("Play_Movie_WH3_DLC29_QB_Nagash_Intro", true, false)
local sfx_cutscene_sweetener_intro_stop = new_sfx("Stop_Movie_WH3_DLC29_QB_Nagash_Intro", false, false)

-------------------------------------------------------------------------------------------------
------------------------------------------ CUTSCENE ---------------------------------------------	
-------------------------------------------------------------------------------------------------
function end_deployment_phase()
    bm:out("\tend_deployment_phase() called")

    local cam = bm:camera()

    cam:fade(true, 0)

	local cutscene_intro = cutscene:new_from_cindyscene(
		"cutscene_intro", 																				-- unique string name for cutscene
		ga_player.sunits,																				-- unitcontroller over player's army
		function() intro_cutscene_end() end,															-- what to call when cutscene is finished
		"script/battle/quest_battles/_cutscene/managers/wh3_nagash_qb_m01.CindySceneManager",		    -- path to cindyscene
		1,																								-- blend in time (s)
		1																								-- blend out time (s)
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
					
			ga_bst.sunits:set_enabled(true)
			bm:callback(function() cam:fade(false, 1) end, 10)
			bm:hide_subtitles()
		end
	)

	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000)

	cutscene_intro:action(
		function()
			ga_bst.sunits:set_enabled(false)
			ga_player.sunits:item(1):set_enabled(false)
		end, 
		200
	)

	cutscene_intro:action(
		function()
			ga_bst.sunits:set_enabled(true)
		end, 
		20000
	)

	-- Voiceover and Subtitles --
	cutscene_intro:action(function() cutscene_intro:play_sound(sfx_cutscene_sweetener_intro_play) end, 100);

	cutscene_intro:add_cinematic_trigger_listener(
	"Play_wh3_dlc29_nag_nagash_staff_of_power_01", 
		function()
			cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_nag_nagash_staff_of_power_01"));
			bm:show_subtitle("wh3_dlc29_nag_nagash_nagash_must_die_intro_01", false, true);
		end	
	)

	cutscene_intro:add_cinematic_trigger_listener(
	"Play_wh3_dlc29_nag_nagash_staff_of_power_02", 
		function()
			cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_nag_nagash_staff_of_power_02"));
			bm:show_subtitle("wh3_dlc29_nag_nagash_nagash_must_die_intro_02", false, true);
		end	
	)

	cutscene_intro:add_cinematic_trigger_listener(
	"Play_wh3_dlc29_nag_nagash_staff_of_power_03", 
		function()
			cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_nag_nagash_staff_of_power_03"));
			bm:show_subtitle("wh3_dlc29_nag_nagash_nagash_must_die_intro_03", false, true);
		end	
	)

	cutscene_intro:add_cinematic_trigger_listener(
	"Play_wh3_dlc29_nag_nagash_staff_of_power_04", 
		function()
			cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_nag_nagash_staff_of_power_04"));
			bm:show_subtitle("wh3_dlc29_nag_nagash_nagash_must_die_intro_04", false, true);
			bm:callback(function() cam:fade(true, 0.5) end, 14500)
		end	
	)

    cutscene_intro:start()
end

function intro_cutscene_end()
	play_sound_2D(sfx_cutscene_sweetener_intro_stop)
	sm:trigger_message("intro_cutscene_end")
	ga_player.sunits:item(1):set_enabled(true)
	-- player_units_hidden = false;
	-- ga_player:set_enabled(true)

	--camera position
    camera_target=v(0, 130, -80, -1)
    camera_position=v(-70, 250, -310, -1)
    bm:scroll_camera_with_cutscene(
        camera_position,
        camera_target,
        0.5
        )
	
end

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

-- Player Army Setup
ga_player = gb:get_army(gb:get_player_alliance_num())

-- Enemy Armies Setup
ga_bst = gb:get_army(gb:get_non_player_alliance_num(), "bst_assault")
ga_chs_1 = gb:get_army(gb:get_non_player_alliance_num(), "chs_invasion_1")
ga_dae_kho = gb:get_army(gb:get_non_player_alliance_num(), "chs_invasion_khorne_1")
ga_dae_nur = gb:get_army(gb:get_non_player_alliance_num(), "chs_invasion_nurgle_1")
ga_dae_tze = gb:get_army(gb:get_non_player_alliance_num(), "chs_invasion_tzeentch_1")
ga_dae_sla = gb:get_army(gb:get_non_player_alliance_num(), "chs_invasion_slaanesh_1")
ga_chs_2 = gb:get_army(gb:get_non_player_alliance_num(), "chs_invasion_2")


-------------------------------------------------------------------------------------------------
----------------------------------------- SPAWN ZONES -------------------------------------------
-------------------------------------------------------------------------------------------------

-- Get Spawn Zones
chs_reinf_zone = bm:get_spawn_zone_collection_by_name("chs_reinf")
kho_teleport_reinf_zone = bm:get_spawn_zone_collection_by_name("kho_teleport_line")
nur_teleport_reinf_zone = bm:get_spawn_zone_collection_by_name("nur_teleport_line")
sla_teleport_reinf_zone = bm:get_spawn_zone_collection_by_name("sla_teleport_line")
tze_teleport_reinf_zone = bm:get_spawn_zone_collection_by_name("tze_teleport_line")

-- Assign Spawn Zones
ga_chs_1:assign_to_spawn_zone_from_collection_on_message("start", chs_reinf_zone, false)
ga_dae_kho:assign_to_spawn_zone_from_collection_on_message("start", kho_teleport_reinf_zone, false)
ga_dae_nur:assign_to_spawn_zone_from_collection_on_message("start", nur_teleport_reinf_zone, false)
ga_dae_tze:assign_to_spawn_zone_from_collection_on_message("start", tze_teleport_reinf_zone, false)
ga_dae_sla:assign_to_spawn_zone_from_collection_on_message("start", sla_teleport_reinf_zone, false)
ga_chs_2:assign_to_spawn_zone_from_collection_on_message("start", chs_reinf_zone, false)


-------------------------------------------------------------------------------------------------
-------------------------------------------- PHASES ---------------------------------------------
-------------------------------------------------------------------------------------------------

-- Phase I
ga_bst:rush()
ga_bst:message_on_casualties("beastmen_damaged", 0.5)
ga_bst:message_on_casualties("beastmen_defeated", 0.8)
ga_bst:rout_over_time_on_message("beastmen_defeated", 10000)

-- Phase II 
ga_chs_1:reinforce_on_message("beastmen_damaged")
ga_chs_1:rush()
ga_chs_1:message_on_casualties("release_chaos_2", 0.5)
ga_chs_1:message_on_casualties("chaos_1_defeated", 1)

ga_dae_kho:reinforce_on_message("beastmen_damaged", 20000)
ga_dae_nur:reinforce_on_message("beastmen_damaged", 25000)
ga_dae_tze:reinforce_on_message("beastmen_damaged", 30000)
ga_dae_sla:reinforce_on_message("beastmen_damaged", 35000)

ga_dae_kho:rush()
ga_dae_nur:rush()
ga_dae_tze:rush()
ga_dae_sla:rush()

-- Phase III 
ga_chs_2:reinforce_on_message("release_chaos_2")
ga_chs_2:rush()
ga_chs_2:message_on_casualties("chaos_2_defeated", 1)
gb:message_on_all_messages_received("chaos_defeated", "chaos_1_defeated", "chaos_2_defeated")



-------------------------------------------------------------------------------------------------
------------------------------------- OBJECTIVE MANAGEMENT  -------------------------------------
-------------------------------------------------------------------------------------------------

-- Objective 1 
gb:set_objective_with_leader_on_message("battle_started", "wh3_dlc29_qb_nag_nagash_nagash_must_die_objective_1")
gb:complete_objective_on_message("beastmen_defeated", "wh3_dlc29_qb_nag_nagash_nagash_must_die_objective_1")

-- Objective 2
gb:set_objective_with_leader_on_message("beastmen_damaged", "wh3_dlc29_qb_nag_nagash_nagash_must_die_objective_2")
gb:complete_objective_on_message("chaos_defeated", "wh3_dlc29_qb_nag_nagash_nagash_must_die_objective_2")

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------
gb:queue_help_on_message("battle_started", "wh3_dlc29_qb_nag_nagash_must_die_hint_01")
gb:queue_help_on_message("beastmen_damaged", "wh3_dlc29_qb_nag_nagash_must_die_hint_02")
gb:queue_help_on_message("release_chaos_2", "wh3_dlc29_qb_nag_nagash_must_die_hint_03")

-------------------------------------------------------------------------------------------------
----------------------------------------- WIN CONDITION -----------------------------------------
-------------------------------------------------------------------------------------------------

ga_player:force_victory_on_message("chaos_defeated", 2500)
ga_player:message_on_rout_proportion("player_defeated", 1)
gb:add_listener(
	"player_defeated",
	function()
		bm:force_battle_end(gb:get_non_player_alliance_num(), "scripted", true, true)		-- Forces defeat on the player, end the battle immediately, force the player to be the loser
	end
)