-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Yuri Barkov
-- Prologue
-- Howling Citadel
-- Attacker

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries();

package.path = "script/battle/?.lua;"
require("wh3_battle_prologue_values");

--bm:camera():fade(true, 0);

gb = generated_battle:new(
	false,                                      		-- screen starts black
	true,                                      		-- prevent deployment for player
	true,                                      		-- prevent deployment for ai
	nil,          -- intro cutscene function
	false                                      		-- debug mode
);

-- Hide start battle button.
bm:show_start_battle_button(false)

-- Stop camera movement.
bm:enable_camera_movement(false)

bm:setup_victory_callback(function() check_win() end);

--preload stuttering fix
intro_cinematic_file = "script/battle/quest_battles/_cutscene/managers/bhc.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh3_main_sfx_01 = new_sfx("play_wh3_main_prologue_qb_howling_citadel_001_1");
wh3_main_sfx_02 = new_sfx("play_wh3_main_prologue_qb_howling_citadel_002_1");
wh3_main_sfx_03 = new_sfx("play_wh3_main_prologue_qb_howling_citadel_003_1");


-------------------------------------------------------------------------------------------------
------------------------------------------- CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------
function end_deployment_phase()
	bm:out("\tend_deployment_phase() called");
		
	local cam = bm:camera();
	
	-- declare cutscene
	local cutscene_intro = cutscene:new_from_cindyscene(
		"cutscene_intro", 																-- unique string name for cutscene
		ga_attacker_01.sunits,															-- unitcontroller over player's army
		function() cam:fade(false, 1) end,																			-- what to call when cutscene is finished
		"script/battle/quest_battles/_cutscene/managers/bhc.CindySceneManager",			-- path to cindyscene
		0,																				-- blend in time (s)
		0																				-- blend out time (s)
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

			bm:stop_cindy_playback(true);
			
			if player_units_hidden then
				ga_attacker_01:set_enabled(true)
			end;
			
			bm:hide_subtitles();

			bm:show_start_battle_button(true)
		end
	);
	

	--cutscene_intro:set_post_cutscene_fade_time(-0.1)
	
	-- set up actions on cutscene
	--cutscene_intro:action(function() cam:fade(false, 1) end, 1000);
	cutscene_intro:action(function() cam:fade(true, 1) end, 38695); --40s

	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_defender_01:set_enabled(true) 
		end, 
		200
	);	
	
	-- Voiceover and Subtitles --
	-- The traitor squanders his power!
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_main_prologue_qb_howling_citadel_001", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_main_prologue_qb_howling_citadel_001_1"));
				bm:show_subtitle("wh3_main_prologue_qb_howling_citadel_001", false, true);
			end
	);

	-- He takes the role of petty warlord, bartering with marauder scum!
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_main_prologue_qb_howling_citadel_002", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_main_prologue_qb_howling_citadel_002_1"));
				bm:show_subtitle("wh3_main_prologue_qb_howling_citadel_002", false, true);
			end
	);

	-- I have a Greater Daemon at my side… I will show them ALL how to wield true power!
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_main_prologue_qb_howling_citadel_003", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_main_prologue_qb_howling_citadel_003_1"));
				bm:show_subtitle("wh3_main_prologue_qb_howling_citadel_003", false, true);
			end
	);

	cutscene_intro:start();
end;

bm:register_phase_change_callback(
    "Deployed",
	function()
		local cam = bm:camera();
		cam:fade(false, 1)
		
		gb.sm:trigger_message("01_intro_cutscene_end")
    end
);

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------
--Player Army
ga_attacker_01 = gb:get_army(gb:get_player_alliance_num(), 1);
ga_attacker_reinforcements = gb:get_army(gb:get_player_alliance_num(), "bloodthirster"); -- Bloodthirster

