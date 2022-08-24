cult_of_sotek = {
	faction_key = "wh2_dlc12_lzd_cult_of_sotek",

	ritual_category_key = "SACRIFICE_RITUAL",
	prophecy_missions = {
		{
			-- prophecy 1 missions
			{complete = false, key = "wh2_dlc12_prophecy_of_sotek_1_1"},
			{complete = false, key = "wh2_dlc12_prophecy_of_sotek_1_2", reward_event = "ScriptEventSacrificeTier2Unlocked"},
			completion_event = "ScriptEventPoSStage1Completed"
		},
		{
			-- prophecy 2 missions
			{complete = false, key = "wh2_dlc12_prophecy_of_sotek_2_1"},
			{complete = false, key = "wh2_dlc12_prophecy_of_sotek_2_2"},
			{complete = false, key = "wh2_dlc12_prophecy_of_sotek_2_3", reward_event = "ScriptEventSacrificeTier3Unlocked"},
			{complete = false, key = "wh2_dlc12_prophecy_of_sotek_2_4", reward_event = "ScriptEventSacrificeTier4Unlocked"},
			completion_event = "ScriptEventPoSStage2Completed"
		},
		{
			-- prophecy 3 mission
			{complete = false, key = "wh2_dlc12_prophecy_of_sotek_3_1", reward_event = "ScriptEventSacrificeTier5Unlocked"}
		}
	},

	ritual_ancillary_types = {
		["wh2_dlc12_tehenhauin_sacrifice_of_quetza"] = "banner",
		["wh2_dlc12_tehenhauin_sacrifice_of_huanabic"] = "follower"
	},

	ancillary_list = {
		follower = {
			"wh2_main_anc_follower_lzd_architect",
			"wh2_main_anc_follower_lzd_astronomer",
			"wh2_dlc12_anc_follower_piqipoqi_qupacoco",
			"wh2_dlc12_anc_follower_chameleon_spotter",
			"wh2_dlc12_anc_follower_swamp_trawler_skink",
			"wh2_dlc12_anc_follower_prophets_spawn_brother",
			"wh2_dlc12_anc_follower_consul_of_calith",
			"wh2_dlc12_anc_follower_priest_of_the_star_chambers",
			"wh2_dlc12_anc_follower_lotl_botls_spawn_brother",
			"wh2_dlc12_anc_follower_obsinite_miner_skink"
		},
		
		banner = {
			"wh2_dlc12_anc_magic_standard_totem_of_the_spitting_viper",
			"wh2_dlc12_anc_magic_standard_coatlpelt_flagstaff", 
			"wh2_dlc12_anc_magic_standard_exalted_banner_of_xapati",
			"wh2_dlc12_anc_magic_standard_totem_pole_of_destiny",
			"wh2_main_anc_magic_standard_sun_standard_of_chotec",
			"wh2_main_anc_magic_standard_the_jaguar_standard",
			"wh2_dlc12_anc_magic_standard_culchan_feathered_standard",
			"wh2_dlc12_anc_magic_standard_flag_of_the_daystar",
			"wh2_dlc12_anc_magic_standard_shroud_of_chaqua",
			"wh2_dlc12_anc_magic_standard_sign_of_the_coiled_one"
		}
	},

	restricted_buildings_list = {
		"wh2_main_lzd_saurus_1",
		"wh2_main_lzd_saurus_2",
		"wh2_main_lzd_saurus_3"
	}
}


function cult_of_sotek:add_tehenhauin_listeners()
	out("#### Adding Tehenhauin Listeners ####")
	local tehenhauin = cm:get_faction(self.faction_key)	
	if not tehenhauin then
		return
	end

	if tehenhauin:is_human() then
		self:trigger_prophecy_completion_events()
		self:declare_prophecy_listeners()
		self:grant_ritual_ancillaries()

		if cm:is_new_game() == true then
			self:adjust_sacrificial_offerings(200)
			self:start_prophecy_1()
		end

	elseif cm:is_new_game() then
		cm:unlock_rituals_in_category(tehenhauin, self.ritual_category_key, -1)
	end
