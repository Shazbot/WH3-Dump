unholy_manifestations = {
    keys = {
        khorne = {
            upgraded = {
                [2] = "wh3_main_ritual_kho_gg_2_upgraded",
                [4] = "wh3_main_ritual_kho_gg_4_upgraded"
            }
        }
    },

	khorne = {
		gg_2_upgraded_settlement_level = 2,
	},
}

function unholy_manifestations:initialise()
    core:add_listener(
		"kho_gg_2_upgraded_listener",
		"RitualCompletedEvent",
		function(context) 
			return context:ritual():ritual_key() == self.keys.khorne.upgraded[2]
		end,
		function(context) 
			local region = context:ritual():ritual_target():get_target_region()
			local settlement = is_region(region) and region:settlement()
			if settlement then
				cm:instantly_set_settlement_primary_slot_level(settlement, self.khorne.gg_2_upgraded_settlement_level)
				cm:callback(function() cm:heal_garrison(region:cqi()) end, 0.5)
			end			
		end,
		true	
	)

	core:add_listener(
		"kho_gg_4_upgraded_listener",
		"RitualCompletedEvent",
		function(context) 
			return context:ritual():ritual_key() == self.keys.khorne.upgraded[4]
		end,
		function(context) 			
			local corruption_types = {
				"chaos",
				"skaven",
				"vampiric",
				"nurgle",
				"slaanesh",
				"tzeentch",
			}
			local prm = context:ritual():ritual_target():get_target_region():province():pooled_resource_manager()
			for i = 1, #corruption_types do
				cm:pooled_resource_factor_transaction(prm:resource("wh3_main_corruption_" .. corruption_types[i]), "local_populace", -100)
			end	
			cm:pooled_resource_factor_transaction(prm:resource("wh3_main_corruption_khorne"), "local_populace", 100)
		end,
		true	
	)
end
