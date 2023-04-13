
---Generic character upgrading system
---Replace a defined character with a clone that shares their name, equipped ancillaries, and a proportion of their level
---Contains in-built support for initiative-based upgrades, but convert_character function can be called from elsewhere. 

CUS = {}

CUS.default_xp_proportion = 0.5

CUS.initiative_to_agent_junctions = {
	wh3_dlc20_character_initiative_devote_exalted_hero_to_khorne = {
		type = "champion",
		subtype = "wh3_dlc20_chs_exalted_hero_mkho",
		},
	wh3_dlc20_character_initiative_devote_exalted_hero_to_nurgle = {
		type = "champion",
		subtype ="wh3_dlc20_chs_exalted_hero_mnur",
		xp_proportion =  0.5},
	wh3_dlc20_character_initiative_devote_sorceror_to_slaanesh_shadows = {
		type = "wizard",
		subtype ="wh3_dlc20_chs_sorcerer_shadows_msla",
		},
	wh3_dlc20_character_initiative_devote_sorceror_to_slaanesh_slaanesh = {
		type = "wizard",
		subtype ="wh3_dlc20_chs_sorcerer_slaanesh_msla",
		xp_proportion =  0.5},
	wh3_dlc20_character_initiative_devote_sorceror_to_tzeentch_metal = {
		type = "wizard",
		subtype ="wh3_dlc20_chs_sorcerer_metal_mtze", 
		},
	wh3_dlc20_character_initiative_devote_sorceror_to_tzeentch_tzeentch = {
		type = "wizard",
		subtype ="wh3_dlc20_chs_sorcerer_tzeentch_mtze",
		},
	wh3_dlc20_character_initiative_devote_lord_to_khorne = {
		type = "general",
		subtype = "wh3_dlc20_chs_lord_mkho",
		},
	wh3_dlc20_character_initiative_devote_lord_to_slaanesh = {
		type = "general",
		subtype ="wh3_dlc20_chs_lord_msla",
		},
	wh3_dlc20_character_initiative_devote_sorceror_lord_to_nurgle_death = {
		type = "general",
		subtype = "wh3_dlc20_chs_sorcerer_lord_death_mnur",
		},
	wh3_dlc20_character_initiative_devote_sorceror_lord_to_nurgle_nurgle = {
		type = "general",
		subtype ="wh3_dlc20_chs_sorcerer_lord_nurgle_mnur",
		},
	wh3_dlc20_character_initiative_devote_sorceror_lord_to_tzeentch_metal = {
		type ="general", 
		subtype ="wh3_dlc20_chs_sorcerer_lord_metal_mtze", 
		},
	wh3_dlc20_character_initiative_devote_sorceror_lord_to_tzeentch_tzeentch = {
		type ="general",
		subtype ="wh3_dlc20_chs_sorcerer_lord_tzeentch_mtze", 
		},
	wh3_dlc20_character_initiative_ascend_lord_to_daemon_prince_khorne = {
		type ="general",
		subtype ="wh3_dlc20_chs_daemon_prince_khorne", 
		}, 
	wh3_dlc20_character_initiative_ascend_lord_to_daemon_prince_nurgle = {
		type ="general", 
		subtype ="wh3_dlc20_chs_daemon_prince_nurgle", 
		}, 
	wh3_dlc20_character_initiative_ascend_lord_to_daemon_prince_slaanesh = {
		type ="general", 
		subtype = "wh3_dlc20_chs_daemon_prince_slaanesh",
		}, 
	wh3_dlc20_character_initiative_ascend_lord_to_daemon_prince_tzeentch = {
		type ="general",
		subtype ="wh3_dlc20_chs_daemon_prince_tzeentch",
		}, 
	wh3_dlc20_character_initiative_ascend_lord_to_daemon_prince_undivided = {
		type ="general",
		subtype ="wh3_dlc20_chs_daemon_prince_undivided",
		},
	wh3_dlc20_character_initiative_ascend_lord_to_daemon_prince_khorne_from_und = {
		type ="general",
		subtype ="wh3_dlc20_chs_daemon_prince_khorne", 
		}, 
	wh3_dlc20_character_initiative_ascend_lord_to_daemon_prince_nurgle_from_und = {
		type ="general", 
		subtype ="wh3_dlc20_chs_daemon_prince_nurgle",
		}, 
	wh3_dlc20_character_initiative_ascend_lord_to_daemon_prince_slaanesh_from_und = {
		type ="general", 
		subtype = "wh3_dlc20_chs_daemon_prince_slaanesh",
		}, 
	wh3_dlc20_character_initiative_ascend_lord_to_daemon_prince_tzeentch_from_und = {
		type ="general",
		subtype ="wh3_dlc20_chs_daemon_prince_tzeentch",
		}, 
}


