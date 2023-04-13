-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Thorek
-- The Lost Vault
-- The Lost Vault
-- Attacker

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------



load_script_libraries();
bm = battle_manager:new(empire_battle:new());

local cam = bm:camera()
--local cutscene_queue = {} 						--queue for multiple cutscenes disabled, firing intro and mid manually

bm:camera():fade(true, 0);

gb = generated_battle:new(
	true,                                      		    -- screen starts black
	true,                                      		-- prevent deployment for player
	true,                                      		    -- prevent deployment for ai
	function() end_deployment_phase() end,          	-- intro cutscene function
	false                                      			-- debug mode
);

--preload stuttering fix
intro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\lostvault.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);

-------------------------------------------------------------------------------------------------
---------------------------------------- VO & SUBS  & Audio ---------------------------
-------------------------------------------------------------------------------------------------

--Intro cutscene
wh2_main_sfx_01 = new_sfx("PLAY_wh2_dlc17_dwf_thorek_ironbrow_final_battle_pt_01"); --8000
wh2_main_sfx_02 = new_sfx("PLAY_wh2_dlc17_dwf_thorek_ironbrow_final_battle_pt_02"); --9000
wh2_main_sfx_03 = new_sfx("PLAY_wh2_dlc17_dwf_thorek_ironbrow_final_battle_pt_03"); --7000
wh2_main_sfx_04 = new_sfx("PLAY_wh2_dlc17_dwf_thorek_ironbrow_final_battle_pt_04"); --8000
wh2_main_sfx_05 = new_sfx("PLAY_wh2_dlc17_dwf_thorek_ironbrow_final_battle_pt_05"); --7000

--Mid-battle cutscene
wh2_main_sfx_06 = new_sfx("PLAY_wh2_dlc17_dwf_thorek_ironbrow_final_battle_pt_06"); --5000
wh2_main_sfx_07 = new_sfx("PLAY_wh2_dlc17_dwf_thorek_ironbrow_final_battle_pt_07"); --9000
wh2_main_sfx_08 = new_sfx("PLAY_wh2_dlc17_dwf_thorek_ironbrow_final_battle_pt_08"); --8000


--SFX Triggers
wh2_main_sfx = new_sfx("Play_Movie_Warhammer2_Thorek_The_Lost_Vault_Intro");
wh2_main_sfx_mid = new_sfx("Play_Movie_Warhammer2_Thorek_The_Lost_Vault_Midbattle");

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_playerarmy = gb:get_army(gb:get_player_alliance_num(), 1, "");
ga_skvstart = gb:get_army(gb:get_non_player_alliance_num(),"enemy_1");
ga_skvleft = gb:get_army(gb:get_non_player_alliance_num(),"enemy_2");
ga_skvright = gb:get_army(gb:get_non_player_alliance_num(),"enemy_3");
ga_skvmain = gb:get_army(gb:get_non_player_alliance_num(),"enemy_4");

raki_sunit = ga_skvmain.sunits:item(1);

-------------------------------------------------------------------------------------------------
------------------------------------------- CUTSCENE 1 --------------------------------------------
-------------------------------------------------------------------------------------------------


function end_deployment_phase()
	bm:out("\tend_deployment_phase() called");
	
	local cam = bm:camera();
	
	-- declare cutscene
	local cutscene_intro = cutscene:new(
		"cutscene_intro", 						-- unique string name for cutscene
		ga_playerarmy.sunits,					-- unitcontroller over player's army
		53000, 									-- duration of cutscene in ms
		function() intro_cutscene_end() end		-- what to call when cutscene is finished
	);
	
	local player_units_hidden = false;
	
	-- set up subtitles
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();
		
	cutscene_intro:set_post_cutscene_fade_time(0.5, 1);
	
	-- skip callback
	cutscene_intro:set_skippable(
		true, 
		function()		
			local cam = bm:camera();
			bm:stop_cindy_playback(true);		
			if player_units_hidden then
				ga_playerarmy:set_enabled(true)
			end;
		end
	);
	
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000);
	
	--cutscene_intro:action(function() cam:move_to(v(-466.958221,300.182526,-169.705276),v(-448.073792,293.935577,-166.715744), 0, false, 30) end, 0);	
	--cutscene:set_restore_cam(
	--camera:fade(boolean to black, number transition duration)

	cutscene_intro:action(function() bm:cindy_playback("script\\battle\\quest_battles\\_cutscene\\managers\\lostvault.CindySceneManager", 0, 2) end, 200);
	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_playerarmy:set_enabled(true) 
		end, 
		200
	);	
	
	-- Voiceover and Subtitles --
	--VO lengths 8, 9, 7, 8, 7
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx) end, 0);	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 2000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc17_dwf_thorek_ironbrow_final_battle_pt_01", "subtitle_with_frame", 0.1, true) end, 2000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 10000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 14000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc17_dwf_thorek_ironbrow_final_battle_pt_02", "subtitle_with_frame", 0.1, true) end, 14000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 24000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 25000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc17_dwf_thorek_ironbrow_final_battle_pt_03", "subtitle_with_frame", 0.1, true) end, 25000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 33000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_04) end, 34000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc17_dwf_thorek_ironbrow_final_battle_pt_04", "subtitle_with_frame", 0.1, true) end, 34000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 43000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_05) end, 44000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc17_dwf_thorek_ironbrow_final_battle_pt_05", "subtitle_with_frame", 0.1, true) end, 44000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 52000);

	cutscene_intro:start();
	
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
end;