--Enemy Armies
ga_defender_01 = gb:get_army(gb:get_non_player_alliance_num(), "defender"); -- Boyar Kurnz main army
ga_defender_reinforcements_west = gb:get_army(gb:get_non_player_alliance_num(), "reinforcements_west"); -- West reinforcements
ga_defender_reinforcements_east = gb:get_army(gb:get_non_player_alliance_num(), "reinforcements_east"); -- East reinforcements
ga_defender_reinforcements_south = gb:get_army(gb:get_non_player_alliance_num(), "reinforcements_south"); -- South reinforcements

-- build spawn zone collections
sz_collection_1 = bm:get_spawn_zone_collection_by_name("defender_reinforcements_west");
sz_collection_2 = bm:get_spawn_zone_collection_by_name("defender_reinforcements_east");
sz_collection_3 = bm:get_spawn_zone_collection_by_name("defender_reinforcements_south");
sz_collection_4 = bm:get_spawn_zone_collection_by_name("attacker_reinforcements");


-- assign reinforcement armies to spawn zones
ga_defender_reinforcements_west:assign_to_spawn_zone_from_collection_on_message("battle_started", sz_collection_1, false);
ga_defender_reinforcements_east:assign_to_spawn_zone_from_collection_on_message("battle_started", sz_collection_2, false);
ga_defender_reinforcements_south:assign_to_spawn_zone_from_collection_on_message("battle_started", sz_collection_3, false);
ga_attacker_reinforcements:assign_to_spawn_zone_from_collection_on_message("battle_started", sz_collection_4, false);

--Player deployment setup
bm:register_phase_change_callback(
        "Deployment", 
        function()
			bm:enable_camera_movement(true)
			
            local v_top_left = v(35, -325);
            local formation_width = 400;
 
            local sunits_player = bm:get_scriptunits_for_local_players_army();
            local uc = sunits_player:get_unitcontroller();
 
			uc:goto_location_angle_width(v_top_left, 0, formation_width);
			uc:change_group_formation("test_melee_forward_simple");
			--Yuri Barkov
			ga_attacker_01.sunits:item(1).uc:teleport_to_location(v(35, -430), 0, 1.4);
			--Zorya Solovyov
				if ga_attacker_01:are_unit_types_in_army("wh3_main_pro_ksl_cha_frost_maiden_ice_0") then
					ga_attacker_01.sunits:get_sunit_by_type("wh3_main_pro_ksl_cha_frost_maiden_ice_0").uc:teleport_to_location(v(40, -430), 0, 1.4);
				end

				if ga_attacker_01:are_unit_types_in_army("wh3_main_pro_ksl_cha_frost_maiden_ice_1") then
					ga_attacker_01.sunits:get_sunit_by_type("wh3_main_pro_ksl_cha_frost_maiden_ice_1").uc:teleport_to_location(v(40, -430), 0, 1.4);
				end	
				
				if ga_attacker_01:are_unit_types_in_army("wh3_main_pro_ksl_cha_frost_maiden_ice_2") then
					ga_attacker_01.sunits:get_sunit_by_type("wh3_main_pro_ksl_cha_frost_maiden_ice_2").uc:teleport_to_location(v(40, -430), 0, 1.4);
				end	
            uc:release_control();

			core:progress_on_loading_screen_dismissed(function() end_deployment_phase() local Loading_screen_sfx = new_sfx("Play_Movie_WH3_Prologue_Battle_Sweetener_Howling_Citadel");
				play_sound_2D(Loading_screen_sfx); end)
        end
    );


YuriInvulernableWhenRouting() -- Stop Yuri from being wounded.

-------------------------------------------------------------------------------------------------
----------------------------------------- ARMY TELEPORT -----------------------------------------
-------------------------------------------------------------------------------------------------

function battle_start_teleport_units()
	bm:out("\tbattle_start_teleport_units() called");
	
----------------------------------- Player Deployment Setup -------------------------------------






----------------------------------- Enemy Deployment Setup -------------------------------------

