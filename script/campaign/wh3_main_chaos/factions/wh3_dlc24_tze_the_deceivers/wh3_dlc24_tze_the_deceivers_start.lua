

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
	local faction_key = "wh3_dlc24_tze_the_deceivers";
	
	local cam_gameplay_start = {
		x = 149.6,
		y = 111.1,
		d = 9.7,
		b = 0,
		h = 11.4
	};

	local cindy_scene_key = "tze_thechangeling";

	local advice_to_play = {
		"wh3_camp_realm_of_chaos_the_changeling_intro_001",
		"wh3_camp_realm_of_chaos_the_changeling_intro_002",
		"wh3_camp_realm_of_chaos_the_changeling_intro_003",
		"wh3_camp_realm_of_chaos_the_changeling_intro_004",
		"wh3_camp_realm_of_chaos_the_changeling_intro_005",
		"wh3_camp_realm_of_chaos_the_changeling_intro_006"
	};

	local function end_callback()
		-- perform non-standard cutscene-end configuration here
	end;
	
	local function cutscene_configurator(c)
		-- perform non-standard cutscene configuration here
	end;

	local fullscreen_movie = "warhammer3/tze/the_changeling_intro";

	-- Hide the faction leader during the cutscene.
	-- Set this to false or nil to not hide/unhide them.
	-- Set this to true or 0 to hide them for the duration of the cutscene, unhiding them at the end
	-- Set this to a positive number to hide them at the start, then unhide them x seconds in to the cutscene.
	local hide_faction_leader_during_cutscene = 45;

	-- Invoke conmmon campaign intro setup
	cm:setup_campaign_intro_cutscene(faction_key, cam_gameplay_start, cindy_scene_key, advice_to_play, end_callback, cutscene_configurator, fullscreen_movie, hide_faction_leader_during_cutscene);
end;