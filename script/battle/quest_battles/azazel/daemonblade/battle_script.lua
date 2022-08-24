-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Azazel
-- Daemonblade
-- Greed Grove
-- Attacker

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------
load_script_libraries();

bm:camera():fade(true, 0);

gb = generated_battle:new(
	true,                                    	  	-- screen starts black
	true,                                    	  	-- prevent deployment for player
	true,                                      		-- prevent deployment for ai
	function() end_deployment_phase() end,          -- intro cutscene function
	false                                      		-- debug mode
);

--preload stuttering fix
intro_cinematic_file = "script/battle/quest_battles/_cutscene/managers/coc_qb_azazel.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);

--Composite Scenes For Portal NEED TO AMEND THIS ONCE FINAL COMP SCENE ADDED
--portal_cs = "composite_scene/wh3_main_slaanesh_gate_portal.csc";

--gb:start_terrain_composite_scene_on_message("battle_started", portal_cs);
--gb:stop_terrain_composite_scene_on_message("battle_started", portal_cs, 9900);

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------
--Player Army
ga_player = gb:get_army(gb:get_player_alliance_num(), 1, "");
--Enemy Armies
ga_wood_elf_rush = gb:get_army(gb:get_non_player_alliance_num(), "enemy_wef_rush");
ga_wood_elf_chokepoint_large = gb:get_army(gb:get_non_player_alliance_num(), "enemy_wef_chokepoint_large");
ga_wood_elf_wizard_guards_left = gb:get_army(gb:get_non_player_alliance_num(), "enemy_wef_wizard_guards_left");
ga_wood_elf_wizard_guards_right = gb:get_army(gb:get_non_player_alliance_num(), "enemy_wef_wizard_guards_right");
ga_wood_elf_spellweaver = gb:get_army(gb:get_non_player_alliance_num(), "enemy_wef_spellweaver");

ga_high_elf_chokepoint_large = gb:get_army(gb:get_non_player_alliance_num(), "enemy_hef_chokepoint_large");
ga_high_elf_wizard_guards = gb:get_army(gb:get_non_player_alliance_num(), "enemy_hef_wizard_guards");
ga_high_elf_arch_mage = gb:get_army(gb:get_non_player_alliance_num(), "enemy_hef_arch_mage");
ga_high_elf_mage = gb:get_army(gb:get_non_player_alliance_num(), "enemy_hef_mage");

-------------------------------------------------------------------------------------------------
----------------------------------------- ARMY TELEPORT -----------------------------------------
-------------------------------------------------------------------------------------------------
function battle_start_teleport_units()
	bm:out("\tbattle_start_teleport_units() called");

	----------------------------------- Player Deployment Setup ------------------------------------
	--Azazel
	ga_player.sunits:item(1).uc:teleport_to_location(v(-211, 90), 135, 5);

	----------------------------------- Enemy Deployment Setup -------------------------------------
	--Wizards
	ga_high_elf_arch_mage.sunits:item(1).uc:teleport_to_location(v(280, -179), 110, 5);
	ga_high_elf_mage.sunits:item(1).uc:teleport_to_location(v(303, -173), -160, 5);
	ga_wood_elf_spellweaver.sunits:item(1).uc:teleport_to_location(v(287, -200), 20, 5);

	--Wizard Defenders
	ga_high_elf_wizard_guards.sunits:item(1).uc:teleport_to_location(v(265, -190), -60, 30);
	ga_high_elf_wizard_guards.sunits:item(2).uc:teleport_to_location(v(282, -160), -60, 30);
	ga_wood_elf_wizard_guards_left.sunits:item(1).uc:teleport_to_location(v(263, -230), -100, 40);
	ga_wood_elf_wizard_guards_right.sunits:item(1).uc:teleport_to_location(v(315, -140), -10, 40);

end;

battle_start_teleport_units();	

-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------
wh3_intro_sfx_00 = new_sfx("WH3_DLC20_QB_Daemonblade_Sweetener");