end


function cult_of_sotek:start_prophecy_1()
	local not_mp = not cm:is_multiplayer()

	-- Obj 1
	cm:trigger_mission(self.faction_key, self.prophecy_missions[1][1].key, not_mp)

	-- Obj 2
	local mm = mission_manager:new(self.faction_key, self.prophecy_missions[1][2].key)
	mm:set_mission_issuer("CLAN_ELDERS")
	mm:add_new_objective("PERFORM_RITUAL")
	mm:add_condition("ritual_category SACRIFICE_RITUAL")
	mm:add_condition("total 5")
	mm:add_payload("effect_bundle{bundle_key wh2_dlc12_prophecy_of_sotek_1_2;turns 0;}")
	mm:add_payload("faction_pooled_resource_transaction{resource lzd_sacrificial_offerings;factor captured_during_missions;amount 200;context absolute;}")
	mm:trigger()

	cm:apply_effect_bundle("wh2_dlc12_prophecy_of_sotek_stage_1", self.faction_key, -1)
end


function cult_of_sotek:start_prophecy_2()
	local not_mp = not cm:is_multiplayer()

	-- Obj 1
	cm:trigger_mission(self.faction_key, self.prophecy_missions[2][1].key, not_mp)

	-- Obj 2
	cm:trigger_mission(self.faction_key, self.prophecy_missions[2][2].key, not_mp)

	-- Obj 3
	cm:trigger_mission(self.faction_key, self.prophecy_missions[2][3].key, not_mp)

	-- Obj 4
	local mm = mission_manager:new(self.faction_key, self.prophecy_missions[2][4].key)
	mm:set_mission_issuer("CLAN_ELDERS")
	mm:add_new_objective("PERFORM_RITUAL")
	mm:add_condition("ritual_category SACRIFICE_RITUAL")
	mm:add_condition("total 5")
	mm:add_payload("effect_bundle{bundle_key wh2_dlc12_prophecy_of_sotek_2_4;turns 0;}")
	mm:add_payload("faction_pooled_resource_transaction{resource lzd_sacrificial_offerings;factor captured_during_missions;amount 200;context absolute;}")
	mm:trigger()
	
	cm:remove_effect_bundle("wh2_dlc12_prophecy_of_sotek_stage_1", self.faction_key)
	cm:apply_effect_bundle("wh2_dlc12_prophecy_of_sotek_stage_2", self.faction_key, -1)

	-- Update skaven / lizardmen diplomacy	
	local lizardmen_faction_list = {}
	local skaven_faction_list = {}
	
	local faction_list = cm:model():world():faction_list()
	
	for i = 0, faction_list:num_items() - 1 do
		if (faction_list:item_at(i):subculture() == "wh2_main_sc_lzd_lizardmen") and (faction_list:item_at(i):is_dead() == false) then
			table.insert(lizardmen_faction_list, faction_list:item_at(i):name())
		end
	end
	
	for i = 0, faction_list:num_items() - 1 do
		if (faction_list:item_at(i):subculture() == "wh2_main_sc_skv_skaven") and (faction_list:item_at(i):is_dead() == false) then
			table.insert(skaven_faction_list, faction_list:item_at(i):name())
		end
	end
	
	for i = 1, #lizardmen_faction_list do
		cm:apply_effect_bundle("wh2_dlc12_prophecy_of_sotek_stage_2", lizardmen_faction_list[i], -1)
		for j = 1, #skaven_faction_list do
			if not cm:get_faction(skaven_faction_list[j]):is_human() then
				cm:force_declare_war(lizardmen_faction_list[i], skaven_faction_list[j], false, false)
			end
		end
	end
	
	for i = 1, #skaven_faction_list do							
		cm:apply_effect_bundle("wh2_dlc12_prophecy_of_sotek_stage_2_skaven", skaven_faction_list[i], -1)
		cm:force_diplomacy("faction:" .. self.faction_key, "faction:" .. skaven_faction_list[i], "peace", false, false, true)
	end