--Slavin Kurnz
ga_defender_01.sunits:item(1).uc:teleport_to_location(v(133, 365), 180, 1.4);
--Chaos Warriors
ga_defender_01.sunits:item(2).uc:teleport_to_location(v(166, 360), 180, 40);
--Chaos Warriors
ga_defender_01.sunits:item(3).uc:teleport_to_location(v(100, 360), 180, 40);
--Chaos Warriors
ga_defender_01.sunits:item(4).uc:teleport_to_location(v(-12, 335), 180, 30);
--Chaos Warriors
ga_defender_01.sunits:item(5).uc:teleport_to_location(v(-120, 335), 180, 30);
--Chaos Marauders
ga_defender_01.sunits:item(6).uc:teleport_to_location(v(133, 335), 180, 30);
--Chaos Marauders
ga_defender_01.sunits:item(7).uc:teleport_to_location(v(-65, 335), 180, 40);
--Chaos Marauders (Great Weapon)
ga_defender_01.sunits:item(8).uc:teleport_to_location(v(180, 335), 180, 30);
--Chaos Marauders (Great Weapon)
ga_defender_01.sunits:item(9).uc:teleport_to_location(v(90, 335), 180, 30);

--War Mammoth
ga_defender_01.sunits:item(10).uc:teleport_to_location(v(155, 335), 180, 6);
--War Mammoth
ga_defender_01.sunits:item(11).uc:teleport_to_location(v(112, 335), 180, 6);
--War Mammoth
ga_defender_01.sunits:item(12).uc:teleport_to_location(v(-90, 335), 180, 6);
--War Mammoth
ga_defender_01.sunits:item(13).uc:teleport_to_location(v(-35, 335), 180, 6);


end;

battle_start_teleport_units();
ga_attacker_01:release();

-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------
--gb:message_on_time_offset("01_intro_cutscene_end", 11000);

--ga_attacker_reinforcements
ga_attacker_reinforcements:reinforce_on_message("battle_started", 3000);
ga_attacker_reinforcements:message_on_deployed("move_to_pos");
ga_attacker_reinforcements:move_to_position_on_message("move_to_pos", v(25, -430));
ga_attacker_reinforcements:release_on_message("01_intro_cutscene_end");


--ga_defender_01 (Boyar Kurnz main army)
ga_defender_01:halt();
ga_defender_01:message_on_proximity_to_enemy("reinforce", 500); -- Reinforce West when the player army is within 500m
ga_defender_01:message_on_proximity_to_enemy("attack", 200); -- attack when the player is within 200m
ga_defender_01:message_on_under_attack("attack");
ga_defender_01:attack_on_message("attack");
ga_defender_01:advance_on_message("reinforce_south");

--ga_defender_reinforcements_west
ga_defender_reinforcements_west:reinforce_on_message("reinforce"); 
ga_defender_reinforcements_west:message_on_deployed("reinforcements_deployed_west");
ga_defender_reinforcements_west:attack_on_message("reinforcements_deployed_west");
ga_defender_reinforcements_west:message_on_casualties("reinforce_east", 0.1); --Reinforce East when reinforcements_west sustains x casualties

--ga_defender_reinforcements_east 
ga_defender_reinforcements_east:reinforce_on_message("reinforce_east");
ga_defender_reinforcements_east:message_on_deployed("reinforcements_deployed_east");
ga_defender_reinforcements_east:attack_on_message("reinforcements_deployed_east");
ga_defender_reinforcements_east:message_on_casualties("reinforce_south", 0.1); --Reinforce South when reinforcements_east sustains x casualties

--ga_defender_reinforcements_south
ga_defender_reinforcements_south:reinforce_on_message("reinforce_south");
ga_defender_reinforcements_south:message_on_deployed("reinforcements_deployed_south");
ga_defender_reinforcements_south:attack_on_message("reinforcements_deployed_south");

