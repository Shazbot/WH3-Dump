
vassal_dilemmas = {
	dilemma_trigger_target = 7,
	woc_subculture = "wh_main_sc_chs_chaos",

	dilemmas = {
		"wh3_dlc20_chs_vassal_dilemma_character_shows_strength",
		"wh3_dlc20_chs_vassal_dilemma_devoted_region_positive",
		"wh3_dlc20_chs_vassal_dilemma_slave_revolt",
		"wh3_dlc20_chs_vassal_dilemma_unruly_vassal"
	},

	payloads = {
		wh3_dlc20_chs_vassal_dilemma_character_shows_strength= {
			FIRST = {
				"wh3_dlc20_payload_vassal_dilemmas_xp_target"
			},
			SECOND = { 
				"wh3_dlc20_payload_vassal_dilemmas_effect_bundle_souls",
				"wh3_dlc20_payload_vassal_dilemmas_effect_bundle_income",
				"wh3_dlc20_payload_vassal_dilemmas_ancillary_target"
			}
		},
		wh3_dlc20_chs_vassal_dilemma_devoted_region_positive= {
			FIRST = {
				"wh3_dlc20_payload_vassal_dilemmas_development_point"
			},
			SECOND = {
				"wh3_dlc20_payload_vassal_dilemmas_effect_bundle_construction_cost",
				"wh3_dlc20_payload_vassal_dilemmas_warriors_income",

			}
		},
		wh3_dlc20_chs_vassal_dilemma_slave_revolt= {
			FIRST = {
				"wh3_dlc20_payload_vassal_dilemmas_damage_buildings_grant_xp"
			},
			SECOND = { 
				"wh3_dlc20_payload_vassal_dilemmas_winds_of_magic_reserve",
				"wh3_dlc20_payload_vassal_dilemmas_vassal_income",
			}
		},
		wh3_dlc20_chs_vassal_dilemma_unruly_vassal= {
			FIRST = {
				"wh3_dlc20_payload_vassal_dilemmas_wound_character_gain_favour"
			},
			SECOND = { 
				"wh3_dlc20_payload_vassal_dilemmas_melee_attack_armies"
			}
		},

	},

	-- These components setup custom payloads
	-- When A dilemma is chosen and it has a custom payload it will find the matching payload in payload_scripted_components
	-- And run the function associated
	-- Uses: custom_payload to setup the payload;
	-- dilemma_builder to set the target for the UI to display
	payload_scripted_components = {
		wh3_dlc20_payload_vassal_dilemmas_xp_target =
			function(custom_payload, target_list, dilemma_builder)
				local vassal_char = target_list.character
				
				if vassal_char then
					local char_family_member = vassal_char:family_member()
					dilemma_builder:add_target("mission_objective", char_family_member)
					custom_payload:character_experience_change(vassal_char, 2500)
				end
				custom_payload:favour_points(target_list.vassal, 15)
			end,

		wh3_dlc20_payload_vassal_dilemmas_ancillary_target =
			function(custom_payload, target_list, dilemma_builder)
				custom_payload:faction_ancillary_gain(target_list.woc_faction, get_random_ancillary_key_for_faction(target_list.woc_faction:name(), false, "uncommon"))
			end,

		wh3_dlc20_payload_vassal_dilemmas_development_point = 
			function(custom_payload, target_list, dilemma_builder)
				local region_target = target_list.region
				if region_target and not region_target:faction_province():is_null_interface() then
					dilemma_builder:add_target("mission_objective", region_target)
					custom_payload:text_display("dummy_province_development_point")
					custom_payload:province_development_point_increase(target_list.region:faction_province(), target_list.vassal)
				end
				custom_payload:favour_points(target_list.vassal, 20)
			end,

		wh3_dlc20_payload_vassal_dilemmas_damage_buildings_grant_xp = 
			function(custom_payload, target_list, dilemma_builder)
				local min_damage = 75
				local max_damage = 90
				if target_list.region then
					dilemma_builder:add_target("mission_objective", target_list.region)
					custom_payload:damage_buildings(target_list.region, min_damage, max_damage)
				end

				if target_list.character then
					dilemma_builder:add_target("target_character_1", target_list.character)
					custom_payload:character_experience_change(target_list.character, 5000)
				end

				custom_payload:favour_points(target_list.vassal, 10)
			end,

		wh3_dlc20_payload_vassal_dilemmas_wound_character_gain_favour = 
			function(custom_payload, target_list, dilemma_builder)
				local vassal_char = target_list.character
				if vassal_char then
					local char_family_member = vassal_char:family_member()
					dilemma_builder:add_target("mission_objective", char_family_member)
					custom_payload:character_to_wound(vassal_char)
					custom_payload:character_experience_change(target_list.character, 2000)
				end
				custom_payload:favour_points(target_list.vassal, 50)
			end,
	}
}