--- hook up agents to the bonus values in data that will modify their starting XP This is method agnostic - the bonus value will be taken into account regardless of how convert_character is called
CUS.subtypes_to_xp_bonus_values = {
	wh3_dlc20_chs_exalted_hero_mkho = "char_upgrade_level_preserved_kho",
	wh3_dlc20_chs_lord_mkho = "char_upgrade_level_preserved_kho",
	wh3_dlc20_chs_exalted_hero_mnur = "char_upgrade_level_preserved_nur",
	wh3_dlc20_chs_sorcerer_shadows_msla = "char_upgrade_level_preserved_sla",
	wh3_dlc20_chs_sorcerer_slaanesh_msla = "char_upgrade_level_preserved_sla",
	wh3_dlc20_chs_sorcerer_tzeentch_mtze = "char_upgrade_level_preserved_tze",
	wh3_dlc20_chs_sorcerer_metal_mtze = "char_upgrade_level_preserved_tze",
	wh3_dlc20_chs_sorcerer_lord_death_mnur = "char_upgrade_level_preserved_nur",
	wh3_dlc20_chs_sorcerer_lord_nurgle_mnur = "char_upgrade_level_preserved_nur",
	wh3_dlc20_chs_sorcerer_lord_metal_mtze = "char_upgrade_level_preserved_tze",
	wh3_dlc20_chs_sorcerer_lord_tzeentch_mtze = "char_upgrade_level_preserved_tze",
}

CUS.subtypes_to_composite_scenes = {
	wh3_dlc20_chs_exalted_hero_mkho = "wh3_campaign_chaos_upgrade_daemons",
	wh3_dlc20_chs_lord_mkho = "wh3_campaign_chaos_upgrade_daemons",
	wh3_dlc20_chs_exalted_hero_mnur = "wh3_campaign_chaos_upgrade_daemons",
	wh3_dlc20_chs_sorcerer_shadows_msla = "wh3_campaign_chaos_upgrade_daemons",
	wh3_dlc20_chs_sorcerer_slaanesh_msla = "wh3_campaign_chaos_upgrade_daemons",
	wh3_dlc20_chs_sorcerer_tzeentch_mtze = "wh3_campaign_chaos_upgrade_daemons",
	wh3_dlc20_chs_sorcerer_metal_mtze = "wh3_campaign_chaos_upgrade_daemons",
	wh3_dlc20_chs_sorcerer_lord_death_mnur = "wh3_campaign_chaos_upgrade_daemons",
	wh3_dlc20_chs_sorcerer_lord_nurgle_mnur = "wh3_campaign_chaos_upgrade_daemons",
	wh3_dlc20_chs_sorcerer_lord_metal_mtze = "wh3_campaign_chaos_upgrade_daemons",
	wh3_dlc20_chs_sorcerer_lord_tzeentch_mtze = "wh3_campaign_chaos_upgrade_daemons",
	wh3_dlc20_chs_daemon_prince_khorne = "wh3_campaign_chaos_upgrade_daemons",
	wh3_dlc20_chs_daemon_prince_nurgle = "wh3_campaign_chaos_upgrade_daemons",
	wh3_dlc20_chs_daemon_prince_slaanesh = "wh3_campaign_chaos_upgrade_daemons",
	wh3_dlc20_chs_daemon_prince_tzeentch = "wh3_campaign_chaos_upgrade_daemons",
	wh3_dlc20_chs_daemon_prince_undivided = "wh3_campaign_chaos_upgrade_daemons",
	wh3_main_kho_exalted_bloodthirster= "wh3_campaign_chaos_upgrade_daemons",
	wh3_main_nur_exalted_great_unclean_one_death= "wh3_campaign_chaos_upgrade_daemons",
	wh3_main_nur_exalted_great_unclean_one_nurgle= "wh3_campaign_chaos_upgrade_daemons",
	wh3_main_sla_exalted_keeper_of_secrets_shadow= "wh3_campaign_chaos_upgrade_daemons",
	wh3_main_sla_exalted_keeper_of_secrets_slaanesh= "wh3_campaign_chaos_upgrade_daemons",
	wh3_main_tze_exalted_lord_of_change_metal = "wh3_campaign_chaos_upgrade_daemons",
	wh3_main_tze_exalted_lord_of_change_tzeentch = "wh3_campaign_chaos_upgrade_daemons",

}

