--#########################
--## Compat Sweep Tables ##
--#########################

g_presets_resolutions_combos = {}
g_presets_resolutions_combos["Low"] = "min_resolution"
g_presets_resolutions_combos["Medium"] = "random_unused_resolution"
g_presets_resolutions_combos["High"] = "random_unused_resolution"
g_presets_resolutions_combos["Ultra"] = "max_resolution"

g_hardware_info_functions = {}
g_hardware_info_functions["CPU"] = "cpu_name"
g_hardware_info_functions["RAM"] = "ram_amount"
g_hardware_info_functions["OS Version"] = "os_version"
g_hardware_info_functions["OS Region"] = "os_country"
g_hardware_info_functions["OS Language"] = "os_language"
g_hardware_info_functions["Machine Type"] = "machine_type"
g_hardware_info_functions["Native Resolution of Monitor"] = "native_resolution"
g_hardware_info_functions["GPU Driver Version"] = "gpu_driver"

-- not being used anywhere at the moment, but it's a very nice table :)
g_graphics_settings_values = {}
g_graphics_settings_values["texture quality"] = {"Low", "Medium", "High", "Ultra"}
g_graphics_settings_values["shadow detail"] = {"Off", "Medium", "High", "Ultra", "Extreme"}
g_graphics_settings_values["vfx detail"] = {"Low", "Medium", "High", "Ultra"}
g_graphics_settings_values["tree detail"] = {"Low", "Medium", "High", "Ultra"}
g_graphics_settings_values["unit detail"] = {"Low", "Medium", "High", "Ultra"}
g_graphics_settings_values["dof"] = {"Off", "On"}
g_graphics_settings_values["reflections"] = {"Off", "On"}
g_graphics_settings_values["fog"] = {"Low", "High"}
g_graphics_settings_values["anti aliasing"] = {"Off", "FXAA", "TAA", "TAA-High"}
g_graphics_settings_values["texture filtering"] = {"Trilinear", "Anisotropic-2x", "Anisotropic-4x", "Anisotropic-8x", "Anisotropic-16x"}
g_graphics_settings_values["grass detail"] = {"Low", "Medium", "High", "Ultra"}
g_graphics_settings_values["terrain detail"] = {"Low", "Medium", "High", "Ultra"}
g_graphics_settings_values["building detail"] = {"Low", "Medium", "High", "Ultra"}
g_graphics_settings_values["unit size"] = {"Small", "Medium", "Large", "Ultra"}
g_graphics_settings_values["porthole quality"] = {"2D", "3D"}
g_graphics_settings_values["corpse lifespan"] = {"30-sec", "60-sec", "120-sec", "Permanent"}
g_graphics_settings_values["unlimited memory"] = {"Off", "On"}
g_graphics_settings_values["vsync"] = {"Off", "On"}
g_graphics_settings_values["vignette"] = {"Off", "On"}
g_graphics_settings_values["proximity fading"] = {"Off", "On"}
g_graphics_settings_values["ssao"] = {"Off", "On"}
g_graphics_settings_values["sharpening"] = {"Off", "On"}
g_graphics_settings_values["screen space shadows"] = {"Off", "On"}
g_graphics_settings_values["lighting quality"] = {"Low", "High"}

g_loading_times_data = {}
g_loading_times_data["Campaign Load Time"] = " "
g_loading_times_data["Battle Load Time"] = " "
g_loading_times_data["Return to Campaign Time"] = " "
g_loading_times_data["Return to Frontend Time"] = " "

-- Cco returns an unlocalised string as a battle type
g_battle_type_names = {}
g_battle_type_names["land_normal"] = "Land Battle"
g_battle_type_names["land_ambush"] = "Ambush Battle"
g_battle_type_names["land_bridge"] = "Chokepoint Battle"
g_battle_type_names["settlement_unfortified"] = "Minor Settlement Battle"
g_battle_type_names["settlement_standard"] = "Siege Battle"
g_battle_type_names["underground_intercept"] = "Subterranean Battle"
g_battle_type_names["survival"] = "Survival Battle"