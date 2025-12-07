dechala_daemonic_units_config =
{
	-- Dechala faction key
	faction_key = "wh3_dlc27_sla_the_tormentors",

	technology_key = "wh3_dlc27_tech_sla_daemonic_attraction",
	ai_unlock_turn = 30,
	tooltip_key = "wh3_dlc27_sla_daemonic_units_required_tech",

	units = 
	{
		"wh3_dlc27_sla_cav_heartseekers_of_slaanesh_dechala",
		"wh3_dlc27_sla_cav_pleasureseekers_dechala",
		"wh3_dlc27_sla_inf_chaos_furies_dechala",
		"wh3_dlc27_sla_inf_daemonette_1_dechala",
		"wh3_dlc27_sla_mon_fiends_of_slaanesh_dechala",
		"wh3_dlc27_sla_mon_keeper_of_secrets_dechala",
		"wh3_dlc27_sla_veh_exalted_seeker_chariot_dechala",
	},
}


dechala_daemonic_units = {}
dechala_daemonic_units.config = dechala_daemonic_units_config


function dechala_daemonic_units:initialise()
	out("#### Adding Dechala Daemonic Units Listeners ####");

	local dechala_faction_interface = cm:get_faction(dechala_daemonic_units.config.faction_key)
	if not dechala_faction_interface then
		return
	end

	if dechala_faction_interface:has_technology(dechala_daemonic_units.config.technology_key) then
		return
	end

	for _, unit_key in ipairs(dechala_daemonic_units.config.units) do
		cm:add_event_restricted_unit_record_for_faction(unit_key, dechala_daemonic_units.config.faction_key, dechala_daemonic_units.config.tooltip_key)
	end

	core:add_listener(
		"DaemonicAttractionResearchCompleted",
		"ResearchCompleted",
		function(context)
			local faction = context:faction()
			local technology_key = context:technology()
			return faction:name() == dechala_daemonic_units.config.faction_key and technology_key == dechala_daemonic_units.config.technology_key
		end,
		function(context)
			for _, unit_key in ipairs(dechala_daemonic_units.config.units) do
				cm:remove_event_restricted_unit_record_for_faction(unit_key, dechala_daemonic_units.config.faction_key)
			end
		end,
		false
	)
end