-------------------------------------------------------------------------------------------------
------------------------------------ CUTSCENE QUEUE SYSTEM --------------------------------------
-------------------------------------------------------------------------------------------------
--[[ NO QUEUE IN USE IN THIS BATTLE - ONLY FOR MULTIPLE CUTSCENES WHICH CAN FIRE SIMULTANEOUSLY
function enqueue_cutscene(c)								--queue for multiple cutscenes disabled, firing intro and mid manually

    if bm:is_any_cutscene_running() then
        table.insert(cutscene_queue, c);
    else
        c:start();
    end;    
end;


	function check_cutscene_queue()							--queue for multiple cutscenes disabled, firing intro and mid manually

    if #cutscene_queue > 0 then
        cutscene_queue[1]:start();
        table.remove(cutscene_queue, 1);
        return true;
    end;
    return false;
end;
]]
-------------------------------------------------------------------------------------------------
--------------------------------- CUTSCENE 2 ----------------------------------------------------
-------------------------------------------------------------------------------------------------

-- declare cutscene
local cutscene_mid = cutscene:new(
	"cutscene_mid", 									-- unique string name for cutscene
	ga_playerarmy.sunits, 								-- unitcontroller over player's army
	30000,												-- duration of cutscene in ms
	
	function() 
		cutscene_mid_end()
		--check_cutscene_queue()						--queue for multiple cutscenes disabled, firing intro and mid manually

		bm:out("\tCUTSCENE_MID called");
	end													-- what to call when cutscene is finished
);

function play_cutscene_mid()

--Turn Invincibility On and Morale Losses Off
	ga_playerarmy.sunits:invincible_if_standing(true)
	ga_playerarmy.sunits:morale_behavior_default_if_standing(false)
	ga_skvmain.sunits:morale_behavior_default_if_standing(false)
	ga_skvleft.sunits:morale_behavior_default_if_standing(false)
	ga_skvright.sunits:morale_behavior_default_if_standing(false)
	ga_playerarmy.sunits:refill_ammo(1.3)

-- Dynamic Teleport Script for Player Armies --

