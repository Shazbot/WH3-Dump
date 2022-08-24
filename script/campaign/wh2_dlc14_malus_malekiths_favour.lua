malus_favour = {
	faction_key = "wh2_main_def_hag_graef",
	malekith_faction_key = "wh2_main_def_naggarond",
	hag_graef_region_key = "wh3_main_combi_region_hag_graef",
	start_dilemma_key = "wh2_dlc14_malus_start_dilemma",
	character_development_key = "wh_event_subcategory_character_development",
	rite_character_spawned = false,
	witch_king_dilemma_key = "wh2_dlc14_def_witch_king_agent_select",
	agent_data = {
		death_hag = {type = "dignitary", key = "wh2_main_def_death_hag"},
		assassin = {type = "spy", key = "wh2_main_def_khainite_assassin"},
		sorc_dark = {type = "wizard", key = "wh2_main_def_sorceress_dark"},
		sorc_fire = {type = "wizard", key = "wh2_main_def_sorceress_fire"},
		sorc_shadow = {type = "wizard", key = "wh2_main_def_sorceress_shadow"},
		master = {type = "champion", key = "wh2_dlc14_def_master"}
	}
}

function malus_favour:add_malus_malekiths_favour_listeners()
	out("#### Adding Malus Malekith's Favour Listeners ####");
	local malus_interface = cm:get_faction(self.faction_key); 
	local malekith_interface = cm:get_faction(self.malekith_faction_key); 

	--check if Malus is human
	if malus_interface:is_null_interface() == false and malus_interface:is_human() == true then
		if cm:is_new_game() == true then
			local secondary_army = cm:get_closest_character_to_position_from_faction(self.faction_key, 195, 612, true, false);

			cm:disable_event_feed_events(true, "", self.character_development_key, "");
			cm:modify_character_personal_loyalty_factor(cm:char_lookup_str(secondary_army), 10);
			out.design("### Loyalty for secondary character set to 10 ###")
			cm:callback(function() 
				cm:disable_event_feed_events(false, "", self.character_development_key, "") 
			end, 0.5);
		end

		core:add_listener(
			"Malus_trigger_dilemma",
			"CharacterPerformsSettlementOccupationDecision",
			function(context)
				local faction = context:character():faction():name();
				local region = context:garrison_residence():region():name();
				local occupation_option = tostring(context:occupation_decision());

				--occupy or loot and occupy
				if occupation_option == "1027" or occupation_option == "1024" then
					-- check if Hag Graef is owned and that its not its beyond turn 5:  
					--##### Making assumption player doesnt take 5 turns to take first region and doesnt lose it and have to retake it within those 5 turns #####
					if cm:turn_number() <= 5 then 
						local hag_graef_owned_by_malus = cm:is_region_owned_by_faction(self.hag_graef_region_key, self.faction_key);
						
						return faction == self.faction_key and region == "wh3_main_combi_region_black_rock" and hag_graef_owned_by_malus;
					end
					return false;
				end
			end,
			function(context)
				cm:callback(function()
					-- this was failing to trigger on the same turn as the occupation due to triggering too quickly.
					cm:trigger_dilemma_raw(self.faction_key, self.start_dilemma_key, true, true);
				end, 0.5)
			end,
			true
		);

		core:add_listener(
			"Malus_DilemmaChoiceMadeEvent",
			"DilemmaChoiceMadeEvent",
			function(context)
				return context:dilemma() == self.start_dilemma_key;
			end,
			function(context)
				local choice = context:choice();

				if choice == 0 then
					self:hag_graef_region_change();	
					local secondary_army = cm:get_closest_character_to_position_from_faction(self.faction_key, 195, 612, true, false);					
					
					if secondary_army:has_region() then 
						local event_type = "wh_event_category_character"

						if secondary_army:region():name() == self.hag_graef_region_key then
							cm:disable_event_feed_events(true, event_type, "", "");
							cm:kill_character(secondary_army:command_queue_index(), true, false);
							cm:disable_event_feed_events(false, event_type, "", "");
						end
					end
				end
			end,
			true
		);
	end

	core:add_listener(
		"malus_RitualCompletedEvent",
		"RitualCompletedEvent",
		function(context)
			return context:succeeded();
		end,
		function(context)
			local faction = context:performing_faction();
			local faction_key = faction:name();
			local ritual = context:ritual():ritual_key();
			
			if ritual == "wh2_dlc14_ritual_def_witch_king" then
				if faction:is_human() == true then
					cm:trigger_dilemma(faction_key, self.witch_king_dilemma_key);
				else
					local agent_rand = cm:random_number(100);
	
					if agent_rand > 75 then
						-- Death Hag
						rite_agent_spawn(faction_key, self.agent_data.death_hag.type, self.agent_data.death_hag.key);
					elseif agent_rand > 50 then
						-- Khainite Assassin
						rite_agent_spawn(faction_key, self.agent_data.assassin.type, self.agent_data.assassin.key);
					elseif agent_rand > 25 then
						-- Sorceress
						local sorceress_rand = cm:random_number(75);
						if sorceress_rand > 50 then
							rite_agent_spawn(faction_key, self.agent_data.sorc_dark.type, self.agent_data.sorc_dark.key);
						elseif sorceress_rand > 25 then
							rite_agent_spawn(faction_key, self.agent_data.sorc_fire.type, self.agent_data.sorc_fire.key);
						else
							rite_agent_spawn(faction_key, self.agent_data.sorc_shadow.type, self.agent_data.sorc_shadow.key);
						end
					else
						-- Master
						rite_agent_spawn(faction_key, self.agent_data.master.type, self.agent_data.master.key);
					end
				end
			end
		end,
		true
	);

	core:add_listener(
		"malus_DilemmaChoiceMadeEvent",
		"DilemmaChoiceMadeEvent",
		function(context)
			return context:dilemma() == self.witch_king_dilemma_key;
		end,
		function(context)
			local faction_key = context:faction():name();
			local choice = context:choice();
	
			if choice == 0 then
				-- Death Hag
				rite_agent_spawn(faction_key, self.agent_data.death_hag.type, self.agent_data.death_hag.key);
			elseif choice == 1 then
				-- Khainite Assassin
				rite_agent_spawn(faction_key, self.agent_data.assassin.type, self.agent_data.assassin.key);
			elseif choice == 2 then
				-- Sorceress
				local sorceress_rand = cm:random_number(75);
				if sorceress_rand > 50 then
					rite_agent_spawn(faction_key, self.agent_data.sorc_dark.type, self.agent_data.sorc_dark.key);
				elseif sorceress_rand > 25 then
					rite_agent_spawn(faction_key, self.agent_data.sorc_fire.type, self.agent_data.sorc_fire.key);
				else
					rite_agent_spawn(faction_key, self.agent_data.sorc_shadow.type, self.agent_data.sorc_shadow.key);
				end
			else
				-- Master
				rite_agent_spawn(faction_key, self.agent_data.master.type, self.agent_data.master.key);
			end
		end,
		true
	);

	core:add_listener(
		"malus_CharacterCreated",
		"CharacterCreated",
		function(context)
			local faction = context:character():faction():name();

			return faction == self.faction_key and self.rite_character_spawned == true;
		end,
		function(context)
			local character = context:character();
			local malekith_interface = cm:model():world():faction_by_key(self.malekith_faction_key);
			local rank = 0;

			if malekith_interface:is_null_interface() == false then
				rank = malekith_interface:region_list():num_items() + 1;
			end

			if rank > 0 then
				-- be careful if its above rank 40 it explodes
				if rank > 39 then
					cm:add_agent_experience(cm:char_lookup_str(character), 40, true);
				else
					cm:add_agent_experience(cm:char_lookup_str(character), rank, true);
				end
			end
			self.rite_character_spawned = false;
		end,
		true
	);
end

function malus_favour:hag_graef_region_change()
	local hag_graef_new_owner = "";
	local malekith_interface = cm:model():world():faction_by_key(self.malekith_faction_key); 
	
	if malekith_interface:is_null_interface() == false and malekith_interface:is_human() == true then
		hag_graef_new_owner = "wh2_main_def_clar_karond";
	else
		hag_graef_new_owner = self.malekith_faction_key;
	end

	cm:disable_event_feed_events(true, "wh_event_category_conquest", "", "")
	cm:transfer_region_to_faction(self.hag_graef_region_key, hag_graef_new_owner);
	cm:callback(function() 
		cm:heal_garrison(cm:get_region(self.hag_graef_region_key):cqi());
		cm:disable_event_feed_events(false, "wh_event_category_conquest", "", "");
		end, 0.5
	);
end
