-- this requires a table containing the benchmarks you want to run
function Lib.Compat.Loops.run_each_benchmark_from_provided_table(benchmarks_table, benchmark_run_count)
    callback(function()
        for i = 1,benchmark_run_count,1 do
            if (benchmarks_table ~= nil) then
                for _, benchmark in ipairs(benchmarks_table) do
                    Lib.Frontend.Misc.ensure_frontend_loaded()
                    Lib.Frontend.Loaders.load_benchmark(nil, benchmark)
                    Lib.Helpers.Misc.exit_benchmark_when_finished()
                    Lib.Frontend.Misc.return_to_frontend()
                end
            end
        end
    end)
end

--####################################
--## VRAM budget logging functions ###
--####################################

local m_vram_settings_table = {"Low", "Medium", "High", "Ultra"} --all the presets the sweep will run on
local m_vram_benchmark_table = {"battle benchmark","siege_benchmark","campaign benchmark"} --all the benchmarks the sweep will execute

--runs through all benchmarks in m_vram_benchmarks_table
local function run_vram_benchmarks()
    callback(function()
        for _,benchmark in ipairs(m_vram_benchmark_table) do
            Lib.Frontend.Loaders.load_benchmark(nil, benchmark) --nil is to ensure the load_benchmark function doesn't change graphics preset/settings
            Lib.Helpers.Misc.exit_benchmark_when_finished(benchmark, true) --true is to enable vram logging
        end
    end)
end

--get function for benchmark table, used in helpers/misc.lua to dynamically create the header for the vram log file
function Lib.Compat.Loops.get_vram_benchmark_table()
    return m_vram_benchmark_table
end

--loop through every preset in the settings table
--for each preset run all the benchmarks in the benchmark table and log the vram budget at the end
--once all benchmarks are done return to frontend and log vram budget there
function Lib.Compat.Loops.vram_budget_loop()
    callback(function()
        for texture_setting,preset in ipairs(m_vram_settings_table) do
            Lib.Frontend.Options.navigate_to_options_set_preset_and_texture_quality(preset,texture_setting)
            Lib.Compat.Misc.add_string_to_log_line(preset) --add the preset to the logline
            run_vram_benchmarks()
            Lib.Frontend.Misc.return_to_frontend()
            --record vram usage on front end
            Lib.Compat.Misc.log_vram()

            --once all benchmarks are done and we are in the front end we have completed the run for this preset so write the log line to the log file
            Lib.Compat.Misc.log_vram_line_to_file()
        end
    end)  
end

--##### Resolution stability loops #####--

function Lib.Compat.Loops.resolution_stability_loop(log_csv, game_mode, display_mode)
    callback(function()
        local resolution_count, resolution_list = Common_Actions.get_dropdown_list_count(Lib.Components.Frontend.resolution_dropdown())
        for _,resolution in ipairs(resolution_list) do
            local used_resolution = UIComponent(resolution:Find("row_tx")):GetStateText()
            Lib.Frontend.Options.select_resolution(used_resolution)
            if log_csv then
                Functions.write_to_document(game_mode..","..display_mode..","..used_resolution..",Pass", g_reso_stab_log_location, g_reso_stab_log_name, ".csv", false, true)
            end
            Lib.Helpers.Misc.wait(2, true)
        end
    end)
end