end


function cult_of_sotek:start_prophecy_3()
	-- Obj 1
	local mm = mission_manager:new(self.faction_key, self.prophecy_missions[3][1].key)
	mm:set_mission_issuer("CLAN_ELDERS")
	mm:add_new_objective("PERFORM_RITUAL")
	mm:add_condition("ritual_category SACRIFICE_RITUAL")
	mm:add_condition("total 5")
	mm:add_payload("effect_bundle{bundle_key wh2_dlc12_prophecy_of_sotek_3_1;turns 0;}")
	mm:add_payload("faction_pooled_resource_transaction{resource lzd_sacrificial_offerings;factor captured_during_missions;amount 200;context absolute;}")
	mm:trigger()
	
	cm:remove_effect_bundle("wh2_dlc12_prophecy_of_sotek_stage_2", self.faction_key)
	cm:apply_effect_bundle("wh2_dlc12_prophecy_of_sotek_stage_3", self.faction_key, -1)
end


function cult_of_sotek:adjust_sacrificial_offerings(amount)
	cm:faction_add_pooled_resource(self.faction_key, "lzd_sacrificial_offerings", "captured_in_battle", amount)
end


function cult_of_sotek:trigger_prophecy_completion_events()
	core:add_listener(
		"pos_mission_success",
		"MissionSucceeded",
		function(context)
			return context:faction():name() == self.faction_key
		end,
		function(context) 
			local mission_key = context:mission():mission_record_key()
			local faction = context:faction()
			
			for _, mission in ipairs(self.prophecy_missions) do

				for _, obj in ipairs(mission) do

					if(mission_key == obj.key) then
						obj.complete = true;

						if(obj.reward_event) then
							cm:callback(function()
								core:trigger_event(obj.reward_event, faction)
								cm:remove_effect_bundle(obj.key, self.faction_key)
							end, 0.5)
						end
	
						for _, objective in ipairs(mission) do
							local obj_complete = objective.complete
							if(obj_complete == false) then
								-- one or more of the objectives in self prophecy still need to be completed.
								return
							end
						end

						-- all objectives for current prophecy are complete.
						if(mission.completion_event) then
							core:trigger_event(mission.completion_event)
						end
						
					end
				end
			end		
		end,
		true	
	)
end


function cult_of_sotek:declare_prophecy_listeners()
	core:add_listener(
		"pos_stage_1_completed",
		"ScriptEventPoSStage1Completed",
		true,
		function() 
			self:start_prophecy_2()
		end,
		false	
	)
	
	core:add_listener(
		"pos_stage_2_completed",
		"ScriptEventPoSStage2Completed",
		true,
		function() 
			self:start_prophecy_3()
		end,
		false	
	)
end


function cult_of_sotek:grant_ritual_ancillaries()
	core:add_listener(
		"sacrifice_ancillary_listener",
		"RitualCompletedEvent",
		function(context) 
			local ritual_key = context:ritual():ritual_key()

			if (self.ritual_ancillary_types[ritual_key])  then
				return true
			end

			return false
		end,
		function(context) 
			local ritual_key = context:ritual():ritual_key()
			local ancillaries = self.ancillary_list[self.ritual_ancillary_types[ritual_key]]
			local rand_anc = ancillaries[cm:random_number(#ancillaries, 1)]

			cm:add_ancillary_to_faction(context:performing_faction(), rand_anc, false) 
		end,
		true	
	)	
end


--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("SotekProphecies", cult_of_sotek.prophecy_missions, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		cult_of_sotek.prophecy_missions = cm:load_named_value("SotekProphecies", cult_of_sotek.prophecy_missions, context)
	end
)