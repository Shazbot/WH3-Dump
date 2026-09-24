vampire_concealment = {
	neferata_faction = "wh3_dlc29_vmp_neferata",
	concealment_resource_key = "wh3_dlc29_nef_concealment"
};

function vampire_concealment:initialise()
	self:add_listeners();
end

function vampire_concealment:add_listeners()
	core:add_listener(
		"FactionTurnStartConcealment",
		"FactionTurnStart",
		function(context)
			return context:faction():name() == self.neferata_faction;
		end,
		function(context)
			local faction = context:faction();
			self:do_per_turn_concealment(faction);
		end,
		true
	);
	core:add_listener(
		"CharacterSkillPointAllocatedConcealment",
		"CharacterSkillPointAllocated",
		true,
		function(context)
			local character = context:character();

			if character:is_faction_leader() == true then
				local faction = character:faction();

				if faction:name() == self.neferata_faction then
					self:update_innate_concealment(faction);
				end
			end
		end,
		true
	);
	core:add_listener(
		"CharacterConvalescedOrKilledConcealment",
		"CharacterConvalescedOrKilled",
		true,
		function(context)
			local character = context:character();

			if character:is_faction_leader() == true then
				local faction = character:faction();

				if faction:name() == self.neferata_faction then
					self:update_innate_concealment(faction);
				end
			end
		end,
		true
	);
	core:add_listener(
		"ResearchCompletedConcealment",
		"ResearchCompleted",
		true,
		function(context)
			local faction = context:faction();

			if faction:name() == self.neferata_faction then
				self:update_innate_concealment(faction);
			end
		end,
		true
	);
	core:add_listener(
		"CharacterConvalescedOrKilledConcealmentKills",
		"CharacterConvalescedOrKilled",
		function(context)
			local convalescence_cause_enum_validity = {
				[0] = true, 	--CONVALESCENCE_CAUSE_ASSASSINATION
				[1] = false, 	--CONVALESCENCE_CAUSE_CONVERSION,
				[2] = true,		--CONVALESCENCE_CAUSE_HUNTED_DOWN,
				[3] = false, 	--CONVALESCENCE_CAUSE_BATTLE,
				[4] = true, 	--CONVALESCENCE_CAUSE_UNKNOWN,
				[5] = false, 	--CONVALESCENCE_CAUSE_IMPRISONED,
				[6] = false, 	--CONVALESCENCE_CAUSE_RETIREMENT,
				[7] = false, 	--CONVALESCENCE_CAUSE_STARTING_GENERAL_REPLACED,
				[8] = false, 	--CONVALESCENCE_CAUSE_RITUAL_PERFORMANCE,
				[9] = false, 	--CONVALESCENCE_CAUSE_PROVINCE_GOVERNORSHIP_CHANGE,
				[10] = false, 	--CONVALESCENCE_CAUSE_RETURNING_TO_GOVERNORSHIP_POOL,
			};
			return convalescence_cause_enum_validity[context:character():convalesence_cause()];
		end,
		function(context)
			local character = context:character();

			if character:is_null_interface() == false and character:has_military_force() == false and character:has_region() == true then
				local province = character:region():province();
				local capital_region = province:capital_region();

				if capital_region:owning_faction():is_faction(character:faction()) then
					local concealment_bv = cm:get_regions_bonus_value(capital_region, "concealment_gain_agent");

					if concealment_bv > 0 then
						local neferata_faction = cm:get_faction(vampire_concealment.neferata_faction);

						if neferata_faction then
							self:add_concealment_to_province(neferata_faction, province, "neferata_owner_agents_killed", concealment_bv);
						end
					end
				end
			end
		end,
		true
	);
	core:add_listener(
		"MilitaryForceDestroyedConcealment",
		"MilitaryForceDestroyed",
		true,
		function(context)
			local military_force = context:military_force();

			if military_force:is_null_interface() == false and military_force:has_general() == true and military_force:is_armed_citizenry() == false then
				local character = military_force:general_character();
				if not character:has_region() then
					return
				end
				local province = character:region():province();
				local capital_region = province:capital_region();

				if capital_region:owning_faction():is_faction(character:faction()) then
					local concealment_bv = cm:get_regions_bonus_value(capital_region, "concealment_gain_force");

					if concealment_bv > 0 then
						local neferata_faction = cm:get_faction(vampire_concealment.neferata_faction);

						if neferata_faction then
							self:add_concealment_to_province(neferata_faction, province, "neferata_owner_armies_killed", concealment_bv);
						end
					end
				end
			end
		end,
		true
	);
