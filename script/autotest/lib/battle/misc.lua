local m_dont_return_to_main_menu = false --specifies whether or not the script should return all the way back to the front end or stay on the custom battle panel after battle

function Lib.Battle.Misc.start_battle()
    callback(function()
        Lib.Battle.Clicks.start_battle()
    end)
end

function Lib.Battle.Misc.ensure_battle_started()
	callback(function()
		local bottom_bar =  Lib.Components.Battle.bottom_bar()
		local start_button = Lib.Components.Battle.start_battle()
		local cinematic_bars = Lib.Components.Campaign.cinematic_bars()
		if(start_button ~= nil and start_button:Visible(true) == true) then
			Utilities.print("Loaded pass deployment")
			Lib.Battle.Clicks.start_battle()
			Lib.Helpers.Misc.wait(1)
		elseif(bottom_bar ~= nil and bottom_bar:Visible(true) == true) then
			Utilities.print("Loaded pass no deployment")
			g_battle_load_verification = true
			return
		elseif(cinematic_bars ~= nil and cinematic_bars:Visible() == true)then
			Utilities.print("Skipping the Survival battle cinematic")
			Common_Actions.trigger_shortcut("ESCAPE")
			Lib.Battle.Misc.ensure_battle_started()
		else
			Lib.Helpers.Misc.wait(1)
			Lib.Battle.Misc.ensure_battle_started()
		end
	end)
end

function Lib.Battle.Misc.ensure_battle_loaded()
	callback(function()
		local bottom_bar =  Lib.Components.Battle.bottom_bar()
		local start_button = Lib.Components.Battle.start_battle()
		local cinematic_bars = Lib.Components.Campaign.cinematic_bars()
		if(start_button ~= nil and start_button:Visible(true) == true) then
			Utilities.print("Battle Loaded - Start button ready")
			return
		elseif(bottom_bar ~= nil and bottom_bar:Visible(true) == true) then
			Utilities.print("Loaded pass no deployment")
			g_battle_load_verification = true
			return
		elseif(cinematic_bars ~= nil and cinematic_bars:Visible() == true)then
			Utilities.print("Skipping the Survival battle cinematic")
			Common_Actions.trigger_shortcut("ESCAPE")
			Lib.Battle.Misc.ensure_battle_loaded()
		else
			Lib.Helpers.Misc.wait(3)
			Lib.Battle.Misc.ensure_battle_loaded()
		end
	end)
end


local function get_map_name()
    -- returns the map name from within battle, or from the pre-battle panel if auto-resolving
	local map_name = Lib.Components.Campaign.map_name()
	if(map_name) then
		return map_name:GetStateText()
	else
		return common.get_context_value("CcoBattleRoot", "", "BattleNameText")
	end
end

function Lib.Battle.Misc.log_pre_battle_save(map_name)
	callback(function()
		if(g_pre_battle_save) then
			Utilities.print("----- INFO: copying pre-battle save file -----")
			local appdata = os.getenv("APPDATA")
			local save_name = Functions.find_file_from_partial_name(g_pre_battle_save, appdata..[[\The Creative Assembly\Warhammer3\save_games]])
			local folder_name = common.game_version()
			map_name = map_name or get_map_name()
			g_save_location = g_save_location or [[\\casan02\tw\Automation\Results\Terrain_logs]]
			Utilities.print([[LOGS! ]]..g_save_location..[[\WH3\]]..folder_name)
			os.execute([[xcopy ]]..appdata..[[\"The Creative Assembly"\Warhammer3\save_games\"]]..save_name..[[" ]]..g_save_location..[[\WH3\"]]..folder_name..[["\"]]..map_name..[[".save* /Y]])
		end
	end)
	Lib.Helpers.Misc.wait(1)
end

function Lib.Battle.Misc.log_terrain_html(map_name)
	callback(function()
		Utilities.print("----- INFO: copying terrain html -----")
		local appdata = os.getenv("APPDATA")
		local folder_name = common.game_version()
		map_name = map_name or get_map_name()
		g_save_location = g_save_location or [[\\casan02\tw\Automation\Results\Terrain_logs]]
		Utilities.print([[LOGS! ]]..g_save_location..[[\WH3\]]..folder_name)
		os.execute([[xcopy ]]..appdata..[[\"The Creative Assembly"\Warhammer3\logs\terrain.html ]]..g_save_location..[[\WH3\"]]..folder_name..[["\"]]..map_name..[[".html* /Y]])
	end)
	Lib.Helpers.Misc.wait(1)
end

