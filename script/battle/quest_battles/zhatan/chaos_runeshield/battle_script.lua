-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Zhatan
-- Chaos Runeshield
-- dar_infield_a / Catchment_25
-- Attacker

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------
load_script_libraries();

bm = battle_manager:new(empire_battle:new());

bm:camera():fade(true, 0);
gb = generated_battle:new(
	true,                                      		-- screen starts black
	true,                                      		-- prevent deployment for player
	true,                                      		-- prevent deployment for ai
	function() end_deployment_phase() end,          -- intro cutscene function
	false                                      		-- debug mode
);

--gb:set_cutscene_during_deployment(true);

--preload stuttering fix^^
intro_cinematic_file = "script/battle/quest_battles/_cutscene/managers/chd_qb_zhatan_m01.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

--friendly faction
ga_playerarmy = gb:get_army(gb:get_player_alliance_num(), 1);
ga_chdally = gb:get_army(gb:get_player_alliance_num(), 2, "ally_chd");

--enemy faction
ga_startenemy = gb:get_army(gb:get_non_player_alliance_num(),"enemy_starting");
ga_skvenemy = gb:get_army(gb:get_non_player_alliance_num(),"enemy_skv");
ga_orcenemy1 = gb:get_army(gb:get_non_player_alliance_num(),"enemy_main01");
ga_enemygrimgor = gb:get_army(gb:get_non_player_alliance_num(),"enemy_grimgor");

--defining bosses in script
grimgor_sunit = ga_enemygrimgor.sunits:get_sunit_by_type("wh_main_grn_cha_grimgor_ironhide");
warboss1_sunit = ga_orcenemy1.sunits:get_sunit_by_type("wh_main_grn_cha_orc_warboss_2");

--Zhatan & Grimgor & objective warbosses are fearless
ga_playerarmy.sunits:item(1):set_stat_attribute("unbreakable", true)
ga_startenemy.sunits:item(1):set_stat_attribute("unbreakable", true)
grimgor_sunit:set_stat_attribute("unbreakable", true)
warboss1_sunit:set_stat_attribute("unbreakable", true)

-------------------------------------------------------------------------------------------------
----------------------------------------- ARMY TELEPORT -----------------------------------------
-------------------------------------------------------------------------------------------------
function battle_start_teleport_units()
	bm:out("\tbattle_start_teleport_units() called");

	-- disable and hide unit groups
	ga_orcenemy1:set_enabled(false);
	ga_enemygrimgor:set_enabled(false);

	ga_playerarmy.sunits:item(1).uc:teleport_to_location(v(-313, -370), 90, 1);

end;

battle_start_teleport_units()

-------------------------------------------------------------------------------------------------
---------------------------------------- VO & SUBS  & Audio -------------------------------------
-------------------------------------------------------------------------------------------------
wh3_intro_sfx_00 = new_sfx("Play_Movie_WH3_DLC23_QB_Zhatan_Chaos_Runeshield_Sweetener");

wh3_main_sfx_01 = new_sfx("play_wh3_dlc23_qb_chd_zhatan_chaos_runeshield_01");
wh3_main_sfx_02 = new_sfx("play_wh3_dlc23_qb_chd_zhatan_chaos_runeshield_02");
wh3_main_sfx_03 = new_sfx("play_wh3_dlc23_qb_chd_zhatan_chaos_runeshield_03");

-------------------------------------------------------------------------------------------------
------------------------------------------- CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------
function end_deployment_phase()
	bm:out("\tend_deployment_phase() called");
	
	
	local cam = bm:camera();
	cam_pos = cam:position();
    cam_targ = cam:target();

	-- declare cutscene
	local cutscene_intro = cutscene:new_from_cindyscene(
		"cutscene_intro", 																-- unique string name for cutscene
		ga_playerarmy.sunits,																-- unitcontroller over player's army
		function() intro_cutscene_end() end,											-- what to call when cutscene is finished
		"script/battle/quest_battles/_cutscene/managers/chd_qb_zhatan_m01.CindySceneManager",			-- path to cindyscene
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
						
			bm:callback(function() cam:fade(false, 0.2) end, 500);
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
		"wh3_dlc23_qb_chd_zhatan_chaos_runeshield_01", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_dlc23_qb_chd_zhatan_chaos_runeshield_01"));
				bm:show_subtitle("wh3_dlc23_chd_zhatan_chaos_runeshield_pt_01", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc23_qb_chd_zhatan_chaos_runeshield_02", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_dlc23_qb_chd_zhatan_chaos_runeshield_02"));
				bm:show_subtitle("wh3_dlc23_chd_zhatan_chaos_runeshield_pt_02", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc23_qb_chd_zhatan_chaos_runeshield_03", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_dlc23_qb_chd_zhatan_chaos_runeshield_03"));
				bm:show_subtitle("wh3_dlc23_chd_zhatan_chaos_runeshield_pt_03", false, true);
			end
	);

	cutscene_intro:action(function() cam:fade(true, 1) end, 38400);

	cutscene_intro:start();

