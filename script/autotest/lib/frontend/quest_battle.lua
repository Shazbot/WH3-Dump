--Autotest Member Variables
local m_quest_battle_loaded

function Lib.Frontend.Quest_Battle.select_faction(faction_choice)
    callback(function()
        Lib.Frontend.Clicks.quest_battle_change_faction()
		Lib.Helpers.Misc.wait(1, true)
		local faction_list_box = Lib.Components.Frontend.quest_battle_faction_list_box()
		if (faction_list_box ~= nil) then
			local faction_count, faction_list = Common_Actions.get_visible_child_count(Lib.Components.Frontend.quest_battle_faction_list_box())
			if faction_choice == "Random" then
				local random_faction_number = math.random(1, faction_count)
				local faction_object = faction_list[random_faction_number]
				local faction_context_object = faction_object:GetContextObjectId("CcoCultureRecord")
				local name_component = common.get_context_value("CcoCultureRecord", faction_context_object, "Name")
				Utilities.print("SELECTING - "..name_component)
				Common_Actions.click_component(faction_object)
			else
				for k,v in pairs(faction_list) do
					local faction_object = v:GetContextObjectId("CcoCultureRecord")
					local name_component = common.get_context_value("CcoCultureRecord", faction_object, "Name")
					if (name_component == faction_choice) then
						Common_Actions.click_component(v)
						break
					end
				end
			end
		else
			Utilities.print("COULDNT FIND THE FACTION BOX")
		end
    end)
end

function Lib.Frontend.Quest_Battle.select_lord(lord)
    callback(function()
		local lord_count, lord_list = Common_Actions.get_visible_child_count(Lib.Components.Frontend.quest_battle_lord_parent())
		if (lord == "Random") then
			lord = math.random(1, lord_count)
		end
        local lord_id = lord_list[lord]:Id()
        Lib.Frontend.Clicks.quest_battle_lord_select(lord_id)
    end)
end

function Lib.Frontend.Quest_Battle.select_and_load_quest_battle(battle_id)
	callback(function()
		Lib.Frontend.Clicks.quest_battle_select(battle_id)
		Lib.Frontend.Clicks.quest_battle_start()
		Lib.Helpers.Misc.wait(2)
	end)
end

local function get_random_quest_faction()
	Lib.Frontend.Clicks.quest_battle_change_faction()
    local faction_count, faction_list = Common_Actions.get_dropdown_list_count(Lib.Components.Frontend.quest_battle_change_faction())
    local faction_choice = math.random(1, faction_count)
	local faction_object = faction_list[faction_choice]
	local faction_cco_object = faction_object:GetContextObjectId("CcoCultureRecord")
	local faction_name = common.get_context_value("CcoCultureRecord", faction_cco_object, "Name")
	Utilities.print(faction_name)
    return faction_name
end

function Lib.Frontend.Quest_Battle.set_faction_id_and_battle_count(faction)
    Lib.Frontend.Clicks.battles_tab()
    Lib.Frontend.Clicks.quest_battle()
    callback(function()
        faction = faction or get_random_quest_faction()
        g_quest_battle_faction = faction
        Lib.Frontend.Quest_Battle.select_faction(faction)
    end)
    callback(function()
        g_quest_battle_list = {}
        local lord_count = Common_Actions.get_visible_child_count(Lib.Components.Frontend.quest_battle_lord_parent())
        for i = 1, lord_count do
            Lib.Frontend.Quest_Battle.select_lord(i)
			local battle_count = Common_Actions.get_visible_child_count(Lib.Components.Frontend.quest_battle_select_parent())
			table.insert(g_quest_battle_list, battle_count)
        end
    end)
    Lib.Frontend.Clicks.return_to_main_menu()
end

local function handle_results_screen()
	callback(function()
		local battle_results = Lib.Components.Menu.results_continue()
		if(battle_results ~= nil and battle_results:Visible() == true) then
			Lib.Menu.Clicks.results_continue()
		else
			handle_results_screen()
		end
	end, wait.standard)
end

local function concede_quest_battle()
	callback(function()
		Lib.Menu.Misc.open_menu_without_fail()
		Lib.Menu.Clicks.concede_battle()
		Lib.Menu.Clicks.popup_confirm()
		Lib.Helpers.Timers.start_timer()
		callback(function()
			-- with AI battles, this step is skipped.
			local in_battle_results = Lib.Components.Battle.button_dismiss_results()
			if(in_battle_results ~= nil and in_battle_results:Visible() == true) then
				Lib.Battle.Clicks.button_dismiss_results()
			end
		end)
		Lib.Helpers.Misc.wait(3)
		handle_results_screen()
	end, wait.long)
end

local function confirm_quest_battle_start_and_concede(battle_duration, battle_id)
	callback(function()
		Utilities.print("CHECKING FOR BATTLE STARTED")
		local quest_battle_start_button = Lib.Components.Frontend.quest_battle_start()
		if (quest_battle_start_button == nil) then
			Lib.Battle.Misc.ensure_quest_battle_loaded()
			g_quest_battle_elastic_table.battle_loaded = true
			m_quest_battle_loaded = true
			Lib.Battle.Misc.handle_start_quest_battle()
			concede_quest_battle()
		else
			Utilities.print("Battle ID: "..battle_id.." failed to start!")
			m_quest_battle_loaded = false
			table.insert(g_failed_to_load_quest_battles, battle_id)
		end
	end)
end