------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------
--Kill or rout Boyar Kurnz's forces
gb:set_objective_on_message("01_intro_cutscene_end", "wh3_main_qb_prologue_ksl_yuri_howling_citadel_hints_main_objective_1");
ga_defender_01:add_ping_icon_on_message("01_intro_cutscene_end", 15, 1, 10000);

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------
--We must reach the portal in the citadel. Kill those that stand in our way!
gb:queue_help_on_message("01_intro_cutscene_end", "wh3_main_qb_prologue_ksl_yuri_howling_citadel_hints_main_hint", 10000, 2000, 5000, false);

--Enemy reinforcements! Quickly, form up.
gb:queue_help_on_message("reinforce", "wh3_main_qb_prologue_ksl_yuri_howling_citadel_hints_reinforcements_1", 10000, 2000, 3000, false);

--More enemy reinforcements! Kurnz looks to slow our approach to the citadel.
gb:queue_help_on_message("reinforce_east", "wh3_main_qb_prologue_ksl_yuri_howling_citadel_hints_reinforcements_2", 10000, 2000, 3000, false);

--An attack from behind! Kurnz forces must have followed us here.
gb:queue_help_on_message("reinforce_south", "wh3_main_qb_prologue_ksl_yuri_howling_citadel_hints_reinforcements_3", 10000, 2000, 3000, false);

--The traitor, Boyar Kurnz, has finally been dealt with!
ga_defender_01:message_on_commander_dead_or_shattered("lord_dead");
gb:queue_help_on_message("lord_dead", "wh3_main_qb_prologue_ksl_yuri_howling_citadel_hints_lord_dead");

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

ga_defender_01.sunits:item(1):morale_behavior_fearless() -- Stop Kurnz routing

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------

function check_win()
	local player_army = bm:get_scriptunits_for_local_players_army();
	local yuri = player_army:get_general_sunit();
	if bm:victorious_alliance() == yuri.alliance_num then
		-- Stop end battle.
		gb:stop_end_battle(true)
	else
		bm:end_battle()
	end
end

bm:register_phase_change_callback(
    "VictoryCountdown",
	function()
		local player_army = bm:get_scriptunits_for_local_players_army();
		local yuri = player_army:get_general_sunit();
		if bm:victorious_alliance() == yuri.alliance_num then
			bm:out("Player has won!");
			common.setup_dynamic_loading_screen("prologue_battle_howling_citadel_outro", "prologue");

			-- Prevent battle from ending until we want it to
			bm:change_victory_countdown_limit(-1);

			bm:queue_help_message(
				"wh3_main_qb_prologue_ksl_yuri_howling_citadel_end_message", 
				5000, 
				2000, 
				true, 
				true,
				function()
					bm:callback(
						function()

							bm:callback(
								function()
									-- Unlock final achievement.
									bm:unlock_achievement("WH3_ACHIEVEMENT_PROLOGUE_COMPLETE")

									bm:steal_escape_key();
									bm:stop_advisor_queue(true);

									local movie_str = "warhammer3/prologue/pro_win";
									core:svr_save_registry_bool(movie_str:gsub("warhammer3/prologue/", ""), true);

									local mo = movie_overlay:new("prologue_outro", "warhammer3/prologue/pro_win");

									mo:set_skippable(false);

									mo:set_end_callback(
										function()
											-- End battle immediately
											bm:change_victory_countdown_limit(0);
											common.call_context_command("QuitToMainMenu");
											bm:release_escape_key()
										end
									);
									cam:fade(true, 0)
									mo:start();
								end,
								3000
							)
						end,
						7000
					)
				end
			)
		else
			bm:out("Player has lost!");

			-- try and load in the prologue_next_quote value from the prologue campaign
			local prologue_next_quote = tostring(core:svr_load_string("prologue_next_quote"));
			if prologue_next_quote then
				bm:out("prologue_next_quote is " .. tostring(prologue_next_quote));
				common.set_custom_loading_screen_text("wh3_prologue_loading_screen_quote_"..prologue_next_quote);
			else
				bm:out("prologue_next_quote is not set");
			end;
		end;
    end
)
