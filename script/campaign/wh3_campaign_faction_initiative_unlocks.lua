-- FACTION INITIATIVE SCRIPT UNLOCKING

------------------
--- HOW TO USE ---
------------------

-- To use the unlocking function you need to add new entries to the relevant tables dependant on unlock condition
-- 		EXAMPLE: faction_initiatives_unlocker.technology_to_initiatives = {tech_key = {initiatives_to_unlock_1, initiatives_to_unlock_2, ...},}
-- Inside the new entry you need to add what initiatives you want unlocked and and additional data. This can either be a single key or a table of keys
-- 		EXAMPLE: tech_key = "wh3_dlc23_faction_initiative_chd_category_hobgoblins_1" or tech_key = {"wh3_dlc23_faction_initiative_chd_category_hobgoblins_1", "wh3_dlc23_faction_initiative_chd_category_hobgoblins_2"}
-- If you wish for an Incident to be triggered once the initiatives are unlocked you need to add an entry for the culture to incident key in faction_initiatives_unlocker.culture_to_incident
-- 		EXAMPLE: faction_initiatives_unlocker.culture_to_incident = {wh3_dlc23_chd_chaos_dwarfs = "wh3_dlc23_incident_hellforge_items_unlocked", ..}
-- To add a new event to listen for you need to add a new empty table {} entry to faction_initiatives_unlocker.event_templates and then add in the event key
-- 		EXAMPLE: {event = "ResearchCompleted", OR event = {"ScriptEventHellforgeUnlockHobgoblins", "BuildingCompleted"}}
-- Finally add the condition that needs to be checked once the corresponding event is triggered
-- 		EXAMPLE: condition =
--					function(context, faction_name)
--						return context:building():faction():name() == faction_name and context:faction():has_technology("wh3_dlc23_tech_chd_military_22")
--					end
--
-- Types of variables and how to use them:
--
-- 		faction_initiatives_unlocker.initiative_cultures -> Add your culture here if you wish to unlock initiatives for it
-- 			culture_key = true,
-- 			faction_initiatives_unlocker.technology_to_initiatives -> Add your technology keys with linked inititives to unlock
--				wh3_dlc23_tech_chd_military_15 = {
--					"wh3_dlc23_faction_initiative_chd_category_melee_infantry_1",
--					"wh3_dlc23_faction_initiative_chd_category_melee_infantry_2",
--					"wh3_dlc23_faction_initiative_chd_category_melee_infantry_11",
--				},
-- 			faction_initiatives_unlocker.building_to_initiatives -> Add your building kets with linked initiatives to unlock along with the required count and completed = false
--				{
--					completed = false,
--					building_keys = {
--						"wh3_dlc23_chd_military_hobgoblins_1",
--						"wh3_dlc23_chd_military_hobgoblins_2",
--					},
--					initiative_keys = {
--						"wh3_dlc23_faction_initiative_chd_category_hobgoblins_6",
--						"wh3_dlc23_faction_initiative_chd_category_hobgoblins_7",
--						"wh3_dlc23_faction_initiative_chd_category_hobgoblins_9",
--						"wh3_dlc23_faction_initiative_chd_category_hobgoblins_10",
--					},
--					count = 2,
--				},
-- 			faction_initiatives_unlocker.script_event_to_initiatives -> Add your custom Script Events with linked inititives to unlock
--				ScriptEventHellforgeUnlockHobgoblins = {
--					"wh3_dlc23_faction_initiative_chd_category_hobgoblins_6",
--					"wh3_dlc23_faction_initiative_chd_category_hobgoblins_7",
--					"wh3_dlc23_faction_initiative_chd_category_hobgoblins_9",
--					"wh3_dlc23_faction_initiative_chd_category_hobgoblins_10",
--				},
-- 			faction_initiatives_unlocker.incident_to_initiatives -> Add your Incidents with linked inititives to unlock
--				wh3_dlc23_chd_convoy_unique_completed_the_haunted_forest = {
--					"wh3_dlc23_faction_initiative_chd_category_hobgoblins_3",
--					"wh3_dlc23_faction_initiative_chd_category_hobgoblins_12",
--				},
-- 			faction_initiatives_unlocker.mission_to_initiatives -> Add your Mission_keys with linked inititives to unlock
-- 				{
-- 					mission_keys = {
-- 						"wh3_dlc23_chd_drazhoath_hellshard_amulet",
-- 						"wh3_dlc23_ie_chd_drazhoath_hellshard_amulet",
-- 						"wh3_dlc23_ie_qb_chd_astragoth_black_hammer_of_hashut",
-- 						"wh3_dlc23_ie_qb_chd_zhatan_chaos_runeshield",
-- 						"wh3_dlc23_qb_chd_zhatan_chaos_runeshield",
-- 						"wh3_dlc23_roc_qb_chd_astragoth_black_hammer_of_hashut",
-- 					},
-- 					initiative_keys = {
-- 						"wh3_dlc23_faction_initiative_chd_category_melee_infantry_5",
-- 						"wh3_dlc23_faction_initiative_chd_category_melee_infantry_9",
-- 						"wh3_dlc23_faction_initiative_chd_category_missile_infantry_5",
-- 						"wh3_dlc23_faction_initiative_chd_category_missile_infantry_9",
-- 					},
-- 				}
-- 			faction_initiatives_unlocker.culture_to_incident -> Add your culture to incident to trigger an incident. OPTIONAL
-- 					wh3_dlc23_chd_chaos_dwarfs = "wh3_dlc23_incident_hellforge_items_unlocked",
-- 				}
--
--
-----------------------------------------------------------
-----------------------------------------------------------


