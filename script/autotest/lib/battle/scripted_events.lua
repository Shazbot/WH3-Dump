function Lib.Battle.Scripted_Events.force_player_victory_on_start()
    callback(function()
        Timers_Callbacks.battle_call(function()
			local deployed_units = bm:get_non_player_alliance()
			if(deployed_units) then
				Utilities.print("----- INFO: Forcing player victory -----")
				rout_all_units(deployed_units)
			end
        end)
	end)
end