jade_dragon_start = {}
jade_dragon_start.faction = "wh3_dlc24_cth_the_celestial_court"
jade_dragon_start.shang_wu_new_owner = "wh3_main_cth_the_jade_custodians"
jade_dragon_start.dilemma = "wh3_dlc24_dilemma_yuan_bo_start"
jade_dragon_start.subtype = "wh3_dlc24_cth_yuan_bo"
jade_dragon_start.start_region = "wh3_main_combi_region_the_high_sentinel"
jade_dragon_start.shang_wu_region = "wh3_main_combi_region_shang_wu"

function jade_dragon_start:initialise()
	local faction = cm:get_faction(jade_dragon_start.faction)
	if not faction or not faction:is_human() then return end

	if not cm:get_saved_value("jade_dragon_start_dilemma_issued") then
		core:add_listener(
			"jade_dragon_start_dilemma",
			"GarrisonOccupiedEvent",
			function(context)
				return not cm:get_saved_value("jade_dragon_start_dilemma_issued") and context:character():character_subtype(self.subtype) and context:garrison_residence():region():name() == self.start_region and cm:is_region_owned_by_faction(self.shang_wu_region, self.faction) and cm:turn_number() < 25
			end,
			function(context)
				cm:trigger_dilemma(self.faction, self.dilemma)
				cm:set_saved_value("jade_dragon_start_dilemma_issued", true)
			end,
			false
		)
	end 
	
	core:add_listener(
		"jade_dragon_start_dilemma_choice",
		"DilemmaChoiceMadeEvent",
		function(context)
			return context:dilemma() == self.dilemma
		end,
		function(context)
			if context:choice() == 1 then
				cm:disable_event_feed_events(true, "wh_event_category_conquest", "", "")
				cm:transfer_region_to_faction(self.shang_wu_region, self.shang_wu_new_owner)
				cm:callback(
					function() 
						cm:heal_garrison(cm:get_region(self.shang_wu_region):cqi());
						cm:disable_event_feed_events(false, "wh_event_category_conquest", "", "")
					end,
					0.5
				)
			end
		end,
		false
	)
end