end;

function intro_cutscene_end()
	--cam:move_to(cam_pos, cam_targ, 0.25)
	cam:fade(false, 1);
	gb.sm:trigger_message("01_intro_cutscene_end")
	ga_playerarmy.sunits:release_control();
	bm:hide_subtitles()
end;

-------------------------------------------------------------------------------------------------
------------------------------------------ ORDERS -------------------------------------------
-------------------------------------------------------------------------------------------------
--Stopping from firing until the cutscene is done
ga_playerarmy:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_playerarmy:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);

--start the battle
ga_playerarmy:release_on_message("battle_started");
ga_chdally:release_on_message("battle_started");
ga_startenemy:release_on_message("battle_started");
ga_skvenemy:release_on_message("battle_started");

--Phase trigger
ga_startenemy:attack_force_on_message("battle_started", ga_chdally, 1000);
ga_skvenemy:attack_force_on_message("battle_started", ga_chdally, 1000);
ga_chdally:attack_force_on_message("battle_started", ga_startenemy, 1000);

ga_startenemy:message_on_rout_proportion("start_dead", 0.8);
ga_startenemy:message_on_casualties("start_dead", 0.8);
ga_startenemy:rout_over_time_on_message("start_dead", 10000);

ga_skvenemy:message_on_rout_proportion("skv_dead", 0.6);
ga_skvenemy:message_on_casualties("skv_dead", 0.6);
ga_skvenemy:rout_over_time_on_message("skv_dead", 7000);


gb:message_on_all_messages_received("ambush_call", "start_dead", "skv_dead");

--Phase 2 orders
gb:add_listener("ambush_call", function() ambush() end);
function ambush()
	ga_orcenemy1:set_enabled(true);
	ga_enemygrimgor:set_enabled(true);
	
	bm:out(">>>AMBUSHH<<<")
end

gb:add_listener("ambush_call", function() kill_the_spare() end);
function kill_the_spare()
        if ga_skvenemy.sunits:are_any_active_on_battlefield() == true
        then ga_skvenemy.sunits:kill_proportion(0.8, 0, true);
        end;
		
		if ga_startenemy.sunits:are_any_active_on_battlefield() == true
        then ga_startenemy.sunits:kill_proportion(0.8, 0, true);
        end;
	bm:out(">>>KILL THE SPARE<<<")	
end

ga_orcenemy1:release_on_message("ambush_call", 1000);
ga_enemygrimgor:release_on_message("ambush_call", 1000);
ga_orcenemy1:rush_on_message("ambush_call", 6000);
ga_enemygrimgor:rush_on_message("ambush_call", 6000);

--Objective Markers
gb:add_listener("ambush_call", function() ping() end);
function ping()
warboss1_sunit:add_ping_icon(15)
grimgor_sunit:add_ping_icon(15)
bm:out(">>>PINGGG<<<")
end

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

--objective listener messages
ga_playerarmy:message_on_commander_death("zhatan_dead", 1);

gb:set_objective_on_message("01_intro_cutscene_end", "wh3_dlc23_qb_chd_zhatan_chaos_runeshield_objective_02");
gb:complete_objective_on_message("ambush_call", "wh3_dlc23_qb_chd_zhatan_chaos_runeshield_objective_02", 2);

