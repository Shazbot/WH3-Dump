




----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--
--	Project Specific battle library scripts go here
--
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------


function display_shanty_text(shanty_number)
	if shanty_number ~= 1 and shanty_number ~= 2 and shanty_number ~= 3 then
		script_error("ERROR: display_shanty_text() called but supplied shanty number [" .. tostring(shanty_number) .. "] is not valid - it should be 1, 2 or 3");
		return false;
	end;
	
	if common.get_advice_history_string_seen("vampire_coast_battle_shanty_" .. shanty_number) and not common.subtitles_enabled() then
		bm:out("Shanty " .. shanty_number .. " was triggered but subtitles are not enabled in player preferences and this is not the first time the player has seen this shanty - not displaying text");
		return;
	end;
	
	-- mark this shanty as seen in the advice history
	common.set_advice_history_string_seen("vampire_coast_battle_shanty_" .. shanty_number);

	-- construct the text pointer
	local tp = text_pointer:new("shanty_text_" .. shanty_number .. "_" .. core:get_unique_counter());
	tp:add_component_text("text", "scripted_subtitles_localised_text_wh2_dlc11_sea_shanty_0" .. shanty_number);
	
	-- set the style
	tp:set_style("top_centre_subtitle");
	tp:set_stream_duration(5);
	
	bm:out("Displaying shanty " .. shanty_number);
	
	tp:show();
	
	bm:callback(
		function()
			tp:hide()
		end,
		10000
	);
end;








-- called by the battle manager on initialisation
function start_project_specific_scripts()

	-- adds a listener for a shanty army ability being used and displays shanty text to go along with the audio
	core:add_listener(
		"shanty_ability_listener",
		"ComponentLClickUp",
		function(context)
			 return UIComponent(context.component):CurrentState() == "down" and string.find(context.string, "button_ability_wh2_dlc11_army_abilities_shanty_verse_");
		end,
		function(context)
			bm:out("waiting to trigger shanty callback");
			bm:remove_process("shanty_ability_callback");
			local ability_name = context.string;
			bm:callback(
				function()
					bm:out("triggering shanty callback");
					core:hide_all_text_pointers();
					display_shanty_text(tonumber(string.sub(ability_name, -1)));
				end,
				500,
				"shanty_ability_callback"
			);
		end,
		true
	);
	
	output_uicomponent_on_click();
end;

