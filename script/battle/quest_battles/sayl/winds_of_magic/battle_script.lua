load_script_libraries();

local gc = generated_cutscene:new(true);

gb = generated_battle:new(
                false,                          -- screen starts black
                false,                          -- prevent deployment for player
                true,                    	    -- prevent deployment for ai
                nil,      						-- intro cutscene function
                false                           -- debug mode
);

---------------------------
----HARD SCRIPT VERSION----
---------------------------
local sm = get_messager();

------------------------------
----------ARMY SETUP----------
------------------------------
ga_player_01 = gb:get_army(gb:get_player_alliance_num());
--Enemy Casters
ga_ai_casters = gb:get_army(gb:get_non_player_alliance_num(), "caster");
--Enemy Forces
ga_ai_main_forces = gb:get_army(gb:get_non_player_alliance_num(), "main_forces");

caster_01 = ga_ai_casters.sunits:item(1);
caster_02 = ga_ai_casters.sunits:item(2);

---------------------------------------
----------COMPOSITION UPDATES----------
---------------------------------------
local casters_objective = "sort_me";
local casters_hint = "sort_me";

local fire_caster_active = false;
local metal_caster_active = false;
local light_caster_active = false;
local life_caster_active = false;
local death_caster_active = false;
local beasts_caster_active = false;

-----Fire Caster Present-----
if ga_ai_casters:are_unit_types_in_army("wh_main_emp_cha_wizard_fire_0") or ga_ai_casters:are_unit_types_in_army("wh2_dlc15_hef_cha_archmage_fire_0") or ga_ai_casters:are_unit_types_in_army("wh2_dlc13_lzd_cha_slann_mage_priest_fire_0") then
	fire_caster_active = true;
	bm:out("Fire caster found")
end

-----Metal Caster Present-----
if ga_ai_casters:are_unit_types_in_army("wh3_dlc25_emp_cha_wizard_metal") or ga_ai_casters:are_unit_types_in_army("wh2_dlc15_hef_cha_archmage_metal_0") or ga_ai_casters:are_unit_types_in_army("wh2_dlc13_lzd_cha_slann_mage_priest_metal_0") then
	metal_caster_active = true;
	bm:out("Metal caster found")
end

-----Light Caster Present-----
if ga_ai_casters:are_unit_types_in_army("wh_main_emp_cha_wizard_light_0") or ga_ai_casters:are_unit_types_in_army("wh2_dlc15_hef_cha_archmage_light_0") or ga_ai_casters:are_unit_types_in_army("wh2_main_lzd_cha_slann_mage_priest_light_0") then
	light_caster_active = true;
	bm:out("Light caster found")
end

-----Life Caster Present-----
if ga_ai_casters:are_unit_types_in_army("wh_dlc05_emp_cha_wizard_life_0") or ga_ai_casters:are_unit_types_in_army("wh2_dlc15_hef_cha_archmage_life_0") or ga_ai_casters:are_unit_types_in_army("wh2_dlc13_lzd_cha_slann_mage_priest_life_0") then
	life_caster_active = true;
	bm:out("Life caster found")
end

-----Death Caster Present-----
if ga_ai_casters:are_unit_types_in_army("wh2_pro07_emp_cha_wizard_death_0") or ga_ai_casters:are_unit_types_in_army("wh2_dlc15_hef_cha_archmage_death_0") or ga_ai_casters:are_unit_types_in_army("wh2_dlc13_lzd_cha_slann_mage_priest_death_0") then
	death_caster_active = true;
	bm:out("Death caster found")
end

-----Beasts Caster Present-----
if ga_ai_casters:are_unit_types_in_army("wh_dlc03_emp_cha_wizard_beasts_0") or ga_ai_casters:are_unit_types_in_army("wh2_dlc15_hef_cha_archmage_beasts_0") or ga_ai_casters:are_unit_types_in_army("wh2_dlc13_lzd_cha_slann_mage_priest_beasts_0") then
	beasts_caster_active = true;
	bm:out("Beasts caster found")
