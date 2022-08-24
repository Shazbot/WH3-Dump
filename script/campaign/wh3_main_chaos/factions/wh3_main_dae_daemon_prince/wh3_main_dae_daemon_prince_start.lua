

-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	FACTION SCRIPT
--
--	Custom script for this faction starts here. This script loads in additional
--	scripts depending on the mode the campaign is being started in (first turn vs
--	open), sets up the faction_start object and does some other things
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

if cm:is_new_game() then
	-- position of the camera when cutscene skipped in singleplayer or gameplay starts in multiplayer
	local cam_gameplay_start = {
		x = 119.2,
		y = 242.0,
		d = 11.4,
		b = 0,
		h = 9.7
	};

	local cindy_scene_key = "chs_prince";

	local advice_to_play = {
		"wh3_main_camp_chaos_dae_legion_chaos_intro_01",
		"wh3_main_camp_chaos_dae_legion_chaos_intro_02",
		"wh3_main_camp_chaos_dae_legion_chaos_intro_03",
		"wh3_main_camp_chaos_dae_legion_chaos_intro_04",
		"wh3_main_camp_chaos_dae_legion_chaos_intro_05",
		"wh3_main_camp_chaos_dae_legion_chaos_intro_06",
		"wh3_main_camp_chaos_dae_legion_chaos_intro_07",
		"wh3_main_camp_chaos_dae_legion_chaos_intro_08",
		"wh3_main_camp_chaos_dae_legion_chaos_intro_09"
	};

	-- Hide the faction leader during the cutscene.
	-- Set this to false or nil to not hide/unhide them.
	-- Set this to true or 0 to hide them for the duration of the cutscene, unhiding them at the end
	-- Set this to a positive number to hide them at the start, then unhide them x seconds in to the cutscene.
	local hide_faction_leader_during_cutscene = 120;

	-- We also want to hide/show the principal enemy army, as they get in the way. Here we store the character cqi for them.
	local principal_enemy_char_cqi;
	local principal_enemy_char_is_hidden = false;


	-- local function to hide/unhide enemy character by cqi
	local function hide_principal_enemy_char(cqi, hide)
		if hide then
			if not principal_enemy_char_is_hidden then
				cm:toggle_character_hidden_from_view(cm:get_character_by_cqi(cqi), true);
				principal_enemy_char_is_hidden = true;
			end;
		else
			if principal_enemy_char_is_hidden then
				cm:toggle_character_hidden_from_view(cm:get_character_by_cqi(cqi), false);
				principal_enemy_char_is_hidden = false;
			end;
		end;
	end;

	
	local function cutscene_configurator(c)
		-- perform non-standard cutscene configuration here

		-- Lookup principal enemy character
		local faction = cm:get_faction("wh_main_emp_nordland");
		if not faction then
			script_error("ERROR: playing Daemon Prince intro cutscene but couldn't find faction wh_main_emp_nordland - this needs fixing")
			return false;
		end;

		local character = cm:get_closest_general_to_position_from_faction(faction, 171, 312);
		principal_enemy_char_cqi = character:command_queue_index();

		-- Hide character at start
		c:action(function() hide_principal_enemy_char(principal_enemy_char_cqi, true) end, 0);

		-- Unhide during cutscene
		c:action(function() hide_principal_enemy_char(principal_enemy_char_cqi, false) end, hide_faction_leader_during_cutscene);
	end;


	local function end_callback()
		-- perform non-standard cutscene-end configuration here

		-- Unhide the principal enemy character at the end of the cutscene
		hide_principal_enemy_char(principal_enemy_char_cqi, false);
	end;

	local fullscreen_movie = "warhammer3/dae/dae_intro";

	
	-- Intro story panel callback, shown after the fsm and before the cindyscene
	local function pre_cindyscene_delay_callback(progression_callback)
		show_intro_story_panel_with_progression_callback(cm:get_local_faction_name(), "wh3_main_story_panel_intro_dae", progression_callback);
	end;

	-- Invoke conmmon campaign intro setup
	cm:setup_campaign_intro_cutscene(cam_gameplay_start, cindy_scene_key, advice_to_play, end_callback, cutscene_configurator, fullscreen_movie, hide_faction_leader_during_cutscene, pre_cindyscene_delay_callback);
end;
