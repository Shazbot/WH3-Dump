sword_of_khaine = {

	key_index = {
		"wh2_dlc10_anc_weapon_the_widowmaker_1", 
		"wh2_dlc10_anc_weapon_the_widowmaker_2", 
		"wh2_dlc10_anc_weapon_the_widowmaker_3"
	},
	negative_index = {
		"wh2_sword_of_khaine_1", 
		"wh2_sword_of_khaine_2", 
		"wh2_sword_of_khaine_3"
	},
	event_index = {
		sword_issued = "wh2_dlc10_sword_of_khaine_issued",
		sword_stuck = "wh2_dlc10_sword_of_khaine_stuck",
		sword_returned = "wh2_dlc10_sword_of_khaine_returned",
		sword_building_done = "wh2_dlc10_sword_of_khaine_building_done",
		sword_level_dilemma_index = {"wh2_dlc10_sword_of_khaine_lv1", "wh2_dlc10_sword_of_khaine_lv2"},
		sword_region_got = "wh2_dlc10_sword_of_khaine_region_captured",
		sword_picking = "wh2_dlc10_sword_of_khaine_pick_or_not",
		sword_claimed_ai = "wh2_dlc10_sword_of_khaine_issued_ai"
	},
	region_key = "wh3_main_combi_region_shrine_of_khaine",
	building_keys = {
		"wh2_main_special_shrine_of_khaine_def_1",
		"wh2_main_special_shrine_of_khaine_hef_1",
		"wh2_main_special_shrine_of_khaine_wef_1"
	},
	growth_time = {15, 10, 10},
	vfx = {
		garrison = "scripted_effect4",
		character = "scripted_effect5"
	},
	owner = {
		character_cqi = nil,
		faction = "",
		lv = 0,
		cd = 0,
		ready = false
	},
	owner_cache = -1,
	vfx_cache = {
		garrison = nil,
		character = nil
	},
	elven_factions = {
		wh_dlc05_sc_wef_wood_elves = true, 
		wh2_main_sc_def_dark_elves = true, 
		wh2_main_sc_hef_high_elves = true
	},
	ai_chance_to_lose_sword = 5 -- % chance per turn the AI has to lose the sword. Checked each turn if growth_time has passed and sword can't level up
}


function sword_of_khaine:initialise()
	self:initiate_sword_button()
	self:add_listeners()
end

function sword_of_khaine:initiate_sword_button()
	
	if cm:is_new_game() then
		self:return_sword_to_shrine();
	end;
	
	local local_faction_key = cm:get_local_faction_name(true);
	
	if not local_faction_key then
		return;
	end;

	local faction = cm:get_faction(local_faction_key)
	local ui_component = "sword_of_khaine"

	if self:faction_is_elven(faction) then
		find_uicomponent(core:get_ui_root(), ui_component):SetVisible(true);
		self:set_sword_button_state();

	else
		find_uicomponent(core:get_ui_root(), ui_component):SetVisible(false);
	end;

end;

-- scan and find sword owner, this is used to correct any corner cases
function sword_of_khaine:get_sword_owner()
	for i = 1, #self.key_index do
		local characters = cm:model():world():characters_owning_ancillary(self.key_index[i])
		if characters:num_items() > 0 then
			local character = characters:item_at(0);
			return character:command_queue_index(), character:faction():name();
		end
	end;
	return false, false
end;

-- Validate the cached data is accurate, if not update the cache or return the sword
function sword_of_khaine:validate_sword_owner()
	local owner_cqi, owner_faction = self:get_sword_owner();

	if self.owner.character_cqi and (not owner_cqi or not owner_faction or owner_faction == "rebels") then
		-- The character wielding the sword has disappeared or is no longer in a faction
		-- Result: Give the sword back
		self:return_sword_to_shrine();
	elseif owner_cqi then
		if owner_cqi ~= self.owner.character_cqi then
			-- Someone unexpected is wielding the sword
			-- Result: Run the function for a newly acquired sword
			self:set_sword_owner(owner_cqi)
		elseif self.owner.faction ~= owner_faction then
			-- Someone is wielding the sword but they've changed faction (probably by confederation or script)
			-- Result: Reset the cached script data
			self:correct_script_cache(owner_cqi)
		end
	end