--apply the following tint states when this subtype is created. Intensity of colour will be randomly picked between chosen values.

CUS.subtypes_to_tints = {
	wh3_dlc20_chs_daemon_prince_khorne = 
	{
		primary = {key = "wh3_main_daemon_prince_khorne_primary", intensity_min = 200, intensity_max = 255},
		secondary = {key = "wh3_main_daemon_prince_khorne_secondary", intensity_min = 200, intensity_max = 255}
	},
	wh3_dlc20_chs_daemon_prince_nurgle = 
	{
		primary = {key = "wh3_main_daemon_prince_nurgle_primary", intensity_min = 200, intensity_max = 255},
		secondary = {key = "wh3_main_daemon_prince_nurgle_secondary", intensity_min = 200, intensity_max = 255}
	},
	wh3_dlc20_chs_daemon_prince_slaanesh = 
	{
		primary = {key = "wh3_main_daemon_prince_slaanesh_primary", intensity_min = 200, intensity_max = 255},
		secondary = {key = "wh3_main_daemon_prince_slaanesh_secondary", intensity_min = 200, intensity_max = 255}
	},
	wh3_dlc20_chs_daemon_prince_tzeentch = 
	{
		primary = {key = "wh3_main_daemon_prince_tzeentch_primary", intensity_min = 200, intensity_max = 255},
		secondary = {key = "wh3_main_daemon_prince_tzeentch_secondary", intensity_min = 200, intensity_max = 255}
	}
}



--- If upgrading *from* the specified subtype, grant the associated trait. Use "default" unless the *target" subtype is specifically named.

CUS.subtype_to_bonus_traits = {
	-- Exalted Heroes
	wh_main_chs_exalted_hero = {
		default = "wh3_dlc20_legacy_trait_exalted_hero_to_marked",
	},
	-- Chaos Lords
	wh_main_chs_lord = {
		default = "wh3_dlc20_legacy_trait_lord_undivided_to_marked", 
		wh3_dlc20_chs_daemon_prince_undivided = "wh3_dlc20_legacy_trait_lord_to_daemon_prince",
	},
	wh3_dlc20_chs_lord_mkho= {
		default = "wh3_dlc20_legacy_trait_lord_to_daemon_prince",
	},
	wh3_dlc20_chs_lord_msla= {
		default = "wh3_dlc20_legacy_trait_lord_to_daemon_prince",
	},
	--Sorcerer Lords
	wh_dlc01_chs_sorcerer_lord_death = {
		default = "wh3_dlc20_legacy_trait_sorcerer_death",
		wh3_dlc20_chs_sorcerer_lord_death_mnur = "wh3_dlc20_legacy_trait_sorcerer_lord_death_to_death_mnur",
	},
	wh3_dlc20_chs_sorcerer_lord_death_mnur = {
		default = "wh3_dlc20_legacy_trait_sorcerer_lord_death_nur_to_daemon_prince",
	},
	wh3_dlc20_chs_sorcerer_lord_nurgle_mnur = {
		default = "wh3_dlc20_legacy_trait_sorcerer_lord_nurgle_nur_to_daemon_prince",
	},
	wh_dlc01_chs_sorcerer_lord_fire = {
		default = "wh3_dlc20_legacy_trait_sorcerer_fire",
		wh3_dlc20_chs_daemon_prince_undivided = "wh3_dlc20_legacy_trait_sorcerer_lord_fire_to_daemon_prince",
	},
	wh_dlc01_chs_sorcerer_lord_metal = {
		default = "wh3_dlc20_legacy_trait_sorcerer_metal",
		wh3_dlc20_chs_sorcerer_lord_metal_mtze = "wh3_dlc20_legacy_trait_sorcerer_metal_to_metal_mtze",
	},
	wh3_dlc20_chs_sorcerer_lord_metal_mtze = {
		default = "wh3_dlc20_legacy_trait_sorcerer_lord_metal_tze_to_daemon_prince",
	},
	wh3_dlc20_chs_sorcerer_lord_tzeentch_mtze = {
		default = "wh3_dlc20_legacy_trait_sorcerer_lord_tzeentch_tze_to_daemon_prince",
	},
	wh_dlc07_chs_sorcerer_lord_shadow = {
		default = "wh3_dlc20_legacy_trait_sorcerer_shadows",
		wh3_dlc20_chs_daemon_prince_slaanesh = "wh3_dlc20_legacy_trait_sorcerer_shadows_to_shadows_msla",
	},
	--Sorcerers
	wh_dlc07_chs_chaos_sorcerer_shadow = {
		default = "wh3_dlc20_legacy_trait_sorcerer_shadows",
		wh3_dlc20_chs_sorcerer_shadows_msla = "wh3_dlc20_legacy_trait_sorcerer_shadows_to_shadows_msla",
	},
	wh_main_chs_chaos_sorcerer_death = {
		default = "wh3_dlc20_legacy_trait_sorcerer_death",
	},
	wh_main_chs_chaos_sorcerer_fire = {
		default = "wh3_dlc20_legacy_trait_sorcerer_fire",
	},
	wh_main_chs_chaos_sorcerer_metal = {
		default = "wh3_dlc20_legacy_trait_sorcerer_metal",
		wh3_dlc20_chs_sorcerer_metal_mtze = "wh3_dlc20_legacy_trait_sorcerer_metal_to_metal_mtze",
	},
}