wh3_main_sfx_01 = new_sfx("play_wh3_dlc20_qb_sla_azazel_daemonblade_01");
wh3_main_sfx_02 = new_sfx("play_wh3_dlc20_qb_sla_azazel_daemonblade_02");
wh3_main_sfx_03 = new_sfx("play_wh3_dlc20_qb_sla_azazel_daemonblade_03");
wh3_main_sfx_04 = new_sfx("play_wh3_dlc20_qb_sla_azazel_daemonblade_04");
wh3_main_sfx_05 = new_sfx("play_wh3_dlc20_qb_sla_azazel_daemonblade_05");

-------------------------------------------------------------------------------------------------
------------------------------------------- CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------
function end_deployment_phase()
	bm:out("\tend_deployment_phase() called");
		
	local cam = bm:camera();
	
	-- REMOVE ME
	cam:fade(true, 0);
	
	-- declare cutscene
	local cutscene_intro = cutscene:new_from_cindyscene(
		"cutscene_intro", 																-- unique string name for cutscene
		ga_player.sunits,															-- unitcontroller over player's army
		function() intro_cutscene_end() end,											-- what to call when cutscene is finished
		"script/battle/quest_battles/_cutscene/managers/coc_qb_azazel.CindySceneManager",			-- path to cindyscene
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
			local cam = bm:camera();
			cam:fade(true, 0);
			bm:stop_cindy_playback(true);
			
			if player_units_hidden then
				ga_player:set_enabled(false)
			end;
						
			bm:callback(function() cam:fade(false, 0.5) end, 500);
			bm:hide_subtitles();
		end
	);
	

	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000);

	cutscene_intro:action(
		function()
			player_units_hidden = false;
		end, 
		200
	);	
	
	-- Voiceover and Subtitles --

	cutscene_intro:action(function() cutscene_intro:play_sound(wh3_intro_sfx_00) end, 100);
	
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc20_qb_sla_azazel_daemonblade_01", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_dlc20_qb_sla_azazel_daemonblade_01"));
				bm:show_subtitle("wh3_dlc20_qb_sla_azazel_daemonblade_01", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc20_qb_sla_azazel_daemonblade_02", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_dlc20_qb_sla_azazel_daemonblade_02"));
				bm:show_subtitle("wh3_dlc20_qb_sla_azazel_daemonblade_02", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc20_qb_sla_azazel_daemonblade_03", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_dlc20_qb_sla_azazel_daemonblade_03"));
				bm:show_subtitle("wh3_dlc20_qb_sla_azazel_daemonblade_03", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc20_qb_sla_azazel_daemonblade_04", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_dlc20_qb_sla_azazel_daemonblade_04"));
				bm:show_subtitle("wh3_dlc20_qb_sla_azazel_daemonblade_04", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc20_qb_sla_azazel_daemonblade_05", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_dlc20_qb_sla_azazel_daemonblade_05"));
				bm:show_subtitle("wh3_dlc20_qb_sla_azazel_daemonblade_05", false, true);
			end
	);

	cutscene_intro:start();
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
	cam:fade(true, 0);
	cam:fade(false, 0);
end;

-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------
--Stopping enemy from firing until the cutscene is done
ga_player:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_player:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);

ga_wood_elf_rush:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_wood_elf_rush:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);
ga_wood_elf_chokepoint_large:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_wood_elf_chokepoint_large:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);
ga_wood_elf_wizard_guards_left:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_wood_elf_wizard_guards_left:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);
ga_wood_elf_wizard_guards_right:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_wood_elf_wizard_guards_right:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);
ga_wood_elf_spellweaver:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_wood_elf_spellweaver:change_behaviour_active_on_message("release_wizards", "fire_at_will", true, true);