function Lib.Battle.Misc.log_terrain_screenshot(map_name)
	callback(function()
		local filename = os.date("autotest_%d%m%y%H%M%S")
		local appdata = os.getenv("APPDATA")
		Utilities.print("----- INFO: taking battle screenshot -----")
		Common_Actions.take_screenshot(filename)
		Lib.Helpers.Misc.wait(1)
		callback(function()
			local folder_name = common.game_version()
			map_name = map_name or get_map_name()
			g_save_location = g_save_location or [[\\casan02\tw\Automation\Results\Terrain_logs]]
			Utilities.print([[LOGS! ]]..g_save_location..[[\WH3\]]..folder_name)
			os.execute([[xcopy ]]..appdata..[[\"The Creative Assembly"\Warhammer3\screenshots\]]..filename..[[.tga ]]..g_save_location..[[\WH3\"]]..folder_name..[["\"]]..map_name..[[".tga* /Y]])
			os.execute([[del /f ]]..appdata..[[\"The Creative Assembly"\Warhammer3\screenshots\]]..filename..[[.tga]])
		end)
		Lib.Helpers.Misc.wait(1)
	end)
end

local function get_active_barrier_count()
	local barrier_count = 0
	Timers_Callbacks.battle_call(function()
		local toggle_system = bm:toggle_system()
		local tog_count = toggle_system:toggle_slot_count()

		if(tog_count > 0) then
			for i = 1, tog_count do
				local tog_slot = toggle_system:toggle_slot(i)
				if(tog_slot) then
					local type = tog_slot:slot_type()
					if(type == "Map Barrier") then
						local bar_enabled = tog_slot:map_barrier():enabled()
						barrier_count = barrier_count + 1
					end
				end
			end
		end

	end)
	return barrier_count
end

local function get_current_survival_point()
	-- survival maps have 3 stages, if 2 barriers are active, we are at stage 1, 1 active, we are at stage 2, 0 active we are at stage 3
	-- If they ever add a map with more than 3 points this will need to be re-addressed.
	return 3 - get_active_barrier_count()
end

local function check_player_owns_current_survival_point()
	-- if both barriars are enabled still, that means the current point is 1.
	local current_point = get_current_survival_point()
	return Lib.Battle.Unit_Controller.check_point_player_owned(current_point)
end

local function concede_survival_battle_after_duration(duration)
	callback(function()
		-- performs survival battle actions while waiting to concede
		local battle_end = Lib.Components.Battle.button_dismiss_results()
		if(battle_end ~= nil and battle_end:Visible() == true) then
			Lib.Battle.Clicks.button_dismiss_results()
			Lib.Helpers.Misc.wait(5)
			Lib.Battle.Misc.handle_battle_results()
		elseif(duration > 0) then
			duration = duration - 1
			local point_to_target = Lib.Battle.Unit_Controller.get_valid_capture_point_by_pathfind()
			if(point_to_target ~= nil) then
				Lib.Battle.Unit_Controller.capture_survival_point(point_to_target)
			else
				Lib.Battle.Unit_Controller.release_script_unit_control()
				local build_chance = math.random(1,10)
				if(build_chance == 1) then
					-- this hovers over a component for 1s so reducing duration further.
					duration = duration - 1
					Lib.Battle.Misc.build_random_available_construct()
				end
			end
			concede_survival_battle_after_duration(duration)
		else
			Lib.Battle.Misc.concede_battle()
		end
	end, wait.standard)
end

function Lib.Battle.Misc.ensure_quest_battle_loaded()
	callback(function()
		local start_button = Lib.Components.Battle.start_battle()
		if (start_button ~= nil) then
			Utilities.print("BATTLE HAS LOADED")
		else
			Lib.Battle.Misc.ensure_quest_battle_loaded()
		end
	end)
end

function Lib.Battle.Misc.handle_start_quest_battle()
	callback(function()
		Lib.Battle.Clicks.start_battle()
		Lib.Helpers.Misc.wait(1)
	end)
end

function Lib.Battle.Misc.concede_battle_after_duration(duration)
	callback(function()
		local battle_end = Lib.Components.Battle.button_dismiss_results()
		if(battle_end ~= nil and battle_end:Visible() == true) then
			Lib.Battle.Clicks.button_dismiss_results()
			Lib.Battle.Misc.handle_battle_results()
		elseif(duration > 0) then
			duration = duration - 1
			if(g_battle_settings ~= nil and g_battle_settings["Map Type"] == "Survival Battle") then
				concede_survival_battle_after_duration(duration)
			else
				Lib.Battle.Misc.concede_battle_after_duration(duration)
			end
		else
			Lib.Battle.Misc.concede_battle()
		end
	end, wait.standard)
