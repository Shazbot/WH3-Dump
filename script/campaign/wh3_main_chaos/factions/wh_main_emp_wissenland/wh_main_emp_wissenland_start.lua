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
	local faction_key = "wh_main_emp_wissenland";
	
	-- position of the camera when cutscene skipped in singleplayer or gameplay starts in multiplayer
	local cam_gameplay_start = {
		x = 202.4,
		y = 22.0,
		d = 14.4,
		b = -0.1,
		h = 11.5
	};

	local cindy_scene_key = "emp_elspeth";

	local advice_to_play = {
		"wh3_camp_realm_of_chaos_elspeth_intro_001",
		"wh3_camp_realm_of_chaos_elspeth_intro_002",
		"wh3_camp_realm_of_chaos_elspeth_intro_003",
		"wh3_camp_realm_of_chaos_elspeth_intro_004",
		"wh3_camp_realm_of_chaos_elspeth_intro_005",
	};
	
	local function end_callback()
		-- perform non-standard cutscene-end configuration here
	end;
	
	local function cutscene_configurator(c)
		-- perform non-standard cutscene configuration here
	end;

	local fullscreen_movie = "warhammer3/emp/elspeth_intro";

	-- Hide the faction leader during the cutscene.
	-- Set this to false or nil to not hide/unhide them.
	-- Set this to true or 0 to hide them for the duration of the cutscene, unhiding them at the end
	-- Set this to a positive number to hide them at the start, then unhide them x seconds in to the cutscene.
	local hide_faction_leader_during_cutscene = false;

	-- Invoke common campaign intro setup
	cm:setup_campaign_intro_cutscene(faction_key, cam_gameplay_start, cindy_scene_key, advice_to_play, end_callback, cutscene_configurator, fullscreen_movie, hide_faction_leader_during_cutscene);	

end