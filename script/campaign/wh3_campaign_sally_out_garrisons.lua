core:add_listener(
		"CharacterFinishedMovingEvent_GarrisonSallyOut",
		"CharacterFinishedMovingEvent",
		function(context)
			local character = context:character();
			return character:has_region() == true and character:is_wounded() == false and character:character_type("colonel");
		end,
		function(context)
			-- We refresh colonel AP because there shouldn't ever be a time they can't move/attack even though they do use AP
			local character_cqi = context:character():command_queue_index();
			cm:replenish_action_points(cm:char_lookup_str(character_cqi));
		end,
		true
);