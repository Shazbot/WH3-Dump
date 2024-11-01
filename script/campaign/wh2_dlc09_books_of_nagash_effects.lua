local resource_locations = {
	["res_gold"] = {},
	["res_gems"] = {},
	["res_rom_marble"] = {}
};

local mannfred_faction_key = "wh_main_vmp_vampire_counts"
local malevolent_museum_key = "wh3_main_special_drakenhof_malevolent_museum"
malevolent_region_key = "wh3_main_combi_region_castle_drakenhof"
local volkmar_faction_key = "wh3_main_emp_cult_of_sigmar"


function add_nagash_books_effects_listeners()
	local all_regions = cm:model():world():region_manager():region_list();
	
	for i = 0, all_regions:num_items() - 1 do
		local current_region = all_regions:item_at(i);
		local current_region_resource = "";
		
		for j = 0, current_region:slot_list():num_items() - 1 do
			local current_slot = current_region:slot_list():item_at(j);
		
			if current_slot:resource_key() ~= "" then
				current_region_resource = current_slot:resource_key();
				break;
			end
		end
		
		if current_region_resource ~= "" then
			for resource, v in pairs(resource_locations) do
				if resource == current_region_resource then
					table.insert(resource_locations[resource], current_region:name());
				end
			end
		end
	end
end


core:add_listener(
	"faction_turn_start_tmb_lift_shroud_resource_locations",
	"FactionTurnStart",
	function(context)
		local faction = context:faction();
		if(faction:is_human()) then
			return faction:has_effect_bundle("wh2_dlc09_books_of_nagash_reward_2") or 
				faction:has_effect_bundle("wh3_main_books_of_nagash_mannfred_reward_2") or
				faction:has_effect_bundle("wh3_main_books_of_nagash_mannfred_studied_reward_2");
		end
	end,
	function(context)
		for k, regions in pairs(resource_locations) do
			for i = 1, #regions do
				cm:make_region_visible_in_shroud(context:faction():name(), regions[i]);
			end
		end
	end,
	true
);


function books_of_nagash_3_replenishment(context, effect)
	local character = context:character();
	local char_cqi = character:command_queue_index();
	local duration = 10;
	
	cm:remove_effect_bundle_from_characters_force("wh2_dlc09_books_of_nagash_reward_3_army", char_cqi);
	cm:remove_effect_bundle_from_characters_force("wh3_main_books_of_nagash_mannfred_studied_reward_3_army", char_cqi);
	cm:remove_effect_bundle_from_characters_force("wh3_main_books_of_nagash_mannfred_reward_3_army", char_cqi);

	cm:apply_effect_bundle_to_characters_force(effect, char_cqi, duration);
	cm:trigger_incident(character:faction():name(),"wh2_dlc09_incident_tmb_sand_storm_spawned", true);
	cm:create_storm_for_region(character:region():name(), 1, duration, "land_storm");
end


core:add_listener(
	"character_sacked_settlement_tmb_create_storm_for_region",
	"CharacterSackedSettlement",
	true,
	function(context)
		local faction = context:character():faction();
		
		if nagash_book_participant_factions[faction:name()] or nagash_book_participant_cultures[faction:culture()] then
			if (faction:has_effect_bundle("wh2_dlc09_books_of_nagash_reward_3")) then
				books_of_nagash_3_replenishment(context, "wh2_dlc09_books_of_nagash_reward_3_army")
			elseif(faction:has_effect_bundle("wh3_main_books_of_nagash_mannfred_studied_reward_3")) then
				books_of_nagash_3_replenishment(context, "wh3_main_books_of_nagash_mannfred_studied_reward_3_army")
			elseif(faction:has_effect_bundle("wh3_main_books_of_nagash_mannfred_reward_3")) then
				books_of_nagash_3_replenishment(context, "wh3_main_books_of_nagash_mannfred_reward_3_army")
			end	
		end
	end,
	true
);


core:add_listener(
	"garrison_occupied_event_tmb_create_storm_for_region",
	"GarrisonOccupiedEvent",
	true,
	function(context)
		local faction = context:character():faction();
		if nagash_book_participant_factions[faction:name()] or nagash_book_participant_cultures[faction:culture()] then
			if (faction:has_effect_bundle("wh2_dlc09_books_of_nagash_reward_3")) then
				books_of_nagash_3_replenishment(context, "wh2_dlc09_books_of_nagash_reward_3_army")
			elseif(faction:has_effect_bundle("wh3_main_books_of_nagash_mannfred_studied_reward_3")) then
				books_of_nagash_3_replenishment(context, "wh3_main_books_of_nagash_mannfred_studied_reward_3_army")
			elseif(faction:has_effect_bundle("wh3_main_books_of_nagash_mannfred_reward_3")) then
				books_of_nagash_3_replenishment(context, "wh3_main_books_of_nagash_mannfred_reward_3_army")
			end	
		end
	end,
	true
);