faction_initiatives_unlocker = {
	cm = false,
	initiative_key = "",
	event = "",
	condition = false
}

faction_initiatives_unlocker.initiative_cultures = {
}

faction_initiatives_unlocker.technology_to_initiatives = {
}

faction_initiatives_unlocker.building_to_initiatives = {
}

faction_initiatives_unlocker.incident_to_initiatives = {
}

faction_initiatives_unlocker.mission_to_initiatives = {
}

faction_initiatives_unlocker.culture_to_incident = {
}

faction_initiatives_unlocker.initiatives_to_activate_immediately = {
}

faction_initiatives_unlocker.event_templates = {
}


--------------------------------------------
-- Faction Initiative unlocking functions --
--------------------------------------------


function faction_initiatives_unlocker:initiatives_unlocker_listeners()
	local factions = cm:model():world():faction_list()
	
	for _, current_faction in model_pairs(factions) do
		if self.initiative_cultures[current_faction:culture()]then
			initiative_faction_exists = true
			
			if not current_faction:faction_initiative_sets():is_empty() then
				self:start(current_faction)
			end
		end
	end
end


function faction_initiatives_unlocker:start(faction_interface)
	local faction_name = faction_interface:name()

	for i = 1, #self.event_templates do
		local event_data = self.event_templates[i]
		if is_string(event_data.event) then
			event_data.event = {event_data.event}
		end
		for _, v in ipairs(event_data.event) do
			core:add_listener(
				v .. "_" .. faction_name .. "_listener",
				v,
				function(context)
					return event_data.condition(context, faction_name)
				end,
				function(context)
					out.design("Initiatives -- Conditions met for event [" .. v .. "], unlocking Initiatives for faction with name [" .. faction_name .. "]")

					local initiative_list = {}
					if is_function(context.technology) then
						initiative_list = self.technology_to_initiatives[context:technology()]
					elseif is_function(context.mission) then
						local mission_key = context:mission():mission_record_key()
						for _, v in ipairs(self.mission_to_initiatives) do
							if self:key_exists_in_list(mission_key, v.mission_keys) then
								initiative_list = v.initiative_keys
								break
							end
						end
					elseif is_function(context.dilemma) then
						initiative_list = self.incident_to_initiatives[context:dilemma()]
					elseif is_function(context.building) then
						local building_key = context:building():name()
						self.building_to_initiatives = cm:get_saved_value("faction_initiative_unlock_building_completed") or self.building_to_initiatives
						for _, v in ipairs(self.building_to_initiatives) do
							if not v.completed and self:key_exists_in_list(building_key, v.building_keys) then
								v.completed = true
								cm:set_saved_value("faction_initiative_unlock_building_completed", self.building_to_initiatives);
								initiative_list = v.initiative_keys
							end
						end
					end

					local faction = cm:get_faction(faction_name)
					for _, initiative_set in model_pairs(faction:faction_initiative_sets()) do
						for j = 1, #initiative_list do
							if not initiative_set:lookup_initiative_by_key(initiative_list[j]):is_null_interface() then
								cm:toggle_initiative_script_locked(initiative_set, initiative_list[j], false);

								out.design("Initiatives -- Unlocking Initiative with key [" .. initiative_list[j] .. "]")
								-- Immediatly activate the initiative if it exists in the initiatives_to_activate_immediately list
								if self:key_exists_in_list(initiative_list[j], self.initiatives_to_activate_immediately) then
									cm:toggle_initiative_active(initiative_set, initiative_list[j], true)
								end
							end
						end
					end

					if self.culture_to_incident[faction:culture()] ~= nil then
						--cm:trigger_incident(faction_name, self.culture_to_incident[faction:culture()], true, false)
					end
				end,
				true
			)
		end
	end
end


function faction_initiatives_unlocker:contains_initiative(list_of_initiatives, initiative_key)
	for i = 1, #list_of_initiatives do
		if initiative_key == list_of_initiatives[i] then return true end
	end
	return false
end


------------------------
--- HELPER FUNCTIONS ---
------------------------

function faction_initiatives_unlocker:building_matches_requirements(faction_key, building_key)
	local faction = cm:get_faction(faction_key)
	local region_list = faction:region_list()
	local found_count = 0
	for _, v in ipairs(self.building_to_initiatives) do
		if not v.completed and self:key_exists_in_list(building_key, v.building_keys) then
			for i = 1, region_list:num_items() do
				local region = region_list:item_at(i-1)
				for j = 1, #v.building_keys do
					local r_name = region:name()
					if region:building_exists(v.building_keys[j]) then
						v.count = v.count or 1
						found_count = found_count + 1
						if found_count >= v.count then return true end
					end
				end
			end
		end
	end	
	return false
end


function faction_initiatives_unlocker:key_exists_in_list(key, list)
	for i = 1, #list do
		if list[i] == key then
			return true
		end
	end
	return false
end