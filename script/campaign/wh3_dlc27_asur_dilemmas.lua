asur_dilemmas = {
	faction_key = "wh3_dlc27_hef_aislinn",
	rituals = {
		["wh3_dlc27_hef_asur_domination_avelorn_1"] = {dilemma = "wh3_dlc27_hef_asur_domination_avelorn", level = 1, faction = "wh2_main_hef_avelorn", downgradable = false},
		["wh3_dlc27_hef_asur_domination_eataine_1"] = {dilemma = "wh3_dlc27_hef_asur_domination_eataine", level = 1, faction = "wh2_main_hef_eataine", downgradable = false},
		["wh3_dlc27_hef_asur_domination_imrik_1"] = {dilemma = "wh3_dlc27_hef_asur_domination_imrik", level = 1, faction = "wh2_dlc15_hef_imrik", downgradable = false},
		["wh3_dlc27_hef_asur_domination_loremasters_1"] = {dilemma = "wh3_dlc27_hef_asur_domination_loremasters", level = 1, faction = "wh2_main_hef_order_of_loremasters", downgradable = false},
		["wh3_dlc27_hef_asur_domination_nagarythe_1"] = {dilemma = "wh3_dlc27_hef_asur_domination_nagarythe", level = 1, faction = "wh2_main_hef_nagarythe", downgradable = false},
		["wh3_dlc27_hef_asur_domination_yvresse_1"] = {dilemma = "wh3_dlc27_hef_asur_domination_yvresse", level = 1, faction = "wh2_main_hef_yvresse", downgradable = false},

		["wh3_dlc27_hef_asur_domination_avelorn_2"] = {dilemma = "wh3_dlc27_hef_asur_domination_avelorn", level = 2, faction = "wh2_main_hef_avelorn", downgradable = false},
		["wh3_dlc27_hef_asur_domination_eataine_2"] = {dilemma = "wh3_dlc27_hef_asur_domination_eataine", level = 2, faction = "wh2_main_hef_eataine", downgradable = false},
		["wh3_dlc27_hef_asur_domination_imrik_2"] = {dilemma = "wh3_dlc27_hef_asur_domination_imrik", level = 2, faction = "wh2_dlc15_hef_imrik", downgradable = false},
		["wh3_dlc27_hef_asur_domination_loremasters_2"] = {dilemma = "wh3_dlc27_hef_asur_domination_loremasters", level = 2, faction = "wh2_main_hef_order_of_loremasters", downgradable = false},
		["wh3_dlc27_hef_asur_domination_nagarythe_2"] = {dilemma = "wh3_dlc27_hef_asur_domination_nagarythe", level = 2, faction = "wh2_main_hef_nagarythe", downgradable = false},
		["wh3_dlc27_hef_asur_domination_yvresse_2"] = {dilemma = "wh3_dlc27_hef_asur_domination_yvresse", level = 2, faction = "wh2_main_hef_yvresse", downgradable = false},

		["wh3_dlc27_hef_asur_domination_avelorn_3"] = {dilemma = "wh3_dlc27_hef_asur_domination_avelorn", level = 3, faction = "wh2_main_hef_avelorn", downgradable = true},
		["wh3_dlc27_hef_asur_domination_eataine_3"] = {dilemma = "wh3_dlc27_hef_asur_domination_eataine", level = 3, faction = "wh2_main_hef_eataine", downgradable = true},
		["wh3_dlc27_hef_asur_domination_imrik_3"] = {dilemma = "wh3_dlc27_hef_asur_domination_imrik", level = 3, faction = "wh2_dlc15_hef_imrik", downgradable = true},
		["wh3_dlc27_hef_asur_domination_loremasters_3"] = {dilemma = "wh3_dlc27_hef_asur_domination_loremasters", level = 3, faction = "wh2_main_hef_order_of_loremasters", downgradable = true},
		["wh3_dlc27_hef_asur_domination_nagarythe_3"] = {dilemma = "wh3_dlc27_hef_asur_domination_nagarythe", level = 3, faction = "wh2_main_hef_nagarythe", downgradable = true},
		["wh3_dlc27_hef_asur_domination_yvresse_3"] = {dilemma = "wh3_dlc27_hef_asur_domination_yvresse", level = 3, faction = "wh2_main_hef_yvresse", downgradable = true}
	}
};