function vassal_dilemmas:initialise()
	core:add_listener(
		"VassalDilemmaTriggerCheck",
		"FactionTurnStart",
		function(context)
			if not cm:is_new_game() then
				local faction = context:faction()
				return faction:is_human() and faction:subculture() == self.woc_subculture and faction:vassals():num_items() > 0
			end
			return false
		end,
		function(context)
			if self:should_trigger_dilemma() then
				self:generate_dilemma_character(context:faction())
			end
		end,
		true
	)
end


function vassal_dilemmas:generate_dilemma_character(faction_key, specific_dilemma)
	local dilemma_key = specific_dilemma or self:get_random_dilemma()
	local dilemma_builder = cm:create_dilemma_builder(dilemma_key)
	local choices = dilemma_builder:possible_choices()
	local faction_interface = cm:get_faction(faction_key)

	local chosen_vassal = self:get_random_vassal(faction_interface)
	local vassal_interface = cm:get_faction(chosen_vassal)

	local target_list = self:get_target_interfaces(dilemma_key, faction_interface, vassal_interface)

	dilemma_builder:add_target("default", vassal_interface)

	for i = 1, #choices do
		local payload = self:generate_payload(choices[i], faction_interface, dilemma_key, target_list, dilemma_builder)
		dilemma_builder:add_choice_payload(choices[i], payload)
	end

	cm:launch_custom_dilemma_from_builder(dilemma_builder, cm:get_faction(faction_key))
end


-- This function returns a list of different target interfaces
-- It gets a random character and region for a given vassal of a Warriors of Chaos faction
-- These interfaces are then used in payload setup and to set the target for a dilemma option, which the UI then uses to display extra information in the dilemma
function vassal_dilemmas:get_target_interfaces(dilemma_key, faction_interface, vassal_interface)
	local target_list = {}
	target_list.character = self:get_random_character(vassal_interface)
	target_list.region = self:get_random_region(vassal_interface)
	target_list.woc_faction = faction_interface
	target_list.vassal = vassal_interface

	return target_list
end


function vassal_dilemmas:generate_payload(choice, faction_interface, dilemma, target_list, dilemma_builder)

	local payload_options = self.payloads[dilemma][choice]

	local random_payload = payload_options[cm:random_number(#payload_options)]
	local custom_payload = cm:create_payload()

	if self.payload_scripted_components[random_payload] then
		local scripted_components = self.payload_scripted_components[random_payload]
		scripted_components(custom_payload, target_list, dilemma_builder)
	else
		custom_payload:components_from_record(random_payload, faction_interface, faction_interface)
	end

	return custom_payload
end


function vassal_dilemmas:get_random_character(faction_key)
	local faction_interface = cm:get_faction(faction_key)
	local character_list = faction_interface:character_list()
	local valid_target_chars = {}
	local random_char = false
	
	for i, character in model_pairs(character_list) do
		-- Ignore garrison commanders
		if not character:character_type("colonel") then
			table.insert(valid_target_chars, character)
		end
	end

	if #valid_target_chars > 0 then
		random_char = valid_target_chars[cm:random_number(#valid_target_chars)]
	else 
		return false
	end

	return random_char
end


function vassal_dilemmas:get_random_region(faction_key)
	local faction_interface = cm:get_faction(faction_key)
	local region_list = faction_interface:region_list()
	local region_count = region_list:num_items()
	if region_count < 1 then
		 return false
	end

	return region_list:item_at(cm:random_number(region_count)-1)
end


function vassal_dilemmas:get_random_vassal(faction_interface)
	local vassal_list = faction_interface:vassals()
	local random_vassal = cm:random_number(vassal_list:num_items())
	local vassal_interface = vassal_list:item_at(random_vassal-1)
	local faction_name = vassal_interface:name()
	return faction_name
end


function vassal_dilemmas:get_random_dilemma()
	return self.dilemmas[cm:random_number(#self.dilemmas)]
end

-- Return if rolled random number is below defined target
-- Out of 100
function vassal_dilemmas:should_trigger_dilemma()
	return cm:random_number() <= self.dilemma_trigger_target
end
