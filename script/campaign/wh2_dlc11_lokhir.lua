lohkir_arks = {
	faction_key = "wh2_dlc11_def_the_blessed_dread",
	black_ark_key = "wh2_main_def_black_ark",
	current_maj_port_count = 0,
	current_blarks_in_pool = 0,
	major_port_list = {},
	admiral_names = {
		"1043335079",
		"1145397024",
		"1225535785",
		"1286859150",
		"1327358560",
		"1373918736",
		"139274725",
		"1396496474",
		"1397432329",
		"1421390481",
		"1442008725",
		"1453701877",
		"1469875558",
		"1480988115",
		"1533578663",
		"1539784441",
		"1548347790",
		"1549964633",
		"1574055340",
		"1599624757",
		"1613104460",
		"1619003680",
		"1631911126",
		"1662609258",
		"1676702302",
		"1714437588",
		"1748721115",
		"1767592018",
		"1772325140",
		"182386008",
		"1865779139",
		"1884036913",
		"1933701425",
		"1984883343",
		"2001547846",
		"2007662807",
		"2019146272",
		"2069123878",
		"2073522645",
		"2147359093",
		"2147359100",
		"2147359108",
		"2147359111",
		"2147359114",
		"2147359115",
		"2147359116",
		"2147359124",
		"2147359134",
		"2147359135",
		"2147359143",
		"2147359467",
		"2147359470",
		"2147359478",
		"2147359486",
		"2147359493",
		"2147359501",
		"2147359511",
		"2147359518",
		"2147359527",
		"2147359529",
		"2147359538",
		"2147359539",
		"2147359540",
		"2147359548",
		"2147359554",
		"2147359575",
		"2147359576",
		"2147359586",
		"2147359626",
		"2147359636",
		"2147359655",
		"2147359664",
		"2147359691",
		"2147359713",
		"2147359818",
		"2147359827",
		"2147359833",
		"2147359836",
		"2147359840",
		"2147359843",
		"2147359846",
		"2147359849",
		"2147359859",
		"2147359864",
		"2147359867",
		"2147359868",
		"2147360075",
		"2147360083",
		"2147360092",
		"2147360132",
		"2147360188",
		"2147360199",
		"2147360201",
		"2147360339",
		"2147360399",
		"2147360409",
		"2147360412",
		"2147360872",
		"2147360880",
		"2147360887",
		"2147360895",
		"2147360898",
		"347628724",
		"372059833",
		"374343023",
		"422011688",
		"423002791",
		"581191811",
		"597082929",
		"683956364",
		"686261355",
		"688987316",
		"697188827",
		"724873043",
		"769215322",
		"794649491",
		"833034999",
		"847757873",
		"924291862",
		"933037566",
		"933807514",
		"944360972"
	}
}

function lohkir_arks:add_lokhir_listeners()
	out("#### Adding Lokhir Listeners ####");
	local lokhir = cm:get_faction(self.faction_key);
	local region_list = cm:model():world():region_manager():region_list();

	for i = 0, region_list:num_items() - 1 do
		local region = region_list:item_at(i)
		if (region:is_province_capital()) and (region:settlement():is_port()) then
			--out.design(region:name());
			table.insert(self.major_port_list, region:name());
		end;
	end;
	
	if lokhir and lokhir:is_null_interface() == false then
		cm:add_faction_turn_start_listener_by_name(
			"black_ark_FactionTurnStart",
			self.faction_key,
			function(context)
				self:major_port_count(context, context:faction())
				self:adjust_black_ark_pool(context)
			end,
			true
		);
		core:add_listener(
			"black_ark_CharacterPerformsSettlementOccupationDecision",
			"CharacterPerformsSettlementOccupationDecision",
			true,
			function(context) self:major_port_count(context, context:character():faction()) end,
			true
		);
		core:add_listener(
			"adjust_blarks_in_pool",
			"CharacterCreated",
			true,
			function(context) self:adjust_blarks_in_pool(context) end,
			true
		);
	end;
end

function lohkir_arks:major_port_count(context, faction)	
	local port_counter = 0;
	local owned_regions = faction:region_list();
				
	for i = 0, owned_regions:num_items() - 1 do
		local region_name = owned_regions:item_at(i):name()

		for j = 1, #self.major_port_list do
			if (region_name == self.major_port_list[j]) then
				port_counter = port_counter + 1;
			end;
		end;
	end;

	local output = tostring(port_counter);
	out.design("############ Number of ports is " .. output ..". ###########");

	if faction:is_human() == false then --If Lokhir is AI then we pretend he has fewer ports than he actually does. Remove this when we get a better fix for the Black Ark spam. 
		port_counter = math.floor(port_counter/3)
	end 

	if not (self.current_maj_port_count == port_counter) then
		self.current_maj_port_count = port_counter;
	end;
	
end

function lohkir_arks:adjust_black_ark_pool(context)
	local num_blarks = self.current_blarks_in_pool;
	local force_list = context:faction():military_force_list();
	
	for i = 0, force_list:num_items() - 1 do	
		if (force_list:item_at(i):general_character():character_subtype(self.black_ark_key)) then
			num_blarks = num_blarks + 1;
		end;
	end;
	
	local output = tostring(num_blarks);
	out.design("############ Number of black arks is " .. output ..". ###########");
	
	if (num_blarks < self.current_maj_port_count) then
		local dif = self.current_maj_port_count - num_blarks;
		
		for i = 1, dif do
			--Create Admiral name
			local forename = "names_name_" .. self.admiral_names[cm:random_number(#self.admiral_names)];

			-- Add Black Ark to pool
			cm:spawn_character_to_pool(self.faction_key, forename, "", "names_name_1270751732", "", 18, true, "general", self.black_ark_key, false, "wh2_main_art_set_def_black_ark");
			self.current_blarks_in_pool = self.current_blarks_in_pool + 1;
		end;
	end;
end

function lohkir_arks:adjust_blarks_in_pool(context)
	local character = context:character();
	
	if (character:faction():name() == self.faction_key) and character:character_subtype(self.black_ark_key) then	
		self.current_blarks_in_pool = self.current_blarks_in_pool - 1;
		
		local output = tostring(self.current_blarks_in_pool);
		out.design("############ Number of black arks in pool " .. output ..". ###########");
	end;
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("lohkir_arks.current_maj_port_count", lohkir_arks.current_maj_port_count, context);
		cm:save_named_value("lohkir_arks.current_blarks_in_pool", lohkir_arks.current_blarks_in_pool, context);
	end
);

cm:add_loading_game_callback(
	function(context)
		if (cm:is_new_game() == false) then
			lohkir_arks.current_maj_port_count = cm:load_named_value("lohkir_arks.current_maj_port_count", lohkir_arks.current_maj_port_count, context);
			lohkir_arks.current_blarks_in_pool = cm:load_named_value("lohkir_arks.current_blarks_in_pool", lohkir_arks.current_blarks_in_pool, context);
		end
	end
);