function asur_dilemmas:initialise()
	self:add_listeners();
end

function asur_dilemmas:add_listeners()
	core:add_listener(
		"asur_dilemmas_ritual",
		"RitualCompletedEvent",
		function(context)
			return context:performing_faction():name() == self.faction_key;
		end,
		function(context)
			local faction = context:performing_faction();
			local ritual = context:ritual():ritual_key();

			if self.rituals[ritual] then
				local dilemma = self.rituals[ritual].dilemma;
				local level = self.rituals[ritual].level;
				local other_faction = cm:get_faction(self.rituals[ritual].faction);

				if self.rituals[ritual].downgradable == true then
					local already_given = cm:get_saved_value("asur_dilemma_"..self.rituals[ritual].faction);

					if already_given then
						level = level - 1;
					end
				end
				dilemma = dilemma.."_"..tostring(level);
				
				cm:trigger_dilemma_with_targets(
					faction:command_queue_index(),
					dilemma,
					other_faction:command_queue_index(),
					0, 0, 0, 0, 0
				);
			end
		end,
		true
	);
	core:add_listener(
		"asur_dilemmas_choice",
		"DilemmaChoiceMadeEvent",
		function(context)
			return context:faction():name() == self.faction_key;
		end,
		function(context)
			local dilemma = context:dilemma();
			local choice = context:choice();
			
			if choice == 3 then
				for key, ritual in pairs(self.rituals) do
					if ritual.downgradable == true and dilemma == ritual.dilemma.."_3" then
						cm:set_saved_value("asur_dilemma_"..ritual.faction, true);
						break;
					end
				end
			end

			if choice == 2 then
				local faction = context:faction();

				if dilemma == "wh3_dlc27_hef_asur_domination_avelorn_2" or dilemma == "wh3_dlc27_hef_asur_domination_avelorn_3" then
					local military_force_list = faction:military_force_list();
		
					for i = 0, military_force_list:num_items() - 1 do
						local military_force = military_force_list:item_at(i);
						cm:heal_military_force(military_force);
					end
				elseif dilemma == "wh3_dlc27_hef_asur_domination_eataine_2" or dilemma == "wh3_dlc27_hef_asur_domination_eataine_3" then
					local char_list = faction:character_list();

					for i = 0, char_list:num_items() - 1 do
						local current_char = char_list:item_at(i);
						local rank = current_char:rank()
						cm:add_agent_experience(cm:char_lookup_str(current_char), rank + 1, true);
					end
				elseif dilemma == "wh3_dlc27_hef_asur_domination_imrik_2" or dilemma == "wh3_dlc27_hef_asur_domination_imrik_3" then
					local char_list = faction:character_list();

					for i = 0, char_list:num_items() - 1 do
						local current_char = char_list:item_at(i);
						cm:replenish_action_points(cm:char_lookup_str(current_char));
					end
				elseif dilemma == "wh3_dlc27_hef_asur_domination_loremasters_2" or dilemma == "wh3_dlc27_hef_asur_domination_loremasters_3" then
					cm:grant_research_points(self.faction_key, 1000);
				--elseif dilemma == "wh3_dlc27_hef_asur_domination_nagarythe_2" or dilemma == "wh3_dlc27_hef_asur_domination_nagarythe_3" then
				elseif dilemma == "wh3_dlc27_hef_asur_domination_yvresse_2" or dilemma == "wh3_dlc27_hef_asur_domination_yvresse_3" then
					local region_list = faction:region_list();

					for i = 0, region_list:num_items() - 1 do
						local region = region_list:item_at(i);
						cm:create_storm_for_region(region:name(), 1, 8, "hef_mist_storm");
					end
				end
			end
		end,
		true
	);
end