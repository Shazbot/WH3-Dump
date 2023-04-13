chaos_dwarf_labour_loss = {
	control_brackets = {
		-- make sure the loss percent matches the loss percent dummies in DaVE on the control effects
		{min = -100, max = -75, loss_percent = 20},
		{min = -74, max = -50, loss_percent = 15},
		{min = -49, max = -25, loss_percent = 10},
		{min = -24, max = 24, loss_percent = 5},
		{min = 25, max = 49, loss_percent = 5},
		{min = 50, max = 74, loss_percent = 3},
		{min = 75, max = 100, loss_percent = 3}
	},

	-- this is the min labour that can be lost each turn if the % is less than this number it will lose this number instead
	min_labour_loss = 5,

	initial_labour = 500
}

function chaos_dwarf_labour_loss:labour_loss()
	self:grant_starting_province_labour()

	core:add_listener(
		"chd_labour_loss",
		"WorldStartRound",
		function(context)
			return cm:turn_number() >= 2
		end,
		function(context)
			self:labour_loss_per_turn()
		end,
		true
	)
end

function chaos_dwarf_labour_loss:grant_starting_province_labour()
	if cm:is_new_game() then
		local human_factions = cm:get_human_factions_of_culture("wh3_dlc23_chd_chaos_dwarfs")
		for _, faction_key in ipairs(human_factions) do
			local faction = cm:get_faction(faction_key)
			local faction_provinces_list = faction:provinces()
			local faction_provinces_count = faction_provinces_list:num_items()

			for i = 0, faction_provinces_count - 1 do
				local province = faction_provinces_list:item_at(i)
				local province_pr_manager = province:pooled_resource_manager()
				local labour = province_pr_manager:resource("wh3_dlc23_chd_labour")

				if labour:is_null_interface() == false then
					cm:pooled_resource_factor_transaction(labour, "other", chaos_dwarf_labour_loss.initial_labour)
					-- Enable labour intake for the factions starting province.
					cm:disable_distribution_to_entity(faction:command_queue_index(), "wh3_dlc23_chd_labour_global_temp", province, false)
				end
			end
		end
	end
end

function chaos_dwarf_labour_loss:labour_loss_per_turn()
	local human_factions = cm:get_human_factions_of_culture("wh3_dlc23_chd_chaos_dwarfs")
	for _, faction_key in ipairs(human_factions) do
		local faction = cm:get_faction(faction_key)
		local faction_provinces_list = faction:provinces()
		local faction_provinces_count = faction_provinces_list:num_items()

		for i = 0, faction_provinces_count - 1 do
			local province = faction_provinces_list:item_at(i)
			local province_data = province:province()
			local prov_control = province_data:regions():item_at(0):public_order()
			local labour = province:pooled_resource_manager():resource("wh3_dlc23_chd_labour")
			local labour_value = labour:value()

			for k, v in ipairs(chaos_dwarf_labour_loss.control_brackets) do
				if prov_control >= v.min and prov_control <= v.max then
					local labour_loss = math.floor((labour_value / 100) * v.loss_percent)

					if(labour_loss < chaos_dwarf_labour_loss.min_labour_loss) then
						labour_loss = chaos_dwarf_labour_loss.min_labour_loss
					end

					cm:pooled_resource_factor_transaction(labour, "wh3_dlc23_chd_loss", -labour_loss)
					break
				end
			end
		end
	end
end