-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Yuan Bo (The Jade Dragon)
-- Dragon's Fang
-- Map
-- Attacker

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
------------------------------------------------------------------------------------------------

load_script_libraries();

gb = generated_battle:new(
	false,                                      		-- screen starts black
	false,                                      		-- prevent deployment for player
	true,                                	      		-- prevent deployment for ai
	function() end_deployment_phase() end,          	-- intro cutscene function
	false                                      			-- debug mode
);

gb:set_cutscene_during_deployment(true);

-- preload stuttering fix
intro_cinematic_file = "script/battle/quest_battles/_cutscene/managers/cth_dragons_fang.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);

-------------------------------------------------------------------------------------------------
------------------------------------------- CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------

function end_deployment_phase()
bm:out("\tend_deployment_phase() called");
		
local cam = bm:camera();
		
local cutscene_intro = cutscene:new_from_cindyscene(
    -- unique string name for cutscene
    "cutscene_intro",
    -- unitcontroller or scriptunits collection over player's army
    ga_player_01.sunits,
    -- end callback
    function() intro_cutscene_end() end,
    -- path to cindy scene
    intro_cinematic_file,
    -- optional fade in/fade out durations
    0,
    0
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
						
			bm:callback(function() cam:fade(false, 0.5) end, 500);
			bm:hide_subtitles();
		end
	);
	
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000);

	-- Voiceover and Subtitles --
	cutscene_intro:action(function() cutscene_intro:play_sound(new_sfx("Play_Movie_WH3_DLC24_QB_The_Dragons_Fang_Sweetener")) end, 100);
	
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc24_qb_cth_yuan_bo_dragons_fang_01", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc24_qb_cat_yuan_bo_the_dragons_fang_01"));
				bm:show_subtitle("wh3_dlc24_qb_cth_yuan_bo_dragons_fang_pt_01", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc24_qb_cth_yuan_bo_dragons_fang_02", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc24_qb_cat_yuan_bo_the_dragons_fang_02"));
				bm:show_subtitle("wh3_dlc24_qb_cth_yuan_bo_dragons_fang_pt_02", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc24_qb_cth_yuan_bo_dragons_fang_03", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc24_qb_cat_yuan_bo_the_dragons_fang_03"));
				bm:show_subtitle("wh3_dlc24_qb_cth_yuan_bo_dragons_fang_pt_03", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc24_qb_cth_yuan_bo_dragons_fang_04", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc24_qb_cat_yuan_bo_the_dragons_fang_04"));
				bm:show_subtitle("wh3_dlc24_qb_cth_yuan_bo_dragons_fang_pt_04", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc24_qb_cth_yuan_bo_dragons_fang_05", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc24_qb_cat_yuan_bo_the_dragons_fang_05"));
				bm:show_subtitle("wh3_dlc24_qb_cth_yuan_bo_dragons_fang_pt_05", false, true);
			end
	);

	cutscene_intro:start();
end;

function intro_cutscene_end()
	play_sound(v(0,0),new_sfx("Play_Movie_WH3_DLC24_QB_Unmute", false, false));
	gb.sm:trigger_message("01_intro_cutscene_end");
end;

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

--player army
ga_player_01 = gb:get_army(gb:get_player_alliance_num());

--enemy armies
ga_ai_cathay_01 = gb:get_army(gb:get_non_player_alliance_num(), "cathay_traitors");
ga_ai_cathay_alchemist_01 = gb:get_army(gb:get_non_player_alliance_num(), "metal_alchemist");
ga_ai_cathay_alchemist_02 = gb:get_army(gb:get_non_player_alliance_num(), "fire_alchemist");
ga_ai_nurgle_02 = gb:get_army(gb:get_non_player_alliance_num(), "plaguebearer_horde");
ga_ai_nurgle_03 = gb:get_army(gb:get_non_player_alliance_num(), "rot_flies");
ga_ai_nurgle_04 = gb:get_army(gb:get_non_player_alliance_num(), "unclean_ones");
ga_ai_nurgle_05 = gb:get_army(gb:get_non_player_alliance_num(), "daemon_prince");

boss_01 = ga_ai_cathay_alchemist_01.sunits:item(1);
boss_02 = ga_ai_cathay_alchemist_02.sunits:item(1);

-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------
gb:message_on_time_offset("start", 1000);
gb:message_on_time_offset("plaguebearers_alerted", 80000);
gb:message_on_time_offset("rot_flies_alerted", 120000);
gb:message_on_time_offset("unclean_ones_alerted", 160000);
gb:message_on_time_offset("daemon_prince_alerted", 200000);

ga_ai_cathay_01.sunits:set_always_visible(true);

gb:message_on_time_offset("bonus_objective_01", 7500);
gb:add_listener(
	"bonus_objective_01",
	function()
		boss_01:add_ping_icon(15);
	end
);

gb:message_on_time_offset("bonus_objective_02", 12500);
gb:add_listener(
	"bonus_objective_02",
	function()
		boss_02:add_ping_icon(15);
	end
);

ga_ai_cathay_alchemist_01:message_on_rout_proportion("metal_alchemist_dead",0.99);
ga_ai_cathay_alchemist_02:message_on_rout_proportion("fire_alchemist_dead",0.99);



