require "data.script.autotest.lib.all"

local file = [[\\casan05\tw\Automation\WH3\Dev\active_script_folder\DLC_Masks\?.lua]]
package.path = package.path .. ";" ..file
require "dlc_masks_table"

local appdata = os.getenv('APPDATA')
local location = appdata .. [[\CA_Autotest\WH3\]]
local mask_file = location..[[chosen_dlc_mask.txt]]
local dlc_mask_filehandle = io.open(mask_file, 'r')
local mask = dlc_mask_filehandle:read()
dlc_mask_filehandle:close()
local observer_script_path = Lib.Elastic.Misc.get_observer_path()
local elastic_log_index = string.format("%q", "nightly")
io.popen('start cmd /c python.exe -u '..observer_script_path.." "..elastic_log_index, 'r')
g_dlc_mask_elastic_table = {}
g_enabled_dlc = {}

Timers_Callbacks.suppress_intro_movie()
Lib.Helpers.Init.script_name("WH3 Faction Load Test")
Lib.Frontend.Misc.ensure_frontend_loaded()
local build_number, cl_number = Utilities.get_build_number_and_cl_number()
local build_stream = Utilities.get_build_stream()
g_dlc_mask_elastic_table.stream = build_stream
g_dlc_mask_elastic_table.build_number = build_number
g_dlc_mask_elastic_table.cl_number = cl_number
g_dlc_mask_elastic_table.chosen_dlc_mask = mask
g_dlc_mask_elastic_table.active_masks = {}

Lib.Frontend.Loaders.load_chaos_campaign("Skarbrand the Exiled")

Lib.Campaign.Misc.confirm_dlc_is_enabled(mask)
callback(function()
	for _,game in pairs(nw_game_index) do
		Utilities.print("Checking DLC Masks for "..game)
		for game_key, dlc_mask in pairs(nw_dlc_masks[game]) do
			Utilities.print("Checking "..dlc_mask)
			if dlc_mask ~= mask then
				Lib.Campaign.Misc.confirm_dlc_is_enabled(dlc_mask)
			end
		end
	end
end)
callback(function()
	if (#g_enabled_dlc > 1) then
		Utilities.print("Test failed due to rogue active DLC masks")
		g_dlc_mask_elastic_table.result = "Failed"
		for _, dlc_mask in pairs(g_enabled_dlc) do
			table.insert(g_dlc_mask_elastic_table.active_masks, dlc_mask)
			if dlc_mask ~= mask then
				Utilities.print("DLC Mask "..dlc_mask.." was enabled when it shouldn't of been!")
			end
		end
	else
		Utilities.print("Test passed as only DLC Mask - "..mask.." was enabled")
		table.insert(g_dlc_mask_elastic_table.active_masks, g_enabled_dlc[1])
		g_dlc_mask_elastic_table.result = "Passed"
	end
	g_dlc_mask_elastic_table.Time_Stamp = os.date("%Y/%m/%d %X")
	Lib.Elastic.Misc.send_dlc_mask_data(g_dlc_mask_elastic_table)
end)

Lib.Menu.Misc.quit_to_frontend()
Lib.Frontend.Misc.quit_to_windows()