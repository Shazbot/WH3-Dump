local cam = bm:camera()
local cutscene_queue = {}

bm:camera():fade(true, 0);

-------------------------------------------------------------------------------------------------
---------------------------------------- COMPOSITE SCENES ---------------------------------------
-------------------------------------------------------------------------------------------------

herdstone_idle = "composite_scene/wh2_dlc17_battle_enviro_heart_of_the_dark_herdstone.csc";
herdstone_powerup = "composite_scene/wh2_dlc17_battle_enviro_heart_of_the_dark_herdstone_khorne.csc";
herdstone_powerloop = "composite_scene/wh2_dlc17_battle_enviro_heart_of_the_dark_herdstone_khorne_looping.csc";
bm:start_terrain_composite_scene(herdstone_idle);

-------------------------------------------------------------------------------------------------
--------------------------------------- AUDIO TRIGGERS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx = new_sfx("Play_Movie_Warhammer2_Heart_of_Dark_Oxyotl_Intro");
wh2_middlebattle1_sfx = new_sfx("Play_Movie_Warhammer2_Heart_of_Dark_Oxyotl_MidBattle1");
wh2_middlebattle2_sfx = new_sfx("Play_Movie_Warhammer2_Heart_of_Dark_Oxyotl_MidBattle2");
wh2_middlebattle3_sfx = new_sfx("Play_Movie_Warhammer3_Heart_of_Dark_Oxyotl_MidBattle2");

-------------------------------------------------------------------------------------------------
---------------------------------------------- VO -----------------------------------------------
-------------------------------------------------------------------------------------------------
--Intro Taurox's Speech
oxyotl_intro_01 = new_sfx("play_wh2_dlc17_lzd_oxyotl_final_battle_phase_1_pt_01"); -- We have bided our time long enough. The purpose of this fell place is clear, the time for action is now.
oxyotl_intro_02 = new_sfx("play_wh2_dlc17_lzd_oxyotl_final_battle_phase_1_pt_02"); -- Behold, the one known as Taurox brings vast numbers of other Children of Chaos, beckoned by the dark power of that stone.
oxyotl_intro_03 = new_sfx("play_wh2_dlc17_lzd_oxyotl_final_battle_phase_1_pt_03"); -- His sacrificial rites are a critical step for Chaos’ advancement into the world, but freeing his captives will slow his progress.
oxyotl_intro_04 = new_sfx("play_wh2_dlc17_lzd_oxyotl_final_battle_phase_1_pt_04"); -- We have the upper hand – for now – but this Doombull must be struck down before he musters more cohorts.
oxyotl_intro_05 = new_sfx("play_wh2_dlc17_lzd_oxyotl_final_battle_phase_1_pt_05"); -- Ready yourselves, braves. The Children of Chaos are the sworn enemies of the Old Ones, and the entire world. They must not prevail!

oxyotl_igc1 = new_sfx("play_wh2_dlc17_lzd_oxyotl_final_battle_phase_2a"); -- The Cloven Ones no longer have reinforcements!

oxyotl_igc2 = new_sfx("play_wh2_dlc17_lzd_oxyotl_final_battle_phase_2b"); -- The Dark Gods must be deprived of their sacrificial offerings. If we kill the Great Bray-Shaman overseers, the prisoners shall go free.

--oxyotl_prisoners_01 = new_sfx("play_wh2_dlc17_lzd_oxyotl_final_battle_phase_3b"); -- The captives bolster our numbers! - UNUSED
--oxyotl_prisoners_02 = new_sfx("play_wh2_dlc17_lzd_oxyotl_final_battle_phase_3c"); -- The warmbloods fight as allies. Chaos truly is a bane to all. - UNUSED

