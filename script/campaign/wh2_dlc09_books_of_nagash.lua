books_of_nagash_max_count = 9

local books_collected = 0;
local books_collected_list = {};
local books_mission_regions = {};
local books_mission_characters = {};
local books_vfx_key = "scripted_effect3";
local non_participant_dilemma_key = "wh3_dlc29_book_of_nagash_acquired_not_book_faction_1"

local nagash_faction_key = "wh3_dlc29_nag_host_of_nagash"

local book_transfer_ritual_category = "BOOK_OF_NAGASH_TRANSFER"
local cult_of_sigmar_faction_key = "wh3_main_emp_cult_of_sigmar"
local arkhan_faction_key = "wh2_dlc09_tmb_followers_of_nagash"

book_objective_overrides = {
	["CAPTURE_REGIONS"] = "wh2_dlc09_objective_override_occupy_settlement",
	["ENGAGE_FORCE"] = "wh2_dlc09_objective_override_defeat_rogue_army"
};

local books_and_missions_prefix = "wh2_dlc09_books_of_nagash_"

local non_participant_book_owner_effect_bundles = {
	--[[ this table structure is an example
		["wh2_dlc09_books_of_nagash_1"] = "wh3_dlc29_books_of_nagash_owner_non_participant_1",
		["wh2_dlc09_books_of_nagash_2"] = "wh3_dlc29_books_of_nagash_owner_non_participant_2",
	]]
}

-- there is currently only one bundle being used for all rogue armies, but this would support if design wanted to have different ones for each book
local rogue_army_book_owner_effect_bundles = {
	--[[ this table structure is an example
		["wh2_dlc09_books_of_nagash_1"] = "wh2_dlc09_bundle_book_rogue_army",
		["wh2_dlc09_books_of_nagash_2"] = "wh2_dlc09_bundle_book_rogue_army",
	]]
}

local faction_to_book_effect_bundles_table = {
	--[[ this table structure is an example
		["wh3_dlc29_nag_host_of_nagash"] = {
			["wh2_dlc09_books_of_nagash_1"] = "wh3_dlc29_books_of_nagash_nagash_reward_1",
			["wh2_dlc09_books_of_nagash_2"] = "wh3_dlc29_books_of_nagash_nagash_reward_2",
			["wh2_dlc09_books_of_nagash_3"] = "wh3_dlc29_books_of_nagash_nagash_reward_3",
		},
		["wh2_dlc09_tmb_khemri"] = {
			["wh2_dlc09_books_of_nagash_1"] = "wh2_dlc09_books_of_nagash_reward_1",
			["wh2_dlc09_books_of_nagash_2"] = "wh2_dlc09_books_of_nagash_reward_2",
			["wh2_dlc09_books_of_nagash_3"] = "wh2_dlc09_books_of_nagash_reward_3",
		},
	]]
}

nagash_book_participant_cultures = {
	["wh2_dlc09_tmb_tomb_kings"] = true
}

nagash_book_participant_factions = {
	["wh_main_vmp_vampire_counts"] = true,
	["wh3_main_emp_cult_of_sigmar"] = true,
	["wh3_dlc29_nag_host_of_nagash"] = true
}

nagash_book_participant_factions_banned_from_transferring_to_own_armies = {
	["wh3_main_emp_cult_of_sigmar"] = true,
}

local books_cooldown_config = {
	min_turns_duration = 5,
	max_turns_duration = 10,
}

local rogue_army_faction_key = "wh2_main_rogue_the_wandering_dead"
local fallback_rogue_army_home_region = "wh3_main_combi_region_great_desert_of_araby"

-- the random offset we add to the position where the book was originally lost 
-- so that when we spawn the army holding it they are not right on top of that same position
-- offset_min can be negative
local books_rogue_army_respawn_lost_location_offset = {
	offset_min = -250,
	offset_max = 250,
}

local books_on_cooldown = {
	--[[ this table structure is an example
		[1] = {
			book_number = 2,
			cooldown_end_turn_number = 12,
			lost_position = {
				x = 510,
				y = 124,
			},
		},
		[2] = {
			book_number = 4,
			cooldown_end_turn_number = 16,
			lost_position = {
				x = 746,
				y = 215,
			},
		},
	]]
}

local non_book_faction_book_acquisition_outcomes = {
	{
		outcome = "lose_books",
		weight = 3,
	},
	{
		outcome = "store_in_capital",
		weight = 1,
	},
}

-- used to store which books are lost in a battle and where the battle was fought
-- for when a non-book player faction has to decide via dilemma what to do with them
-- since the dilemma gets triggered right after the battle we store data for and then this table is cleared there is no need for us to make it persistent
local pending_battle_location_and_books_lost_cache = {
	--[[ this table structure is an example
		books_lost = {
			[1] = 4,
			[2] = 6,
			[3] = 1,
		},
		battle_pos = {
			x = 510,
			y = 124,
		},
	]]
}

local book_details = {
	rogue_army_book_owner_effect_bundles = {},
	non_participant_book_owner_effect_bundles = {},
	participant_book_owner_effect_bundles = {},
}

function is_book_participant_faction(faction_interface)
	return nagash_book_participant_factions[faction_interface:name()] or nagash_book_participant_cultures[faction_interface:culture()]
end

function does_local_faction_have_access_to_books_of_nagash()
	return is_book_participant_faction(cm:get_local_faction(true))
end

function fail_books_of_nagash_mission_for_other_participant_factions(mission_key, completing_faction_key)
	completing_faction_key = completing_faction_key or ""
	local human_factions = cm:get_human_factions();

	for i = 1, #human_factions do
		local faction_name = human_factions[i]
		local faction = cm:get_faction(faction_name)
		if faction_name ~= completing_faction_key and is_book_participant_faction(faction) then
			cm:fail_custom_mission(faction_name, mission_key)
		end
	end
end