teleport_coords = {
--front end chars
	{coord = v(-25, -76), rot = 90, width = 20},
	{coord = v(-72, -23), rot = 90, width = 20},
	{coord = v(-52, -126), rot = 90, width = 20},
--front end units
	{coord = v(-75, 10), rot = 60, width = 20}, 
	{coord = v(-75, -170), rot = 120, width = 20},
	{coord = v(-110, -20), rot = 90, width = 25},
	{coord = v(-110, -150), rot = 90, width = 25},
	{coord = v(-50, 10), rot = 60, width = 20},
	{coord = v(-50, -170), rot = 120, width = 20},
	{coord = v(-60, -55), rot = 70, width = 40},
	{coord = v(-60, -95), rot = 110, width = 40},
--front end ranged	
	{coord = v(-76, -137), rot = 135, width = 20},
	{coord = v(-45, -39), rot = 10, width = 20},
	{coord = v(-36, -117), rot = 170, width = 20},
	{coord = v(-35, -57), rot = 60, width = 20},
	{coord = v(-24, -99), rot = 100, width = 20},
--front end carnosaur
	{coord = v(-30, -150), rot = 90, width = 20},
--front end artillery
	{coord = v(-100, -40), rot = 45, width = 30},
	{coord = v(-100, -130), rot = 135, width = 30},
	{coord = v(-120, -85), rot = 135, width = 30},
--21st unit (shouldn't do anything)	
	{coord = v(-0, 0), rot = 90, width = 40},
};

army_size = ga_playerarmy.sunits:count()
for i = 1, army_size do
	local current_teleport_coord = teleport_coords[i];
	if(#teleport_coords <  i) then
		out.design("WARNING: Not enough coordinates to support the current army size, the rest of the army will be deployed normally.")
		break
	end;
	
	ga_playerarmy.sunits:item(i).uc:teleport_to_location(current_teleport_coord.coord,current_teleport_coord.rot,current_teleport_coord.width);
end;

	--Teleport ratto attackos
	ga_skvleft.sunits:item(3).uc:teleport_to_location(v(-272, 198), 90, 30);
	ga_skvleft.sunits:item(4).uc:teleport_to_location(v(-328, 206), 90, 30);
	ga_skvmain.sunits:item(3).uc:teleport_to_location(v(-356, -436), 90, 30);
	ga_skvright.sunits:item(5).uc:teleport_to_location(v(-300, -380), 90, 30);
	
		
	cutscene_mid:action(
		function()
			cam:fade(false, 1);
			--cam:move_to(v(-781.747, 84.081, 5.09), v(-770.503, 81.635, 21.587), 0, true, 50);
		end,
		17000
	);


	
	local player_units_hidden = false;
	
	-- set up subtitles
	local subtitles = cutscene_mid:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();
		
	cutscene_mid:set_post_cutscene_fade_time(3.0, 3200);
	
	-- skip callback
	cutscene_mid:set_skippable(
		true, 
		function()		
			local cam = bm:camera();
			bm:stop_cindy_playback(true);		
			if player_units_hidden then
				ga_playerarmy:set_enabled(true)
			end;
		end
	);

	-- set up actions on cutscene
	cutscene_mid:action(function() cam:fade(false, 1) end, 1000);
	
	--cutscene_mid:action(function() cam:move_to(v(-233.444122,282.273102,-104.831215),v(-215.390945,273.799988,-102.21595), 0, false, 30) end, 0);	

	cutscene_mid:action(function() bm:cindy_playback("script\\battle\\quest_battles\\_cutscene\\managers\\lostvault_mid_01.CindySceneManager", 0, 2) end, 200);
	
	--VO lengths 5, 9, 8
	cutscene_mid:action(function() cutscene_mid:play_sound(wh2_main_sfx_mid) end, 0);
	cutscene_mid:action(function() cutscene_mid:play_sound(wh2_main_sfx_06) end, 2000);	
	cutscene_mid:action(function() cutscene_mid:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc17_dwf_thorek_ironbrow_final_battle_pt_06", "subtitle_with_frame", 0.1, true) end, 2000);	
	cutscene_mid:action(function() cutscene_mid:hide_custom_cutscene_subtitles() end, 8000);
	
	cutscene_mid:action(function() cutscene_mid:play_sound(wh2_main_sfx_07) end, 9000);	
	cutscene_mid:action(function() cutscene_mid:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc17_dwf_thorek_ironbrow_final_battle_pt_07", "subtitle_with_frame", 0.1, true) end, 9000);	
	cutscene_mid:action(function() cutscene_mid:hide_custom_cutscene_subtitles() end, 19000);
	
	cutscene_mid:action(function() cutscene_mid:play_sound(wh2_main_sfx_08) end, 20000);	
	cutscene_mid:action(function() cutscene_mid:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc17_dwf_thorek_ironbrow_final_battle_pt_08", "subtitle_with_frame", 0.1, true) end, 20000);	
	cutscene_mid:action(function() cutscene_mid:hide_custom_cutscene_subtitles() end, 29000);
	
	cutscene_mid:action(function() cutscene_mid:hide_custom_cutscene_subtitles() end, 30000);

	cutscene_mid:start();
	
	--enqueue_cutscene(cutscene_mid);				--queue for multiple cutscenes disabled, firing intro and mid manually
end;

function cutscene_mid_end()

--Turn Invincibility Off (leaving thorek's army fearless)
	ga_playerarmy.sunits:set_invincible(false)

	gb.sm:trigger_message("02_mid_cutscene_end")
end;

--------------------------------------------------------------------------------------------
------------------------------------------ ORDERS -------------------------------------------
-------------------------------------------------------------------------------------------------
if raki_sunit then
	bm:watch(
		function()
			return is_shattered_or_dead(raki_sunit)
		end,
		0,
		function()
			bm:out("*** raki is shattered or dead! ***");
			gb.sm:trigger_message("raki_dead")
			ga_playerarmy:play_sound_charge()					--adds a charge/cheer sound effect when the unit dies
		end
	);
end;

--Stopping armies from firing until cutscene 1 is done
ga_playerarmy:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_playerarmy:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);

ga_skvstart:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_skvstart:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);

ga_skvstart:add_winds_of_magic_on_message("battle_started", -50)
ga_skvstart:add_winds_of_magic_on_message("01_intro_cutscene_end", 50)
ga_skvstart:add_winds_of_magic_on_message("skvstart_dead", -50)

--start the battle
ga_playerarmy:release_on_message("01_intro_cutscene_end");
ga_skvstart:release_on_message("01_intro_cutscene_end");
ga_skvstart:attack_force_on_message("01_intro_cutscene_end", ga_playerarmy)

--enemy reinforcements
ga_skvright:reinforce_on_message("skvstart_dead");
ga_skvleft:reinforce_on_message("skvstart_dead");
ga_skvmain:reinforce_on_message("skvstart_dead");

gb:message_on_time_offset("reinforcement_release_1", 3000, "02_mid_cutscene_end");
gb:message_on_time_offset("reinforcement_release_2", 35000, "02_mid_cutscene_end");

ga_skvleft:release_on_message("reinforcement_release_1");
ga_skvright:release_on_message("reinforcement_release_1");
ga_skvmain:release_on_message("reinforcement_release_1");

gb:add_listener("reinforcement_release_2", function() attackrats() end);
function attackrats()
	ga_skvleft:attack_force(ga_playerarmy)
	ga_skvright:attack_force(ga_playerarmy)
	ga_skvmain:attack_force(ga_playerarmy)
	bm:out(">>>attackrats<<<")
end


--Stopping armies from firing until cutscene 2 is done
ga_playerarmy:change_behaviour_active_on_message("start_cutscene_mid", "fire_at_will", false, false);
ga_playerarmy:change_behaviour_active_on_message("02_mid_cutscene_end", "fire_at_will", true, true);

ga_skvleft:change_behaviour_active_on_message("skvstart_dead", "fire_at_will", false, false);
ga_skvleft:change_behaviour_active_on_message("reinforcement_release_1", "fire_at_will", true, true);

ga_skvmain:change_behaviour_active_on_message("skvstart_dead", "fire_at_will", false, false);
ga_skvmain:change_behaviour_active_on_message("reinforcement_release_2", "fire_at_will", true, true);

ga_skvright:change_behaviour_active_on_message("skvstart_dead", "fire_at_will", false, false);
ga_skvright:change_behaviour_active_on_message("reinforcement_release_1", "fire_at_will", true, true);

ga_skvleft:add_winds_of_magic_on_message("battle_started", -50)
ga_skvleft:add_winds_of_magic_on_message("reinforcement_release_2", 50)

ga_skvmain:add_winds_of_magic_on_message("battle_started", -50)
ga_skvmain:add_winds_of_magic_on_message("reinforcement_release_2", 50)

ga_skvright:add_winds_of_magic_on_message("battle_started", -50)
ga_skvright:add_winds_of_magic_on_message("reinforcement_release_2", 50)


--subtitles
gb:queue_help_on_message("01_intro_cutscene_end", "wh2_dlc17_qb_dwf_thorek_lost_vault_hint_01", 6000, 2000, 5000);
gb:queue_help_on_message("skvstart_dead", "wh2_dlc17_qb_dwf_thorek_lost_vault_hint_03", 6000, nil, 5000);
gb:queue_help_on_message("02_mid_cutscene_end", "wh2_dlc17_qb_dwf_thorek_lost_vault_hint_02", 6000, nil, 5000);
gb:queue_help_on_message("thorek_dead", "wh2_dlc17_qb_dwf_thorek_klad_brakak_hint_03", 6000, nil, 5000);
gb:queue_help_on_message("reinforcement_release_2", "wh2_dlc17_qb_dwf_thorek_lost_vault_hint_05", 6000, nil, 5000);
gb:queue_help_on_message("raki_dead", "wh2_dlc17_qb_dwf_thorek_lost_vault_hint_06", 6000, nil, 5000);

--Fearless rats off
gb:add_listener("reinforcement_release_2", function() fear_the_dorfs() end);

function fear_the_dorfs()
	ga_skvmain.sunits:morale_behavior_default_if_standing(true)
	ga_skvright.sunits:morale_behavior_default_if_standing(true)
	ga_skvleft.sunits:morale_behavior_default_if_standing(true)
	bm:out(">>>FEAR THE DORFS!!!<<<")
end

--post victory message
ga_playerarmy:message_on_victory("won")
gb:add_listener("won", function() play_victory_text() end);

function play_victory_text()
	bm:queue_help_message("wh2_dlc17_qb_dwf_thorek_lost_vault_hint_04", 6000, 5000, true, true);
	
end

--objective marker
ga_skvmain:add_ping_icon_on_message("reinforcement_release_2", 15, 1)

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------
--objective listener messages
ga_playerarmy:message_on_commander_death("thorek_dead", 1);
ga_skvstart:message_on_rout_proportion("skvstart_dead", 0.95);
ga_skvstart:message_on_casualties("skvstart_dead", 0.6);
ga_skvstart:rout_over_time_on_message("skvstart_dead", 10000)
gb:message_on_time_offset("cam_fade", 10000, "skvstart_dead");
gb:message_on_time_offset("start_cutscene_mid", 12000, "skvstart_dead");
gb:add_listener("start_cutscene_mid", function() play_cutscene_mid() end);

--set objectives
gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc17_qb_dwf_thorek_klad_brakak_objective_03");
gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc17_qb_dwf_thorek_lost_vault_objective_01");
gb:set_objective_on_message("02_mid_cutscene_end", "wh2_dlc17_qb_dwf_thorek_lost_vault_objective_02");
gb:set_objective_on_message("reinforcement_release_2", "wh2_dlc17_qb_dwf_thorek_lost_vault_objective_03");

--complete objectives
gb:fail_objective_on_message("thorek_dead", "wh2_dlc17_qb_dwf_thorek_klad_brakak_objective_03", 5);
gb:complete_objective_on_message("skvstart_dead", "wh2_dlc17_qb_dwf_thorek_lost_vault_objective_01", 5);
gb:complete_objective_on_message("raki_dead", "wh2_dlc17_qb_dwf_thorek_lost_vault_objective_03", 5);

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

--camera fade before cutscene 2--
gb:add_listener("cam_fade", function() cam_fade_mid() end);

function cam_fade_mid()
	bm:camera():fade(true, 1);
end

--Pinging zone to direct player--

gb:add_ping_icon_on_message("01_intro_cutscene_end", v(-22, 200, -72), 15)
gb:remove_ping_icon_on_message("start_cutscene_mid", v(-22, 200, -72), 0)

--Army ability hiding and revealing---

local sm = get_messager();

--Switching army ability on after cutscene 2
local army_abilities = "wh2_dlc17_army_abilities_ancestral_rune_of_grimnir";

function show_army_abilities(value)
	local army_ability_parent = get_army_ability_parent();
	
	find_uicomponent(army_ability_parent, "button_holder_" .. army_abilities):SetVisible(value);

end;

function highlight_army_ability(value)
	local army_ability_parent = get_army_ability_parent();

	find_uicomponent(army_ability_parent, "button_ability_" .. army_abilities):Highlight(value, false, 100);

end;

function get_army_ability_parent()
	return find_uicomponent(core:get_ui_root(), "army_ability_parent");
end;

show_army_abilities(false);

--Making ability glow after it is made available
sm:add_listener(
	"02_mid_cutscene_end",
	function()
		show_army_abilities(true);
		
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
			20000
		);
	end
);

--objective locators---
gb:set_locatable_objective_callback_on_message(
    "reinforcement_release_2",
    "wh2_dlc17_qb_dwf_thorek_lost_vault_objective_03",
    5000,
    function()
        local sunit = raki_sunit;  -- Where is says "get_general_sunit()" replace with item(number) i.e. item(1)
        if sunit then
            local cam_targ = sunit.unit:position();
            local cam_pos = v_offset_by_bearing(
                cam_targ,
                get_bearing(cam_targ, bm:camera():position()),    -- horizontal bearing from camera target to current camera position
                100,                                                -- distance from camera position to camera target
                d_to_r(30)                                        -- vertical bearing from horizon to cam-targ/cam-pos line
            );
            return cam_pos, cam_targ;
        end;
    end,
    2
);

gb:set_locatable_objective_callback_on_message(
    "01_intro_cutscene_end",
    "wh2_dlc17_qb_dwf_thorek_klad_brakak_objective_03",
    5000,
    function()
        local sunit = ga_playerarmy.sunits:item(1);  -- Where is says "get_general_sunit()" replace with item(number) i.e. item(1)
        if sunit then
            local cam_targ = sunit.unit:position();
            local cam_pos = v_offset_by_bearing(
                cam_targ,
                get_bearing(cam_targ, bm:camera():position()),    -- horizontal bearing from camera target to current camera position
                100,                                                -- distance from camera position to camera target
                d_to_r(30)                                        -- vertical bearing from horizon to cam-targ/cam-pos line
            );
            return cam_pos, cam_targ;
        end;
    end,
    2
);

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_playerarmy:rout_over_time_on_message("thorek_dead", 10000)