function Lib.Frontend.Quest_Battle.send_quest_battle_elastic_data(faction, quest_battle_name)
	callback(function()
		if m_quest_battle_loaded == true then
			g_quest_battle_elastic_table.concede_and_exit = true
		else
			g_quest_battle_elastic_table.concede_and_exit = nil
		end
		g_quest_battle_elastic_table.Time_Stamp = os.date("%Y/%m/%d %X")
		g_quest_battle_elastic_table.quest_battle_name = quest_battle_name
		if string.find(quest_battle_name, ":") then
			quest_battle_name = quest_battle_name:gsub("%:", "")
		end
		local quest_battle_name_fixed = quest_battle_name:gsub("%s+", "_")
		local file_name = faction.."_"..quest_battle_name_fixed.."_full_sweep.json"
		Lib.Elastic.Misc.create_data_file(file_name)
	end)
end

function Lib.Frontend.Quest_Battle.load_full_sweep_quest_battles(faction, lord, battle_duration)
	callback(function()
		Utilities.print("FULL SWEEP STARTING!")
		local lord_name_component = Lib.Components.Frontend.quest_battle_lord_name()
		local lord_name = lord_name_component:GetStateText()
		g_quest_battle_elastic_table.selected_lord =  lord_name
		local battle_count, battle_table = Common_Actions.get_visible_child_count(Lib.Components.Frontend.quest_battle_list())
		callback(function()
			for i=1, battle_count do
				Lib.Helpers.Misc.wait(2)
				local quest_table_context_object = Lib.Components.Frontend.quest_battle_localised_name(battle_table[i])
				local quest_battle_name = quest_table_context_object:GetStateText()
				local battle_id =  battle_table[i]:Id()
				Lib.Frontend.Quest_Battle.select_and_load_quest_battle(battle_id)
				callback(function()
					confirm_quest_battle_start_and_concede(battle_duration, battle_id)
					Lib.Frontend.Misc.ensure_quest_battle_menu_loaded()
					Lib.Frontend.Quest_Battle.send_quest_battle_elastic_data(faction, quest_battle_name)
					if (i < battle_count) then
						Lib.Frontend.Quest_Battle.renavigate_to_faction_and_lord(faction, lord)
					end
				end)
			end
			callback(function()
				Lib.Frontend.Clicks.return_to_main_menu()
			end)
		end)
	end)
end

function Lib.Frontend.Quest_Battle.load_random_quest_battle(battle_duration)
	callback(function()
		local lord_name_component = Lib.Components.Frontend.quest_battle_lord_name()
		local lord_name = lord_name_component:GetStateText()
		g_quest_battle_elastic_table.selected_lord =  lord_name
		local battle_count, battle_table = Common_Actions.get_visible_child_count(Lib.Components.Frontend.quest_battle_list())
		local random_number = math.random(1, battle_count)
		if (battle_table[random_number]:Visible() == true) then
			Lib.Helpers.Misc.wait(2)
			local quest_table_context_object = Lib.Components.Frontend.quest_battle_localised_name(battle_table[random_number])
			local quest_battle_name = quest_table_context_object:GetStateText()
			local battle_id =  battle_table[random_number]:Id()
			Lib.Frontend.Quest_Battle.select_and_load_quest_battle(battle_id)
			callback(function()
				confirm_quest_battle_start_and_concede(battle_duration)
				Lib.Frontend.Misc.ensure_quest_battle_menu_loaded()
				Lib.Frontend.Quest_Battle.send_quest_battle_elastic_data(g_quest_battle_elastic_table.selected_faction, quest_battle_name)
			end)
			Lib.Frontend.Clicks.return_to_main_menu()
		else
			Lib.Frontend.Quest_Battle.load_random_quest_battle(battle_duration)
		end
	end)
end

function Lib.Frontend.Quest_Battle.load_specific_quest_battle(battle_choice, battle_duration)
	callback(function()
		local lord_name_component = Lib.Components.Frontend.quest_battle_lord_name()
		local lord_name = lord_name_component:GetStateText()
		g_quest_battle_elastic_table.selected_lord =  lord_name
		local _, battle_table = Common_Actions.get_visible_child_count(Lib.Components.Frontend.quest_battle_list())
		if (battle_table[battle_choice]:Visible() == true) then
			local quest_table_context_object = Lib.Components.Frontend.quest_battle_localised_name(battle_table[battle_choice])
			local quest_battle_name = quest_table_context_object:GetStateText()
			local battle_id =  battle_table[battle_choice]:Id()
			Lib.Frontend.Quest_Battle.select_and_load_quest_battle(battle_id)
			callback(function()
				confirm_quest_battle_start_and_concede(battle_duration)
				Lib.Frontend.Misc.ensure_quest_battle_menu_loaded()
				Lib.Frontend.Quest_Battle.send_quest_battle_elastic_data(g_quest_battle_elastic_table.selected_faction, quest_battle_name)
			end)
			Lib.Frontend.Clicks.return_to_main_menu()
		end
	end)
end

function Lib.Frontend.Quest_Battle.renavigate_to_faction_and_lord(faction, lord)
	callback(function()
		local faction_header = Lib.Components.Frontend.quest_battle_faction_header()
		if (faction_header ~= nil) then
			local current_faction = faction_header:GetStateText()
			if (current_faction ~= faction) then
				Utilities.print("Faction and Lord are incorrect. Switching to correct Faction and Lord...")
				Lib.Frontend.Loaders.quest_battle_setup(faction, lord)
			end
		end
	end)
end