---------------------
--------SETUP--------
---------------------

function CUS:initialise()
	self:add_character_conversion_listeners()
end

function CUS:add_character_conversion_listeners()

	core:add_listener(
		"upgrade_initiative_activated",
		"CharacterInitiativeActivationChangedEvent",
		function(context)
			return self.initiative_to_agent_junctions[context:initiative():record_key()] ~= nil
		end,
		function(context)
			local initiative_key = context:initiative():record_key()
			local character_to_upgrade = context:character()
			local upgrade_details = self.initiative_to_agent_junctions[initiative_key]
			local new_character_agent_type = upgrade_details.type
			local new_character_agent_subtype = upgrade_details.subtype
			local new_character_level_proportion = upgrade_details.xp_proportion or self.default_xp_proportion
			local incident_to_trigger = upgrade_details.incident

			self:convert_character(character_to_upgrade, new_character_agent_type, new_character_agent_subtype, new_character_level_proportion, incident_to_trigger)
		end,
		true
	)
end

---------------------
----CORE FUNCTIONS---
---------------------

---safe to call from other scripts
function CUS:convert_character(character, new_type, new_subtype, opt_inherited_level_proportion, opt_incident, opt_copy_name)

	if character:is_null_interface() then
		script_error("ERROR: convert_character() called with an invalid character interface. They will not get upgraded")
		return
	end

	local x = character:logical_position_x()
	local y = character:logical_position_y()

	if not (is_string(new_type) and is_string(new_subtype)) then
		script_error("ERROR: convert_character_subtype() is being used without valid strings for agent type and subtype")
		return
	end

	local inherited_level_proportion = opt_inherited_level_proportion or 1

	if not is_number(inherited_level_proportion) then
		script_error("ERROR: convert_character_subtype() has received a parameter for level proportion, but it is not a number!")
		return
	end

	if not is_string(opt_incident) and not is_nil(opt_incident) then
		script_error("ERROR: convert_character_subtype() has received a parameter for an incident, but it is not a string!")
		return
	end

	---collect all the old character data
	local old_char_details = {
		mf = character:military_force(),
		rank = character:rank(),
		fm_cqi = character:family_member():command_queue_index(),
		character_details = character:character_details(),
		faction_key = character:faction():name(),
		character_forename = character:get_forename(),
		character_surname = character:get_surname(),
		parent_force = character:embedded_in_military_force(),
		subtype = character:character_subtype_key(),
		traits = character:all_traits(),
		ap = character:action_points_remaining_percent()
	}

	local new_character
	if character:has_military_force() then
		new_character = cm:replace_general_in_force(old_char_details.mf, new_subtype)
	else
		new_x, new_y = cm:find_valid_spawn_location_for_character_from_position(old_char_details.faction_key, x, y, false)
		new_character = cm:create_agent(old_char_details.faction_key, new_type, new_subtype, new_x, new_y)
	end

	if new_character then
		self:update_new_character(old_char_details, new_character, inherited_level_proportion)
		if opt_incident then
			cm:trigger_incident_with_targets(new_character:faction():command_queue_index(), opt_incident, 0, 0, new_character:command_queue_index(), 0, 0, 0)
		end
	end