ga_high_elf_chokepoint_large:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_high_elf_chokepoint_large:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);
ga_high_elf_wizard_guards:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_high_elf_wizard_guards:change_behaviour_active_on_message("release_wizards", "fire_at_will", true, true);
ga_high_elf_arch_mage:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_high_elf_arch_mage:change_behaviour_active_on_message("release_wizards", "fire_at_will", true, true);
ga_high_elf_mage:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_high_elf_mage:change_behaviour_active_on_message("release_wizards", "fire_at_will", true, true);


--Defend Chokepoint Large
ga_high_elf_chokepoint_large:defend_on_message("01_intro_cutscene_end", 20, -144, 100);
ga_wood_elf_chokepoint_large:defend_on_message("01_intro_cutscene_end", 63, -160, 50);

ga_high_elf_chokepoint_large:message_on_rout_proportion("release_chokepoint_large", 0.75);
ga_wood_elf_chokepoint_large:message_on_rout_proportion("release_chokepoint_large", 0.75);

ga_high_elf_chokepoint_large:release_on_message("release_chokepoint_large");
ga_wood_elf_chokepoint_large:release_on_message("release_chokepoint_large");

--Defend Wizards
--Wizards
ga_high_elf_arch_mage:defend_on_message("01_intro_cutscene_end",280, -179, 2);
ga_high_elf_mage:defend_on_message("01_intro_cutscene_end",303, -173, 2);
ga_wood_elf_spellweaver:defend_on_message("01_intro_cutscene_end",287, -200, 2);

--If player gets within range release the wizards
ga_player:message_on_proximity_to_position("release_wizards", v(285, 1089, -179), 140);
daemonblade_portal = "composite_scene/wh3_main_slaanesh_gate_portal.csc";
gb:start_terrain_composite_scene_on_message("battle_started", daemonblade_portal, 100);	
gb:stop_terrain_composite_scene_on_message("release_wizards", daemonblade_portal, 1000);

ga_high_elf_arch_mage:release_on_message("release_wizards");
ga_high_elf_mage:release_on_message("release_wizards");
ga_wood_elf_spellweaver:release_on_message("release_wizards");

--Wizard Defenders
ga_high_elf_wizard_guards:defend_on_message("01_intro_cutscene_end", 265, -190, 40);
ga_wood_elf_wizard_guards_left:defend_on_message("01_intro_cutscene_end", 263, -230, 10);
ga_wood_elf_wizard_guards_right:defend_on_message("01_intro_cutscene_end", 315, -140, 10);

ga_high_elf_wizard_guards:release_on_message("release_wizards");
ga_wood_elf_wizard_guards_left:release_on_message("release_wizards");
ga_wood_elf_wizard_guards_right:release_on_message("release_wizards");

ga_high_elf_chokepoint_large:message_on_rout_proportion("release_wizard_defenders", 0.75);
ga_wood_elf_chokepoint_large:message_on_rout_proportion("release_wizard_defenders", 0.75);
ga_high_elf_wizard_guards:release_on_message("release_wizard_defenders");
ga_wood_elf_wizard_guards_left:release_on_message("release_wizard_defenders");
ga_wood_elf_wizard_guards_right:release_on_message("release_wizard_defenders");

--Rush Force
ga_wood_elf_rush:rush_on_message("01_intro_cutscene_end", 1000);
ga_wood_elf_rush:message_on_rout_proportion("release_wef_rush", 0.75);
ga_wood_elf_rush:release_on_message("release_wef_rush", 1000);

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_on_message("01_intro_cutscene_end", "wh3_dlc20_qb_chs_azazel_daemonblade_hints_main_objective");
gb:complete_objective_on_message("release_wizards", "wh3_dlc20_qb_chs_azazel_daemonblade_hints_main_objective", 500)
gb:set_objective_on_message("release_wizards", "wh3_dlc20_qb_chs_azazel_daemonblade_hints_main_objective_2");

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("01_intro_cutscene_end", "wh3_dlc20_qb_chs_azazel_daemonblade_hints_start_battle", 7000, 2000, 0);
gb:queue_help_on_message("release_wizards", "wh3_dlc20_qb_chs_azazel_daemonblade_hints_mages_interrupted");