function initialise_books_of_nagash()
	out("#### Adding Books of Nagash Listeners ####");
	
	-- Sets lists for Immortal Empires
	book_objective_list = book_objective_list_grand;
	book_objective_list_faction = book_objective_list_faction_grand;

	populate_book_effect_bundle_tables()
	
	if cm:is_new_game() then
		local human_factions = cm:get_human_factions();
		local should_spawn = true
		local any_human_book_participant_factions = false
		
		for i = 1, #human_factions do
			local faction = cm:get_faction(human_factions[i])
			if is_book_participant_faction(faction) then
				setup_book_missions(human_factions[i], should_spawn, cm:is_multiplayer());

				should_spawn = false

				if nagash_book_participant_factions_banned_from_transferring_to_own_armies[human_factions[i]] then
					cm:set_script_state(faction, "banned_from_transferring_to_own_armies", true)
				end
				any_human_book_participant_factions = true
			end
		end

		if not any_human_book_participant_factions then
			initialise_books_on_map_with_no_book_faction()
		end
	end

	core:add_listener(
		"BookOwnerCompletedBattle",
		"BattleConflictFinished",
		true,
		function(context)
			local battle = context:pending_battle()

	 		-- ensure it's a finished battle with clear winners
	 		if not battle:has_been_fought() or
	 			not battle:has_attacker() or
	 			not battle:has_defender() or
	 			battle:is_draw() then
	 			return false
	 		end

			local region_key = ""
			local winner, loser
			local secondary_losers
			if battle:attacker_won() then 
				winner = battle:attacker()
				loser = battle:defender()
				secondary_losers = battle:secondary_defenders()
			else
				loser = battle:attacker()
				winner = battle:defender()
				secondary_losers = battle:secondary_attackers()
			end

			local is_siege_battle = battle:siege_battle()
			local settlement_holder_lost_battle = false
			if is_siege_battle then
				region_key = battle:region_data():key()
				settlement_holder_lost_battle = did_settlement_holder_lose_battle(region_key, loser:faction():name())
			end
			
			local loser_force_cqi = loser:military_force():command_queue_index()
			local loser_forces_owned_books = get_books_owned_by_target(loser_force_cqi)
			add_lost_books_from_secondary_loser_forces(loser_forces_owned_books, secondary_losers)
			local loser_region_owned_books = settlement_holder_lost_battle and get_books_owned_by_target(region_key) or {}

			-- if neither the losing force nor the setttlement have any books then nothing for us to do
			if table.is_empty(loser_forces_owned_books) and table.is_empty(loser_region_owned_books) then
				return
			end

			local force_eligible_to_take_books_cqi = winner:military_force():command_queue_index()

			-- if a force holding books loses a settlement battle we either give the books to an army that is stationed in the settlement or we toss them on cooldown
			if is_siege_battle and settlement_holder_lost_battle == false and table.is_empty(loser_forces_owned_books) == false then 
				local region_interface = cm:get_region(region_key)
				if region_interface and region_interface:is_null_interface() == false then
					local residence = region_interface:garrison_residence()
					local settlement_has_stationed_army = residence:has_army()
					local loser_army_wiped = was_loser_army_wiped(battle)

					-- if there is a stationed army it should already be stored in force_eligible_to_take_books_cqi
					-- if there is no stationed army then the main force on the settlement's side is the armed citizenry, which can not hold books.
					-- therefore if there are reinforcements then we give the books to the first reinforcing army
					local first_reinforcement_army_cqi = false
					if settlement_has_stationed_army == false then
						local num_defenders = cm:pending_battle_cache_num_defenders()
						if num_defenders > 1 then
							local char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_defender(2)
							first_reinforcement_army_cqi = mf_cqi
							force_eligible_to_take_books_cqi = mf_cqi
						end
					end

					if settlement_has_stationed_army == false and first_reinforcement_army_cqi == false then
						if not loser_army_wiped then
							-- if there is no stationed or reinforcing army to give the books to and the army holding the books didn't fully die then they don't lose any of them by design
							return
						end
						
						for i = 1, #loser_forces_owned_books do 	
							local book_number = loser_forces_owned_books[i]
							remove_book_from_current_owner(book_number)
							local battle_pos_x, battle_pos_y = battle:logical_position()
							local battle_pos = {
								x = battle_pos_x,
								y = battle_pos_y,
							}
							set_book_on_cooldown(book_number, battle_pos)
						end
						return
					end
				end
			end

			local potential_new_owner_force_interface = cm:get_military_force_by_cqi(force_eligible_to_take_books_cqi)
			if not potential_new_owner_force_interface or potential_new_owner_force_interface:is_null_interface() then
				script_error("ERROR: Attempted to transfer Book of Nagash to force with cqi [" .. tostring(force_eligible_to_take_books_cqi) .. "] but the force could not be found");
				return
			end
		
			-- if the winner is a garrison army (meaning an army with a book attacked a settlement and lost or the garrison sallied out and attacked an army with a book)
			-- we want to give the book to the first reinforcing army, if there is any
			if potential_new_owner_force_interface:is_armed_citizenry() and potential_new_owner_force_interface:has_garrison_residence() then
				local num_attackers = cm:pending_battle_cache_num_attackers()
				if num_attackers > 1 then
					local char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_attacker(2)
					force_eligible_to_take_books_cqi = mf_cqi
				else
					-- if we have no reinforcing army give the book to the closest force from our faction
					local battle_pos_x, battle_pos_y = battle:logical_position()
					local closest_force_interface = cm:get_closest_military_force_from_faction(potential_new_owner_force_interface:faction():name(), battle_pos_x, battle_pos_y)
					if not closest_force_interface or closest_force_interface:is_null_interface() then
						-- if we have no other forces then we set the book(s) on cooldown
						local battle_pos = {
							x = battle_pos_x,
							y = battle_pos_y,
						}
						for i = 1, #loser_forces_owned_books do 	
							local book_number = loser_forces_owned_books[i]
							set_book_on_cooldown(book_number, battle_pos)
						end
					else
						force_eligible_to_take_books_cqi = closest_force_interface:command_queue_index()
					end
				end
			end

			local total_lost_books = get_all_lost_books(loser_forces_owned_books, loser_region_owned_books)
			for i = 1, #total_lost_books do 	
				local book_number = total_lost_books[i]
				remove_book_from_current_owner(book_number)
			end
			grant_owned_books_to_new_owner(total_lost_books, force_eligible_to_take_books_cqi)
		end,
		true
	);

		core:add_listener(
		"books_of_nagash_non_participant_dilemma",
		"DilemmaChoiceMadeEvent",
		function(context)
			return context:dilemma() == non_participant_dilemma_key
		end,
		function(context)
			local new_owner_faction_interface = context:faction()
			local new_owner_faction_key = new_owner_faction_interface:name()
			if table.is_empty(pending_battle_location_and_books_lost_cache) then
				script_error("ERROR: Triggered dilemma for books gained for faction [" .. tostring(new_owner_faction_key) .. "] but there is no data about the books lost in the battle")
				return
			end

			local choice_key = context:choice_key()
			if choice_key == "FIRST" then 
				--books go on cooldown
				for i = 1, #pending_battle_location_and_books_lost_cache.books_lost do 	
					local book_number = pending_battle_location_and_books_lost_cache.books_lost[i]
					set_book_on_cooldown(book_number, pending_battle_location_and_books_lost_cache.battle_pos)
				end
			elseif choice_key == "SECOND" then
				-- books go to capital
				-- this dilemma will trigger only if the faction has a home region, so this is guaranteed to be valid
				local home_region = context:faction():home_region()
				local home_region_key = home_region:name()
				for i = 1, #pending_battle_location_and_books_lost_cache.books_lost do 	
					local book_number = pending_battle_location_and_books_lost_cache.books_lost[i]
					local book_key = get_book_and_mission_key_for_index(book_number)
					trigger_recurring_book_mission_for_participant_factions(home_region_key, book_number, false)
					set_saved_value_and_script_state_for_book_owner(book_key, home_region_key)
					local book_bundle_for_faction = get_book_effect_bundle_for_faction(new_owner_faction_interface, book_key)
					cm:apply_effect_bundle_to_region(book_bundle_for_faction, home_region_key, 0)
				end
			end

			pending_battle_location_and_books_lost_cache = {}
		end,
		true
	)

	core:add_listener(
		"NagashBooks_MissionSucceeded",
		"MissionSucceeded",
		true,
		function(context)
			local mission_key = context:mission():mission_record_key();
			if string.find(mission_key, books_and_missions_prefix) then
				local faction = context:faction();
				local faction_name = faction:name();
				fail_books_of_nagash_mission_for_other_participant_factions(mission_key, faction_name);

				local mission_target = cm:get_saved_value(mission_key)
				local mission_string = string.split(mission_key, "_")
				local book_number = mission_string[#mission_string]

				-- if our mission target is a number it means it's an army cqi so our target is a force, if not then it means our target is a settlement
				local is_target_force = is_number(mission_target)
				trigger_recurring_book_mission_for_participant_factions(mission_target, book_number, is_target_force, faction_name)
			end
		end,
		true
	)

	-- book transfer rituals
	core:add_listener(
		"books_of_nagash_book_transfer_ritual",
		"RitualCompletedEvent",
		function(context)
			return context:ritual():ritual_category() == book_transfer_ritual_category
		end,
		function(context)
			local ritual = context:ritual()
			-- ritual keys have the structure "wh2_dlc09_books_of_nagash_6_transfer" so we need to take away the back part to get the book key
			local transferred_book_key = string.sub(ritual:ritual_key(), 0, -string.len("_transfer") - 1)
			local book_string_split = string.split(transferred_book_key, "_")
			local book_number = book_string_split[#book_string_split]
			
			remove_book_from_current_owner(book_number)

			local ritual_target = ritual:ritual_target()
			local new_book_owner_force_interface = ritual_target:get_target_force()

			if not new_book_owner_force_interface or new_book_owner_force_interface:is_null_interface() then
				script_error("ERROR: Attempted to transfer Book of Nagash to force but ritual [" .. tostring(ritual:ritual_key()) .. "] has no target force set");
				return
			end

			local new_owner_force_cqi = new_book_owner_force_interface:command_queue_index()
			local new_book_owner_faction = new_book_owner_force_interface:faction()
			if not new_book_owner_faction or new_book_owner_faction:is_null_interface() then
				script_error("ERROR: Attempted to transfer Book of Nagash to force with cqi [" .. tostring(new_owner_force_cqi) .. "] but the force has no owning faction");
				return
			end

			grant_book_to_new_book_participant_owner(book_number, new_book_owner_force_interface, new_book_owner_faction)
			deactivate_nagash_book_slot_if_unowned(book_number)

			local new_owner_faction_key = new_book_owner_faction:name()
			-- if the new owner is Volkmar's faction then the books go to his capital so the new mission target will be a settlement
			local is_new_target_force = new_owner_faction_key ~= cult_of_sigmar_faction_key
			-- since the book is changing hands we need to re-trigger the missions for everyone else excluding the faction that now holds this book
			fail_books_of_nagash_mission_for_other_participant_factions(get_book_and_mission_key_for_index(book_number), context:performing_faction():name())
			trigger_recurring_book_mission_for_participant_factions(new_owner_force_cqi, book_number, is_new_target_force, new_owner_faction_key)
		end,
		true
	)


	core:add_listener(
		"books_of_nagash_book_confederation",
		"FactionJoinsConfederation",
		function(context)
			local faction = context:confederation()
			return nagash_book_participant_factions[faction:name()] or nagash_book_participant_cultures[faction:culture()]
		end,
		function(context)
			update_number_of_books_owned_by_faction(context:confederation())
		end,
		true
	)
	
	core:add_listener(
		"NagashBooks_WorldStartRound",
		"WorldStartRound",
		true,
		function(context)
			for i = #books_on_cooldown, 1, -1 do
				if cm:turn_number() == books_on_cooldown[i].cooldown_end_turn_number then
					replace_book_on_map(books_on_cooldown[i])
					table.remove(books_on_cooldown, i)
				end
			end
		end,
		true
	)
	
	-- CAI behavior - opportunistic transfer of books to Nagash's force
	core:add_listener(
		"NagashBooks_CAIFactionTurnEnd",
		"FactionTurnEnd",
		function(context)
			return context:faction():name() == nagash_faction_key and not context:faction():is_human()
		end,
		function(context)
			local nag_faction = context:faction()
			local nag_char = nag_faction:faction_leader()
			local nag_force = nag_char:military_force()
			if not nag_char:has_military_force() then
				-- Ritual not possible if Nagash doesn't have a military force
				return 
			end
			for i = 1, books_of_nagash_max_count do
				local ritual_key = "wh2_dlc09_books_of_nagash_" .. i .. "_transfer"
				local modify_ritual_setup = cm:create_new_ritual_setup(nag_faction, ritual_key)
				if not modify_ritual_setup then
					script_error("ERROR: Failed to create ritual setup for ritual with key [" .. ritual_key .. "]");
					return
				end
				local campaign_book_cco = cco("CcoCampaignBookOfNagash", "wh2_dlc09_books_of_nagash_" .. i)
				local nagash_is_valid_target = campaign_book_cco:Call("GetForcesAvailableForBookTransfer.Any(CQI == " .. nag_force:command_queue_index() .. ")")
				local modify_ritual_target = modify_ritual_setup:target()
				if modify_ritual_target:is_force_valid_target(nag_force) and nagash_is_valid_target then
					modify_ritual_target:set_target_force(nag_force)
				end

				if modify_ritual_target:valid() then
					cm:perform_ritual_with_setup(modify_ritual_setup)
				end
			end
		end,
		true
	)

	-- if an army dies due to attrition or whatever reason other than battle and it is carrying some books we should make sure they aren't left in an undefined state
	core:add_listener(
		"NagashBooks_MilitaryForceDestroyed",
		"MilitaryForceDestroyed",
		true,
		function(context)
			local destroyed_force_interface = context:military_force()
			local destroyed_force_cqi = destroyed_force_interface:command_queue_index()
			local books_owned_by_force = get_books_owned_by_target(destroyed_force_cqi)
			if table.is_empty(books_owned_by_force) then
				return
			end

			local force_general = destroyed_force_interface:general_character()
			if not force_general or force_general:is_null_interface() then
				-- spawned/temporary forces (e.g. Shambling Horde) can be destroyed after the general is already gone
				local fallback_region = cm:get_region(fallback_rogue_army_home_region)
				if fallback_region and not fallback_region:is_null_interface() then
					set_books_on_cooldown_at_settlement_position(books_owned_by_force, fallback_region)
				else
					script_error("ERROR: Trying to remove a book from force with cqi " .. destroyed_force_cqi .. " but it has no general and fallback region [" .. tostring(fallback_rogue_army_home_region) .. "] could not be found")
				end
				return
			end

			set_books_on_cooldown_at_character_position(books_owned_by_force, force_general)
		end,
		true
	)

	core:add_listener(
		"NagashBooks_PreRegionFactionChangeEvent",
		"PreRegionFactionChangeEvent",
		function(context)
			local reason = context:reason()
			return reason == "abandoned" or reason == "abandoned to rebels"
		end,
		function(context)
			local region_interface = context:region()
			local books_owned_by_region = get_books_owned_by_target(region_interface:name())
			if table.is_empty(books_owned_by_region) then
				return
			end

			set_books_on_cooldown_at_settlement_position(books_owned_by_region, region_interface)
		end,
		true
	)

	core:add_listener(
		"NagashBooks_MissionCancelled",
		"MissionCancelled",
		true,
		function(context)
			local mission_key = context:mission():mission_record_key();
			if string.find(mission_key, books_and_missions_prefix) then
				local faction = context:faction()
				local faction_name = faction:name()
				local mission_target = cm:get_saved_value(mission_key)

				local is_target_force = is_number(mission_target)
				if is_target_force then
					remove_book_character_vfx(mission_key, faction_name)
				else
					remove_book_region_vfx(mission_key, faction_name)
				end
			end
		end,
		true
	)

	core:add_listener(
		"NagashBooks_FactionBecomesVassal",
		"FactionBecomesVassal",
		function(context)
			return is_book_participant_faction(context:vassal():master())
		end,
		function(context)
			local vassal_faction_interface = context:vassal()
			local master_faction_interface = vassal_faction_interface:master()
			local vassal_faction_key = vassal_faction_interface:name()
			local master_faction_leader_force = nil
			if master_faction_interface:has_faction_leader() and master_faction_interface:faction_leader():has_military_force() then
				master_faction_leader_force = master_faction_interface:faction_leader():military_force()
			end
			
			-- if a book faction vassalizes another faction the master gets any books the vassal owned
			-- we try to give them to the faction leader first, if they don't have a force then we give them to the army closest to the previous owner
			-- and as a last resort we set them on cooldown
			-- go through each book and get the ones the vassal owns
			local books_to_transfer_to_master_faction = get_books_to_transfer_to_master_faction(vassal_faction_key, master_faction_leader_force ~= nil)
			for i = 1, #books_to_transfer_to_master_faction do
				local book_info = books_to_transfer_to_master_faction[i]
				if master_faction_leader_force ~= nil then
					grant_book_to_new_book_participant_owner(book_info.book_number, master_faction_leader_force, master_faction_interface)
				else
					local closest_master_force_interface = cm:get_closest_military_force_from_faction(master_faction_interface:name(), book_info.last_owner_position.x, book_info.last_owner_position.y)
					if closest_master_force_interface and closest_master_force_interface:is_null_interface() == false then
						grant_book_to_new_book_participant_owner(book_info.book_number, closest_master_force_interface, master_faction_interface)
					else
						set_book_on_cooldown(book_info.book_number, book_info.last_owner_position)
					end
				end
			end
			
			if is_book_participant_faction(vassal_faction_interface) then
				update_number_of_books_owned_by_faction(vassal_faction_interface)
			end
		end,
		true
	)
end

function setup_rogue_army_diplomacy(rogue_faction_key)
	-- first disallow all factions from interacting with the rogue one
	cm:force_diplomacy("all", "faction:" .. rogue_faction_key, "all", false, false, true)

	local function allow_war_between_factions(faction_1_key, faction_2_key)
		cm:force_diplomacy("faction:" .. faction_1_key, "faction:" .. faction_2_key, "war", true, true, false)
	end

	-- now allow all human factions to be in war with the rogue army
	local human_faction_keys = cm:get_human_factions()
	for i = 1, #human_faction_keys do
		local human_faction_key = human_faction_keys[i]
		allow_war_between_factions(human_faction_key, rogue_faction_key)
	end

	-- also allow any book-related faction to be in war with the rogue army
	for faction_key, is_enabled in dpairs(nagash_book_participant_factions) do
		if is_enabled then
			-- only do this if it's not a human faction,
			-- as if it is - it's already been taken care of above
			local is_human_faction = table.contains(human_faction_keys, faction_key)
			if not is_human_faction then
				allow_war_between_factions(faction_key, rogue_faction_key)
			end
		end
	end

	-- also look through the book-related cultures and do the same
	for culture_key, is_enabled in dpairs(nagash_book_participant_cultures) do
		if is_enabled then
			local factions = cm:get_factions_by_culture(culture_key)
			for i = 1, #factions do
				local faction = factions[i]
				local faction_key = faction:name()
				
				-- again, only do this if it's not a human faction
				local is_human_faction = table.contains(human_faction_keys, faction_key)
				if not is_human_faction then
					allow_war_between_factions(faction_key, rogue_faction_key)
				end
			end
		end
	end
end

function setup_book_missions(faction_key, spawn_forces, is_mp)
	cm:disable_event_feed_events(true, "", "wh_event_subcategory_faction_missions_objectives", "");
	
	if not is_mp then
		-- Switch the books to specific locations for certain factions in singleplayer
		if book_objective_list_faction[faction_key] ~= nil then
			book_objective_list = book_objective_list_faction[faction_key];
		end
	end
	
	-- Create the book objectives
	local book_objective_count = #book_objective_list;
	
	for i = 1, book_objective_count do
		local mm = mission_manager:new(faction_key, books_and_missions_prefix .. i);
		
		local book_objective_number = cm:random_number(#book_objective_list);
		
		if is_mp then
			book_objective_number = i;
		end
		
		local book_objective = book_objective_list[book_objective_number];
		
		mm:add_new_objective(book_objective.objective);
		mm:set_mission_issuer("BOOK_NAGASH");
		
		if book_objective.objective == "CAPTURE_REGIONS" then
			mm:add_condition("region " .. book_objective.target);
			mm:add_condition("ignore_allies");
			
			books_mission_regions[books_and_missions_prefix .. i] = book_objective.target;
			set_saved_value_and_script_state_for_book_owner(books_and_missions_prefix .. i, book_objective.target)
			add_book_region_vfx(book_objective.target)
		elseif book_objective.objective == "ENGAGE_FORCE" then
			if spawn_forces then
				spawn_game_start_rogue_army_for_book(book_objective, i)
			end
			
			local faction_leader = cm:get_faction(book_objective.target):faction_leader()
			local force_cqi = faction_leader:military_force():command_queue_index();
			local leader_cqi = faction_leader:command_queue_index();
			mm:add_condition("cqi " .. force_cqi);
			mm:add_condition("requires_victory");

			books_mission_characters[books_and_missions_prefix .. i] = leader_cqi
			set_saved_value_and_script_state_for_book_owner(books_and_missions_prefix .. i, force_cqi)
			add_book_character_vfx(leader_cqi)
		end
		
		if book_objective_overrides[book_objective.objective] ~= nil then
			mm:add_condition("override_text mission_text_text_" .. book_objective_overrides[book_objective.objective]);
		end

		mm:add_payload("text_display dummy_blank")

		mm:set_should_whitelist(false);
		mm:trigger();
		
		if not is_mp then
			table.remove(book_objective_list, book_objective_number);
		end
	end
	
	-- Arkhan's book. Automatically succeeds for him
	local is_arkhan = (faction_key == arkhan_faction_key);
	local arkhan_faction = cm:get_faction(arkhan_faction_key)
	local ninth_book_key = get_book_and_mission_key_for_index(9)
	local mm2 = mission_manager:new(faction_key, ninth_book_key)
	mm2:set_mission_issuer("BOOK_NAGASH")
	local arkhan_force_cqi = arkhan_faction:faction_leader():military_force():command_queue_index()
	
	if is_arkhan then
		mm2:add_new_objective("SCRIPTED");
		mm2:add_condition("script_key arkhan_book_mission_" .. faction_key);
		mm2:add_condition("override_text mission_text_text_wh2_dlc09_objective_override_arkhan_book_owned");
	else
		mm2:add_new_objective("ENGAGE_FORCE");
		mm2:add_condition("cqi " .. arkhan_force_cqi);
		mm2:add_condition("requires_victory");
		mm2:add_condition("override_text mission_text_text_" .. book_objective_overrides["ENGAGE_FORCE"]);
	end
	
	mm2:add_payload("text_display dummy_blank");
	mm2:set_should_whitelist(false);
	mm2:trigger();
	
	set_saved_value_and_script_state_for_book_owner(ninth_book_key, arkhan_force_cqi)
	local ninth_book_bundle_for_faction = get_book_effect_bundle_for_faction(faction_key, ninth_book_key)
	cm:apply_effect_bundle_to_force(ninth_book_bundle_for_faction, arkhan_force_cqi, 0)

	if is_arkhan then
		cm:complete_scripted_mission_objective(faction_key, ninth_book_key, "arkhan_book_mission_" .. faction_key, is_arkhan);
	else
		local arkhan_faction_leader_cqi = arkhan_faction:faction_leader():command_queue_index()
		books_mission_characters[ninth_book_key] = arkhan_faction_leader_cqi
		add_book_character_vfx(arkhan_faction_leader_cqi)
	end
	cm:disable_event_feed_events(false, "", "wh_event_subcategory_faction_missions_objectives", "");
end

function remove_book_region_vfx(mission_key, faction_to_remove_from)
	if books_mission_regions[mission_key] == nil or does_local_faction_have_access_to_books_of_nagash() == false then
		return
	end

	faction_to_remove_from = faction_to_remove_from or nil
	local local_faction = cm:get_local_faction(true)
	if faction_to_remove_from and faction_to_remove_from ~= local_faction:name() then
		return
	end

	local region_key = books_mission_regions[mission_key]
	local region_interface = cm:model():world():region_manager():region_by_key(region_key)
	if region_interface and region_interface:is_null_interface() == false then
		local garrison_residence = region_interface:garrison_residence()
		if garrison_residence and garrison_residence:is_null_interface() == false then
			local garrison_residence_CQI = garrison_residence:command_queue_index()
			cm:remove_garrison_residence_vfx(garrison_residence_CQI, books_vfx_key)
		end
	end
end

function remove_book_character_vfx(mission_key, faction_to_remove_from)
	if books_mission_characters[mission_key] == nil or does_local_faction_have_access_to_books_of_nagash() == false then
		return
	end
	faction_to_remove_from = faction_to_remove_from or nil
	local local_faction = cm:get_local_faction(true)
	if faction_to_remove_from and faction_to_remove_from ~= local_faction:name() then
		return
	end

	local character_cqi = books_mission_characters[mission_key]
	cm:remove_character_vfx(character_cqi, books_vfx_key)
end

function trigger_recurring_book_mission_for_participant_factions(objective_target_lookup, book_number, target_is_millitary_force, exclude_faction)
	local human_factions = cm:get_human_factions()

	for i = 1, #human_factions do
		local faction_key = human_factions[i]
		local faction = cm:get_faction(faction_key)
		if faction_key ~= exclude_faction and is_book_participant_faction(faction) then
			cm:disable_event_feed_events(true, "", "wh_event_subcategory_faction_missions_objectives", "");
			
			local mm = mission_manager:new(faction_key, get_book_and_mission_key_for_index(book_number));

			mm:set_mission_issuer("BOOK_NAGASH");

			local book_key = get_book_and_mission_key_for_index(i)
			if target_is_millitary_force then 
				mm:add_new_objective("ENGAGE_FORCE");
				mm:add_condition("cqi " .. objective_target_lookup);
				mm:add_condition("requires_victory");
				mm:add_condition("override_text mission_text_text_" .. book_objective_overrides["ENGAGE_FORCE"]);

				local target_force_interface = cm:get_military_force_by_cqi(objective_target_lookup)
				if target_force_interface and target_force_interface:is_null_interface() == false then
					local general_interface = target_force_interface:general_character()
					if general_interface and general_interface:is_null_interface() == false then
						local general_cqi = general_interface:command_queue_index()
						books_mission_characters[book_key] = general_cqi
						add_book_character_vfx(general_cqi)
					end
				end
			else 
				mm:add_new_objective("CAPTURE_REGIONS");
				mm:add_condition("region " .. objective_target_lookup);
				mm:add_condition("override_text mission_text_text_" .. book_objective_overrides["CAPTURE_REGIONS"]);
				books_mission_regions[book_key] = objective_target_lookup
				add_book_region_vfx(objective_target_lookup)
			end
			
			mm:add_payload("text_display dummy_blank")

			mm:set_should_whitelist(false);
			mm:trigger();
			cm:disable_event_feed_events(false, "", "wh_event_subcategory_faction_missions_objectives", "");
		end
	end
end

function does_target_currently_own_any_books(possible_owner)	
	for i = 1, books_of_nagash_max_count do 
		local current_book_owner = cm:get_saved_value(books_and_missions_prefix .. i)

		if current_book_owner == possible_owner then
			return true
		end
	end
	return false
end

function get_books_owned_by_target(owner)
	local owned_books = {}

	for i = 1, books_of_nagash_max_count do 
		local current_book_owner = cm:get_saved_value(books_and_missions_prefix .. i)

		if current_book_owner == owner then
			table.insert(owned_books, i)
		end
	end

	return owned_books
end

function populate_book_effect_bundle_tables()
	-- populate table for participant factions first
	local book_effect_bundles = cco("CcoCampaignRoot", ""):Call("DatabaseRecords(\"CcoBooksOfNagashFactionEffectBundleJunctionRecord\")")
	for i = 1, #book_effect_bundles do
		local slot_record = book_effect_bundles[i]
		local faction_key = slot_record:Call("FactionKey")
		local book_key = slot_record:Call("BookKey")
		local effect_bundle_key = slot_record:Call("EffectBundleKey")

		if faction_to_book_effect_bundles_table[faction_key] == nil then
			faction_to_book_effect_bundles_table[faction_key] = {}
		end

		local faction_book_bundle_data = faction_to_book_effect_bundles_table[faction_key]
		faction_book_bundle_data[book_key] = effect_bundle_key
	end

	-- populate non-participant and rogue army bundle tables
	local books_list = cco("CcoCampaignRoot", ""):Call("DatabaseRecords(\"CcoBooksOfNagashDetailsRecord\")")
	for i = 1, #books_list do
		local slot_record = books_list[i]
		local book_key = slot_record:Call("Key")
		local non_participant_effect_bundle = slot_record:Call("NonParticipantFactionEffectBundle")
		local rogue_army_effect_bundle = slot_record:Call("RogueArmyFactionEffectBundle")

		non_participant_book_owner_effect_bundles[book_key] = non_participant_effect_bundle:Call("Key")
		rogue_army_book_owner_effect_bundles[book_key] = rogue_army_effect_bundle:Call("Key")
	end
end

function get_book_effect_bundle_for_faction(faction_interface_or_key, book_key)
	local faction_interface = nil
	if is_string(faction_interface_or_key) then
		faction_interface = cm:get_faction(faction_interface_or_key)
	else
		faction_interface = faction_interface_or_key
	end

	if not faction_interface or faction_interface:is_null_interface() then
		script_error("ERROR: Attempted to get an effect bundle for a Book of Nagash for a faction that doesn't exist")
		return
	end

	local faction_key = is_string(faction_interface_or_key) and faction_interface_or_key or faction_interface:name()

	if faction_interface:is_rogue_faction() then
		return rogue_army_book_owner_effect_bundles[book_key]
	elseif not is_book_participant_faction(faction_interface) then
		return non_participant_book_owner_effect_bundles[book_key]
	else
		local faction_book_bundle_data = faction_to_book_effect_bundles_table[faction_key]
		if faction_book_bundle_data then
			return faction_book_bundle_data[book_key]
		end
	end

	script_error("ERROR: Attempted to get an effect bundle for a Book of Nagash for faction [" .. faction_key .. "] but found no suitable bundle")
	return nil
end

function grant_book_to_new_book_participant_owner(book_number, new_owner_force_interface, new_owner_faction_interface)
	local new_owner_is_human = new_owner_faction_interface:is_human()
	local new_owner_faction_key = new_owner_faction_interface:name()
	local new_owner = nil
	local book_key = get_book_and_mission_key_for_index(book_number)
	local book_bundle_for_faction = get_book_effect_bundle_for_faction(new_owner_faction_interface, book_key)
	-- we don't apply any effect bundles to the book factions here because they are granted to them via completing the mission for the corresponding book
	if new_owner_faction_key == cult_of_sigmar_faction_key then
		local home_region = new_owner_faction_interface:home_region()
		if home_region and not home_region:is_null_interface() then 
			local region_key = home_region:name()
			set_saved_value_and_script_state_for_book_owner(book_key, region_key)
			new_owner = region_key
			cm:apply_effect_bundle_to_region(book_bundle_for_faction, region_key, 0)
		else
			-- if somehow Volkmar doesn't have a capital he has bigger issues
			local battle_pos_x,battle_pos_y = cm:model():pending_battle():logical_position()
			local battle_pos = {
				x = battle_pos_x,
				y = battle_pos_y,
			}
			set_book_on_cooldown(book_number, battle_pos)
			return
		end
	else
		local new_owner_force_cqi = new_owner_force_interface:command_queue_index()
		set_saved_value_and_script_state_for_book_owner(book_key, new_owner_force_cqi)
		new_owner = new_owner_force_cqi
		cm:apply_effect_bundle_to_force(book_bundle_for_faction, new_owner_force_cqi, 0)
	end

	if new_owner_is_human == false and new_owner ~= nil then
		local is_target_force = is_number(new_owner)
		trigger_recurring_book_mission_for_participant_factions(new_owner, book_number, is_target_force)
	end

	update_number_of_books_owned_by_faction(new_owner_faction_interface)
end

function grant_owned_books_to_new_owner(owned_books, new_owner_force_cqi)
	local new_owner_force_interface = cm:get_military_force_by_cqi(new_owner_force_cqi)
	if not new_owner_force_interface or new_owner_force_interface:is_null_interface() then
		script_error("ERROR: Attempted to transfer Book of Nagash to force with cqi [" .. tostring(new_owner_force_cqi) .. "] but the force could not be found");
		return
	end

	local new_owner_faction_interface = new_owner_force_interface:faction()
	if not new_owner_faction_interface or new_owner_faction_interface:is_null_interface() then
		script_error("ERROR: Attempted to transfer Book of Nagash to force with cqi [" .. tostring(new_owner_force_cqi) .. "] but the force has no owning faction");
		return
	end

	local new_owner_faction_key = new_owner_faction_interface:name()
	if is_book_participant_faction(new_owner_faction_interface) then
		for i = 1, #owned_books do 	
			local book_number = owned_books[i]
			grant_book_to_new_book_participant_owner(book_number, new_owner_force_interface, new_owner_faction_interface)
		end
	else
		local battle_pos_x, battle_pos_y = cm:model():pending_battle():logical_position()
		local battle_pos = {
			x = battle_pos_x,
			y = battle_pos_y,
		}
		local new_owner_has_home_region = new_owner_faction_interface:has_home_region()

		if new_owner_faction_interface:is_human() then
			if not new_owner_has_home_region then
				for i = 1, #owned_books do
					set_book_on_cooldown(owned_books[i], battle_pos)
				end
				-- TODO: trigger an incident to tell players the books went on cooldown cause they have no settlements
			else
				pending_battle_location_and_books_lost_cache.books_lost = owned_books
				pending_battle_location_and_books_lost_cache.battle_pos = battle_pos
				cm:trigger_dilemma(new_owner_faction_key, non_participant_dilemma_key)
			end
		else
			local chosen_outcome, outcome_index
			if new_owner_has_home_region then
				local book_outcomes = weighted_list:new()
				for i = 1, #non_book_faction_book_acquisition_outcomes do
					local possible_outcome = non_book_faction_book_acquisition_outcomes[i]
					book_outcomes:add_item(possible_outcome.outcome, possible_outcome.weight)
				end
				chosen_outcome, outcome_index = book_outcomes:weighted_select()
			end

			for i = 1, #owned_books do 	
				local book_number = owned_books[i]
				local book_key = get_book_and_mission_key_for_index(book_number)
				fail_books_of_nagash_mission_for_other_participant_factions(book_key, new_owner_faction_key)
				
				if new_owner_has_home_region == false or chosen_outcome == "lose_books" then
					set_book_on_cooldown(book_number, battle_pos)
				elseif chosen_outcome == "store_in_capital" then
					local home_region = new_owner_faction_interface:home_region()
					local home_region_key = home_region:name()
					local book_bundle_for_faction = get_book_effect_bundle_for_faction(new_owner_faction_interface, book_key)
					cm:apply_effect_bundle_to_region(book_bundle_for_faction, home_region_key, 0)
					set_saved_value_and_script_state_for_book_owner(book_key, home_region_key)
					trigger_recurring_book_mission_for_participant_factions(home_region_key, book_number, false)
				end
			end
		end
	end

	for i = 1, #owned_books do
		deactivate_nagash_book_slot_if_unowned(owned_books[i])
	end
end

function remove_book_from_current_owner(book_number)
	local book_key = get_book_and_mission_key_for_index(book_number)
	local current_book_owner = cm:get_saved_value(book_key)
	-- if there is no saved value for this book then it is on cooldown aka not present on the map
	if not current_book_owner then
		return
	end

	local current_owning_faction_interface
	local current_owning_faction_key
	if is_number(current_book_owner) then
		local force_owner_interface = cm:get_military_force_by_cqi(current_book_owner)
		if not force_owner_interface or force_owner_interface:is_null_interface() then
			script_error("ERROR: Attempted to remove Book of Nagash from owner but found no force with cqi [" .. tostring(current_book_owner) .. "]");
			return
		end

		local owning_faction_interface = force_owner_interface:faction()
		if not owning_faction_interface or owning_faction_interface:is_null_interface() then
			script_error("ERROR: Attempted to remove Book of Nagash from owner but force with cqi [" .. tostring(current_book_owner) .. "] has no owning faction");
			return
		end
		
		current_owning_faction_interface = owning_faction_interface
		current_owning_faction_key = owning_faction_interface:name()
		local book_bundle_for_faction = get_book_effect_bundle_for_faction(current_owning_faction_interface, book_key)
		cm:remove_effect_bundle_from_force(book_bundle_for_faction, current_book_owner)
		remove_book_character_vfx(book_key)
		books_mission_characters[book_key] = nil
	else
		local region_owner_interface = cm:get_region(current_book_owner)
		if not region_owner_interface or region_owner_interface:is_null_interface() then
			script_error("ERROR: Attempted to remove Book of Nagash from owner but found no region with key [" .. tostring(current_book_owner) .. "]");
			return
		end

		local owning_faction_interface = region_owner_interface:owning_faction()
		if not owning_faction_interface or owning_faction_interface:is_null_interface() then
			script_error("ERROR: Attempted to remove Book of Nagash from owner but region with key [" .. tostring(current_book_owner) .. "] has no owning faction");
			return
		end
		
		current_owning_faction_interface = owning_faction_interface
		current_owning_faction_key = owning_faction_interface:name()
		local book_bundle_for_faction = get_book_effect_bundle_for_faction(current_owning_faction_interface, book_key)
		cm:remove_effect_bundle_from_region(book_bundle_for_faction, current_book_owner)
		remove_book_region_vfx(book_key)
		books_mission_regions[book_key] = nil
	end
	
	if is_book_participant_faction(current_owning_faction_interface) then
		update_number_of_books_owned_by_faction(current_owning_faction_interface)
	end
	clear_saved_value_and_script_state_for_book_owner(book_key)
end

function is_book_held_by_human(book_number)
	local current_book_owner = cm:get_saved_value(get_book_and_mission_key_for_index(book_number))
	-- if there is no saved value for this book then it is on cooldown aka not present on the map
	if not current_book_owner then
		return false
	end

	if is_number(current_book_owner) then
		local force_owner_interface = cm:get_military_force_by_cqi(current_book_owner)
		if not force_owner_interface or force_owner_interface:is_null_interface() then
			script_error("ERROR: Attempted to check Book of Nagash owner but found no force with cqi [" .. tostring(current_book_owner) .. "]");
			return false
		end

		local owning_faction_interface = force_owner_interface:faction()
		if not owning_faction_interface or owning_faction_interface:is_null_interface() then
			script_error("ERROR: Attempted to check Book of Nagash owner but force with cqi [" .. tostring(current_book_owner) .. "] has no owning faction");
			return false
		end
		
		local is_human = owning_faction_interface:is_human()
		return is_human
	else
		local region_owner_interface = cm:get_region(current_book_owner)
		if not region_owner_interface or region_owner_interface:is_null_interface() then
			script_error("ERROR: Attempted to check Book of Nagash owner but found no region with key [" .. tostring(current_book_owner) .. "]");
			return false
		end

		local owning_faction_interface = region_owner_interface:owning_faction()
		if not owning_faction_interface or owning_faction_interface:is_null_interface() then
			script_error("ERROR: Attempted to check Book of Nagash owner but region with key [" .. tostring(current_book_owner) .. "] has no owning faction");
			return
		end
		
		local is_human = owning_faction_interface:is_human()
		return is_human
	end
end

function get_count_of_books_owned_by_faction(faction_key)
	local count = 0

	for i = 1, books_of_nagash_max_count do 
		local current_book_owner = cm:get_saved_value(books_and_missions_prefix .. i)

		if current_book_owner ~= nil and is_string(current_book_owner) then
			local region = cm:get_region(current_book_owner)

			if region and region:is_null_interface() == false then
				local owner_key = region:owning_faction():name()
				
				if owner_key == faction_key then
					count = count + 1
				end
			end
		elseif current_book_owner ~= nil and is_number(current_book_owner) then
			local mf = cm:get_military_force_by_cqi(current_book_owner)

			if mf and mf:is_null_interface() == false then
				local owner_key = mf:faction():name()

				if owner_key == faction_key then
					count = count + 1
				end
			end
		end

	end

	return count
end

function update_number_of_books_owned_by_faction(faction_interface)
	-- delay required as some scenarios such as disbanding an army holding a book didn't update correctly within the same tick
	cm:callback(
		function()
			local faction_key = faction_interface:name()
			local books_of_nagash_count = get_count_of_books_owned_by_faction(faction_key)

			cm:set_saved_value("books_of_nagash_count_" .. faction_key, books_of_nagash_count)
			core:trigger_event("ScriptEventBookOfNagashUpdated", faction_interface, books_of_nagash_count)
		end,
		1
	)
end

function clear_saved_value_and_script_state_for_book_owner(book_key)
	-- CAI usage - clearing this script state so GDS tasks stop generating against this target
	local current_saved_value = cm:get_saved_value(book_key)
	if is_number(current_saved_value) then
		local force_interface = cm:get_military_force_by_cqi(current_saved_value)
		if force_interface and not force_interface:is_null_interface() then
			cm:remove_script_state(force_interface, "has_book_of_nagash")
		end
	elseif is_string(current_saved_value) then
		local region_interface = cm:get_region(current_saved_value)
		if region_interface and not region_interface:is_null_interface() then
			cm:remove_script_state(region_interface, "has_book_of_nagash")
		end
	end

	cm:remove_script_state(book_key)
	cm:clear_saved_value(book_key)
end

function set_saved_value_and_script_state_for_book_owner(book_key, new_owner)
	cm:set_saved_value(book_key, new_owner)
	if is_number(new_owner) then
		cm:set_script_state(book_key, "CcoCampaignMilitaryForce" .. new_owner)
		-- CAI usage - setting this script state allows GDS task generators to filter the list of all enemy forces down to the ones with books
		local force_interface = cm:get_military_force_by_cqi(new_owner)
		if force_interface and not force_interface:is_null_interface() then
			cm:set_script_state(force_interface, "has_book_of_nagash", true)		
		end
	else
		cm:set_script_state(book_key, "CcoCampaignSettlement" .. new_owner)
		-- CAI usage - setting this script state allows GDS task generators to filter the list of all enemy regions down to the ones with books
		local region_interface = cm:get_region(new_owner)
		if region_interface and not region_interface:is_null_interface() then
			cm:set_script_state(region_interface, "has_book_of_nagash", true)
		end
	end
end

function set_book_on_cooldown(book_number, book_lost_logical_position, cooldown_duration_override)
	cooldown_duration_override = cooldown_duration_override or nil
	local cooldown_duration = cooldown_duration_override or cm:random_number(books_cooldown_config.max_turns_duration, books_cooldown_config.min_turns_duration)
	local cooldown_end_turn = cm:turn_number() + cooldown_duration
	
	if not table.is_empty(book_lost_logical_position) then
		local book_on_cooldown_details = {
			book_number = book_number,
			cooldown_end_turn_number = cooldown_end_turn,
			lost_position = book_lost_logical_position,
		}
		table.insert(books_on_cooldown, book_on_cooldown_details)
	end

	local book_key = get_book_and_mission_key_for_index(book_number)
	clear_saved_value_and_script_state_for_book_owner(book_key)
	local cooldown_shared_state_key = book_key .. "_cooldown_end"
	cm:set_script_state(cooldown_shared_state_key, cooldown_end_turn)
	deactivate_nagash_book_slot_if_unowned(book_number)
	--TODO: potentially fire off an incident here
end

function get_rogue_army_starting_spawn_point_offset()
	local random_offset_x
	local random_offset_y
	local offset_min = books_rogue_army_respawn_lost_location_offset.offset_min
	local offset_max = books_rogue_army_respawn_lost_location_offset.offset_max
	if offset_min < 0 then
		random_offset_x = cm:random_number(offset_max - offset_min, 0) + offset_min
		random_offset_y = cm:random_number(offset_max - offset_min, 0) + offset_min
	else
		random_offset_x = cm:random_number(offset_max, offset_min)
		random_offset_y = cm:random_number(offset_max, offset_min)
	end

	return random_offset_x, random_offset_y
end

function get_rogue_army_valid_spawn_position(book_lost_position)
	local valid_spawn_pos_x = -1
	local valid_spawn_pos_y = -1
	local random_offset_x, random_offset_y = get_rogue_army_starting_spawn_point_offset()
	local book_spawn_position_x = book_lost_position.x + random_offset_x
	local book_spawn_position_y = book_lost_position.y + random_offset_y

	valid_spawn_pos_x, valid_spawn_pos_y = cm:find_valid_spawn_location_for_character_from_position(rogue_army_faction_key, book_spawn_position_x, book_spawn_position_y, false)
	if valid_spawn_pos_x == -1 or valid_spawn_pos_y == -1 then
		-- if we failed, try to just find a valid position nearest to where the book was lost
		valid_spawn_pos_x, valid_spawn_pos_y = cm:find_valid_spawn_location_for_character_from_position(rogue_army_faction_key, book_lost_position.x, book_lost_position.y, false)
		if valid_spawn_pos_x == -1 or valid_spawn_pos_y == -1 then
		-- if we've still failed, which really should not happen often at all, just spawn somewhere in the desert
			valid_spawn_pos_x, valid_spawn_pos_y = cm:find_valid_spawn_location_for_character_from_settlement(rogue_army_faction_key, fallback_rogue_army_home_region, false, false)
		end
	end

	return valid_spawn_pos_x, valid_spawn_pos_y
end

function replace_book_on_map(book_on_cooldown_details)
	-- parameters for the force that we'll spawn
	-- these should be moved to some sort of a config once the design has been fleshed out
	local force_size = cm:random_number(20, 12)
	local force_strength = cm:random_number(9, 4)

	local unit_list = WH_Random_Army_Generator:generate_random_army("books_of_nagash_force_" .. book_on_cooldown_details.book_number, "wh_main_sc_vmp_vampire_counts", force_size, force_strength, true, false)

	local valid_spawn_pos_x, valid_spawn_pos_y = get_rogue_army_valid_spawn_position(book_on_cooldown_details.lost_position)
	if valid_spawn_pos_x == -1 or valid_spawn_pos_y == -1 then
		script_error("ERROR: Attempted to spawn force with Book of Nagash but no valid position found")
		return
	end

	local region_at_pos = cm:model():get_region_at_logical_position(valid_spawn_pos_x, valid_spawn_pos_y)
	local home_region_key = ""
	if not region_at_pos or region_at_pos:is_null_interface() then
		home_region_key = fallback_rogue_army_home_region
	else
		home_region_key = region_at_pos:name()
	end

	local book_number = book_on_cooldown_details.book_number
	cm:create_force(
		rogue_army_faction_key,
		unit_list,
		home_region_key,
		valid_spawn_pos_x,
		valid_spawn_pos_y,
		false,
		function(cqi, created_force_cqi)
			local book_effect_bundle = get_book_effect_bundle_for_faction(rogue_army_faction_key, get_book_and_mission_key_for_index(book_number))
			cm:apply_effect_bundle_to_force(book_effect_bundle, created_force_cqi, 0)
			set_saved_value_and_script_state_for_book_owner(get_book_and_mission_key_for_index(book_number), created_force_cqi)
			trigger_recurring_book_mission_for_participant_factions(created_force_cqi, book_number, true)
		end
	)

	clear_shared_state_cooldown_for_book(book_number)
end

function did_settlement_holder_lose_battle(region_key, loser_faction_key)
	local region_interface = cm:get_region(region_key)
	if region_interface and region_interface:is_null_interface() == false then
		local owning_faction = region_interface:owning_faction()
		if owning_faction and owning_faction:is_null_interface() == false then
			return owning_faction:name() == loser_faction_key
		end
	end

	return false
end

function was_loser_army_wiped(pending_battle)
	local eps = 0.001
	if pending_battle:attacker_won() then
		local percentage_of_defender_killed = pending_battle:percentage_of_defender_killed()
		return math.abs(percentage_of_defender_killed - 1.0) < eps
	else
		local percentage_of_attacker_killed = pending_battle:percentage_of_attacker_killed()
		return math.abs(percentage_of_attacker_killed - 1.0) < eps
	end
end

function get_all_lost_books(force_owned_books, region_owned_books)
	table.append(force_owned_books, region_owned_books)
	return force_owned_books
end

-- used when a character dies to attrition or causes other than battle and is carrying books so they don't go into an undefined state
function set_books_on_cooldown_at_character_position(books_lost, character_interface)
	local character_pos_x = character_interface:logical_position_x()
	local character_pos_y = character_interface:logical_position_y()
	local character_pos = {
		x = character_pos_x,
		y = character_pos_y,
	}
		
	set_books_on_cooldown_at_position(books_lost, character_pos)
end

function set_books_on_cooldown_at_settlement_position(books_lost, region_interface)
	local settlement_interface = region_interface:settlement()
	if not settlement_interface or settlement_interface:is_null_interface() then
		return
	end

	local settlement_pos_x = settlement_interface:logical_position_x()
	local settlement_pos_y = settlement_interface:logical_position_y()
	local settlement_pos = {
		x = settlement_pos_x,
		y = settlement_pos_y,
	}

	set_books_on_cooldown_at_position(books_lost, settlement_pos)
end

function set_books_on_cooldown_at_position(books_lost, position)
	for i = 1, #books_lost do
		local book_number = books_lost[i]
		remove_book_from_current_owner(book_number)
		set_book_on_cooldown(book_number, position)
	end
end

function initialise_books_on_map_with_no_book_faction()
	local book_objective_count = #book_objective_list;
	
	for i = 1, book_objective_count do
		local book_objective_number = cm:random_number(#book_objective_list);
		local book_objective = book_objective_list[book_objective_number];
		
		if book_objective.objective == "CAPTURE_REGIONS" then					
			set_saved_value_and_script_state_for_book_owner(books_and_missions_prefix .. i, book_objective.target)
		elseif book_objective.objective == "ENGAGE_FORCE" then
			spawn_game_start_rogue_army_for_book(book_objective, i)

			local faction_leader = cm:get_faction(book_objective.target):faction_leader()
			local force_cqi = faction_leader:military_force():command_queue_index();
			set_saved_value_and_script_state_for_book_owner(books_and_missions_prefix .. i, force_cqi)
		end
		
		table.remove(book_objective_list, book_objective_number);
	end

	local arkhan_faction = cm:get_faction(arkhan_faction_key)
	local arkhan_force_cqi = arkhan_faction:faction_leader():military_force():command_queue_index()
	set_saved_value_and_script_state_for_book_owner("wh2_dlc09_books_of_nagash_9", arkhan_force_cqi)
end

function spawn_game_start_rogue_army_for_book(objective_details, book_number)
	cm:spawn_rogue_army(objective_details.target, objective_details.pos.x, objective_details.pos.y);
	setup_rogue_army_diplomacy(objective_details.target)
	
	if objective_details.patrol ~= nil then
		out("Setting Books of Nagash rogue army patrol path for " .. objective_details.target);
		local im = invasion_manager;
		local rogue_force = cm:get_faction(objective_details.target):faction_leader():military_force();
		local book_patrol = im:new_invasion_from_existing_force("BOOK_PATROL_" .. objective_details.target, rogue_force);
		book_patrol:set_target("PATROL", objective_details.patrol);
		local book_effect_bundle = get_book_effect_bundle_for_faction(objective_details.target, get_book_and_mission_key_for_index(book_number))
		book_patrol:apply_effect(book_effect_bundle, -1);
		book_patrol:start_invasion();
	end
end

function clear_cooldown_for_book(book_number)
	for i = #books_on_cooldown, 1, -1 do
		if books_on_cooldown[i].book_number == book_number then
			table.remove(books_on_cooldown, i)
		end
	end
	
	clear_shared_state_cooldown_for_book(book_number)
end

function clear_shared_state_cooldown_for_book(book_number)
	local cooldown_shared_state_key = get_book_and_mission_key_for_index(book_number) .. "_cooldown_end"
	cm:remove_script_state(cooldown_shared_state_key)
end

function get_book_and_mission_key_for_index(book_number)
	return books_and_missions_prefix .. book_number
end

function add_book_region_vfx(target_region_key)
	if does_local_faction_have_access_to_books_of_nagash() == false then
		return
	end

	local target_region_interface = cm:get_region(target_region_key)
	if target_region_interface and target_region_interface:is_null_interface() == false then
		local local_faction = cm:get_local_faction(true)
		local region_owning_faction = target_region_interface:owning_faction()
		if region_owning_faction and 
			region_owning_faction:is_null_interface() == false and 
			region_owning_faction:name() ~= local_faction:name()
		then
			local garrison_residence = target_region_interface:garrison_residence()
			if garrison_residence and garrison_residence:is_null_interface() == false then
				local garrison_residence_cqi = garrison_residence:command_queue_index()
				cm:add_garrison_residence_vfx(garrison_residence_cqi, books_vfx_key, true)
			end
		end
	end
end

function add_book_character_vfx(character_cqi)
	if does_local_faction_have_access_to_books_of_nagash() == false then
		return
	end

	local character_interface = cm:get_character_by_cqi(character_cqi)
	if character_interface and character_interface:is_null_interface() == false then
		local local_faction = cm:get_local_faction(true)
		local character_faction = character_interface:faction()
		if character_faction and
			character_faction:is_null_interface() == false and
			character_faction:name() ~= local_faction:name()
		then
			cm:add_character_vfx(character_cqi, books_vfx_key, true)
		end
	end
end

function add_lost_books_from_secondary_loser_forces(loser_forces_owned_books, secondary_losers)
	for i = 0, secondary_losers:num_items() - 1 do
		local loser = secondary_losers:item_at(i)
		local loser_mf = loser:military_force()

		local secondary_lost_books = get_books_owned_by_target(loser_mf:command_queue_index())
		table.append(loser_forces_owned_books, secondary_lost_books)
	end
end

function does_nagash_currently_hold_book(book_number)
	local current_book_owner = cm:get_saved_value(get_book_and_mission_key_for_index(book_number))
	if not is_number(current_book_owner) then
		return false
	end

	local force_owner_interface = cm:get_military_force_by_cqi(current_book_owner)
	if not force_owner_interface or force_owner_interface:is_null_interface() then
		return false
	end

	local owning_faction_interface = force_owner_interface:faction()
	return owning_faction_interface and not owning_faction_interface:is_null_interface() and owning_faction_interface:name() == nagash_faction_key
end

-- Book spell slots are faction initiatives whose capacity comes from the army/region book bundle.
-- Capacity drops as soon as that bundle is removed, but INITIATIVE_SET only deactivates overflow at start of turn.
-- Call this after ownership has fully settled so same-faction transfers keep the slotted spell.
function deactivate_nagash_book_slot_if_unowned(book_number)
	if does_nagash_currently_hold_book(book_number) then
		return
	end

	local nagash_faction = cm:get_faction(nagash_faction_key)
	if not nagash_faction or nagash_faction:is_null_interface() then
		return
	end

	local initiative_set = nagash_faction:lookup_faction_initiative_set_by_key("wh3_dlc29_book_of_nagash_slot_" .. tostring(book_number))
	if not initiative_set or initiative_set:is_null_interface() then
		return
	end

	local active_initiatives = initiative_set:active_initiatives()
	local keys_to_deactivate = {}
	for i = 0, active_initiatives:num_items() - 1 do
		table.insert(keys_to_deactivate, active_initiatives:item_at(i):record_key())
	end

	for _, initiative_key in ipairs(keys_to_deactivate) do
		cm:toggle_initiative_active(initiative_set, initiative_key, false)
	end
end

function get_books_to_transfer_to_master_faction(vassal_faction_key, master_faction_leader_has_force)
	local books_to_transfer = {}
	for i = 1, books_of_nagash_max_count do 
		local current_book_owner = cm:get_saved_value(books_and_missions_prefix .. i)
		if current_book_owner ~= nil and is_string(current_book_owner) then
			local region = cm:get_region(current_book_owner)
			if region and region:is_null_interface() == false then
				local owner_key = region:owning_faction():name()
				if owner_key == vassal_faction_key then
					local book_info = {
						book_number = i,
						last_owner_position = {}
					}
					if master_faction_leader_has_force == false then
						-- if it's in a region and we have no faction leader force we get the settlement's location 
						local settlement_interface = region:settlement()
						if settlement_interface and settlement_interface:is_null_interface() == false then
							book_info.last_owner_position = {
								x = settlement_interface:logical_position_x(),
								y = settlement_interface:logical_position_y(),
							}
						end
					end
					table.insert(books_to_transfer, book_info)
				end
			end
		elseif current_book_owner ~= nil and is_number(current_book_owner) then
			local mf = cm:get_military_force_by_cqi(current_book_owner)
			if mf and mf:is_null_interface() == false then
				local owner_key = mf:faction():name()
				if owner_key == vassal_faction_key then
					local book_info = {
						book_number = i,
						last_owner_position = {}
					}
					if master_faction_leader_has_force == false then
						-- if it's in a force and we have no faction leader force we get the force general's location
						local force_general = mf:general_character()
						if force_general and force_general:is_null_interface() == false then
							book_info.last_owner_position = {
								x = force_general:logical_position_x(),
								y = force_general:logical_position_y(),
							}
						end
					end
					table.insert(books_to_transfer, book_info)
				end
			end
		end
	end

	return books_to_transfer
end
--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("books_collected", books_collected, context);
		cm:save_named_value("books_collected_list", books_collected_list, context);
		cm:save_named_value("books_mission_regions", books_mission_regions, context);
		cm:save_named_value("books_mission_characters", books_mission_characters, context);
		cm:save_named_value("books_on_cooldown", books_on_cooldown, context)
	end
);

cm:add_loading_game_callback(
	function(context)
		books_collected = cm:load_named_value("books_collected", 0, context);
		books_collected_list = cm:load_named_value("books_collected_list", books_collected_list, context);
		books_mission_regions = cm:load_named_value("books_mission_regions", books_mission_regions, context);
		books_mission_characters = cm:load_named_value("books_mission_characters", books_mission_characters, context);
		books_on_cooldown = cm:load_named_value("books_on_cooldown", books_on_cooldown, context)
	end
);
