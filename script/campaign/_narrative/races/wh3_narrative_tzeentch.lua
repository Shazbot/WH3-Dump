------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	RACE-SPECIFIC NARRATIVE EVENT CHAINS
--
--	PURPOSE
--
--	This file defines chains of narrative events that are specific to a particular race. These are mostly 
--	tutorial missions related to race features like Khorne Skulls, Kislev Atamans, Cathay Compass etc. 
--	
--	The narrative loader function defined at the bottom of this file is added to the narrative system with a call
--	to narrative.add_loader_for_culture. The function will be called when the narrative system is started,
--	on or around the first tick, but only if there is a human-controlled faction in the campaign of the
--	relevant race.
--
--	LOADED
--	This file is currently loaded from wh3_narrative_shared_faction_data.lua, this may change in the future. It
--	is loaded when narrative.start() is called, as the faction data is loaded.
--	
--	AUTHORS
--	SV
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

out.narrative("* wh3_narrative_tzeentch.lua loaded");

local shared_prepend_str = shared_narrative_event_prepend_str;












------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	CHANGING OF THE WAYS
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


local function tzeentch_changing_of_the_ways_narrative_loader(faction_key)

	-- output header
	narrative.output_chain_header("tzeentch changing of the ways", faction_key);

	narrative.unimplemented_output("tzeentch changing of the ways");



	-- query: advice

	-- 		wait 3 turns

	--			trigger: has changing of the ways action been used

	--				no:

	--					EVENT: use changing of the ways action

	--				wait 1 turn

	--					query: has any CotW tech been researched

	--						no:

	--							research any CotW tech

	--						yes:

	--							goto expert

	--		EXPERT: wait 15 turns

	--			unlock five CotW actions


	narrative.output_chain_footer();

end;











------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	GREAT GAME
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

local function tzeentch_great_game_narrative_loader(faction_key)
	great_game_narrative_loader(
		faction_key, 
		"Tzeentch",							-- chaos type name (for script messages)
		"wh3_main_corruption_tzeentch", 	-- corruption pooled resource key
		"wh3_main_tze_tzeentch"				-- culture
	);
end;












------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	EYE OF TZEENTCH
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


local function tzeentch_eye_of_tzeentch_narrative_loader(faction_key)

	-- output header
	narrative.output_chain_header("tzeentch eye of tzeentch", faction_key);

	narrative.unimplemented_output("tzeentch eye of tzeentch");

	narrative.output_chain_footer();

end;












------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	Start all Chains
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


local function start_tzeentch_narrative_events(faction_key)

	tzeentch_changing_of_the_ways_narrative_loader(faction_key);
	tzeentch_great_game_narrative_loader(faction_key);
	tzeentch_eye_of_tzeentch_narrative_loader(faction_key);
	chaos_movements_narrative_loader(faction_key);
end;


-- Ensure that these narrative events are started for any player-controlled faction matching the culture
narrative.add_loader_for_culture("wh3_main_tze_tzeentch", start_tzeentch_narrative_events);