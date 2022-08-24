belakor_daemon_prince_creation = {
	belakor_faction_key = "wh3_main_chs_shadow_legion",
	daemon_prince_subtype = "wh3_dlc20_chs_daemon_prince_undivided",
	faction_set_key = "human_factions", -- the effect will only apply to human races e.g. empire, bretonnia etc.
	effect_bundle_key = "wh3_main_bundle_belakor_daemon_prince_creation", -- timed effect bundle
	infinite_effect_bundle_key = "wh3_main_bundle_belakor_daemon_prince_creation_infinite", -- infinite effect bundle (used to check when the above bundle expires, as it's removed before the character is killed)
	effect_bundle_duration = 10
}

function belakor_daemon_prince_creation:start()
	core:add_listener(
		"belakor_daemon_prince_spawn",
		"ScriptEventBelakorDaemonPrinceEffectBundleExpires",
		function()
			return not cm:get_faction(self.belakor_faction_key):is_dead()
		end,
		function(context)
			local family_member_cqi = tonumber(context.string)
			
			local family_member = cm:get_family_member_by_cqi(family_member_cqi)
			
			if family_member then
				local character = family_member:character()
				
				if not character:is_null_interface() and character:has_effect_bundle(self.infinite_effect_bundle_key) then
					cm:trigger_incident_with_targets(cm:get_faction(self.belakor_faction_key):command_queue_index(), "wh3_main_incident_belakor_daemon_prince_created", 0, 0, character:command_queue_index(), 0, 0, 0)
					cm:kill_character_and_commanded_unit(cm:char_lookup_str(character), false)
					cm:spawn_character_to_pool(self.belakor_faction_key, "", "", "", "", 21, true, "general", self.daemon_prince_subtype, false, "")
				end
			end
		end,
		true
	)
	
	core:add_listener(
		"belakor_hero_targets_army",
		"CharacterCharacterTargetAction",
		function(context)
			local target_character = context:target_character()
			
			return context:character():faction():name() == self.belakor_faction_key and (context:mission_result_critial_success() or context:mission_result_success())
		end,
		function(context)
			self:apply_effect_bundle(context:target_character())
		end,
		true
	)
	
	core:add_listener(
		"belakor_wins_battle",
		"BattleCompleted",
		function()
			return cm:pending_battle_cache_faction_is_involved(self.belakor_faction_key) and cm:model():pending_battle():has_been_fought()
		end,
		function()
			local character = false
			local char_cqi = false
			local mf_cqi = false
			local faction_name = false
			
			if cm:pending_battle_cache_faction_is_attacker(self.belakor_faction_key) then
				char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_defender(1)
			else
				char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_attacker(1)
			end
			
			if char_cqi then
				character = cm:get_character_by_cqi(char_cqi)
			end
			
			if character then
				if cm:pending_battle_cache_faction_won_battle(self.belakor_faction_key) then
					self:apply_effect_bundle(character)
				elseif cm:pending_battle_cache_faction_lost_battle(self.belakor_faction_key) then
					self:remove_effect_bundle(character)
				end
			end
		end,
		true
	)
	
	-- clear any effect bundles if belakor's faction dies
	core:add_listener(
		"belakor_faction_dies",
		"WorldStartRound",
		true,
		function()
			if not cm:get_saved_value("belakor_faction_dead") and cm:get_faction(self.belakor_faction_key):is_dead() then
				-- only do this the first round belakor's faction is dead
				cm:set_saved_value("belakor_faction_dead", true)
				
				local faction_list = cm:model():world():faction_list()
				
				for i = 0, faction_list:num_items() - 1 do
					local current_faction = faction_list:item_at(i)
					
					if not current_faction:is_dead() then
						local character_list = current_faction:character_list()
						
						for j = 0, character_list:num_items() - 1 do
							local current_character = character_list:item_at(j)
							
							if cm:char_is_general(current_character) then
								self:remove_effect_bundle(current_character)
							end
						end
					end
				end
			else
				cm:set_saved_value("belakor_faction_dead", false)
			end
		end,
		true
	)
end

function belakor_daemon_prince_creation:apply_effect_bundle(character)
	if cm:char_is_general_with_army(character) and character:faction():is_contained_in_faction_set(self.faction_set_key) and not character:character_details():is_unique() and not character:is_faction_leader() then
		cm:apply_effect_bundle_to_character(self.effect_bundle_key, character, self.effect_bundle_duration)
		cm:apply_effect_bundle_to_character(self.infinite_effect_bundle_key, character, 0)
		
		cm:add_turn_countdown_event(self.belakor_faction_key, self.effect_bundle_duration, "ScriptEventBelakorDaemonPrinceEffectBundleExpires", tostring(character:family_member():command_queue_index()))
	end
end

function belakor_daemon_prince_creation:remove_effect_bundle(character)
	if character:has_effect_bundle(self.effect_bundle_key) then
		cm:remove_effect_bundle_from_character(self.effect_bundle_key, character)
	end
	
	if character:has_effect_bundle(self.infinite_effect_bundle_key) then
		cm:remove_effect_bundle_from_character(self.infinite_effect_bundle_key, character)
	end
end