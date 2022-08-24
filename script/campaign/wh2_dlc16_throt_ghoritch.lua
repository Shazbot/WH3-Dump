function add_throt_unlock_ghoritch_listeners()
	out("#### Adding Throt Unlock Ghoritch Listeners ####");
	local throt_faction_key = "wh2_main_skv_clan_moulder";
    local throt_faction = cm:get_faction(throt_faction_key);
	
	if throt_faction:is_human() then
		core:add_listener(
			"Ghoritch_MissionSucceeded",
			"MissionSucceeded",
			function(context)
				return context:mission():mission_record_key() == "wh3_main_ie_qb_skv_throt_main_whip_of_domination";
			end,
			function()
				cm:spawn_unique_agent_at_character(throt_faction:command_queue_index(), "wh2_dlc16_skv_ghoritch", throt_faction:faction_leader():command_queue_index(), false);
				cm:trigger_incident(throt_faction_key, "wh2_dlc16_incident_skv_ghoritch_arrives", true, false);
			end,
			false
		);
	else
		core:add_listener(
			"Ghoritch_CharacterRankUp",
			"CharacterRankUp",
			function(context)
				local character = context:character();
				return character:character_subtype("wh2_dlc16_skv_throt_the_unclean") and character:rank() == 5;
			end,
			function(context)
				cm:spawn_unique_agent(context:character():faction():command_queue_index(), "wh2_dlc16_skv_ghoritch", false);
			end,
			false
		);
	end
end