oxyotl_igc3_01 = new_sfx("play_wh2_dlc17_lzd_oxyotl_final_battle_phase_3d"); -- This will not end until the Bloodbeast is slain! We must send him to oblivion where all Chaos belongs! 
oxyotl_igc3_02 = new_sfx("play_wh2_dlc17_lzd_oxyotl_the_golden_blowpipe_of_ptoohee_pt_01"); -- I have seen the horror of the Ruinous Powers. Wherever their influence spreads in this world, death surely follows.
oxyotl_igc3_03 = new_sfx("play_wh2_dlc17_lzd_oxyotl_final_battle_phase_3a"); -- Our allies join the fight. Advance, braves! Advance!

-------------------------------------------------------------------------------------------------
--------------------------------------- OPENING CUTSCENE ----------------------------------------
-------------------------------------------------------------------------------------------------
function end_deployment_phase()
	bm:out("\tend_deployment_phase() called");

	-- teleport units into their desired positions
	battle_start_teleport_units();
	--bm:modify_battle_speed(0);
		
	local cam = bm:camera();
	
	-- REMOVE ME
	cam:fade(true, 0);
	
	-- declare cutscene
	local cutscene_intro = cutscene:new(
		"cutscene_intro", 						-- unique string name for cutscene
		ga_oxyotl.sunits,					-- unitcontroller over player's army
		62800, 									-- duration of cutscene in ms
		function() intro_cutscene_end() end		-- what to call when cutscene is finished
	);
	local player_units_hidden = false;
	-- set up subtitles
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();
	-- cutscene_intro:set_post_cutscene_fade_time(0);
	-- skip callback
	cutscene_intro:set_skippable(
		true, 
		function()
			local cam = bm:camera();
			cam:fade(true, 0);
			bm:stop_cindy_playback(true);
			if player_units_hidden then
				ga_oxyotl:set_enabled(true)
			end;
			bm:callback(function() cam:fade(false, 0.5) end, 500);
		end
	);
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000);
	
	-- cutscene_intro:action(function() cam:move_to(v(-781.747, 84.081, 5.09), v(-770.503, 81.635, 21.587), 0, false, 30) end, 0);	

	cutscene_intro:action(function() bm:cindy_playback("script/battle/quest_battles/_cutscene/managers/heartoxy_first_01.CindySceneManager", 0, 2) end, 200);
	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_oxyotl:set_enabled(true) 
		end, 
		200
	);
	cutscene_intro:action(
	function()
		ga_oxyotl.sunits:item(1).uc:teleport_to_location(v(264.496, -388.576), 345, 2);
	end, 
	10000
	);

cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx) end, 0);
	--wh2_dlc17_lzd_oxyotl_final_battle_phase_1_pt_01 - 12s
	--wh2_dlc17_lzd_oxyotl_final_battle_phase_1_pt_02 - 13s
	--wh2_dlc17_lzd_oxyotl_final_battle_phase_1_pt_03 - 9s
	--wh2_dlc17_lzd_oxyotl_final_battle_phase_1_pt_04 - 11s
	--wh2_dlc17_lzd_oxyotl_final_battle_phase_1_pt_05 - 13s

	cutscene_intro:action(function() cutscene_intro:play_sound(oxyotl_intro_01) end, 2000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc17_lzd_oxyotl_final_battle_phase_1_pt_01", "subtitle_with_frame", 0.1, true) end, 2000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 14000);

	cutscene_intro:action(function() cutscene_intro:play_sound(oxyotl_intro_02) end, 14500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc17_lzd_oxyotl_final_battle_phase_1_pt_02", "subtitle_with_frame", 0.1, true) end, 14500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 27500);

	cutscene_intro:action(function() cutscene_intro:play_sound(oxyotl_intro_03) end, 28000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc17_lzd_oxyotl_final_battle_phase_1_pt_03", "subtitle_with_frame", 0.1, true) end, 28000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 37000);

	cutscene_intro:action(function() cutscene_intro:play_sound(oxyotl_intro_04) end, 37500);
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc17_lzd_oxyotl_final_battle_phase_1_pt_04", "subtitle_with_frame", 0.1, true) end, 37500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 48500);

	cutscene_intro:action(function() cutscene_intro:play_sound(oxyotl_intro_05) end, 49000);
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc17_lzd_oxyotl_final_battle_phase_1_pt_05", "subtitle_with_frame", 0.1, true) end, 49000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 62000);

	cutscene_intro:start();
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
	ga_oxyotl.sunits:item(1).uc:teleport_to_location(v(264.496, -388.576), 270, 2);
	ga_oxyotl.sunits:item(1):release_control()

end;


-------------------------------------------------------------------------------------------------
------------------------------------ CUTSCENE QUEUE SYSTEM --------------------------------------
-------------------------------------------------------------------------------------------------

function enqueue_cutscene(c)
    if bm:is_any_cutscene_running() then
        table.insert(cutscene_queue, c);
    else
        c:start();
    end;    
end;

function check_cutscene_queue()
    if #cutscene_queue > 0 then
        cutscene_queue[1]:start();
        table.remove(cutscene_queue, 1);
        return true;
    end;
    return false;
end;

-------------------------------------------------------------------------------------------------
--------------------------------- CUTSCENE 1 - DOOMBULL DEAD FULL! ------------------------------
-------------------------------------------------------------------------------------------------
-- This cutscene is triggered if the player kills the Doombull without attacking the Bray Shamans first
-- It is generally the default route through the battle

cutscene_doombull_dead = cutscene:new(
	"cutscene_doombull_dead", 					-- unique string name for cutscene
	ga_oxyotl.sunits, 									-- unitcontroller over player's army
	21000,												-- duration of cutscene in ms
	function() 
		cutscene_doombull_dead_end()
		check_cutscene_queue()
	end	-- what to call when cutscene is finished
);

cutscene_doombull_dead:set_restore_cam(2, v(-5.368604,211.113266,-443.824707),v(-121.819504,120.852684,-319.73645), 2);
cutscene_doombull_dead:set_close_advisor_on_end(false);
cutscene_doombull_dead:set_post_cutscene_fade_time(0);
cutscene_doombull_dead:set_should_disable_unit_ids(true);
cutscene_doombull_dead:set_should_enable_cinematic_camera(false);
cutscene_doombull_dead:set_skippable(false);

function play_cutscene_doombull_dead()
	cam:fade(true, 1);
	
--Turn Invincibility On and Morale Losses Off
--Player + Allies
	ga_oxyotl.sunits:invincible_if_standing(true)

	cutscene_doombull_dead:action(
		function()
			cam:fade(false, 1);
			cam:move_to(v(-262.56778,114.383705,-363.134583),v(-425.983704,56.92424,-447.383575), 0, false, 0);
			cam:move_to(v(-438.79837,87.880447,-489.789124),v(-362.209717,58.182388,-316.434692), 4, false, 0);
		end,
		1000
	);

	cutscene_doombull_dead:action(
		function()
			cam:fade(true, 1);
		end,
		9000
	);
	cutscene_doombull_dead:action(function() gb.sm:trigger_message("brays_move") end, 9000);
	cutscene_doombull_dead:action(
		function()
			cam:fade(false, 1);
			cam:move_to(v(-427.039215,88.752983,392.524597),v(-428.010498,88.817818,392.295715), 0, false, 0);
			cam:move_to(v(-427.039215,88.752983,392.524597),v(-428.010498,88.817818,392.295715), 6, false, 15);
		end,
		10000
	);
	cutscene_doombull_dead:action(
		function()
			cam:move_to(v(293.774445,102.461472,10.009407),v(294.680145,102.362648,9.597101), 0, false, 0);
			cam:move_to(v(293.774445,102.461472,10.009407),v(294.680145,102.362648,9.597101), 6, false, 15);
		end,
		15000
	);
	cutscene_doombull_dead:action(
		function()
			cam:fade(true, 1);
		end,
		20000
	);

	cutscene_doombull_dead:action(function() cutscene_doombull_dead:play_sound(wh2_middlebattle1_sfx) end, 0);

	cutscene_doombull_dead:action(function() cutscene_doombull_dead:play_sound(oxyotl_igc1) end, 3000);
	cutscene_doombull_dead:action(function() cutscene_doombull_dead:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc17_lzd_oxyotl_final_battle_phase_2a", "subtitle_with_frame", 0.1, true) end, 3000);	
	cutscene_doombull_dead:action(function() cutscene_doombull_dead:hide_custom_cutscene_subtitles() end, 9000);

	cutscene_doombull_dead:action(function() cutscene_doombull_dead:play_sound(oxyotl_igc2) end, 10000);
	cutscene_doombull_dead:action(function() cutscene_doombull_dead:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc17_lzd_oxyotl_final_battle_phase_2b", "subtitle_with_frame", 0.1, true) end, 10000);	
	cutscene_doombull_dead:action(function() cutscene_doombull_dead:hide_custom_cutscene_subtitles() end, 20000);

	enqueue_cutscene(cutscene_doombull_dead);
end;
function cutscene_doombull_dead_end()
		--Turn Invincibility Off and Morale Loss back on
	--Player
	ga_oxyotl.sunits:set_invincible(false)
	ga_oxyotl.sunits:morale_behavior_default_if_standing(true)
	cam:fade(false, 1);
	gb.sm:trigger_message("cutscene_doombull_dead_end")
end;

-------------------------------------------------------------------------------------------------
--------------------------------- CUTSCENE 2 - DOOMBULL DEAD LITE! ------------------------------
-------------------------------------------------------------------------------------------------
-- This cutscene is triggered if the player chooses to attack the Bray Shamans before killing the Doombull
-- This split is to catch out players who try to break the level using flying units or cheesy tactics

cutscene_doombull_dead_lite = cutscene:new(
	"cutscene_doombull_dead_lite", 					-- unique string name for cutscene
	ga_oxyotl.sunits, 									-- unitcontroller over player's army
	10000,												-- duration of cutscene in ms
	function() 
		cutscene_doombull_dead_lite_end()
		check_cutscene_queue()
	end	-- what to call when cutscene is finished
);

cutscene_doombull_dead_lite:set_restore_cam(2, v(-5.368604,211.113266,-443.824707),v(-121.819504,120.852684,-319.73645), 2);
cutscene_doombull_dead_lite:set_close_advisor_on_end(false);
cutscene_doombull_dead_lite:set_post_cutscene_fade_time(0);
cutscene_doombull_dead_lite:set_should_disable_unit_ids(true);
cutscene_doombull_dead_lite:set_should_enable_cinematic_camera(false);
cutscene_doombull_dead_lite:set_skippable(false);

function play_cutscene_doombull_dead_lite()
	cam:fade(true, 1);
	
--Turn Invincibility On and Morale Losses Off
--Player + Allies
	ga_oxyotl.sunits:invincible_if_standing(true)

	cutscene_doombull_dead_lite:action(
		function()
			cam:fade(false, 1);
			cam:move_to(v(-262.56778,114.383705,-363.134583),v(-425.983704,56.92424,-447.383575), 0, false, 0);
			cam:move_to(v(-438.79837,87.880447,-489.789124),v(-362.209717,58.182388,-316.434692), 4, false, 0);
		end,
		1000
	);
	cutscene_doombull_dead_lite:action(
		function()
			cam:fade(true, 1);
		end,
		9000
	);

	cutscene_doombull_dead_lite:action(function() cutscene_doombull_dead_lite:play_sound(oxyotl_igc1) end, 3000);
	cutscene_doombull_dead_lite:action(function() cutscene_doombull_dead_lite:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc17_lzd_oxyotl_final_battle_phase_2a", "subtitle_with_frame", 0.1, true) end, 3000);	
	cutscene_doombull_dead_lite:action(function() cutscene_doombull_dead_lite:hide_custom_cutscene_subtitles() end, 9000);

	enqueue_cutscene(cutscene_doombull_dead_lite);
end;
function cutscene_doombull_dead_lite_end()
		--Turn Invincibility Off and Morale Loss back on
	--Player
	ga_oxyotl.sunits:set_invincible(false)
	ga_oxyotl.sunits:morale_behavior_default_if_standing(true)
	cam:fade(false, 1);
	gb.sm:trigger_message("cutscene_doombull_dead_lite_end")
end;

-------------------------------------------------------------------------------------------------
----------------------------------- CUTSCENE 3 - BRAYS MOVE -------------------------------------
-------------------------------------------------------------------------------------------------

cutscene_brays_move = cutscene:new(
	"cutscene_brays_move", 					-- unique string name for cutscene
	ga_oxyotl.sunits, 									-- unitcontroller over player's army
	12000,												-- duration of cutscene in ms
	function() 
		cutscene_brays_move_end()
		check_cutscene_queue()
	end	-- what to call when cutscene is finished
);

cutscene_brays_move:set_restore_cam(2, v(-5.368604,211.113266,-443.824707),v(-121.819504,120.852684,-319.73645), 2);
cutscene_brays_move:set_close_advisor_on_end(false);
cutscene_brays_move:set_post_cutscene_fade_time(0);
cutscene_brays_move:set_should_disable_unit_ids(true);
cutscene_brays_move:set_should_enable_cinematic_camera(false);
cutscene_brays_move:set_skippable(false);

function play_cutscene_brays_move()
	cam:fade(true, 1);
	
--Turn Invincibility On and Morale Losses Off
--Player + Allies
	ga_oxyotl.sunits:invincible_if_standing(true)
	cutscene_brays_move:action(function() gb.sm:trigger_message("brays_move") end, 1000);
	cutscene_brays_move:action(
		function()
			cam:fade(false, 1);
			cam:move_to(v(-427.039215,88.752983,392.524597),v(-428.010498,88.817818,392.295715), 0, false, 0);
			cam:move_to(v(-427.039215,88.752983,392.524597),v(-428.010498,88.817818,392.295715), 6, false, 15);
		end,
		1000
	);
	cutscene_brays_move:action(
		function()
			cam:move_to(v(293.774445,102.461472,10.009407),v(294.680145,102.362648,9.597101), 0, false, 0);
			cam:move_to(v(293.774445,102.461472,10.009407),v(294.680145,102.362648,9.597101), 6, false, 15);
		end,
		6000
	);
	cutscene_brays_move:action(
		function()
			cam:fade(true, 1);
		end,
		11000
	);
	

	cutscene_brays_move:action(function() cutscene_brays_move:play_sound(wh2_middlebattle2_sfx) end, 0);

	cutscene_brays_move:action(function() cutscene_brays_move:play_sound(oxyotl_igc2) end, 1000);
	cutscene_brays_move:action(function() cutscene_brays_move:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc17_lzd_oxyotl_final_battle_phase_2b", "subtitle_with_frame", 0.1, true) end, 1000);	
	cutscene_brays_move:action(function() cutscene_brays_move:hide_custom_cutscene_subtitles() end, 11000);

	enqueue_cutscene(cutscene_brays_move);
end;
function cutscene_brays_move_end()
		--Turn Invincibility Off and Morale Loss back on
	--Player
	ga_oxyotl.sunits:set_invincible(false)
	ga_oxyotl.sunits:morale_behavior_default_if_standing(true)
	--ga_enemy_army_oxyotl.sunits:item(1):set_stat_attribute("stalk", true);
	cam:fade(false, 1);
	gb.sm:trigger_message("cutscene_brays_move_end")
end;

-------------------------------------------------------------------------------------------------
-------------------------------- CUTSCENE 3 - RITUAL COMPLETE! ----------------------------------
-------------------------------------------------------------------------------------------------

cutscene_ritual_complete = cutscene:new(
	"cutscene_ritual_complete", 					-- unique string name for cutscene
	ga_oxyotl.sunits, 									-- unitcontroller over player's army
	35000,												-- duration of cutscene in ms
	function() 
		cutscene_ritual_complete_end()
		check_cutscene_queue()
	end	-- what to call when cutscene is finished
);

cutscene_ritual_complete:set_restore_cam(2, v(-301.733337,218.95015,-143.914612),v(-229.754639,104.384857,-6.856216), 2);
cutscene_ritual_complete:set_close_advisor_on_end(false);
cutscene_ritual_complete:set_post_cutscene_fade_time(0);
cutscene_ritual_complete:set_should_disable_unit_ids(true);
cutscene_ritual_complete:set_should_enable_cinematic_camera(false);
cutscene_ritual_complete:set_skippable(false);

function play_cutscene_ritual_complete()
	cam:fade(true, 1);
	
--Turn Invincibility On and Morale Losses Off
--Player + Allies
	ga_oxyotl.sunits:invincible_if_standing(true)
	ga_spotter.sunits:invincible_if_standing(true)
	ga_spotter.sunits:take_control()

	cutscene_ritual_complete:action(
		function()
			cam:fade(false, 1);
			cam:move_to(v(-246.522751,201.484848,-38.200115),v(-188.909561,226.610825,143.649796), 2, false, 0);
			cam:move_to(v(294.420319,108.99836,111.115471),v(294.047119,109.300652,111.992615), 8, false, 50);
			ga_spotter:set_enabled(true);
		end,
		1000
	);
	cutscene_ritual_complete:action(
		function()
			gb.sm:trigger_message("powerup");
		end,
		2000
	);
	cutscene_ritual_complete:action(
		function()
			cam:fade(true, 1);
		end,
		9000
	);
	cutscene_ritual_complete:action(
		function()
			cam:fade(false, 1);
			cam:move_to(v(38.560432,95.169601,399.498322),v(38.220341,94.621613,400.262512), 2, false, 55);
			cam:move_to(v(-26.485178,30.942856,429.453247),v(46.894192,16.623793,607.565308), 8, false, 35);
		end,
		10000
	);
	cutscene_ritual_complete:action(function() gb.sm:trigger_message("spawn_the_beef") end, 11000);

	cutscene_ritual_complete:action(
		function()
			cam:fade(true, 1);
		end,
		25000
	);
	cutscene_ritual_complete:action(
		function()
			cam:fade(false, 1);
			cam:move_to(v(378.650635,115.492088,279.012451),v(394.963928,89.226173,336.554352), 0, false, 0);
			cam:move_to(v(373.3927,67.633492,416.293884),v(374.330872,67.650444,416.639893), 4, false, 40);
		end,
		26000
	);
	cutscene_ritual_complete:action(
		function()
			cam:fade(true, 1);
		end,
		34000
	);

	cutscene_ritual_complete:action(function() cutscene_ritual_complete:play_sound(wh2_middlebattle3_sfx) end, 0);

	cutscene_ritual_complete:action(function() cutscene_ritual_complete:play_sound(oxyotl_igc3_01) end, 1000);
	cutscene_ritual_complete:action(function() cutscene_ritual_complete:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc17_lzd_oxyotl_final_battle_phase_3d", "subtitle_with_frame", 0.1, true) end, 1000);	
	cutscene_ritual_complete:action(function() cutscene_ritual_complete:hide_custom_cutscene_subtitles() end, 10000);

	cutscene_ritual_complete:action(function() cutscene_ritual_complete:play_sound(oxyotl_igc3_02) end, 11000);
	cutscene_ritual_complete:action(function() cutscene_ritual_complete:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc17_lzd_oxyotl_the_golden_blowpipe_of_ptoohee_pt_01", "subtitle_with_frame", 0.1, true) end, 11000);	
	cutscene_ritual_complete:action(function() cutscene_ritual_complete:hide_custom_cutscene_subtitles() end, 23000);

	cutscene_ritual_complete:action(function() cutscene_ritual_complete:play_sound(oxyotl_igc3_03) end, 26000);
	cutscene_ritual_complete:action(function() cutscene_ritual_complete:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc17_lzd_oxyotl_final_battle_phase_3a", "subtitle_with_frame", 0.1, true) end, 26000);	
	cutscene_ritual_complete:action(function() cutscene_ritual_complete:hide_custom_cutscene_subtitles() end, 32000);

	enqueue_cutscene(cutscene_ritual_complete);
end;
function cutscene_ritual_complete_end()

--Turn Invincibility Off and Morale Loss back on
--Player
	ga_oxyotl.sunits:set_invincible(false)
	ga_oxyotl.sunits:morale_behavior_default_if_standing(true)
	ga_spotter.sunits:set_invincible(false)
	ga_spotter.sunits:morale_behavior_default_if_standing(true)

	ga_spotter.sunits:item(1).uc:teleport_to_location(v(442.14, 340.812), 270, 40);
	ga_spotter.sunits:release_control()
	cam:fade(false, 1);
	gb.sm:trigger_message("cutscene_ritual_complete_end")
end;

gb:message_on_time_offset("trigger_cutscene_doombull_dead", 10000, "doombull_dead_first")
gb:add_listener("trigger_cutscene_doombull_dead", function() play_cutscene_doombull_dead() end);

gb:message_on_time_offset("trigger_cutscene_doombull_dead_lite", 10000, "doombull_dead_lite")
gb:add_listener("trigger_cutscene_doombull_dead_lite", function() play_cutscene_doombull_dead_lite() end);

gb:message_on_time_offset("trigger_cutscene_brays_move", 5000, "brays_move_early")
gb:add_listener("trigger_cutscene_brays_move", function() play_cutscene_brays_move() end);

gb:message_on_time_offset("trigger_cutscene_ritual_complete", 10000, "trigger_ritual")
gb:add_listener("trigger_cutscene_ritual_complete", function() play_cutscene_ritual_complete() end);

-- Spawn Ghorgon
ga_enemy_army_taurox_main:use_army_special_ability_on_message("spawn_the_beef","wh2_dlc17_army_abilities_ghorgon_summon_qb_scripted", v(-4.28342, 491.967), 3.141, 4, 0);
ga_enemy_army_taurox_main:use_army_special_ability_on_message("spawn_the_beef","wh2_dlc17_army_abilities_cygor_summon_qb_scripted", v(28.084, 485.065), 3.141, 4, 0);
ga_enemy_army_taurox_main:use_army_special_ability_on_message("spawn_the_beef","wh2_dlc17_army_abilities_cygor_summon_qb_scripted", v(-25.8276, 485.236), 3.141, 4, 1000);

ga_enemy_army_taurox_main:use_army_special_ability_on_message("spawn_the_beef","wh2_dlc17_army_abilities_chaos_spawn_summon_qb_scripted", v(-34.9476, 461.756), 3.66519, 40, 0);
ga_enemy_army_taurox_main:use_army_special_ability_on_message("spawn_the_beef","wh2_dlc17_army_abilities_chaos_spawn_summon_qb_scripted", v(-4.4105, 446.796), 3.141, 40, 1000);
ga_enemy_army_taurox_main:use_army_special_ability_on_message("spawn_the_beef","wh2_dlc17_army_abilities_chaos_spawn_summon_qb_scripted", v(18.1803, 466.277), 2.61799, 40, 2000);

-- Comp Scene Triggers
gb:stop_terrain_composite_scene_on_message("powerup", herdstone_idle, 3250);
gb:start_terrain_composite_scene_on_message("powerup", herdstone_powerup);
gb:start_terrain_composite_scene_on_message("powerup", herdstone_powerloop, 3250);
gb:stop_terrain_composite_scene_on_message("powerup", herdstone_powerup, 6000);