end

-----Set Objectives & Hints-----
if fire_caster_active == true and metal_caster_active == true then
	bm:out("Fire & Metal casters found, setting Fire & Metal objective & hint")
	casters_objective = "wh3_dlc27_qb_nor_sayl_winds_of_magic_objective_fire_metal"
	casters_hint = "wh3_dlc27_qb_nor_sayl_winds_of_magic_hint_fire_metal"
elseif fire_caster_active == true and light_caster_active == true then
	bm:out("Fire & Light casters found, setting Fire & Light objective & hint")
	casters_objective = "wh3_dlc27_qb_nor_sayl_winds_of_magic_objective_fire_light"
	casters_hint = "wh3_dlc27_qb_nor_sayl_winds_of_magic_hint_fire_light"
elseif fire_caster_active == true and life_caster_active == true then
	bm:out("Fire & Life casters found, setting Fire & Life objective & hint")
	casters_objective = "wh3_dlc27_qb_nor_sayl_winds_of_magic_objective_fire_life"
	casters_hint = "wh3_dlc27_qb_nor_sayl_winds_of_magic_hint_fire_life"
elseif fire_caster_active == true and death_caster_active == true then
	bm:out("Fire & Death casters found, setting Fire & Death objective & hint")
	casters_objective = "wh3_dlc27_qb_nor_sayl_winds_of_magic_objective_fire_death"
	casters_hint = "wh3_dlc27_qb_nor_sayl_winds_of_magic_hint_fire_death"
elseif fire_caster_active == true and beasts_caster_active == true then
	bm:out("Fire & Beasts casters found, setting Fire & Beasts objective & hint")
	casters_objective = "wh3_dlc27_qb_nor_sayl_winds_of_magic_objective_fire_beasts"
	casters_hint = "wh3_dlc27_qb_nor_sayl_winds_of_magic_hint_fire_beasts"
elseif metal_caster_active == true and light_caster_active == true then
	bm:out("Metal & Light casters found, setting Metal & Light objective & hint")
	casters_objective = "wh3_dlc27_qb_nor_sayl_winds_of_magic_objective_metal_light"
	casters_hint = "wh3_dlc27_qb_nor_sayl_winds_of_magic_hint_metal_light"
elseif metal_caster_active == true and life_caster_active == true then
	bm:out("Metal & Life casters found, setting Metal & Life objective & hint")
	casters_objective = "wh3_dlc27_qb_nor_sayl_winds_of_magic_objective_metal_life"
	casters_hint = "wh3_dlc27_qb_nor_sayl_winds_of_magic_hint_metal_life"
elseif metal_caster_active == true and death_caster_active == true then
	bm:out("Metal & Death casters found, setting Metal & Death objective & hint")
	casters_objective = "wh3_dlc27_qb_nor_sayl_winds_of_magic_objective_metal_death"
	casters_hint = "wh3_dlc27_qb_nor_sayl_winds_of_magic_hint_metal_death"
elseif metal_caster_active == true and beasts_caster_active == true then
	bm:out("Metal & Beasts casters found, setting Metal & Beasts objective & hint")
	casters_objective = "wh3_dlc27_qb_nor_sayl_winds_of_magic_objective_metal_beasts"
	casters_hint = "wh3_dlc27_qb_nor_sayl_winds_of_magic_hint_metal_beasts"
elseif light_caster_active == true and life_caster_active == true then
	bm:out("Light & Life casters found, setting Light & Life objective & hint")
	casters_objective = "wh3_dlc27_qb_nor_sayl_winds_of_magic_objective_light_life"
	casters_hint = "wh3_dlc27_qb_nor_sayl_winds_of_magic_hint_light_life"
elseif light_caster_active == true and death_caster_active == true then
	bm:out("Light & Death casters found, setting Light & Death objective & hint")
	casters_objective = "wh3_dlc27_qb_nor_sayl_winds_of_magic_objective_light_death"
	casters_hint = "wh3_dlc27_qb_nor_sayl_winds_of_magic_hint_light_death"
