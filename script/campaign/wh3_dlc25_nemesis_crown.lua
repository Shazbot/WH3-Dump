--Saves CQI of Crown oner, Keeps track of how many battles to upgrade, turns left to fight and crown level
nemesis_crown = {
	
	crown_data = {
		owner_faction_key = nil,
		owner_fm_cqi = nil,
		battles_to_advance = 4,
		turns_to_fight = 7,
		current_level = 1,
		min_level = 1,
		max_level = 5,

		spawn_min_turn = 25,
		spawn_cooldown = 20,
		has_spawned = false,
		holder_is_human = false,
		battles_timer = 8,

		crown_first_spawn = true,
		--list of factions the crown event has triggered for
		crown_marker_factions_spawned_for = {},
		crown_marker_key_counter = 1,
	},

	cultures = {
		"wh_main_brt_bretonnia",
		"wh3_main_cth_cathay",
		"wh3_main_ksl_kislev",
		"wh2_main_lzd_lizardmen",
		"wh_main_emp_empire",
		"wh_dlc05_wef_wood_elves"
	},

	--used to apply the correct effect bundle to each subculture
	subculture_bundle_suffixes = {
		["wh_dlc03_sc_bst_beastmen"] 		=  "_bst",
		["wh_main_sc_brt_bretonnia"] 		=  "_brt",
		["wh3_dlc23_sc_chd_chaos_dwarfs"] 	=  "_chd",
		["wh3_main_sc_dae_daemons"] 		=  "_dae",
		["wh2_main_sc_def_dark_elves"] 		=  "_def",
		["wh_main_sc_dwf_dwarfs"] 			=  "_dwf",
		["wh3_main_sc_cth_cathay"] 			=  "_cth",
		["wh_main_sc_grn_greenskins"] 		=  "_grn",
		["wh2_main_sc_hef_high_elves"] 		=  "_hef",
		["wh3_main_sc_kho_khorne"] 			=  "_kho",
		["wh3_main_sc_ksl_kislev"] 			=  "_ksl",
		["wh2_main_sc_lzd_lizardmen"] 		=  "_lzd",
		["wh_dlc08_sc_nor_norsca"] 			=  "_nor",
		["wh3_main_sc_nur_nurgle"] 			=  "_nur",
		["wh3_main_sc_ogr_ogre_kingdoms"] 	=  "_ogr",
		["wh2_main_sc_skv_skaven"] 			=  "_skv",
		["wh3_main_sc_sla_slaanesh"]		=  "_sla",
		["wh_main_sc_emp_empire"] 			=  "_emp",
		["wh2_dlc09_sc_tmb_tomb_kings"] 	=  "_tmb",
		["wh3_main_sc_tze_tzeentch"] 		=  "_tze",
		["wh2_dlc11_sc_cst_vampire_coast"] 	=  "_cst",
		["wh_main_sc_vmp_vampire_counts"] 	=  "_vmp",
		["wh_main_sc_chs_chaos"] 			=  "_chs",
		["wh_dlc05_sc_wef_wood_elves"] 		=  "_wef",
	},
	faction_bundle_suffixes = {
		["wh3_dlc27_sla_the_tormentors"] 	=  "_dechala",
	},
	
	--spawn locations table follows this makeup{theatre, region_key, hint, x, y}
	spawn_locations = {
		--EMPIRE locations
		{location = "EMPIRE",  		region_key =  "wh3_main_combi_region_carroburg", 					incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_empire_river", 			coords ={x = 542, y = 661}},
		{location = "EMPIRE",  		region_key =  "wh3_main_combi_region_weismund", 					incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_empire_forest", 			coords ={x = 500, y = 694}},
		{location = "EMPIRE",  		region_key =  "wh3_main_combi_region_middenheim", 					incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_empire_landmark", 		coords ={x = 534, y = 703}},
		{location = "EMPIRE",  		region_key =  "wh3_main_combi_region_aarnau", 						incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_empire_coast", 			coords ={x = 458, y = 714}},
		{location = "EMPIRE",  		region_key =  "wh3_main_combi_region_wreckers_point", 				incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_empire_forest", 			coords ={x = 497, y = 736}},
		{location = "EMPIRE",  		region_key =  "wh3_main_combi_region_salzenmund", 					incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_empire_river", 			coords ={x = 565, y = 744}},
		{location = "EMPIRE",  		region_key =  "wh3_main_combi_region_dietershafen", 				incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_empire_coast", 			coords ={x = 505, y = 753}},
		{location = "EMPIRE",  		region_key =  "wh3_main_combi_region_laurelorn_forest", 			incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_empire_forest", 			coords ={x = 525, y = 719}},
		{location = "EMPIRE",  		region_key =  "wh3_main_combi_region_norden", 						incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_empire_mountain", 		coords ={x = 584, y = 751}},
		{location = "EMPIRE",  		region_key =  "wh3_main_combi_region_hergig", 						incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_empire_mountain", 		coords ={x = 598, y = 720}},
		{location = "EMPIRE",  		region_key =  "wh3_main_combi_region_gryphon_wood", 				incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_empire_forest", 			coords ={x = 661, y = 681}},
		{location = "EMPIRE",  		region_key =  "wh3_main_combi_region_bechafen", 					incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_empire_river", 			coords ={x = 703, y = 694}},
		{location = "EMPIRE",  		region_key =  "wh3_main_combi_region_mordheim", 					incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_empire_river", 			coords ={x = 674, y = 646}},
		{location = "EMPIRE",  		region_key =  "wh3_main_combi_region_talabheim", 					incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_empire_forest", 			coords ={x = 629, y = 666}},
		{location = "EMPIRE",  		region_key =  "wh3_main_combi_region_kemperbad",					incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_empire_landmark", 		coords ={x = 554, y = 645}},
		{location = "EMPIRE",  		region_key =  "wh3_main_combi_region_niedling", 					incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_empire_landmark", 		coords ={x = 639, y = 642}},
		{location = "EMPIRE",  		region_key =  "wh3_main_combi_region_flensburg", 					incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_empire_river", 			coords ={x = 573, y = 605}},
		{location = "EMPIRE",  		region_key =  "wh3_main_combi_region_grenzstadt",					incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_empire_mountain", 		coords ={x = 661, y = 572}},
		{location = "EMPIRE",  		region_key =  "wh3_main_combi_region_pfeildorf", 					incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_empire_mountain", 		coords ={x = 586, y = 555}},
		{location = "EMPIRE",  		region_key =  "wh3_main_combi_region_wissenburg", 					incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_empire_mountain", 		coords ={x = 563, y = 567}},
		{location = "EMPIRE",  		region_key =  "wh3_main_combi_region_grunburg", 					incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_empire_forest", 			coords ={x = 530, y = 619}},
		{location = "EMPIRE", 		region_key =  "wh3_main_combi_region_eilhart", 						incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_empire_river", 			coords ={x = 496, y = 645}},
		{location = "EMPIRE",  		region_key =  "wh3_main_combi_region_waldenhof", 					incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_empire_landmark", 		coords ={x = 702, y = 646}},
		{location = "EMPIRE",  		region_key =  "wh3_main_combi_region_swartzhafen", 					incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_empire_mountain", 		coords ={x = 684, y = 596}},
		--LUSTRIA locations
		{location = "LUSTRIA",  	region_key =  "wh3_main_combi_region_tlax", 						incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_lustria_skeleton", 		coords ={x = 251, y = 272}},
		{location = "LUSTRIA",  	region_key =  "wh3_main_combi_region_xahutec", 						incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_lustria_skeleton", 		coords ={x = 221, y = 297}},
		{location = "LUSTRIA",  	region_key =  "wh3_main_combi_region_tlanxla", 						incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_lustria_skeleton", 		coords ={x = 108, y = 334}},
		{location = "LUSTRIA",  	region_key =  "wh3_main_combi_region_temple_of_kara", 				incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_lustria_coast", 			coords ={x = 129, y = 378}},
		{location = "LUSTRIA",  	region_key =  "wh3_main_combi_region_the_blood_hall", 				incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_lustria_coast", 			coords ={x = 25,  y = 343}},
		{location = "LUSTRIA",  	region_key =  "wh3_main_combi_region_xlanzec", 						incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_lustria_coast", 			coords ={x = 256, y = 100}},
		{location = "LUSTRIA",  	region_key =  "wh3_main_combi_region_shrine_of_sotek", 				incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_lustria_coast", 			coords ={x = 64,  y = 341}},
		{location = "LUSTRIA",  	region_key =  "wh3_main_combi_region_tlanxla", 						incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_lustria_river", 			coords ={x = 141, y = 342}},
		{location = "LUSTRIA",  	region_key =  "wh3_main_combi_region_itza", 						incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_lustria_river", 			coords ={x = 188, y = 233}},
		{location = "LUSTRIA",  	region_key =  "wh3_main_combi_region_chupayotl", 					incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_lustria_river", 			coords ={x = 231, y = 170}},
		{location = "LUSTRIA",  	region_key =  "wh3_main_combi_region_subatuun", 					incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_lustria_mountain", 		coords ={x = 155, y = 197}},
		{location = "LUSTRIA",  	region_key =  "wh3_main_combi_region_mine_of_the_bearded_skulls",	incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_lustria_mountain", 		coords ={x = 112, y = 206}},
		{location = "LUSTRIA",  	region_key =  "wh3_main_combi_region_chamber_of_visions", 			incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_lustria_mountain", 		coords ={x = 85,  y = 263}},
		--CATHAY locations
		{location = "CATHAY",  		region_key =  "wh3_main_combi_region_nan_li", 						incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_cathay_sentinel", 		coords ={x = 1140, y = 637}},
		{location = "CATHAY",  		region_key =  "wh3_main_combi_region_wei_jin", 						incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_cathay_sentinel", 		coords ={x = 1259, y = 644}},
		{location = "CATHAY",  		region_key =  "wh3_main_combi_region_shang_yang", 					incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_cathay_sentinel", 		coords ={x = 1106, y = 568}},
		{location = "CATHAY",  		region_key =  "wh3_main_combi_region_qiang", 						incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_cathay_sentinel", 		coords ={x = 1109, y = 454}},
		{location = "CATHAY",  		region_key =  "wh3_main_combi_region_shang_wu", 					incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_cathay_river", 			coords ={x = 1180, y = 476}},
		{location = "CATHAY",  		region_key =  "wh3_main_combi_region_fu_chow", 						incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_cathay_river", 			coords ={x = 1326, y = 509}},
		{location = "CATHAY",  		region_key =  "wh3_main_combi_region_nonchang", 					incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_cathay_river", 			coords ={x = 1230, y = 518}},
		{location = "CATHAY",  		region_key =  "wh3_main_combi_region_li_temple", 					incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_cathay_river", 			coords ={x = 1315, y = 417}},
		{location = "CATHAY",  		region_key =  "wh3_main_combi_region_bamboo_crossing",				incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_cathay_river", 			coords ={x = 1271, y = 415}},
		{location = "CATHAY",  		region_key =  "wh3_main_combi_region_haichai", 						incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_cathay_floating_island", 	coords ={x = 1327, y = 602}},
		{location = "CATHAY",  		region_key =  "wh3_main_combi_region_shi_wu", 						incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_cathay_floating_island", 	coords ={x = 1378, y = 428}},
		{location = "CATHAY",  		region_key =  "wh3_main_combi_region_baleful_hills", 				incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_cathay_floating_island", 	coords ={x = 1212, y = 538}},
		{location = "CATHAY",  		region_key =  "wh3_main_combi_region_temple_of_elemental_winds",	incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_cathay_floating_island", 	coords ={x = 1174, y = 440}},
		--SOUTHLANDS locations
		{location = "SOUTHLANDS",  	region_key =  "wh3_main_combi_region_great_desert_of_araby", 		incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_southlands_desert", 		coords ={x = 500, y = 252}},
		{location = "SOUTHLANDS",  	region_key =  "wh3_main_combi_region_black_tower_of_arkhan",		incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_southlands_desert", 		coords ={x = 554, y = 281}},
		{location = "SOUTHLANDS",  	region_key =  "wh3_main_combi_region_plain_of_tuskers", 			incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_southlands_desert", 		coords ={x = 575, y = 244}},
		{location = "SOUTHLANDS",  	region_key =  "wh3_main_combi_region_ka_sabar", 					incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_southlands_desert", 		coords ={x = 622, y = 232}},
		{location = "SOUTHLANDS", 	region_key =  "wh3_main_combi_region_numas", 						incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_southlands_desert", 		coords ={x = 677, y = 308}},
		{location = "SOUTHLANDS", 	region_key =  "wh3_main_combi_region_temple_of_skulls", 			incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_southlands_river", 		coords ={x = 803, y = 254}},
		{location = "SOUTHLANDS",  	region_key =  "wh3_main_combi_region_soteks_trail", 				incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_southlands_river", 		coords ={x = 722, y = 154}},
		{location = "SOUTHLANDS",  	region_key =  "wh3_main_combi_region_dawns_light", 					incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_southlands_river", 		coords ={x = 583, y =  87}},
		{location = "SOUTHLANDS",  	region_key =  "wh3_main_combi_region_yuatek", 						incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_southlands_river", 		coords ={x = 588, y = 112}},
		{location = "SOUTHLANDS",  	region_key =  "wh3_main_combi_region_cuexotl", 						incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_southlands_river", 		coords ={x = 618, y = 168}},
		{location = "SOUTHLANDS",  	region_key =  "wh3_main_combi_region_statues_of_the_gods", 			incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_southlands_river", 		coords ={x = 524, y = 182}},
		{location = "SOUTHLANDS",  	region_key =  "wh3_main_combi_region_mount_arachnos", 				incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_southlands_mountain", 	coords ={x = 731, y = 284}},
		{location = "SOUTHLANDS",  	region_key =  "wh3_main_combi_region_the_golden_tower", 			incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_southlands_mountain", 	coords ={x = 663, y = 200}},
		{location = "SOUTHLANDS",  	region_key =  "wh3_main_combi_region_temple_of_skulls", 			incident_key = "wh3_dlc25_incident_nemesis_crown_whispers_southlands_mountain", 	coords ={x = 753, y = 272}},

	},

	-- This is set up in the region group table in the database
	region_groups = {
		{"wh3_dlc25_nemesis_crown_empire_ie_regions", "wh3_dlc25_incident_nemesis_crown_whispers_empire"}, 
		{"wh3_dlc25_nemesis_crown_cathay_ie_regions", "wh3_dlc25_incident_nemesis_crown_whispers_cathay"}, 
		{"wh3_dlc25_nemesis_crown_lustria_ie_regions", "wh3_dlc25_incident_nemesis_crown_whispers_lustria"},
		{"wh3_dlc25_nemesis_crown_southlands_ie_regions", "wh3_dlc25_incident_nemesis_crown_whispers_southlands"}
	},

	--certain cultures have a chance to keep or seal
	ai_chance_to_keep = 50,

	effect_bundle_prefix = "wh3_dlc25_nemesis_crown_effect_bundle_",
	lost_event = "wh3_dlc25_incident_nemesis_crown_lost",
	dies_event = "wh3_dlc25_incident_nemesis_crown_owner_dies",
	sealed_event = "wh3_dlc25_incident_nemesis_crown_sealed",
	dilemma_claim_crown = "wh3_dlc25_the_fate_of_the_nemesis_crown",
	dilemma_level_up = "wh3_dlc25_nemesis_crown_level_up",
	changed_event = "wh3_dlc25_incident_nemesis_crown_taken",
	powered_up_event = "wh3_dlc25_incident_nemesis_crown_powered_up",
	claimed_ai = "wh3_dlc25_incident_nemesis_crown_found_ai",

	nemesis_crown_faction_key = "wh3_dlc25_rogue_da_mad_howlerz",
	
	vfx = {
		character = "scripted_effect28"
	}
}

-- Setup Listener
function nemesis_crown:initialise()
	--check to prevent it breaking old saves before nemesis crown faction was added
	if cm:get_faction(self.nemesis_crown_faction_key, false) then

		if cm:is_new_game() then
			cm:set_saved_value("current_crown_spawn_location", false)
		end

		local human_factions = cm:get_human_factions()		
		--Nemesis Crown script is valid for all characters in Immortal Empires
		--Do not run if there is no human players, safeguard for autoruns
		if #human_factions > 0 and cm:get_campaign_name() == "main_warhammer" then
			self:update_context_values()
			self:update_shared_state_values()			
			
			self:marker_and_battle_listeners(human_factions)
			self:script_event_listeners(human_factions)
			self:dev_command_listeners()
		end

		if self.crown_data.owner_fm_cqi then
			local character_cqi = cm:get_family_member_by_cqi(self.crown_data.owner_fm_cqi):character():command_queue_index()
			cm:add_character_vfx(character_cqi, self.vfx.character, true)
		end
	end
end

-- A function to reset the nemesis crown holder character cqi, its spawn state and inform everyone it is lost
function nemesis_crown:set_crown_lost(event_type)
	local human_factions = cm:get_human_factions()
	local crown = self.crown_data
	
	local previous_faction = crown.owner_faction_key
	local previous_owner = crown.owner_fm_cqi
	local previous_character = cm:get_family_member_by_cqi(previous_owner):character()
	
	crown.owner_faction_key = nil
	crown.owner_fm_cqi = nil
	crown.holder_is_human = false
	crown.has_spawned = false
	if crown.current_level > crown.min_level then
		crown.current_level = crown.current_level - 1
	end
	nemesis_crown.crown_data.crown_marker_factions_spawned_for = {}
	cm:set_saved_value("current_crown_spawn_location", false)
	cm:set_saved_value("NemesisCrown_LocationDiscovered", false)
	crown.spawn_min_turn = cm:turn_number() + crown.spawn_cooldown

	for i = 1, #human_factions do
		if previous_character:is_null_interface() == false then
			cm:trigger_incident_with_targets(cm:get_faction(human_factions[i]):command_queue_index(), event_type, cm:get_faction(previous_faction):command_queue_index(), 0, previous_character:command_queue_index(), 0, 0, 0)
		else
			cm:trigger_incident((human_factions[i]), event_type .. "_no_model", true)
		end
	end
	self:update_context_values()
	self:update_shared_state_values()
end

function nemesis_crown:get_closest_legendary_lord_from_position(x,y)
	local closest_distance = false
	local closest_character = false
	local faction_list = cm:model():world():faction_list()

	for i = 0,  faction_list:num_items() - 1 do
		local current_faction = faction_list:item_at(i);
		if current_faction:can_be_human() and current_faction:is_human() == false and current_faction:is_dead() == false then
		
			local current_faction_leader = current_faction:faction_leader()
			if current_faction_leader:has_military_force() then
				local current_distance = distance_squared(x, y, current_faction_leader:logical_position_x(), current_faction_leader:logical_position_y());
				if closest_distance == false or current_distance < closest_distance then
					closest_distance = current_distance;
					closest_character = current_faction_leader;
				end;
			end;	
		end;	
	end;
	return closest_character, closest_distance;	
end

-- The Dilemma generated to give the player the option to take the nemesis crown/upgrade the crown or seal it
function nemesis_crown:generate_dilemma(dilemma_key)
	local crown = self.crown_data
	local crown_character = cm:get_family_member_by_cqi(crown.owner_fm_cqi):character()
	local crown_level = crown.current_level
	local dilemma_builder = cm:create_dilemma_builder(dilemma_key)
	local payload_builder = cm:create_payload()

	local nemesis_effect_bundle_sealed = cm:create_new_custom_effect_bundle("wh3_dlc25_bundle_nemesis_crown_sealed")
	nemesis_effect_bundle_sealed:add_effect("wh_main_effect_force_all_campaign_replenishment_rate", "faction_to_force_own", 10)
	nemesis_effect_bundle_sealed:add_effect("wh_main_effect_force_army_campaign_enable_replenishment_in_foreign_territory", "faction_to_force_own", 1)
	nemesis_effect_bundle_sealed:set_duration(10)

	payload_builder:text_display("dummy_nemesis_crown_take")
	payload_builder:effect_bundle_to_character(crown_character, self:generate_effect_bundle_key(crown_character))
	dilemma_builder:add_target("default", crown_character:family_member())
	dilemma_builder:add_choice_payload("FIRST", payload_builder)
	payload_builder:clear()

	local treasury_amount = 2000 + (crown_level*1500)
	payload_builder:treasury_adjustment(treasury_amount)
	payload_builder:effect_bundle_to_faction(nemesis_effect_bundle_sealed)
	payload_builder:text_display("dummy_nemesis_crown_seal")
	dilemma_builder:add_choice_payload("SECOND", payload_builder)

	cm:launch_custom_dilemma_from_builder(dilemma_builder, cm:get_faction(crown.owner_faction_key))
end

-- Returns the correct effect bundle when removing and applying effect bundles
function nemesis_crown:generate_effect_bundle_key(character)
	local crown = self.crown_data
	local faction = character:faction()
	local faction_name = faction:name()
	local subculture = faction:subculture()

	if self.faction_bundle_suffixes[faction_name] ~= nil then
		return self.effect_bundle_prefix .. tostring(crown.current_level) .. self.faction_bundle_suffixes[faction_name]
	elseif self.subculture_bundle_suffixes[subculture] ~= nil then
		return self.effect_bundle_prefix .. tostring(crown.current_level) .. self.subculture_bundle_suffixes[subculture]
	else
		return self.effect_bundle_prefix .. tostring(crown.current_level)
	end
end

function nemesis_crown:crown_owner_wins_battle()
	local crown = self.crown_data
	local crown_character = cm:get_family_member_by_cqi(crown.owner_fm_cqi):character()
	crown.battles_to_advance = crown.battles_to_advance - 1
	
	if crown.battles_to_advance == 0 and crown.current_level < crown.max_level then
		cm:remove_effect_bundle_from_character(self:generate_effect_bundle_key(crown_character), crown_character)
		
		crown.current_level = crown.current_level + 1
		if crown.current_level == crown.max_level then
			crown.battles_to_advance = -1
		end
		crown.battles_to_advance = crown.current_level + 3
		-- If a human wins enough battles to get nemesis crown to next level we fire the dilemma, if its AI we just upgrade the crown
		if not crown_character:is_null_interface() and crown_character:faction():is_human() then
			crown.holder_is_human = true
			self:generate_dilemma(self.dilemma_level_up)
		elseif not crown_character:is_null_interface() and not crown_character:faction():is_human() then
			cm:apply_effect_bundle_to_character(self:generate_effect_bundle_key(crown_character), crown_character, 0)
		end
	end
	
	crown.turns_to_fight = crown.battles_timer - crown.current_level
	self:update_context_values()
	self:update_shared_state_values()
end

function nemesis_crown:update_context_values()
	local crown = self.crown_data
	
	-- Always give the UI an int cqi
	local int_fm_cqi = -1
	if crown.owner_fm_cqi ~= nil then
		int_fm_cqi = crown.owner_fm_cqi
	end
	
	common.set_context_value("nemesis_crown_owning_faction_key", tostring(crown.owner_faction_key))
	common.set_context_value("nemesis_crown_owning_family_member_cqi", int_fm_cqi)
	common.set_context_value("nemesis_crown_battles_to_advance", crown.battles_to_advance)
	common.set_context_value("nemesis_crown_current_level", crown.current_level)
	common.set_context_value("nemesis_crown_turns_to_fight", crown.turns_to_fight)
	
	-- Set the current and next effect bundle keys
	if crown.owner_faction_key ~= nil then
		local faction = cm:get_faction(crown.owner_faction_key)
		if not faction then return end

		local subculture = faction:subculture()
		local faction_name = faction:name()
		local subculture_suffix = self.subculture_bundle_suffixes[subculture]
		local faction_suffix = self.faction_bundle_suffixes[faction_name]

		if faction_suffix ~= nil then
			common.set_context_value("nemesis_crown_current_effect_bundle_key", self.effect_bundle_prefix .. tostring(crown.current_level) .. faction_suffix)
			common.set_context_value("nemesis_crown_next_effect_bundle_key", self.effect_bundle_prefix .. tostring(crown.current_level + 1) .. faction_suffix)
		elseif subculture_suffix ~= nil then
			common.set_context_value("nemesis_crown_current_effect_bundle_key", self.effect_bundle_prefix .. tostring(crown.current_level) .. subculture_suffix)
			common.set_context_value("nemesis_crown_next_effect_bundle_key", self.effect_bundle_prefix .. tostring(crown.current_level + 1) .. subculture_suffix)
		else
			common.set_context_value("nemesis_crown_current_effect_bundle_key", self.effect_bundle_prefix .. tostring(crown.current_level))
			common.set_context_value("nemesis_crown_next_effect_bundle_key", self.effect_bundle_prefix .. tostring(crown.current_level + 1))
		end
	end
end

function nemesis_crown:update_shared_state_values()
	local crown = self.crown_data

	local int_fm_cqi = -1
	if crown.owner_fm_cqi ~= nil then
		int_fm_cqi = crown.owner_fm_cqi
	end

	cm:set_script_state("nemesis_crown_owning_faction_key", tostring(crown.owner_faction_key))
	cm:set_script_state("nemesis_crown_owning_family_member_cqi", int_fm_cqi)
	cm:set_script_state("nemesis_crown_battles_to_advance", crown.battles_to_advance)
	cm:set_script_state("nemesis_crown_current_level", crown.current_level)
	cm:set_script_state("nemesis_crown_turns_to_fight", crown.turns_to_fight)
end

function nemesis_crown:crown_owner_loses_battle(new_owner_cqi)
	local crown = self.crown_data
	local previous_crown_character = cm:get_family_member_by_cqi(crown.owner_fm_cqi):character()

	local new_crown_character = cm:get_family_member_by_cqi(new_owner_cqi):character()
	local new_crown_faction = new_crown_character:faction()

	if not previous_crown_character:is_null_interface() then
		local character_cqi = cm:get_family_member_by_cqi(self.crown_data.owner_fm_cqi):character():command_queue_index()

		cm:remove_effect_bundle_from_character(self:generate_effect_bundle_key(previous_crown_character), previous_crown_character)
		cm:remove_character_vfx(character_cqi, self.vfx.character)
	end
	
	--character must be alive, not a garrison, must be a general but not a caravan master
	if new_crown_faction:is_rebel() or not (not new_crown_character:is_null_interface() and new_crown_character:is_wounded() == false and new_crown_character:military_force():is_armed_citizenry() == false 
	and new_crown_character:character_type("general") and not (new_crown_character:character_subtype("wh3_dlc23_chd_lord_convoy_overseer") or new_crown_character:character_subtype("wh3_main_cth_lord_caravan_master"))) then				
		
		nemesis_crown:set_crown_lost(self.lost_event)
	else
		crown.battles_to_advance = crown.current_level + 3
		crown.turns_to_fight = crown.battles_timer - crown.current_level
		crown.owner_fm_cqi = new_owner_cqi
		crown.owner_faction_key = new_crown_faction:name()
		
		if new_crown_faction:is_human() then
			crown.holder_is_human = true
			self:generate_dilemma(self.dilemma_claim_crown)
		else
			self:ai_crown_choice()
		end
	
	end
	
	self:update_context_values()
	self:update_shared_state_values()
end

function nemesis_crown:ai_crown_choice()
	local crown = self.crown_data
	local crown_character = cm:get_family_member_by_cqi(crown.owner_fm_cqi):character()
	local crown_culture = crown_character:faction():culture()

	local keep_roll = cm:random_number(100)
	local human_factions = cm:get_human_factions()
	if crown_culture == "wh_main_dwf_dwarfs" or string.find(crown.owner_faction_key, "_qb") then
		nemesis_crown:set_crown_lost(self.sealed_event)
	else
		-- check if the crown owners culture should roll to take the crown
		local rolling_culture = false
		for i = 1, #self.cultures do
			if crown_culture == self.cultures[i] then
				rolling_culture = true
			end
		end

		if rolling_culture then
			if keep_roll > self.ai_chance_to_keep then
				cm:apply_effect_bundle_to_character(self:generate_effect_bundle_key(crown_character), crown_character, 0)
				cm:add_character_vfx(crown_character:command_queue_index(), self.vfx.character, true)
				for i = 1, #human_factions do
					cm:trigger_incident_with_targets(cm:get_faction(human_factions[i]):command_queue_index(), self.changed_event, crown_character:faction():command_queue_index(), 0, crown_character:command_queue_index(), 0, 0, 0)
				end
			else
				nemesis_crown:set_crown_lost(self.sealed_event)
			end
		else
			cm:apply_effect_bundle_to_character(self:generate_effect_bundle_key(crown_character), crown_character, 0)
			cm:add_character_vfx(crown_character:command_queue_index(), self.vfx.character, true)
			for i = 1, #human_factions do
				cm:trigger_incident_with_targets(cm:get_faction(human_factions[i]):command_queue_index(), self.changed_event, crown_character:faction():command_queue_index(), 0, crown_character:command_queue_index(), 0, 0, 0)
			end
		end
	end

end

function nemesis_crown:create_marker_key(num)
	return "nemesis_crown_marker_" .. tostring(num)
end

function nemesis_crown:crown_spawn_region(human_factions, is_debug_spawn)

	local crown = self.crown_data
	--pick a random location from all possible spawn locations
	local spawn_location = self.spawn_locations[cm:random_number(#self.spawn_locations)]

	--if its first crown spawn and the random pick wasnt in the empire
	if crown.crown_first_spawn == true and spawn_location.location ~= "EMPIRE" then
		local empire_count = 0
		for i = 1, #self.spawn_locations do
			if self.spawn_locations[i].location == "EMPIRE" then
				empire_count = empire_count + 1
			else
				break
			end
		end
		-- This always picks the Empire one for the first spawn in a campaign
		spawn_location = self.spawn_locations[cm:random_number(empire_count)]
		crown.crown_first_spawn = false
	end

	--used to help QA debug spawn the crown
	if is_debug_spawn then
		--force spawn the crown at Carroburg
		spawn_location = self.spawn_locations[1]
	end

	for i = 1, #human_factions do
		cm:trigger_incident((human_factions[i]), spawn_location.incident_key, true)
	end	

	cm:set_saved_value("current_crown_spawn_location", spawn_location)

	-- stops the crown spawning multiple times
	crown.has_spawned = true

	cm:add_round_turn_countdown_event(10, "ScriptEventNemesisCrownHint")
	cm:add_round_turn_countdown_event(15, "ScriptEventAiSearchesCrown")
	cm:add_round_turn_countdown_event(20, "ScriptEventAiClaimsCrown")
end

function nemesis_crown:marker_and_battle_listeners(human_factions)
	local crown = self.crown_data	

	core:add_listener(
		"NemesisCrown_WorldStart",
		"WorldStartRound",
		function(context)
			return cm:turn_number() >= crown.spawn_min_turn and crown.has_spawned == false
		end,
		function(context)
			self:crown_spawn_region(human_factions, false)												
		end,
		true
	)		

	core:add_listener(
		"NemesisCrown_CharacterKilled",
		"CharacterConvalescedOrKilled",
		function(context)
			local character = context:character()
			local character_fm_cqi = character:family_member():command_queue_index()
			local crown = self.crown_data
			return character_fm_cqi == crown.owner_fm_cqi and not cm:model():pending_battle():is_active()			
		end,
		function(context)
			local character = cm:get_character_by_fm_cqi(crown.owner_fm_cqi)
			if character then
				cm:remove_effect_bundle_from_character(self:generate_effect_bundle_key(character), character)
				cm:remove_character_vfx(character:command_queue_index(), self.vfx.character)
			end
			nemesis_crown:set_crown_lost(self.dies_event)		
		end,
		true
	)

	core:add_listener(
		"NemesisCrown_TurnUpdate",
		"FactionTurnStart",
		function(context)
			return context:faction():name() == crown.owner_faction_key
		end,
		function(context)
			if crown.holder_is_human == true and crown.turns_to_fight ~= 0 then
				crown.turns_to_fight = crown.turns_to_fight - 1
			end
			if crown.holder_is_human == true and crown.turns_to_fight <= 0 then
				local character = cm:get_character_by_fm_cqi(crown.owner_fm_cqi)
				if character then
					cm:remove_effect_bundle_from_character(self:generate_effect_bundle_key(character), character)
					cm:remove_character_vfx(crown.owner_fm_cqi, self.vfx.character)
				end
				nemesis_crown:set_crown_lost(self.lost_event)
				--number of battles required to increase crown level = current level +3
				crown.battles_to_advance = crown.current_level + 3
				crown.turns_to_fight = crown.battles_timer - crown.current_level
			end		
			self:update_context_values()
			self:update_shared_state_values()				
		end,
		true
	)

	core:add_listener(
		"NemesisCrown_CharacterRegionCheck",
		"FactionTurnStart",
		function(context)
			return context:faction():is_human() and crown.owner_fm_cqi == nil
		end,
		function(context)
			local faction = context:faction()
			local faction_name = faction:name()
			local character_list = faction:character_list()
			local nemesis_marker_key = self:create_marker_key(crown.crown_marker_key_counter)

			for i = 0, character_list:num_items()- 1 do
				local character = character_list:item_at(i)
				local spawn_location = cm:get_saved_value("current_crown_spawn_location")
				if spawn_location ~= false and spawn_location ~= nil then
					local spawn_province = cm:get_region(spawn_location.region_key):province():key()
					local crown_marker_factions_spawned_for = nemesis_crown.crown_data.crown_marker_factions_spawned_for
	
					if character:has_region() and character:region():province():key() == spawn_province then
						local faction_already_received_event = false
						if #crown_marker_factions_spawned_for > 0 then
							for j = 1, #crown_marker_factions_spawned_for do
								if crown_marker_factions_spawned_for[j] == faction_name then
									faction_already_received_event = true
									break
								end
							end
						end
						if faction_already_received_event == false then
							table.insert(crown_marker_factions_spawned_for, faction_name)
						
							nemesis_marker = Interactive_Marker_Manager:new_marker_type(nemesis_marker_key, "wh3_dlc25_nemesis_crown_battle_marker", nil, 1, faction_name)
							nemesis_marker:add_interaction_event("ScriptEventNemesisCrownEncounterMarkerBattleTriggered")
							nemesis_marker:add_spawn_event_feed_event(
								"event_feed_strings_text_wh3_dlc25_event_feed_string_scripted_event_nemesis_crown_marker_spawn",
								"event_feed_strings_text_wh3_dlc25_event_feed_string_scripted_event_invasion_nemesis_crown_primary_detail",
								"event_feed_strings_text_wh3_dlc25_event_feed_string_scripted_event_invasion_nemesis_crown_secondary_detail",
								1806,
								faction_name
							)

							nemesis_marker:set_loaned_characters_allowed(false)
							nemesis_marker:is_persistent(false)
							nemesis_marker:spawn_at_location(spawn_location.coords.x, spawn_location.coords.y, false)

							-- all spawned markers are despawned at once when one is interacted with
							-- that is why this won't work in the usual way
							nemesis_marker:despawn_on_interaction(false)

							cm:set_saved_value("NemesisCrown_LocationDiscovered", true)
							
							crown.crown_marker_key_counter = crown.crown_marker_key_counter + 1
						end
					end
				end
			end
		end,
		true
	)

	core:add_listener(
		"ScriptEvent_NemesisCrownEncounterMarkerBattleTriggered",
		"ScriptEventNemesisCrownEncounterMarkerBattleTriggered",
		true,
		function(context)
			local character = context:character()
			local faction_list = cm:model():world():faction_list()

			Forced_Battle_Manager:trigger_forced_battle_with_generated_army(
				character:military_force():command_queue_index(),
				self.nemesis_crown_faction_key,
				"grn_greenskins_goblins_only",
				19,
				math.clamp(math.round(cm:turn_number() / 10), 1, 10), --increases army strength based on turn number
				false,
				false,
				true,
				nil,
				nil,
				nil,
				math.clamp(math.round(cm:turn_number() / 10), 1, 10), --increases general level based on turn number
				nil
			)

			local nemesis_char_list = cm:get_faction(self.nemesis_crown_faction_key):character_list()
			for i = 0, nemesis_char_list:num_items() - 1 do
				local nemesis_char_items = nemesis_char_list:item_at(i)
				local nemesis_char_fm = nemesis_char_items:family_member()
				local nemesis_char = nemesis_char_fm:character()

				if not nemesis_char:is_null_interface() then
					local nemesis_char_cqi = nemesis_char_fm:character():command_queue_index()
					--local character = 
					crown.owner_fm_cqi = nemesis_char_fm:command_queue_index()
					cm:apply_effect_bundle_to_character(self:generate_effect_bundle_key(nemesis_char_items), nemesis_char_items, 0)
					cm:add_character_vfx(nemesis_char_cqi, self.vfx.character, true)

					if nemesis_char:has_military_force() then
						cm:apply_effect_bundle_to_characters_force("wh_main_bundle_military_upkeep_free_force", nemesis_char_cqi, 0)
					end
				end
			end	

			--If the faction lives this is meant to stop all diplomacy between them and other factions.
			cm:force_diplomacy("faction:"..self.nemesis_crown_faction_key, "all", "all", false, false, true)
			cm:force_diplomacy("faction:"..self.nemesis_crown_faction_key, "all", "war", true, true, true)
			cm:force_diplomacy("faction:"..self.nemesis_crown_faction_key, "all", "peace", true, false, false)
			for j = 0, faction_list:num_items() - 1 do
				local current_faction = faction_list:item_at(j):name()

				if current_faction ~= self.nemesis_crown_faction_key then
					cm:force_declare_war(self.nemesis_crown_faction_key, faction_list:item_at(j):name(), false, false)
				end
			end
			
			crown.owner_faction_key = self.nemesis_crown_faction_key
			self:update_context_values()
			self:update_shared_state_values()

			-- remove the markers for all players now that one has been triggered
			self:despawn_all_markers()
		end,
		true
	)


	-- The big battle script to check various things about when the Nemesis Crown has been involved in a battle
	core:add_listener(
	"NemesisCrown_BattleCompleted",
	"BattleCompleted",
	function(context)
		local crown = self.crown_data
		--check the crown owning faction exists and took part in battle
		if  crown.owner_faction_key ~= nil then
			return cm:pending_battle_cache_faction_is_involved(crown.owner_faction_key) and context:model():pending_battle():has_been_fought()
		end
		return false
	end,
	function(context)
		local crown = self.crown_data
		local crown_owner = cm:get_family_member_by_cqi(crown.owner_fm_cqi):character()
		local crown_owner_survived = true
		local crown_owner_attacker = cm:pending_battle_cache_faction_is_attacker(crown.owner_faction_key)
		
		--determine if crown owner survived battle
		if crown_owner:is_null_interface() == false then
			if crown_owner:is_wounded() == true then
				crown_owner_survived = false
			end
		else
			crown_owner_survived = false
		end
			
		if crown_owner_survived == false or cm:pending_battle_cache_char_is_involved(crown_owner) then
			--check defender won and crown owner lost
			if (cm:pending_battle_cache_defender_victory() and crown_owner_attacker) then
				if cm:pending_battle_cache_num_defenders() >= 1 then
					for i = 1, cm:pending_battle_cache_num_defenders() do	
						local defender_fm_cqi = cm:pending_battle_cache_get_defender_fm_cqi(i)
						local winner_character = cm:get_family_member_by_cqi(defender_fm_cqi):character()
						if winner_character:is_null_interface() == false then										
							self:crown_owner_loses_battle(defender_fm_cqi)
							return
						end
					end
				end
				
			--check attacker won and crown owner lost
			elseif (cm:pending_battle_cache_attacker_victory() and crown_owner_attacker == false) then	
				if cm:pending_battle_cache_num_attackers() >= 1 then
					for i = 1, cm:pending_battle_cache_num_attackers() do	
						local attacker_fm_cqi = cm:pending_battle_cache_get_attacker_fm_cqi(i)
						local winner_character = cm:get_family_member_by_cqi(attacker_fm_cqi):character()
						if winner_character:is_null_interface() == false then										
							self:crown_owner_loses_battle(attacker_fm_cqi)
							return
						end
					end
				end

			--crown owner won battle
			else
				--if the crown owner died but army won the battle then the crown is lost
				if crown_owner_survived == false then
					nemesis_crown:set_crown_lost(self.dies_event)				
				else
					self:crown_owner_wins_battle()
				end
			end
		end

		self:update_context_values()
		self:update_shared_state_values()
	end,
	true
	)

	-- Use this to set the Nemesis Crown family CQI to empty if the player chooses to seal the crown, aswell as resetting the variables
	core:add_listener(
		"NemesisCrown_DilemmaChoice",
		"DilemmaChoiceMadeEvent",
		function(context)
			local dilemma = context:dilemma()
			return dilemma == self.dilemma_claim_crown or dilemma == self.dilemma_level_up
		end,
		function(context)
			local character_cqi = cm:get_family_member_by_cqi(self.crown_data.owner_fm_cqi):character():command_queue_index()
			
			if context:choice() == 1 then
				nemesis_crown:set_crown_lost(self.sealed_event)
				self:update_context_values()
				self:update_shared_state_values()
				cm:remove_character_vfx(character_cqi, self.vfx.character)
			else
				--assume the dilemma was claiming the crown
				local incident_key = self.changed_event
				
				
				--check if dilemma was level up, if it was change the incident key
				if context:dilemma() == self.dilemma_level_up then
					incident_key = self.powered_up_event
				end
				
				for i = 1, #human_factions do
					cm:trigger_incident_with_targets(cm:get_faction(human_factions[i]):command_queue_index(), incident_key, cm:get_faction(crown.owner_faction_key):command_queue_index(), 0, character_cqi, 0, 0, 0)
				end

				cm:add_character_vfx(character_cqi, self.vfx.character, true)
				
				self:despawn_all_markers()
			end
		end,
		true
	)
end

function nemesis_crown:script_event_listeners(human_factions)
	local crown = self.crown_data

	core:add_listener(
		"NemesisCrown_AiSearchesCrown",
		"ScriptEventAiSearchesCrown",
		function(context)
			return crown.has_spawned == true and crown.owner_fm_cqi == nil
		end,
		function(context)
			for i = 1, #human_factions do
				cm:trigger_incident((human_factions[i]), "wh3_dlc25_incident_nemesis_crown_ai_searches", true)
			end
		end,
		true
	)

	core:add_listener(
		"NemesisCrown_LocationHint",
		"ScriptEventNemesisCrownHint",
		function(context)
			--checks if crown has spawned, that it doesnt have an owner and that the marker hasnt already spawned
			return crown.has_spawned == true and crown.owner_fm_cqi == nil and not cm:get_saved_value("NemesisCrown_LocationDiscovered")
		end,
		function(context)
			local spawn_location = cm:get_saved_value("current_crown_spawn_location")
			if spawn_location ~= false and spawn_location ~= nil then
				local spawn_region = cm:get_region(spawn_location.region_key)
				if spawn_region:is_abandoned() then
					for i = 1, #human_factions do
						cm:trigger_incident((human_factions[i]), "wh3_dlc25_incident_nemesis_crown_whispers_abandoned", true)
					end
				else					
					for i = 1, #human_factions do
						local player_faction = cm:get_faction(human_factions[i])
						local target_faction = spawn_region:owning_faction()
						if player_faction ~= target_faction then
							cm:trigger_incident_with_targets(player_faction:command_queue_index(), "wh3_dlc25_incident_nemesis_crown_whispers_owner", target_faction:command_queue_index(), 0, 0, 0, 0, 0)
						end
					end
				end
			end
		end,
		true
	)			

	core:add_listener(
		"NemesisCrown_AiClaimsCrown",
		"ScriptEventAiClaimsCrown",
		function(context)
			return crown.has_spawned == true and crown.owner_fm_cqi == nil
		end,
		function(context)
			local spawn_location = cm:get_saved_value("current_crown_spawn_location")
			if spawn_location ~= false and spawn_location ~= nil then
				local settlement = cm:get_region(spawn_location.region_key):settlement()
				local character = nemesis_crown:get_closest_legendary_lord_from_position(settlement:logical_position_x(),settlement:logical_position_y())

				if not character  then
					out("Script error - No Valid Character found to give Nemesis Crown")
					return
				end

				crown.owner_fm_cqi = character:family_member():command_queue_index()
				crown.owner_faction_key = character:faction():name()
				
				cm:apply_effect_bundle_to_character(self:generate_effect_bundle_key(character), character, 0)
				cm:add_character_vfx(character:command_queue_index(), self.vfx.character, true)

				for i = 1, #human_factions do
					cm:trigger_incident_with_targets(cm:get_faction(human_factions[i]):command_queue_index(), self.claimed_ai, cm:get_faction(crown.owner_faction_key):command_queue_index(), 0, cm:get_family_member_by_cqi(crown.owner_fm_cqi):character():command_queue_index(), 0, 0, 0)
				end

				self:despawn_all_markers()
			end

		end,
		true
	)

	core:add_listener(
		"NemesisCrown_ConfederatedCrown",
		"FactionJoinsConfederation",
		function(context)
			return context:faction():name() == crown.owner_faction_key
		end,
		function(context)
			crown.owner_faction_key = context:confederation():name()
			self:update_context_values()
			self:update_shared_state_values()
		end,
		false
	)

end

function nemesis_crown:despawn_all_markers()
	-- the keys of the spawned markers should be starting at 1 and up to the count
	-- note that there is no key for the current counter value, hence the -1 below
	for i = 1, self.crown_data.crown_marker_key_counter - 1 do
		local marker_key = self:create_marker_key(i)
		local marker = Interactive_Marker_Manager:get_marker(marker_key)
		if marker then
			marker:despawn_all()
		end
	end

	-- reset the counter now
	self.crown_data.crown_marker_key_counter = 1
end

--single function call for QA to debug spawn the nemesis crown
function nemesis_crown:qa_debug_spawn_crown()
	self:crown_spawn_region(cm:get_human_factions(), true)
end

function nemesis_crown:dev_command_listeners()
	local crown = self.crown_data
	
	core:add_listener(
		"NemesisCrown_DevAdjustCrownLevel",
		"ComponentLClickUp",
		function(context)
			return context.string == "dev_increase_nemesis_crown_level" or context.string == "dev_decrease_nemesis_crown_level"
		end,
		function(context)
			if crown.owner_fm_cqi ~= nil then
				local character = cm:get_character_by_fm_cqi(crown.owner_fm_cqi)

				if character then
					cm:remove_effect_bundle_from_character(self:generate_effect_bundle_key(character), character)
				end
		
				if context.string == "dev_increase_nemesis_crown_level" then 
					if crown.current_level < crown.max_level then
						crown.current_level = crown.current_level + 1
					end
				elseif crown.current_level > 1 then
					crown.current_level = crown.current_level - 1
				end
				
				if character then
					cm:apply_effect_bundle_to_character(self:generate_effect_bundle_key(character), character, 0)
				end

				self:update_context_values()
				self:update_shared_state_values()
			end
		end,
		true
	)
	
	core:add_listener(
		"NemesisCrown_DevAdjustCrownBattlesToLevelUp",
		"ComponentLClickUp",
		function(context)
			return context.string == "dev_increase_nemesis_crown_battles" or context.string == "dev_decrease_nemesis_crown_battles"
		end,
		function(context)
			if context.string == "dev_increase_nemesis_crown_battles" then 
				crown.battles_to_advance = crown.battles_to_advance + 1
			elseif crown.battles_to_advance > 1 then
				crown.battles_to_advance = crown.battles_to_advance - 1
			end
			
			self:update_context_values()
			self:update_shared_state_values()
		end,
		true
	)
	
	core:add_listener(
		"NemesisCrown_DevAdjustCrownTurnsToFight",
		"ComponentLClickUp",
		function(context)
			return context.string == "dev_increase_nemesis_crown_turns" or context.string == "dev_decrease_nemesis_crown_turns"
		end,
		function(context)
			if context.string == "dev_increase_nemesis_crown_turns" then 
				crown.turns_to_fight = crown.turns_to_fight + 1
			elseif crown.turns_to_fight > 1 then
				crown.turns_to_fight = crown.turns_to_fight - 1
			end
			
			self:update_context_values()
			self:update_shared_state_values()
		end,
		true
	)
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("NemesisCrown_CrownData", nemesis_crown.crown_data, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			nemesis_crown.crown_data = cm:load_named_value("NemesisCrown_CrownData", nemesis_crown.crown_data, context)
		end
	end
)