end

function Lib.Battle.Misc.concede_battle_when_ended(dont_return_to_main_menu)
	m_dont_return_to_main_menu = dont_return_to_main_menu
	callback(function()
		local battle_end = Lib.Components.Battle.button_dismiss_results()
		local battle_results_continue = Lib.Components.Battle.battle_results_continue()
		if(battle_end ~= nil and battle_end:Visible() == true or battle_results_continue ~= nil and battle_results_continue:Visible() == true) then
			if(battle_end ~= nil and battle_end:Visible() == true) then Lib.Battle.Clicks.button_dismiss_results() end --this button doesnt always appear...
			Lib.Battle.Misc.handle_battle_results()
		else
			Lib.Battle.Misc.concede_battle_when_ended(dont_return_to_main_menu)
		end
	end, wait.standard)
end

function Lib.Battle.Misc.concede_battle()
    callback(function()
		callback(function()
			g_battle_name_from_cco = common.get_context_value("CcoBattleRoot", "", "BattleNameText")
			g_battle_type_from_cco = common.get_context_value("CcoBattleRoot", "", "BattleTypeState")
			g_faction_name_from_cco = common.get_context_value("CcoBattleRoot", "", "PlayerArmyContext.FactionName")
		end)
        Lib.Menu.Misc.open_menu_without_fail()
        Lib.Menu.Clicks.concede_battle()
		Lib.Menu.Clicks.popup_confirm()
		Lib.Helpers.Misc.wait(1)
		Lib.Helpers.Timers.start_timer()
		callback(function()
			-- with AI battles, this step is skipped.
			local in_battle_results = Lib.Components.Battle.button_dismiss_results()
			if(in_battle_results ~= nil and in_battle_results:Visible() == true) then
				Lib.Battle.Clicks.button_dismiss_results()
			end
		end)
		Lib.Helpers.Misc.wait(1)
		Lib.Battle.Misc.handle_battle_results()
    end, wait.long)
end

function Lib.Battle.Misc.handle_battle_results()
	callback(function()
		-- If the battle was a custom battle, there will be battle results
		local battle_results = Lib.Components.Menu.results_continue()
		if(battle_results ~= nil and battle_results:Visible() == true) then
			Lib.Menu.Clicks.results_continue()
			Lib.Helpers.Timers.end_timer("Return to Frontend Time")
			Lib.Helpers.Misc.wait(3)
			if(not m_dont_return_to_main_menu)then
				Lib.Frontend.Clicks.return_to_main_menu()
			end
		elseif(Lib.Campaign.Actions.get_campaign_battle_fought() == true) then
			-- Battle has loaded back into campaign, end campaign battle load timer
			Lib.Helpers.Timers.end_timer("Return to Campaign Time")
			if g_battle_name ~= nil then
				Lib.Helpers.Timers.write_campaign_timers_to_file("Campaign Battle to Campaign Map ("..g_battle_name..")")
			end
		else
			-- Check if a post campaign battle event has triggered (campaign battles have different post battle screens)
			Lib.Battle.Misc.handle_battle_results()
			
		end
	end, wait.standard)
end

local function get_active_build_point_list()
	local keys = {}
	local bp_count, bp_list = Common_Actions.get_visible_child_count(Lib.Components.Battle.survival_build_point_parent())

	for k, v in pairs(bp_list) do
		if(v:CurrentState() == "active") then
			table.insert(keys, v)
		end
	end

	return keys
end

local function click_random_construct(build_point)
	callback(function()
		if(build_point) then
			local build_point_id = build_point:Id()
			local const_count, const_list = Common_Actions.get_visible_child_count(Lib.Components.Battle.survival_build_point_option_parent(build_point_id))

			if(const_count > 0) then

				local construct_choice = math.random(1, const_count)
				local construct = const_list[construct_choice]
				local construct_id = construct:Id()

				if(construct ~= nil and construct:CurrentState() == "active") then
					Lib.Battle.Clicks.survival_build_point_option_select(build_point_id, construct_id)
				end
			end
		end
	end)
end

function Lib.Battle.Misc.build_random_available_construct()
	callback(function()
		local active_bp_list = get_active_build_point_list()
		if(#active_bp_list > 0) then
			local build_point = active_bp_list[math.random(1, #active_bp_list)]
			Functions.hover_over_component_then_call_function(build_point, function() 
				click_random_construct(build_point)
			end) 
		end
	end)
end