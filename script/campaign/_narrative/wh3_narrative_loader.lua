

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	NARRATIVE LOADER
--
--	PURPOSE
--	When loaded, this file loads other files related to the narrative system and to shared narrative events/queries/triggers.
--
--	LOADED
--	This file should be loaded by the per-campaign script for narrative events e.g. wh3_chaos_narrative_events.lua for
--	the Chaos campaign. It should get loaded on start of script.
--	
--	AUTHORS
--	SV
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


out.narrative("* wh3_narrative_loader.lua loaded");

-- load base narrative system
require("wh3_narrative_system");

-- load template files for events, queries and triggers
require("wh3_narrative_event_templates");
require("wh3_narrative_query_templates");
require("wh3_narrative_trigger_templates");

-- load shared faction data - basic faction data shared between all campaigns
require("wh3_narrative_shared_faction_data");

-- load shared narrative chain definitions
require("wh3_narrative_shared_chains");