elseif light_caster_active == true and beasts_caster_active == true then
	bm:out("Light & Beasts casters found, setting Light & Beasts objective & hint")
	casters_objective = "wh3_dlc27_qb_nor_sayl_winds_of_magic_objective_light_beasts"
	casters_hint = "wh3_dlc27_qb_nor_sayl_winds_of_magic_hint_light_beasts"
elseif life_caster_active == true and death_caster_active == true then
	bm:out("Life & Death casters found, setting Life & Death objective & hint")
	casters_objective = "wh3_dlc27_qb_nor_sayl_winds_of_magic_objective_life_death"
	casters_hint = "wh3_dlc27_qb_nor_sayl_winds_of_magic_hint_life_death"
elseif life_caster_active == true and beasts_caster_active == true then
	bm:out("Life & Beasts casters found, setting Life & Beasts objective & hint")
	casters_objective = "wh3_dlc27_qb_nor_sayl_winds_of_magic_objective_life_beasts"
	casters_hint = "wh3_dlc27_qb_nor_sayl_winds_of_magic_hint_life_beasts"
elseif death_caster_active == true and beasts_caster_active == true then
	bm:out("Death & Beasts casters found, setting Death & Beasts objective & hint")
	casters_objective = "wh3_dlc27_qb_nor_sayl_winds_of_magic_objective_death_beasts"
	casters_hint = "wh3_dlc27_qb_nor_sayl_winds_of_magic_hint_death_beasts"
else
	bm:out("Casters not found?")
end

--------------------------------------
----------HINTS & OBJECTIVES----------
--------------------------------------
-----OBJECTIVE 1-----
--Defeat the Enemy Forces
gb:set_objective_with_leader_on_message("objective_01", "wh3_dlc27_qb_nor_sayl_winds_of_magic_objective_01");
gb:complete_objective_on_message("enemy_defeated", "wh3_dlc27_qb_nor_sayl_winds_of_magic_objective_01");
gb:remove_objective_on_message("enemy_defeated", "wh3_dlc27_qb_nor_sayl_winds_of_magic_objective_01", 10000);

gb:queue_help_on_message("start", "wh3_dlc27_qb_nor_sayl_winds_of_magic_hint_01");

-----OBJECTIVE 2-----
--Defeat the Casters of X & Y
gb:set_objective_with_leader_on_message("casters_hint_01", casters_objective);
gb:complete_objective_on_message("casters_defeated", casters_objective);
gb:remove_objective_on_message("casters_defeated", casters_objective, 10000);

gb:queue_help_on_message("casters_in", casters_hint);

----------------------------------
----------SPECIAL ORDERS----------
----------------------------------
gb:message_on_time_offset("start", 100);
gb:message_on_time_offset("objective_01", 5000);

caster_01:set_stat_attribute("unbreakable", true);
caster_02:set_stat_attribute("unbreakable", true);

gb:message_on_all_messages_received("enemy_defeated", "casters_defeated", "main_forces_defeated")

ga_player_01:force_victory_on_message("enemy_defeated", 5000);

----------------------------------
----------PHASE 1 ORDERS----------
----------------------------------
ga_ai_main_forces:rush_on_message("start");
ga_ai_main_forces:message_on_rout_proportion("casters_reinforce",0.35);
ga_ai_main_forces:message_on_rout_proportion("main_forces_defeated",0.95);

gb:add_listener(
	"casters_hint_01",
	function()
		caster_01:add_ping_icon(15);
		caster_02:add_ping_icon(15);
	end,
	true
);

----------------------------------
----------PHASE 2 ORDERS----------
----------------------------------
gb:message_on_time_offset("casters_hint_01", 5000, "casters_in");

ga_ai_casters:reinforce_on_message("casters_reinforce");
ga_ai_casters:message_on_any_deployed("casters_in");
ga_ai_casters:rush_on_message("casters_in");
ga_ai_casters:message_on_rout_proportion("casters_defeated",0.95);