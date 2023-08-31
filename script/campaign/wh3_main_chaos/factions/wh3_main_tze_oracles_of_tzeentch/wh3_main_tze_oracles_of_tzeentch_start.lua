

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
	local faction_key = "wh3_main_tze_oracles_of_tzeentch";
	
	-- position of the camera when cutscene skipped in singleplayer or gameplay starts in multiplayer
	local cam_gameplay_start = {
		x = 538.4,
		y = 376.4,
		d = 17.1,
		b = 0,
		h = 13.9
	};

	local cindy_scene_key = "tze_kairos";

	local advice_to_play = {
		"wh3_main_camp_chaos_tze_oracles_tzeentch_intro_01",
		"wh3_main_camp_chaos_tze_oracles_tzeentch_intro_02",
		"wh3_main_camp_chaos_tze_oracles_tzeentch_intro_03",
		"wh3_main_camp_chaos_tze_oracles_tzeentch_intro_04",
		"wh3_main_camp_chaos_tze_oracles_tzeentch_intro_05",
		"wh3_main_camp_chaos_tze_oracles_tzeentch_intro_06",
		"wh3_main_camp_chaos_tze_oracles_tzeentch_intro_07",
		"wh3_main_camp_chaos_tze_oracles_tzeentch_intro_08",
		"wh3_main_camp_chaos_tze_oracles_tzeentch_intro_09",
		"wh3_main_camp_chaos_tze_oracles_tzeentch_intro_10"
	};
	
	local function end_callback()
		-- perform non-standard cutscene-end configuration here
	end;
	
	local function cutscene_configurator(c)
		-- perform non-standard cutscene configuration here
	end;

	local fullscreen_movie = "warhammer3/tze/tze_intro_fat";

	-- Hide the faction leader during the cutscene.
	-- Set this to false or nil to not hide/unhide them.
	-- Set this to true or 0 to hide them for the duration of the cutscene, unhiding them at the end
	-- Set this to a positive number to hide them at the start, then unhide them x seconds in to the cutscene.
	local hide_faction_leader_during_cutscene = 45;

	-- Intro story panel callback, shown after the fsm and before the cindyscene
	local function pre_cindyscene_delay_callback(progression_callback)
		show_intro_story_panel_with_progression_callback(faction_key, "wh3_main_story_panel_intro_tze", progression_callback);
	end;

	-- Invoke conmmon campaign intro setup
	cm:setup_campaign_intro_cutscene(faction_key, cam_gameplay_start, cindy_scene_key, advice_to_play, end_callback, cutscene_configurator, fullscreen_movie, hide_faction_leader_during_cutscene, pre_cindyscene_delay_callback, true);
end;