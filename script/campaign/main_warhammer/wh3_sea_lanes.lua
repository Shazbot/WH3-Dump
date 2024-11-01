sea_lanes = {
	templates = {
		"wh3_main_teleportation_node_template_jade_to_dread",
		"wh3_main_teleportation_node_template_underworld_sea",
		"wh3_main_teleportation_node_template_jade_to_far_sea",
		"wh3_main_teleportation_node_template_jade_to_lustria_gulf",
		"wh3_dlc23_teleportation_node_template_chaos_dwarf_canal"
	},
	nodes = {
		["wh3_main_teleportation_node_template_jade_to_dread"] = {
			"wh3_main_sea_lane_far_jade_to_dread_1",
			"wh3_main_sea_lane_far_jade_to_dread_2"
		},
		["wh3_main_teleportation_node_template_jade_to_far_sea"] = {
			"wh3_main_sea_lane_far_jade_to_far_sea_1",
			"wh3_main_sea_lane_far_jade_to_far_sea_2"
		},
		["wh3_main_teleportation_node_template_jade_to_lustria_gulf"] = {
			"wh3_main_sea_lane_far_jade_to_lustria_gulf_1",
			"wh3_main_sea_lane_far_jade_to_lustria_gulf_2"
		},
		["wh3_main_teleportation_node_template_underworld_sea"] = {
			"wh3_main_sea_lane_underworld_sea_1",
			"wh3_main_sea_lane_underworld_sea_2"
		},
		["wh3_dlc23_teleportation_node_template_chaos_dwarf_canal"] = {
			"wh3_dlc23_sea_lane_chaos_dwarf_canal_north",
			"wh3_dlc23_sea_lane_chaos_dwarf_canal_south"
		}
	},
	incident_key = "wh3_main_incident_sea_lanes_character_arrived"
}

function sea_lanes:open_all_nodes()
	for _, template in ipairs(sea_lanes.templates) do
		for _, node in ipairs(sea_lanes.nodes[template]) do
			cm:teleportation_network_open_node(node, template)
		end
	end
end

function sea_lanes:character_arrived_incident_listener()
	core:add_listener(
		"sea_lanes_character_arrived",
		"TeleportationNetworkMoveCompleted",
		function(context)
			local from_record = context:from_record()

			return from_record:is_null_interface() == false and sea_lanes.nodes[from_record:template_key()]
		end,
		function(context)
			if context:character():is_null_interface() == false and context:character():character():is_null_interface() == false then
				local character = context:character():character()
				local character_cqi = character:command_queue_index()
				local faction_cqi = character:faction():command_queue_index()
				cm:trigger_incident_with_targets(faction_cqi, self.incident_key, 0, 0, character_cqi, 0, 0, 0)
			end
		end,
		true	
	);
end

function sea_lanes:initiate_sea_lanes()
	local sea_lanes_enabled = cm:model():shared_states_manager():get_state_as_bool_value("enable_sea_lanes")
	out.design("Campaign Settings: Sea Lanes Enabled - "..tostring(sea_lanes_enabled))
	if sea_lanes_enabled then
		sea_lanes:open_all_nodes()
		sea_lanes:character_arrived_incident_listener()
	end
end