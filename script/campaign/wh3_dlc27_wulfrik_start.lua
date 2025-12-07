wulfrik_start = {}
wulfrik_start.faction = "wh_dlc08_nor_norsca"
wulfrik_start.troll_fjord_new_owner = "wh_main_nor_bjornling"
wulfrik_start.dilemma = "wh3_dlc27_dilemma_wulfrik_start"
wulfrik_start.start_region = "wh3_main_combi_region_monument_of_the_moon"
wulfrik_start.troll_fjord_region = "wh3_main_combi_region_troll_fjord"

function wulfrik_start:initialise()
	local faction = cm:get_faction(self.faction)
	if not faction or not faction:is_human() then return end

	if not cm:get_saved_value("wulfrik_start_dilemma_issued") then
		core:add_listener(
			"wulfrik_start_dilemma",
			"RegionFactionChangeEvent",
			function(context)
				return not cm:get_saved_value("wulfrik_start_dilemma_issued")
					--and context:region():name() == self.start_region
					and cm:is_region_owned_by_faction(self.troll_fjord_region, self.faction)
					and cm:is_region_owned_by_faction(context:region():name(), self.faction)
					and cm:turn_number() < 25
			end,
			function(context)
				cm:trigger_dilemma(self.faction, self.dilemma)
				cm:set_saved_value("wulfrik_start_dilemma_issued", true)
			end,
			false
		)
	end
	
	core:add_listener(
		"wulfrik_start_dilemma_choice",
		"DilemmaChoiceMadeEvent",
		function(context)
			return context:dilemma() == self.dilemma
		end,
		function(context)
			if context:choice() == 1 then
				cm:disable_event_feed_events(true, "wh_event_category_conquest", "", "")
				if cm:model():world():faction_by_key(self.troll_fjord_new_owner):is_null_interface() == false then
					custom_starts:abandon_region(self.troll_fjord_region)
				else
					cm:transfer_region_to_faction(self.troll_fjord_region, self.troll_fjord_new_owner)
					cm:callback(
						function() 
							cm:heal_garrison(cm:get_region(self.troll_fjord_region):cqi())
							cm:disable_event_feed_events(false, "wh_event_category_conquest", "", "")
						end,
						0.5
					)
				end
			end
		end,
		false
	)
end