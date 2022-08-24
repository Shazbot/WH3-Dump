------------------------------------------------------------------------------
--
--	Show Realms of Chaos mod
--	Stephen
--
--	Shows the Realms of Chaos after the cindy intro on turn one. They will
--	disappear as soon as a character moves.
--	This is to help cindy artists create replays with the RoC displayed.
------------------------------------------------------------------------------

function show_realms_of_chaos()
	local tweaker_name = "SCRIPTED_TWEAKER_17";

	if core:is_tweaker_set(tweaker_name) then
		script_error("INFO: show_realms_of_chaos() mod is active - the Realms of Chaos will be drawn after the intro cindyscene is finished");

		-- test scripts here
		function show_rocs()
			cm:force_terrain_patch_visible("wh3_main_patch_area_forge_of_souls");
			cm:force_terrain_patch_visible("wh3_main_patch_area_khorne_realm");
			cm:force_terrain_patch_visible("wh3_main_patch_area_nurgle_realm");
			cm:force_terrain_patch_visible("wh3_main_patch_area_slaanesh_realm");
			cm:force_terrain_patch_visible("wh3_main_patch_area_tzeentch_realm");
		end;

		core:add_listener(
			"test",
			"ScriptEventIntroCutsceneFinished",
			true,
			function()
				cm:callback(function() show_rocs() end, 1);
			end,
			true
		);

		core:add_listener(
			"test",
			"ComponentLClickUp",
			true,
			function()
				show_rocs();
			end,
			true
		);
	end;
end;