end;

-- Script data is somehow out of sync, so we'll reset it to default with the current sword owner
function sword_of_khaine:correct_script_cache(cqi)
	if cqi then
		self.owner = {
			character_cqi = cqi,
			faction = cm:model():character_for_command_queue_index(cqi):faction():name(),
			lv = 1,
			cd = self.growth_time[1],
			ready = true
		};
	end;
	
	self:set_sword_button_state();
end;

-- Returns if the shrine of khaine is built, and who owns the region (or nil if it's abandoned)
function sword_of_khaine:check_shrine_state_and_owner()
	local shrine_built = false
	local owning_faction = nil
	local region = cm:get_region(self.region_key);
	if not region:is_abandoned() then

		owning_faction = region:owning_faction():name()

		for i = 0, region:slot_list():num_items() - 1 do
			if shrine_built then
				break
			end
			local current_slot = region:slot_list():item_at(i);
			
			if current_slot:has_building() then
				for j = 1, #self.building_keys do
					if current_slot:building():name() == self.building_keys[j] then
						shrine_built = true
						break
					end;
				end;
			end;
		end;

	end;
	return shrine_built, owning_faction
end

-- Set button state according to cached sword owner
function sword_of_khaine:set_sword_button_state()
	local local_faction = cm:get_local_faction_name(true);
	local button = find_uicomponent(core:get_ui_root(), "button_sword_of_khaine");
	local faction_symbol = find_uicomponent(core:get_ui_root(), "faction_symbol");
	local ui_fire_vfx = false
	
	if self.owner.faction and self.owner.faction ~= "rebels" then
		-- Someone controls the shrine and it's not the generic rebels faction
		local cqi = cm:get_faction(self.owner.faction):command_queue_index();
		faction_symbol:SetVisible(true);
		button:InterfaceFunction("SetFactionFlag", cqi);
		
		if not self.owner.character_cqi then
			if self.owner.faction == local_faction and self.owner.ready then
				-- Nobody is wielding the sword, but the local faction is ready to wield it
				-- This is the only instance where the UI fire vfx should be visible
				button:SetState("active");
				button:InterfaceFunction("SetTooltip",cqi, "sword_button_active");
				ui_fire_vfx = true
			else
				-- Nobody is wielding the sword, and the local faction cannot wield it yet (no shrine built or they don't own it)
				button:SetState("locked_active");
				button:InterfaceFunction("SetTooltip",cqi, "sword_button_locked_down");
			end;
		elseif self.owner.faction == local_faction then
			-- The sword is wielded by a character belonging to the local faction
			faction_symbol:SetVisible(false);
			button:SetState("owned");
			button:InterfaceFunction("SetTooltip", cqi, "sword_button_owned");
		else
			-- The sword is wielded by a character belonging to another faction
			button:SetState("locked_down");
			button:InterfaceFunction("SetTooltip", cqi, "sword_button_owned_by_others");
		end;
	elseif not self.owner.character_cqi then
		-- Nobody wields the sword, and the shrine has been razed or is owned by generic rebels
		faction_symbol:SetVisible(false);
		button:SetState("locked_active");
		button:InterfaceFunction("SetTooltip", "sword_button_locked_down_and_razed");
	end;
	find_uicomponent(core:get_ui_root(), "button_sword_of_khaine_vfx"):SetVisible(ui_fire_vfx);
end;

-- Reset sword owner, returning sword back to sword region
function sword_of_khaine:return_sword_to_shrine()
	
	if self.owner.character_cqi then
		core:trigger_event("ScriptEventSwordReturned");
	end;
	
	self:remove_sword();

	self.owner = {
		character_cqi = nil,
		faction = nil,
		lv = 0,
		cd = 0,
		ready = false
	};

	self.owner.ready, self.owner.faction = self:check_shrine_state_and_owner()
	
	self:set_sword_button_state();
end

--apply or remove vfx from char/region
function sword_of_khaine:handle_vfx(cqi, apply)
	local region = cm:get_region(self.region_key);
	local garrison_residence = region:garrison_residence();
	local garrison_residence_cqi = garrison_residence:command_queue_index();
	
	-- Clear out any existing vfx first, otherwise multiple entities could end up with the sword vfx
	self:remove_vfx()

	if apply then
		if cqi then
			local character = cm:get_character_by_cqi(cqi);
						
			if not character:is_null_interface() then
				if character:in_settlement() then
					local garrison_cqi = character:region():garrison_residence():command_queue_index();
					
					cm:add_garrison_residence_vfx(garrison_cqi, self.vfx.garrison, true);
					self.vfx_cache.garrison = garrison_cqi;
				else
					cm:add_character_vfx(cqi, self.vfx.character, true);
					self.vfx_cache.character = cqi;
				end
			end;
		elseif not garrison_residence:is_null_interface() and self.vfx_cache.garrison ~= garrison_residence_cqi then
			cm:add_garrison_residence_vfx(garrison_residence_cqi,self.vfx.garrison, true);
			self.vfx_cache.garrison = garrison_residence_cqi;
		end;
	end;
end;

function sword_of_khaine:remove_vfx()
	if self.vfx_cache.character then
		-- Make sure the character isn't already dead before we remove the vfx
		if cm:get_character_by_cqi(self.vfx_cache.character) then
			cm:remove_character_vfx(self.vfx_cache.character, self.vfx.character);
		end
		self.vfx_cache.character = nil;
	end;
	
	if self.vfx_cache.garrison then
		cm:remove_garrison_residence_vfx(self.vfx_cache.garrison, self.vfx.garrison);
		self.vfx_cache.garrison = nil;
	end;
end;

-- remove sword and sword vfx and sword effect bundle
function sword_of_khaine:remove_sword()
	if self.owner.character_cqi then
		self:handle_vfx(self.owner.character_cqi, false);
		self:remove_sword_effect_bundle();
		local faction = cm:get_faction(self.owner.faction);
		
		for i = 1, #self.key_index do
			cm:force_remove_ancillary_from_faction(faction, self.key_index[i]);
		end;
	end;
end;

function sword_of_khaine:remove_sword_effect_bundle()
	for i = 1, #self.negative_index do
		cm:remove_effect_bundle(self.negative_index[i], self.owner.faction);
	end;
end;

-- set new sword owner and update sword owner cache
function sword_of_khaine:set_sword_owner(cqi, limited_to_elven)
	local character = cm:get_character_by_cqi(cqi); 
	
	if not character or character:is_null_interface() or (limited_to_elven and not self:faction_is_elven(character:faction())) or character:faction():name() == "rebels" then
		-- The character cqi isn't valid, or the sword is limited to elves and we're not elven, or the character is a rebel
		self:return_sword_to_shrine();
	else 
		-- If we're here we have a valid character interface,
		-- and the sword is not limited to elven, 
		-- or it's limited to elven and the character is elven
		self:remove_sword();
		local sword_owner_faction = character:faction();
		self.owner = {
			character_cqi = cqi,
			faction = sword_owner_faction:name(),
			lv = 1,
			cd = self.growth_time[1],
			ready = true
		};
		
		cm:force_add_ancillary(character, self.key_index[self.owner.lv], true, false);
		
		if sword_owner_faction:is_human() then
			cm:apply_effect_bundle(self.negative_index[self.owner.lv], self.owner.faction, 0);
		else
			local human_factions = cm:get_human_factions();
			
			for i = 1, #human_factions do
				cm:trigger_incident_with_targets(
					cm:get_faction(human_factions[i]):command_queue_index(),
					self.event_index.sword_claimed_ai,
					0,
					0,
					self.owner.character_cqi,
					0,
					0,
					0
				);
			end;
		end;
		
		self:set_sword_button_state();
		self:handle_vfx(cqi, true);
		out("Assigned sword to cqi [" .. self.owner.character_cqi .. "] with faction [" .. self.owner.faction .. "]");
	end;
end;

function sword_of_khaine:faction_is_elven(faction)
	local subculture = faction:subculture();
	
	return self.elven_factions[subculture] ~= nil;
end;

-- The sword hungersssss
function sword_of_khaine:level_up()
	if (self.owner.lv + 1) <= #self.key_index then
		local character = cm:get_character_by_cqi(self.owner.character_cqi);

		-- Make sure the character actually exists
		if not character then
			script_error("ERROR: sword_of_khaine:level_up() called but supplied character cqi: "..self.owner.character_cqi.." has not returned a valid character interface");
		end
		local sword_owner_faction = cm:get_faction(self.owner.faction);

		-- Remove current lvl sword from currently stored character_cqi
		self:remove_sword_effect_bundle();
		out("Removing_sword with level [" .. self.key_index[self.owner.lv] .. "] from character with cqi [" .. self.owner.character_cqi .. "]");
		cm:force_remove_ancillary_from_faction(sword_owner_faction, self.key_index[self.owner.lv]);
		
		self.owner.lv = self.owner.lv + 1;
		self.owner.cd = self.growth_time[self.owner.lv];
		
		cm:force_add_ancillary(character, self.key_index[self.owner.lv], true, false);

		if sword_owner_faction:is_human() then
			cm:apply_effect_bundle(self.negative_index[self.owner.lv], self.owner.faction, 0);
		end;
	end;
end;

function sword_of_khaine:is_character_valid_to_equip_sword(character)
	return not character:is_null_interface() and cm:char_is_general_with_army(character) and not character:military_force():is_armed_citizenry() and character:character_subtype_key() ~= "wh2_main_def_black_ark";
end;

function sword_of_khaine:find_candidate_for_faction(faction)
	for i = 0, faction:character_list():num_items() - 1 do
		local current_character = faction:character_list():item_at(i);
		
		if self:is_character_valid_to_equip_sword(current_character) and current_character:has_region() and current_character:in_settlement() and current_character:region():name() == self.region_key then
			return current_character:command_queue_index();
		end;
	end;
end;

function sword_of_khaine:transfer_sword_after_battle(target_character)
	if target_character and target_character:won_battle() and self:is_character_valid_to_equip_sword(target_character) then
		local cqi = target_character:command_queue_index();
		local faction = target_character:faction();
		
		if faction:is_human() then
			cm:trigger_dilemma(faction:name(), self.event_index.sword_picking);
			self.owner_cache = cqi;
		else
			self:set_sword_owner(cqi, false);
		end;
	end;
end;



function sword_of_khaine:add_listeners()

	core:add_listener(
		"initiate_sword_button_listener",
		"ScriptEventInitiateSwordButton",
		true,
		function()
			self:initiate_sword_button();
		end,
		true
	);

	-- check if confederation changes sword owner's faction
	core:add_listener(
		"sword_of_khaine_FactionJoinsConfederation",
		"FactionJoinsConfederation",
		true,
		function()
			self:validate_sword_owner();
		end,
		true
	);

	-- check if civil war changes sword owner's faction
	core:add_listener(
		"sword_of_khaine_FactionCivilWarOccured",
		"FactionCivilWarOccured",
		true,
		function()
			self:validate_sword_owner();
		end,
		true
	);

	-- check if mission reward had unequipped the sword
	core:add_listener(
		"sword_of_khaine_CharacterAncillaryGained",
		"CharacterAncillaryGained",
		function(context)
			return context:character():command_queue_index() == self.owner.character_cqi;
		end,
		function()
			local character = cm:get_character_by_cqi(self.owner.character_cqi);
			
			if not character:has_ancillary(self.key_index[self.owner.lv]) then
				cm:force_remove_ancillary_from_faction(character:faction(), self.key_index[self.owner.lv]);
				cm:force_add_ancillary(character, self.key_index[self.owner.lv], true, false);
			end;
		end,
		true
	);

	-- check if the sword's home region is razed
	core:add_listener(
		"sword_of_khaine_CharacterRazedSettlement",
		"CharacterRazedSettlement",
		function(context)
			return context:character():region():name() == self.region_key;
		end,
		function(context)
			find_uicomponent(core:get_ui_root(), "faction_symbol"):SetVisible(false);
			
			if not self.owner.character_cqi then
				self.owner.faction = nil;
				self:set_sword_button_state();
			end;
		end,
		true
	);

	-- check if we should power-up the sword
	core:add_listener(
		"sword_of_khaine_WorldStartRound",
		"WorldStartRound",
		true,
		function()
			self:validate_sword_owner();
		
			if self.owner.faction then

				local current_faction_name = self.owner.faction
				local current_faction = cm:get_faction(current_faction_name)

				if not current_faction:is_null_interface() then
					if current_faction:is_human() then
						if self.owner.character_cqi then
							if self.owner.cd >= 1 and self.owner.lv <= #self.key_index then
								self.owner.cd = self.owner.cd - 1;
							elseif self.owner.cd == 0 and self.owner.lv + 1 <= #self.key_index then
								cm:trigger_dilemma(current_faction_name, self.event_index.sword_level_dilemma_index[self.owner.lv]);
							end;
						end;
					-- deal with AI
					elseif not self.owner.character_cqi and self.owner.ready then
						-- give sword to the highest ranked general in the ai's faction
						if cm:random_number(100) >= 20 then
							local char_list = current_faction:character_list();
							local highest_rank = 0;
							local highest_cqi = nil;
							
							for i = 0, char_list:num_items() - 1 do
								local current_char = char_list:item_at(i);
								
								if current_char:rank() > highest_rank and self:is_character_valid_to_equip_sword(current_char) then
									highest_rank = current_char:rank()
									highest_cqi = current_char:command_queue_index();
								end;
							end;
							
							self:set_sword_owner(highest_cqi, true);
							
							core:trigger_event("ScriptEventSwordClaimedByAI");
						end;
					elseif self.owner.character_cqi then	
						if self.owner.cd >= 1 and self.owner.lv <= #self.key_index then
							self.owner.cd = self.owner.cd - 1;
							if self.owner.cd == 0 then
								self:level_up();
							end
						elseif self.owner.cd == 0 and self.owner.lv == #self.key_index then
							--remove the sword from the general by a chance, if he's holding it too long
							if cm:random_number(100) <= self.ai_chance_to_lose_sword then
								self:return_sword_to_shrine();
								
								local human_factions = cm:get_human_factions();
								
								for i = 1, #human_factions do
									cm:trigger_incident(human_factions[i], self.event_index.sword_returned, true);
								end;
							end;
						end;
					end;
				end;
			end;
		end,
		true
	);

	-- issue sword when incident is triggered
	-- this is done such a way since only events are broadcasted during UIevents (button click)
	core:add_listener(
		"sword_of_khaine_IncidentOccuredEvent",
		"IncidentOccuredEvent",
		function(context)
			return context:dilemma() == self.event_index.sword_issued;
		end,
		function(context)
			local faction = context:faction();
			local candidate = self:find_candidate_for_faction(faction);
			
			if candidate then
				self:set_sword_owner(candidate, false);
				
				if cm:get_local_faction_name(true) == faction:name() then
					core:trigger_event("ScriptEventSwordClaimedByPlayer");
				end;
			end;
		end,
		true
	);

	--level-up/return sword based on dilemma
	core:add_listener(
		"sword_of_khaine_DilemmaChoiceMadeEvent",
		"DilemmaChoiceMadeEvent",
		true,
		function(context)
			local choice = context:choice();
			local dilemma = context:dilemma();
			local faction_name = context:faction():name();
			local local_faction = cm:get_local_faction_name(true);
			
			for i = 1, #self.event_index.sword_level_dilemma_index do
				if i == 1 and faction_name == local_faction then
					core:trigger_event("ScriptEventSwordDilemmaFirst");
				end;
				
				if dilemma == self.event_index.sword_level_dilemma_index[i] then
					if choice == 0 then
						self:level_up();
						
						if i == #self.event_index.sword_level_dilemma_index then
							cm:trigger_incident(faction_name, self.event_index.sword_stuck, true);
							
							if self.owner.faction == local_faction then
								core:trigger_event("ScriptEventSwordStuck");
							end;
						end;
					elseif choice == 1 then
						self:return_sword_to_shrine();
						cm:trigger_incident(faction_name, self.event_index.sword_returned, true);
					end;
				end;
			end;
			
			if dilemma == self.event_index.sword_picking then
				if choice == 0 and self.owner_cache > 0 then
					self:set_sword_owner(self.owner_cache);
				elseif choice == 1 then
					self:return_sword_to_shrine();
				end;
			end;
		end,
		true
	);

	-- transfer through battles
	core:add_listener(
		"sword_of_khaine_BattleCompleted",
		"BattleCompleted",
		true,
		function(context)
			local is_night_battle = cm:model():pending_battle():night_battle();
				
			-- Check the sword owning faction exists and is in the battle, and that they're on the losing side
			if self.owner.faction ~= nil then

				if cm:pending_battle_cache_num_attackers() >= 1 then
					for i = 1, cm:pending_battle_cache_num_attackers() do
						if is_night_battle and i == 2 then
							break;
						end;
						
						local attacker_fm_cqi = cm:pending_battle_cache_get_attacker_fm_cqi(i)
						local attacker_fm = cm:get_family_member_by_cqi(attacker_fm_cqi)
						if attacker_fm and not attacker_fm:character_details():is_null_interface() then

							local attacker_faction = attacker_fm:character_details():faction()
							for i = 1, #self.key_index do
								
								if attacker_faction:ancillary_exists(self.key_index[i]) and attacker_fm:character_details():has_ancillary(self.key_index[i]) then
									local defender_char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_defender(1);
									
									out("Sword of Khaine: The previous owner has been defeated in battle, so we'll check to see if "..faction_name.." can steal the sword, and if not return it to the shrine")
									
									self:transfer_sword_after_battle(cm:get_character_by_cqi(defender_char_cqi));
									break;
								end;
							end;
						end;
					end;
				end;

				
				if cm:pending_battle_cache_num_defenders() >= 1 then
					for i = 1, cm:pending_battle_cache_num_defenders() do
						if is_night_battle and i == 2 then
							break;
						end;
						
						local defender_fm_cqi = cm:pending_battle_cache_get_defender_fm_cqi(i)
						local defender_fm = cm:get_family_member_by_cqi(defender_fm_cqi)
						if defender_fm and not defender_fm:character_details():is_null_interface() then

							local defender_faction = defender_fm:character_details():faction()
							for i = 1, #self.key_index do
								
								if defender_faction:ancillary_exists(self.key_index[i]) and defender_fm:character_details():has_ancillary(self.key_index[i]) then
									local attacker_char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_attacker(1);
									
									out("Sword of Khaine: The previous owner has been defeated in battle, so we'll check to see if "..faction_name.." can steal the sword, and if not return it to the shrine")
									
									self:transfer_sword_after_battle(cm:get_character_by_cqi(attacker_char_cqi));
									break;
								end;
							end;
						end;
					end;
				end;

			end
		end,
		true
	);

	local camera_is_moving = false;

	--Listen for the sword of khaine button being pressed for camera moves/claiming incident
	core:add_listener(
		"SwordButtonListener",
		"ComponentLClickUp", 
		function(context)
			return UIComponent(context.component):Id() == "button_sword_of_khaine";
		end,
		function()
			if not camera_is_moving then
				local faction = cm:get_faction(cm:get_local_faction_name(true))
				if self.owner.character_cqi then
					local character = cm:get_character_by_cqi(self.owner.character_cqi);
					
					if character then
						cm:scroll_camera_from_current(false, 3, {character:display_position_x(), character:display_position_y(), 14.7, 0, 12});
						camera_is_moving = true;
						cm:callback(function() camera_is_moving = false end, 3);
					end;
				elseif self.owner.faction == faction:name() and self.owner.ready and self:find_candidate_for_faction(faction) then
					-- Fire a multiplayer-safe event through the UI to trigger the incident, rather than the incident directly
					CampaignUI.TriggerCampaignScriptEvent(faction:command_queue_index(), "sword_of_khaine_ui_button_pressed")
				else
					local settlement = cm:get_region(self.region_key):settlement();
					cm:scroll_camera_from_current(false, 3, {settlement:display_position_x(), settlement:display_position_y(), 14.7, 0, 12});
					camera_is_moving = true;
					cm:callback(function() camera_is_moving = false end, 3);
				end;
			end;


		end,
		true
	);

	-- Trigger incident via the UI to make it mp safe
	core:add_listener(
		"sword_of_khaine_ui_button_pressed",
		"UITrigger",
		function(context)
			return context:trigger() == "sword_of_khaine_ui_button_pressed"
		end,
		function(context)
			local faction_key = cm:model():faction_for_command_queue_index(context:faction_cqi()):name()
			cm:trigger_incident(faction_key, self.event_index.sword_issued, true, true);

		end,
		true
	);

	core:add_listener(
		"sword_of_khaine_BuildingCompleted",
		"BuildingCompleted",
		function(context)
			local building = context:building();
			
			return building:superchain() == "wh2_main_sch_special_shrine_of_khaine" and self:faction_is_elven(building:faction());
		end,
		function(context)
			if not self.owner.character_cqi then
				self:return_sword_to_shrine();
				
				if self.owner.ready and cm:get_faction(self.owner.faction):is_human() then
					cm:trigger_incident(self.owner.faction, self.event_index.sword_building_done, true);
					
					if self:find_candidate_for_faction(context:building():faction()) then
						core:trigger_event("ScriptEventSwordAvailable");
					end;
				end;
			end;
		end,
		true
	);

	-- sword region being occupied
	-- candidate enters the region
	core:add_listener(
		"sword_of_khaine_CharacterEntersGarrison",
		"CharacterEntersGarrison",
		true,
		function(context)
			local character = context:character();
			
			if context:garrison_residence():region():name() == self.region_key and not self.owner.character_cqi then
				self:return_sword_to_shrine();
				
				if self.owner.faction ~= nil and self:faction_is_elven(cm:get_faction(self.owner.faction)) then
					cm:trigger_incident(character:faction():name(), self.event_index.sword_region_got, true);
				end;
			end;
			
			if character:command_queue_index() == self.owner.character_cqi then
				self:handle_vfx(self.owner.character_cqi, true);
			end;
		end,
		true
	);

	core:add_listener(
		"sword_of_khaine_CharacterLeavesGarrison",
		"CharacterLeavesGarrison",
		true,
		function(context)
			if context:garrison_residence():region():name() == self.region_key and context:character():command_queue_index() == self.owner.character_cqi then
				self:handle_vfx(self.owner.character_cqi, true);
			end;
		end,
		true
	);

end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("sword_of_khaine_owner", sword_of_khaine.owner, context);	
		cm:save_named_value("sword_of_khaine_vfx_cache", sword_of_khaine.vfx_cache, context);
		cm:save_named_value("sword_of_khaine_owner_cache", sword_of_khaine.owner_cache, context);
	end
);

cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			sword_of_khaine.owner = cm:load_named_value("sword_of_khaine_owner", sword_of_khaine.owner, context);
			sword_of_khaine.vfx_cache = cm:load_named_value("sword_of_khaine_vfx_cache", sword_of_khaine.vfx_cache, context);
			sword_of_khaine.owner_cache = cm:load_named_value("sword_of_khaine_owner_cache", sword_of_khaine.owner_cache, context);
		end
	end
);