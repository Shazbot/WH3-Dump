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
	incident_key = "wh3_main_incident_sea_lanes_character_arrived",
	aislinn_nodes = {
		--{template = "wh3_main_teleportation_node_template_aislinn_east", node = "wh3_dlc27_aislinn_sea_lane_east_1"}, -- Disabled for GW
		--{template = "wh3_main_teleportation_node_template_aislinn_east", node = "wh3_dlc27_aislinn_sea_lane_east_2"},
		{template = "wh3_main_teleportation_node_template_aislinn_north", node = "wh3_dlc27_aislinn_sea_lane_north_1"},
		{template = "wh3_main_teleportation_node_template_aislinn_north", node = "wh3_dlc27_aislinn_sea_lane_north_2"},
		{template = "wh3_main_teleportation_node_template_aislinn_west", node = "wh3_dlc27_aislinn_sea_lane_west_1"},
		{template = "wh3_main_teleportation_node_template_aislinn_west", node = "wh3_dlc27_aislinn_sea_lane_west_2"},
		{template = "wh3_main_teleportation_node_template_aislinn_south", node = "wh3_dlc27_aislinn_sea_lane_south_1"},
		{template = "wh3_main_teleportation_node_template_aislinn_south", node = "wh3_dlc27_aislinn_sea_lane_south_2"}
	},
	
	lokhir_nodes = {
		{template = "wh3_main_teleportation_node_template_lokhir_north", node = "wh3_dlc27_lokhir_sea_lane_north_1"},
		{template = "wh3_main_teleportation_node_template_lokhir_north", node = "wh3_dlc27_lokhir_sea_lane_north_2"},
		{template = "wh3_main_teleportation_node_template_lokhir_west", node = "wh3_dlc27_lokhir_sea_lane_west_1"},
		{template = "wh3_main_teleportation_node_template_lokhir_west", node = "wh3_dlc27_lokhir_sea_lane_west_2"},
		{template = "wh3_main_teleportation_node_template_lokhir_south", node = "wh3_dlc27_lokhir_sea_lane_south_1"},
		{template = "wh3_main_teleportation_node_template_lokhir_south", node = "wh3_dlc27_lokhir_sea_lane_south_2"}
	},

	persistent = {
		eastern_isles_nodes_open = false,
	}
}



function sea_lanes:open_all_nodes()
	for _, template in ipairs(sea_lanes.templates) do
		for _, node in ipairs(sea_lanes.nodes[template]) do
			cm:teleportation_network_open_node(node, template)
		end
	end
end

function sea_lanes:open_aislinn_nodes()
	-- Check if the nodes are already open - either by Aislinn or by Lokhir
	if sea_lanes.persistent.eastern_isles_nodes_open == false then
		for i = 1, #sea_lanes.aislinn_nodes do
			cm:teleportation_network_open_node(sea_lanes.aislinn_nodes[i].node, sea_lanes.aislinn_nodes[i].template);
		end
		sea_lanes.persistent.eastern_isles_nodes_open = true
	end
end

function sea_lanes:close_aislinn_nodes()
	if sea_lanes.persistent.eastern_isles_nodes_open == true then
		for i = 1, #sea_lanes.aislinn_nodes do
			cm:teleportation_network_close_node(sea_lanes.aislinn_nodes[i].node);
		end
		sea_lanes.persistent.eastern_isles_nodes_open = false
	end
end

function sea_lanes:open_lokhir_nodes()
	if sea_lanes.persistent.eastern_isles_nodes_open == false then
		for i = 1, #sea_lanes.lokhir_nodes do
			cm:teleportation_network_open_node(sea_lanes.lokhir_nodes[i].node, sea_lanes.lokhir_nodes[i].template);
		end
		--Lokhir nodes are for Aislinn and Lokhir - we mark that the nodes are open, so that the Aislinn-only nodes don't open afterwards
		sea_lanes.persistent.eastern_isles_nodes_open = true
	end
end

function sea_lanes:character_arrived_incident_listener()
	core:add_listener(
		"sea_lanes_character_arrived",
		"TeleportationNetworkMoveCompleted",
		true,
		function(context)
			if context:character():is_null_interface() == false and context:character():character():is_null_interface() == false then
				local character = context:character():character();
				local faction = character:faction();
				local from_record = context:from_record();

				if from_record:is_null_interface() == false then
					local template_key = from_record:template_key();
					local instant_move_bv = cm:get_factions_bonus_value(faction, "instant_sea_lane_travel");

					if instant_move_bv == 0 then
						if sea_lanes.nodes[template_key] then
							local faction_cqi = faction:command_queue_index();
							local character_cqi = character:command_queue_index();
							cm:trigger_incident_with_targets(faction_cqi, self.incident_key, 0, 0, character_cqi, 0, 0, 0);
						end
					else
						-- Some factions can instantly use sea lanes so we should move the camera and not trigger the incident
						-- Bonus value is reusable but we need to check here which teleport nodes are actually used as some don't need camera movement
						if sea_lanes.nodes[template_key] then
							local x, y, d, b, h = cm:get_camera_position();
							x = character:display_position_x();
							y = character:display_position_y();
							cm:set_camera_position(x, y, d, b, h);
						else
							for i = 1, #sea_lanes.aislinn_nodes do
								if sea_lanes.aislinn_nodes[i].template == template_key then
									local x, y, d, b, h = cm:get_camera_position();
									x = character:display_position_x();
									y = character:display_position_y();
									cm:set_camera_position(x, y, d, b, h);
									break;
								end
							end
						end
					end
				end
			end
		end,
		true	
	);
end

function sea_lanes:initiate_sea_lanes()
	local sea_lanes_enabled = cm:model():shared_states_manager():get_state_as_bool_value("enable_sea_lanes")
	out.design("Campaign Settings: Sea Lanes Enabled - "..tostring(sea_lanes_enabled))
	if sea_lanes_enabled then
		sea_lanes:open_all_nodes();
	end
	sea_lanes:character_arrived_incident_listener();
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("SeaLanesPersistentData", sea_lanes.persistent, context);
	end
);

cm:add_loading_game_callback(
	function(context)
		if (cm:is_new_game() == false) then
			sea_lanes.persistent = cm:load_named_value("SeaLanesPersistentData", sea_lanes.persistent, context);
		end
	end
);