end

function vampire_concealment:update_innate_concealment(faction)
	local intended_value = cm:get_factions_bonus_value(faction, "concealment_gain_innate_indicator") or 0;
	local innate_concealment_resource = faction:pooled_resource_manager():resource("wh3_dlc29_vmp_concealment_innate");
	local current_value = innate_concealment_resource:value();
	local new_value = intended_value - current_value;
	
	if new_value ~= 0 then
		local faction_key = faction:name();
		cm:faction_add_pooled_resource(faction_key, "wh3_dlc29_vmp_concealment_innate", "other", new_value);
	end
end

function vampire_concealment:do_per_turn_concealment(faction)
	local foreign_slot_managers = faction:foreign_slot_managers();
	
	for i = 0, foreign_slot_managers:num_items() - 1 do
		local region = foreign_slot_managers:item_at(i):region();
		local province = region:province();
		
		local pooled_resource_manager = cm:get_or_create_faction_province_persistent_pooled_resource_manager(faction, province);

		if pooled_resource_manager:is_null_interface() == false then
			local concealment_resource = pooled_resource_manager:resource(self.concealment_resource_key);
			
			if concealment_resource:is_null_interface() == false then
				local concealment_innate_faction = cm:get_factions_bonus_value(faction, "concealment_gain_innate");
				local concealment_innate_region = cm:get_regions_bonus_value(region, "concealment_gain_innate");
				local concealment_gain_innate = concealment_innate_region + concealment_innate_faction;

				if concealment_gain_innate > 0 then
					cm:pooled_resource_factor_transaction(concealment_resource, "neferata_innate", concealment_gain_innate);
				end
				
				local concealment_gain_covens = cm:get_regions_bonus_value(region, "concealment_gain_covens");

				if concealment_gain_covens > 0 then
					cm:pooled_resource_factor_transaction(concealment_resource, "neferata_covens_positive", concealment_gain_covens);
				end

				local concealment_loss_covens = cm:get_regions_bonus_value(region, "concealment_loss_covens");
				
				if concealment_loss_covens < 0 then
					cm:pooled_resource_factor_transaction(concealment_resource, "neferata_covens_negative", concealment_loss_covens);
				end

				if cm:get_factions_bonus_value(faction, "concealment_loss_disabled") == 0 and cm:get_regions_bonus_value(region, "concealment_loss_disabled") == 0 then
					local concealment_loss_agent = cm:get_regions_bonus_value(region, "concealment_loss_agent");

					if concealment_loss_agent < 0 then
						cm:pooled_resource_factor_transaction(concealment_resource, "neferata_owner_agents_present", concealment_loss_agent);
					end

					local concealment_loss_force = cm:get_regions_bonus_value(region, "concealment_loss_force");
					
					if concealment_loss_force < 0 then
						cm:pooled_resource_factor_transaction(concealment_resource, "neferata_owner_armies_present", concealment_loss_force);
					end
				end
			end
		end
	end
end

function vampire_concealment:add_concealment_to_province(faction, province, factor, amount)
	local pooled_resource_manager = cm:get_or_create_faction_province_persistent_pooled_resource_manager(faction, province);

	if pooled_resource_manager:is_null_interface() == false then
		local concealment_resource = pooled_resource_manager:resource(self.concealment_resource_key);

		if concealment_resource:is_null_interface() == false then
			cm:pooled_resource_factor_transaction(concealment_resource, factor or "hidden", amount or 1);
		end
	end
end