if grimgor_sunit then
	bm:watch(
		function()
			return is_shattered_or_dead(grimgor_sunit)
		end,
		0,
		function()
			bm:out("*** grimgor_sunit is shattered or dead! ***");
			gb.sm:trigger_message("grimgor_dead")
			ga_playerarmy:play_sound_charge()					--adds a charge/cheer sound effect when the unit dies
		end
	);
end;

if warboss1_sunit then
	bm:watch(
		function()
			return is_shattered_or_dead(warboss1_sunit)
		end,
		0,
		function()
			bm:out("*** warboss1_sunit is shattered or dead! ***");
			gb.sm:trigger_message("warboss1_dead")
			ga_playerarmy:play_sound_charge()					--adds a charge/cheer sound effect when the unit dies
		end
	);
end;

gb:set_objective_on_message("ambush_call", "wh3_dlc23_qb_chd_zhatan_chaos_runeshield_objective_01");
gb:complete_objective_on_message("victory", "wh3_dlc23_qb_chd_zhatan_chaos_runeshield_objective_01", 2);

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

--Army ability hiding and revealing---

local sm = get_messager();

--Switching army ability on after ambush called
local army_abilities = {
	"wh3_dlc23_army_abilities_guns_of_zharr",
};

function show_army_abilities(seq, value)
	local army_ability_parent = get_army_ability_parent();

	find_uicomponent(army_ability_parent, "button_holder_" .. army_abilities[seq]):SetVisible(value);
		
end;

function highlight_army_ability(seq, value)
	local army_ability_parent = get_army_ability_parent();

	find_uicomponent(army_ability_parent, "button_ability_" .. army_abilities[seq]):Highlight(value, false, 100);

end;

function get_army_ability_parent()
	return find_uicomponent(core:get_ui_root(), "army_ability_parent");
end;

for i = 1, #army_abilities do
	show_army_abilities(i, false);
end

sm:add_listener(
	"ambush_call",
	function()
		show_army_abilities(1, true);
		
		bm:callback(
			function()
				highlight_army_ability(1, true);
			end,
			1000
		);
		
		bm:callback(
			function()
				highlight_army_ability(1, false);
			end,
			30000
		);
	end
);

--REMOVE army ability after battle is over [PUT THAT HERE]


-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------
ga_playerarmy:rout_over_time_on_message("zhatan_dead", 15000);
ga_orcenemy1:rout_over_time_on_message("warboss1_dead", 90000);
ga_enemygrimgor:rout_over_time_on_message("grimgor_dead", 90000);
ga_playerarmy:message_on_casualties("zhatan_dead", 1);

gb:message_on_all_messages_received("victory", "warboss1_dead", "grimgor_dead");

ga_playerarmy:force_victory_on_message("victory", 20000); 
ga_enemygrimgor:force_victory_on_message("zhatan_dead", 18000); 
-------------------------------------------------------------------------------------------------
-------------------------------------------- SUBTITLES ------------------------------------------
-------------------------------------------------------------------------------------------------
gb:queue_help_on_message("zhatan_dead", "wh3_dlc23_qb_chd_zhatan_chaos_runeshield_hint_03", 6000, nil, 1000);
gb:queue_help_on_message("grimgor_dead", "wh3_dlc23_qb_chd_zhatan_chaos_runeshield_hint_06", 6000, nil, 1000);
gb:queue_help_on_message("warboss1_dead", "wh3_dlc23_qb_chd_zhatan_chaos_runeshield_hint_04", 6000, nil, 1000);
gb:queue_help_on_message("ambush_call", "wh3_dlc23_qb_chd_zhatan_chaos_runeshield_hint_07", 6000, nil, 1000);
gb:queue_help_on_message("ambush_call", "wh3_dlc23_qb_chd_zhatan_chaos_runeshield_hint_01", 6000, nil, 7000);
gb:queue_help_on_message("ambush_call", "wh3_dlc23_qb_chd_zhatan_chaos_runeshield_hint_08", 6000, nil, 13000);
gb:queue_help_on_message("ambush_call", "wh3_dlc23_qb_chd_zhatan_chaos_runeshield_hint_02", 6000, nil, 19000);
gb:queue_help_on_message("victory", "wh3_dlc23_qb_chd_zhatan_chaos_runeshield_hint_09", 6000, nil, 2000);
