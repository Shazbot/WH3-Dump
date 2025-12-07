aislinn_war = {
	faction_key = "wh3_dlc27_hef_aislinn",
	gift_wars = {}
};

function aislinn_war:initialise()
	self:add_listeners();
end

function aislinn_war:add_listeners()
	core:add_listener(
		"aislinn_war_occupation",
		"CharacterPerformsSettlementOccupationDecision",
		function(context)
			return context:occupation_decision() == "96128829";
		end,
		function(context)
			local region = context:garrison_residence():region();
			local previous_owner_key = context:previous_owner();
			local previous_owner = cm:get_faction(previous_owner_key);
			local current_owner = region:owning_faction();
			local current_owner_key = current_owner:name();
			out("Aislinn Gifted:\nRegion: "..region:name().."\n"..previous_owner_key.." -> "..current_owner_key);

			if previous_owner_key == aislinn_narrative.pirate_faction_key then
				-- We don't want to do any of this for the first pirate faction
				return false;
			end

			for i = 1, #self.gift_wars do
				if (self.gift_wars[i].from == previous_owner_key or self.gift_wars[i].to == previous_owner_key) and (self.gift_wars[i].from == current_owner_key or self.gift_wars[i].to == current_owner_key) then
					self.gift_wars[i].value = self.gift_wars[i].value + 1;

					if self.gift_wars[i].value >= 3 then
						self.gift_wars[i].is_war = true; -- Convert this into a war if it isn't already
					end
					return false; -- This potential war is already tracked, no need to continue
				end
			end

			if previous_owner and previous_owner:is_dead() == false and previous_owner:is_human() == false and previous_owner:at_war_with(current_owner) == false then
				-- The previous owner is not at war with the High Elf you gifted the region to
				-- Naturally they are not going to be pleased with the new owner so there is a chance they will go to war
				-- The chance is based on various diplomatic standing thresholds
				local diplo = previous_owner:diplomatic_attitude_towards(current_owner_key);
				local chance = 0;

				if previous_owner:is_vassal_of(current_owner) then
					return false;
				end
				if previous_owner:trade_agreement_with(current_owner) or previous_owner:military_access_pact_with(current_owner) then
					diplo = diplo + 20;
				end
				if previous_owner:non_aggression_pact_with(current_owner) then
					diplo = diplo + 50;
				end
				if previous_owner:defensive_allies_with(current_owner) then
					diplo = diplo + 90;
				end
				if previous_owner:military_allies_with(current_owner) then
					diplo = diplo + 100;
				end
				out("\tDiplo: "..diplo);

				if diplo < -200 then
					chance = 100;
				elseif diplo < -100 then
					chance = 90;
				elseif diplo < -50 then
					chance = 60;
				elseif diplo < 0 then
					chance = 50;
				elseif diplo < 50 then
					chance = 33;
				elseif diplo < 100 then
					chance = 25;
				elseif diplo < 200 then
					chance = 15;
				end

				local difficulty = cm:get_difficulty()

				if difficulty == 1 then
					chance = chance - 10;
				elseif difficulty == 2 then
					chance = chance + 10;
				elseif difficulty == 3 then
					chance = chance + 25;
				else
					chance = chance + 40;
				end
				out("\tChance: "..chance);

				if cm:model():random_percent(chance) then
					local new_war = {};
					new_war.from = previous_owner_key;
					new_war.to = current_owner_key;
					
					-- Depending on the chance there is also a chance of this being a war or just a diplomatic incident
					-- Meaning the more likely the faction was to do something, the more likely it is to be war
					-- e.g. there was only a 10% chance the faction was going to react but they still did, then there's a 90% chance it won't be war
					if cm:model():random_percent(chance) then
						new_war.is_war = true;
						out("\tPreparing war: "..previous_owner_key.." ->"..current_owner_key);
					else
						new_war.is_war = false;
						out("\tPreparing diplo: "..previous_owner_key.." ->"..current_owner_key);
					end

					new_war.value = 1;
					table.insert(self.gift_wars, new_war);
					cm:force_diplomacy("faction:"..previous_owner_key, "faction:"..current_owner_key, "war", false, false, true);
				else
					out("\tFailed to do anything");
				end
			end
		end,
		true
	);
	core:add_listener(
		"aislinn_war_turn_start",
		"FactionTurnStart",
		function(context)
			local faction = context:faction();
			return faction and faction:is_human() and faction:is_factions_turn()
		end,
		function(context)
			local faction = context:faction();
			local faction_key = faction:name();

			if faction_key == self.faction_key then
				for i = #self.gift_wars, 1, -1 do
					local previous_owner_key = self.gift_wars[i].from;
					local previous_owner = cm:get_faction(previous_owner_key);
					local current_owner_key = self.gift_wars[i].to;
					local current_owner = cm:get_faction(current_owner_key);
					cm:force_diplomacy("faction:"..previous_owner_key, "faction:"..current_owner_key, "war", true, true, true); -- No matter what, allow war again

					if (previous_owner and previous_owner:is_dead() == false) and (current_owner and current_owner:is_dead() == false) then -- Make sure both parties are still alive
						if self.gift_wars[i].is_war == true then
							-- Declare War
							cm:force_declare_war(self.gift_wars[i].from, self.gift_wars[i].to, true, true);
							cm:trigger_dilemma_with_targets(
								faction:command_queue_index(),
								"wh3_dlc27_dilemma_aislinn_gift_war",
								previous_owner:command_queue_index(),
								current_owner:command_queue_index(),
								0, 0, 0, 0
							);
						else
							-- Harm Relations
							local dilemma_builder = cm:create_dilemma_builder("wh3_dlc27_dilemma_aislinn_gift_diplo");
							local payload_builder = cm:create_payload();
							payload_builder:diplomatic_attitude_adjustment_between(previous_owner, current_owner, -6);
							dilemma_builder:add_choice_payload("FIRST", payload_builder);
							payload_builder:clear();
							
							dilemma_builder:add_target("default", previous_owner);
							dilemma_builder:add_target("target_faction_1", current_owner);
							cm:launch_custom_dilemma_from_builder(dilemma_builder, faction);
						end
						
						table.remove(self.gift_wars, i);
						break;
					else
						table.remove(self.gift_wars, i); -- No longer valid, so delete
					end
				end
			end
		end,
		true
	);
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("aislinn_gift_wars", aislinn_war.gift_wars, context);
	end
);
cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			aislinn_war.gift_wars = cm:load_named_value("aislinn_gift_wars", aislinn_war.gift_wars, context);
		end
	end
);