core:add_listener(
	"mission_succeeded_tmb_lift_shroud",
	"MissionSucceeded",
	true,
	function(context)
		local mission_key = context:mission():mission_record_key();
		
		if mission_key == "wh2_dlc09_books_of_nagash_2" then
			local faction_name = context:faction():name();

			for k, regions in pairs(resource_locations) do
				for i = 1, #regions do
					cm:make_region_visible_in_shroud(faction_name, regions[i]);
				end
			end
		elseif mission_key == "wh2_dlc09_books_of_nagash_4"  then
			local faction = context:faction()

			if faction:culture() == "wh2_dlc09_tmb_tomb_kings" then
				local faction_name = faction:name();
				
				cm:pooled_resource_mod(faction:command_queue_index(), "tmb_canopic_jars", "other", 400);
				cm:remove_event_restricted_unit_record_for_faction("wh2_dlc09_tmb_mon_necrosphinx_ror", faction_name);
			end
		end
	end,
	true
);

function mannfred_malevolant_museum_effect_update()
	local region = cm:get_region(malevolent_region_key)
	local owner = region:owning_faction()

	if owner:name() == mannfred_faction_key and region:building_exists(malevolent_museum_key) then
		-- apply studied effects
		for i = 1, 8 do
			if owner:has_effect_bundle("wh3_main_books_of_nagash_mannfred_reward_"..i) then
				cm:remove_effect_bundle("wh3_main_books_of_nagash_mannfred_reward_"..i, mannfred_faction_key)
				cm:apply_effect_bundle("wh3_main_books_of_nagash_mannfred_studied_reward_"..i, mannfred_faction_key, 0)
			end
		end
	else
		-- apply base effects
		for i = 1, 8 do
			if owner:has_effect_bundle("wh3_main_books_of_nagash_mannfred_studied_reward_"..i) then
				cm:remove_effect_bundle("wh3_main_books_of_nagash_mannfred_studied_reward_"..i, mannfred_faction_key)
				cm:apply_effect_bundle("wh3_main_books_of_nagash_mannfred_reward_"..i, mannfred_faction_key, 0)
			end
		end
	end
end

core:add_listener(
	"MannfredBooksOfNagashStudiedBuilding",
	"BuildingCompleted",
	function(context)
		return context:building():name() == malevolent_museum_key 
	end,
	function(context)
		mannfred_malevolant_museum_effect_update()
	end,
	true
)

core:add_listener(
	"MannfredBooksOfNagashStudiedMission",
	"MissionSucceeded",
	function(context)
		return context:faction():name() == mannfred_faction_key and context:mission():mission_issuer_record_key() == "BOOK_NAGASH"
	end,
	function(context)
		cm:callback(function()
			-- MissionSucceeded is triggering before rewards are granted, which is resulting in effects not being doubled until the following turn. 
			-- This second delay ensures new effects granted by the mission are also doubled straight away.
			mannfred_malevolant_museum_effect_update()
		end,
		1)
	end,
	true
)

core:add_listener(
	"MannfredBooksOfNagashBloodKiss",
	"MissionSucceeded",
	function(context)
		return context:faction():name() == mannfred_faction_key and context:mission():mission_record_key() == "wh2_dlc09_books_of_nagash_7"
	end,
	function(context)
		-- one time bonus when mission first completed, grant 3 blood kisses
		cm:faction_add_pooled_resource(mannfred_faction_key, "vmp_blood_kiss", "other", 3);
	end,
	false
)

core:add_listener(
	"MannfredBooksOfNagashStudiedRoundStart",
	"FactionRoundStart",
	function(context)
		return context:faction():name() == mannfred_faction_key
	end,
	function(context)
		mannfred_malevolant_museum_effect_update()
	end,
	true
)

core:add_listener(
	"VolkmarBooksOfNagashZeal",
	"MissionSucceeded",
	function(context)
		return context:faction():name() == volkmar_faction_key and context:mission():mission_issuer_record_key() == "BOOK_NAGASH"
	end,
	function(context)
		-- add +1 Zeal pooled resource
		cm:faction_add_pooled_resource(volkmar_faction_key, "wh3_main_emp_volkmar_books_destroyed", "wh3_main_emp_volkmar_books_destroyed", 1);
	end,
	true
)