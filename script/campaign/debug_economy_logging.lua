
cm:add_first_tick_callback_new(
	function()
		out.design("***Begin economy logging***")
		local scripted_GUID = os.time();
		cm:set_script_state("campaign_GUID", scripted_GUID);
	end
);

core:add_listener(
	"log_player_economy_data",
	"FactionTurnEnd",
	function(context)
		return context:faction():is_human();
	end,
	function(context)
		local faction = context:faction();
		--output_data(generate_economy_datum(faction));
	end,
	true
);

function generate_economy_datum(faction_interface)

	local scripted_GUID = cm:model():shared_states_manager():get_state_as_float_value("campaign_GUID")
	local turn_number = faction_interface:model():turn_number();
	
	local gross_treasury = faction_interface:treasury();
	local gross_expenditure = faction_interface:expenditure();
	local gross_income = faction_interface:income();
	
	local net_income = faction_interface:net_income();
	local trade_income = faction_interface:trade_value();
	local upkeep = faction_interface:upkeep();
	
	local num_regions = faction_interface:region_list():num_items();
	local num_forces = faction_interface:military_force_list():num_items() - num_regions;
	
	return scripted_GUID,
			turn_number,
			gross_treasury,
			gross_expenditure,
			gross_income,
			net_income,
			trade_income,
			upkeep,
			num_forces,
			num_regions
end

function output_data(
					scripted_GUID,
					turn_number,
					gross_treasury,
					gross_expenditure,
					gross_income,
					net_income,
					trade_income,
					upkeep,
					num_forces,
					num_regions
					)
	
	local comma = ", ";
	local newline = "\n";
	local scripted_GUID_string = tostring(scripted_GUID)..".txt";
	

	out.design("Save out economy data")
	file = io.open(scripted_GUID_string, "a")
	io.output(file)
	
	if turn_number == 1 then
		io.write(
			"Turn Number",
			comma,
			"Gross Treasury",
			comma,
			"Gross Expenditure",
			comma,
			"Gross Income",
			comma,
			"Net Income",
			comma,
			"Trade Income",
			comma,
			"Upkeep",
			comma,
			"Number of Armies",
			comma,
			"Number of Regions",
			newline
			);
	end
	
	io.write(
			turn_number,
			comma,
			gross_treasury,
			comma,
			gross_expenditure,
			comma,
			gross_income,
			comma,
			net_income,
			comma,
			trade_income,
			comma,
			upkeep,
			comma,
			num_forces,
			comma,
			num_regions,
			newline
		);

	-- closes the open file
	io.close(file)
end