ga_ai_cathay_01:attack_on_message("start");
ga_ai_cathay_alchemist_01:attack_on_message("start");
ga_ai_cathay_alchemist_02:attack_on_message("start");

ga_ai_nurgle_02:reinforce_on_message("plaguebearers_alerted",1000);
ga_ai_nurgle_02:message_on_any_deployed("plaguebearers_advance"); 
ga_ai_nurgle_02:rush_on_message("plaguebearers_advance");

-- The enemy will reinforce and rush the player after a set duration
ga_ai_nurgle_03:reinforce_on_message("rot_flies_alerted",1000);
ga_ai_nurgle_03:message_on_any_deployed("rot_flies_advance"); 
ga_ai_nurgle_03:rush_on_message("rot_flies_advance");

-- The enemy will reinforce and rush the player after a set duration
ga_ai_nurgle_04:reinforce_on_message("unclean_ones_alerted",1000);
ga_ai_nurgle_04:message_on_any_deployed("unclean_ones_advance"); 
ga_ai_nurgle_04:rush_on_message("unclean_ones_advance");

-- The enemy will reinforce and rush the player after a set duration
ga_ai_nurgle_05:reinforce_on_message("daemon_prince_alerted",1000);
ga_ai_nurgle_05:message_on_any_deployed("daemon_prince_advance"); 
ga_ai_nurgle_05:rush_on_message("daemon_prince_advance");

gb:add_listener(
	"fire_alchemist_dead",
	function()
		boss_01:remove_ping_icon();
	end,
	true
);

gb:add_listener(
	"metal_alchemist_dead",
	function()
		boss_02:remove_ping_icon();
	end,
	true
);
-------------------------------------------------------------------------------------------------
------------------------------ ARMY ABILITY UNLOCKS ---------------------------------------------
-------------------------------------------------------------------------------------------------

local sm = get_messager();
-------ARMY ABILITY-------
local army_abilities_metal = "wh3_dlc20_cataclysm_bound_gehennas_golden_globe";

function show_army_abilities_metal(value)
	local army_ability_parent = get_army_ability_parent();
	find_uicomponent(army_ability_parent, "button_holder_" .. army_abilities_metal):SetVisible(value);
end;

function highlight_army_ability(value)
	local army_ability_parent = get_army_ability_parent();
	find_uicomponent(army_ability_parent, "button_ability_" .. army_abilities_metal):Highlight(value, false, 100);
end;

function get_army_ability_parent()
	return find_uicomponent(core:get_ui_root(), "army_ability_parent");
end;

show_army_abilities_metal(false);

sm:add_listener(
	"metal_alchemist_dead",
	function()
		show_army_abilities_metal(true);
		
		bm:callback(
			function()
				highlight_army_ability(true);
			end,
			1000
		);
	
		bm:callback(
			function()
				highlight_army_ability(false);
			end,
			7000
		);
	end
);


local army_abilities_fire = "wh3_dlc20_cataclysm_bound_magma_storm";

function show_army_abilities_fire(value)
	local army_ability_parent = get_army_ability_parent();
	
	find_uicomponent(army_ability_parent, "button_holder_" .. army_abilities_fire):SetVisible(value);

end;

function highlight_army_ability(value)
	local army_ability_parent = get_army_ability_parent();

	find_uicomponent(army_ability_parent, "button_ability_" .. army_abilities_fire):Highlight(value, false, 100);

end;

function get_army_ability_parent()
	return find_uicomponent(core:get_ui_root(), "army_ability_parent");
end;

show_army_abilities_fire(false);

sm:add_listener(
	"fire_alchemist_dead",
	function()
		show_army_abilities_fire(true);
		
		bm:callback(
			function()
				highlight_army_ability(true);
			end,
			1000
		);
		
		bm:callback(
			function()
				highlight_army_ability(false);
			end,
			7000
		);
	end
);

-------------------------------------------------------------------------------------------------
---------------------------------------- OBJECTIVES ---------------------------------------------
-------------------------------------------------------------------------------------------------
gb:set_objective_on_message("start", "wh_main_qb_objective_attack_defeat_army");

gb:set_objective_on_message("bonus_objective_01", "wh3_dlc24_qb_cth_yuan_bo_dragons_fang_bonus_01"); 
gb:complete_objective_on_message("fire_alchemist_dead", "wh3_dlc24_qb_cth_yuan_bo_dragons_fang_bonus_01");

gb:set_objective_on_message("bonus_objective_02", "wh3_dlc24_qb_cth_yuan_bo_dragons_fang_bonus_02");
gb:complete_objective_on_message("metal_alchemist_dead", "wh3_dlc24_qb_cth_yuan_bo_dragons_fang_bonus_02");

gb:queue_help_on_message("start", "wh3_dlc24_qb_cth_yuan_bo_dragons_fang_01");
gb:queue_help_on_message("plaguebearers_advance", "wh3_dlc24_qb_cth_yuan_bo_dragons_fang_02");
gb:queue_help_on_message("rot_flies_advance", "wh3_dlc24_qb_cth_yuan_bo_dragons_fang_03");
gb:queue_help_on_message("unclean_ones_advance", "wh3_dlc24_qb_cth_yuan_bo_dragons_fang_04");
gb:queue_help_on_message("daemon_prince_advance", "wh3_dlc24_qb_cth_yuan_bo_dragons_fang_05");