end

--- should never need to call this seperately
function CUS:update_new_character(old_char_details, new_char_interface, level_proportion_base)
	cm:reassign_ancillaries_to_character_of_same_faction(old_char_details.character_details, new_char_interface:character_details())

	if old_char_details.character_forename == "" and old_char_details.character_surname == "" then
		cm:randomise_character_name(new_char_interface)
	else
		cm:change_character_localised_name(new_char_interface,old_char_details.character_forename, old_char_details.character_surname,"names_name_2147358938","names_name_2147358938")
	end

	local new_subtype = new_char_interface:character_subtype_key()
	local new_character_level_proportion = level_proportion_base
	local new_char_lookup = cm:char_lookup_str(new_char_interface)
	local traits_to_copy = old_char_details.traits

	if self.subtypes_to_xp_bonus_values[new_subtype] then
		local bonus_value = self.subtypes_to_xp_bonus_values[new_subtype]
		if cm:get_characters_bonus_value(new_char_interface, bonus_value) > 0 then
			new_character_level_proportion = new_character_level_proportion + cm:get_characters_bonus_value(new_char_interface, bonus_value)/100
		end
	end

	if traits_to_copy then
		for i =1, #traits_to_copy do
			local trait_to_copy = traits_to_copy[i]
			cm:force_add_trait(new_char_lookup, trait_to_copy)
		end
	end

	if self.subtype_to_bonus_traits[old_char_details.subtype] then
		local trait_to_add= self.subtype_to_bonus_traits[old_char_details.subtype].default

		if self.subtype_to_bonus_traits[old_char_details.subtype][new_subtype] then
			trait_to_add = self.subtype_to_bonus_traits[old_char_details.subtype][new_subtype]
		end

		if trait_to_add then
			cm:force_add_trait(new_char_lookup, trait_to_add)
		end

	end

	if self.subtypes_to_tints[new_subtype] then
		local tint_details = self.subtypes_to_tints[new_subtype]
		local primary_colour_key = tint_details.primary.key
		local primary_colour_amount = cm:random_number(tint_details.primary.intensity_max, tint_details.primary.intensity_min)
		local secondary_colour_key = tint_details.secondary.key
		local secondary_colour_amount = cm:random_number(tint_details.secondary.intensity_max, tint_details.secondary.intensity_min)

		cm:set_tint_activity_state_for_character(new_char_interface, true)
		cm:set_tint_colour_for_character(new_char_interface, primary_colour_key, primary_colour_amount, secondary_colour_key, secondary_colour_amount)
	end

	if self.subtypes_to_composite_scenes[new_subtype] then
		local composite_scene = self.subtypes_to_composite_scenes[new_subtype]
		local x = new_char_interface:logical_position_x();
		local y = new_char_interface:logical_position_y();
		cm:add_scripted_composite_scene_to_logical_position(composite_scene, composite_scene, x, y, x, y + 1, true, false, false);
	end

	if old_char_details.ap > 0 then
		cm:replenish_action_points(new_char_lookup, old_char_details.ap/100)
	end

	cm:add_agent_experience(cm:char_lookup_str(new_char_interface:command_queue_index()), math.floor(old_char_details.rank * new_character_level_proportion)+1, true)
	cm:suppress_immortality(old_char_details.fm_cqi, true)

	cm:callback(function()
		cm:kill_character_and_commanded_unit("family_member_cqi:" .. old_char_details.fm_cqi, true)
	end, 0.5)

	if not old_char_details.parent_force:is_null_interface() then
		cm:embed_agent_in_force(new_char_interface, old_char_details.parent_force)
	end
end