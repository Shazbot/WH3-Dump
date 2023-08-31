



---------------------------------------------------------
--
-- intro setup
--
---------------------------------------------------------
--Set up a metric variable to be used in campaign later
core:svr_save_bool("sbool_prologue_first_battle_loaded_in", true);

bm:setup_battle(
	function()
		sunits_enemy_main_missile:change_behaviour_active("skirmish", false);

		-- conflict phase has started - teleport ai units back to their starting positions
		sunits_allied_defenders:teleport_to_start_location();
		sunits_enemy_all:teleport_to_start_location();
		sunits_allied_defenders:teleport_to_start_location();
		sunits_allied_skirmishers:teleport_to_start_location();

		hide_enemy_general();
	end
);

bm:register_phase_change_callback(
	"Deployment", 
	function()

		-- Disable camera rotation.
		bm:disable_shortcut("rot_l", true)
		bm:disable_shortcut("rot_r", true)
	
		-- prevent UI hiding
		bm:enable_ui_hiding(false);
		
		-- show the cutscene borders immediately (but allow the mouse cursor)
		bm:enable_cinematic_ui(true, true, true);
	
		core:progress_on_loading_screen_dismissed(function() start_deployment_phase()  end, "custom_loading_screen");
	end
);


function hide_user_interface_at_battle_start()
	-- hide user interface
	bm:show_ui(false);
	bm:show_ui_options_panel(false)
	bm:show_start_battle_button(false);
	
	-- Setup help panel to float in top right
	local hpm = get_help_page_manager();
	hpm:set_close_on_game_menu_opened(false);				-- help panel does not close when ESC menu opened
	hpm:related_panel_opened("float_top_right", true);		-- spoof a panel opening which forces the help panel to float in the top-right corner
	hpm:enable_menu_bar_index_button(false);				-- disable the ? help page button
	
	-- prevent pausing
	if not core:is_tweaker_set("SCRIPTED_TWEAKER_06") then
		bm:disable_shortcut("toggle_pause", true);
	end;
	
	-- prevent tactical map
	bm:disable_shortcut("show_tactical_map", true);
	
	-- prevent battle speed toggling
	bm:disable_shortcut("cycle_battle_speed", true);
	
	-- prevent first-person camera
	bm:disable_shortcut("context_camera", true);
	
	-- prevent UI hiding
	bm:enable_ui_hiding(false);
	
	-- prevent grouping and formations
	bm:disable_shortcut("toggle_group", true);
	bm:disable_groups(true);
	bm:disable_formations(true);
	
	-- force minimised tooltips
	bm:force_minimised_tooltips(true);
end;


function start_deployment_phase()

	hide_user_interface_at_battle_start();

	set_player_army_visibility_cutscene_intro_start(false);

	-- set up a listener which overrides the loading screen if the player skips
	override_loading_screen_on_skip();

	bm:set_volume(VOLUME_TYPE_MUSIC, 100);
	bm:set_volume(VOLUME_TYPE_SFX, 100);
	bm:set_volume(VOLUME_TYPE_VO, 100);
	-- set the music to enter the bespoke state 
	bm:set_music_vm_variable("bespoke_battle_id", "prologue_battle_one");
	-- set the music to enter the bespoke music action so that we play kislev tension music
	bm:set_music_vm_variable("bespoke_battle_script_actions", "set_tension_loop");

	-- play intro cindyscene
	play_cutscene_intro()
	
	bm:register_phase_change_callback("Deployed", function() bm:steal_input_focus(true, true) end)
	
	bm:end_current_battle_phase();
end;



core:add_listener(
	"skip_battle_listener",
	"ComponentLClickUp",
	function(context) return context.string == "button_concede" end,
	function() 
		core:svr_save_bool("sbool_load_post_intro_campaign", true) -- load script for campaign  
		common.setup_dynamic_loading_screen("prologue_battle_1_outro", "prologue");

		--Set up a metric variable to be used in campaign later
		core:svr_save_bool("sbool_prologue_first_battle_skipped", true);
	end,
	false
);







---------------------------------------------------------
--
-- intro cutscene
--
---------------------------------------------------------


-- mute sounds for intro cutscene
bm:set_volume(VOLUME_TYPE_MUSIC, 0);
bm:set_volume(VOLUME_TYPE_SFX, 0);
bm:set_volume(VOLUME_TYPE_VO, 0);

cutscene_intro = cutscene:new_from_cindyscene(
	"cutscene_intro",
	sunits_player_start, 
	function() 
		bm:steal_input_focus(false, false);
		bm:release_escape_key_with_callback("StopEscDuringIntro")
		bm:disable_unit_details_panel(true);
		start_battle();
	end, 
	"script/battle/scenario_battles/_cutscene/managers/01_prologue_intro_opening.CindySceneManager",
	0,
	0
);

cutscene_intro:set_skippable(true, function() skip_cutscene_intro() end);
cutscene_intro:set_post_cutscene_fade_time(0.5, 500);
cutscene_intro:set_show_cinematic_bars(true);

-- cutscene_intro:set_debug(true);

--[[
generals_speech_01 = new_sfx("play_wh2_intro_battle_skv_1_1");
generals_speech_02 = new_sfx("play_wh2_intro_battle_skv_2_1");
]]

function play_cutscene_intro()
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();

	cam:fade(false, 0);
	
	cutscene_intro:set_skip_camera(pos_cam_gameplay_start, pos_targ_gameplay_start);

	cutscene_intro:play_sound(new_sfx("Play_Movie_WH3_Prologue_Battle_1_Sweetener_Layer_01"));

	-- The journey has been long, but we are ready.
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_scenario_01_prologue_intro_01", 
		function()
			cutscene_intro:play_sound(new_sfx("play_wh3_scenario_01_prologue_intro_01_1"));
			bm:show_subtitle("wh3_scenario_01_prologue_intro_01", false, true);
		end
	);

	-- Fellow Ungols, we are of Kislev - show these cowardly dogs what that means. They hunger for blood, let them taste cold steel!
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_scenario_01_prologue_intro_02",
		function()
			cutscene_intro:play_sound(new_sfx("play_wh3_scenario_01_prologue_intro_02_1"));
			bm:show_subtitle("wh3_scenario_01_prologue_intro_02", false, true)
		end
	);
	
	cutscene_intro:action(function() teleport_player_army_cutscene_intro_start() end, 0);
	cutscene_intro:action(
		function()
			cutscene_intro.player_army_visible = true;
			set_player_army_visibility_cutscene_intro_start(true);
			move_player_army_cutscene_intro_start() 
			--Set up a metric variable to be used in campaign later
			core:svr_save_bool("sbool_prologue_first_battle_watched_intro_cutscene", true);
		end, 
		3000
	);
	
	cutscene_intro:start();
end;

function skip_cutscene_intro()
	if not cutscene_intro.player_army_visible then
		set_player_army_visibility_cutscene_intro_start(true);
	end;

	sunits_player_start:teleport_to_start_location();
	bm:hide_subtitles();

	--Set up a metric variable to be used in campaign later
	core:svr_save_bool("sbool_prologue_first_battle_skipped_intro_cutscene", true);
end;