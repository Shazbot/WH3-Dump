load_script_libraries();

local file_name, file_path = get_file_name_and_path();

package.path = file_path .. "/?.lua;" .. package.path;
require("wh3_battle_prologue_values");
--AddRematchListener()
HideDismissResults()
HideConcedeButton()
HideRematchButton()
HideReplayButton()

-- load the wh2 intro battle script library
package.path = package.path .. ";script/battle/intro_battles/?.lua"
require("wh2_intro_battle");

bm:load_scripted_tours();

bm:set_close_queue_advice(false);
bm:out("");
bm:out("********************************************************************");
bm:out("********************************************************************");
bm:out("*** Dervingard battle script file loaded");
bm:out("********************************************************************");
bm:out("********************************************************************");
bm:out("");

-- Stores whether the player deployed at the front of the keep.
local player_spawned_at_front = false

--Set up a metric variable to be used in campaign later
core:svr_save_bool("sbool_prologue_dervingard_battle_loaded_in", true);

---------------------------------------------------------------------------
---------------------------------------------------------------------------
--
-- Assign Army Groups and Starting Positions
--
---------------------------------------------------------------------------
---------------------------------------------------------------------------
local player_army = bm:get_scriptunits_for_local_players_army();
local yuri = player_army:get_general_sunit();
local enemy_army = bm:get_scriptunits_for_main_enemy_army_to_local_player()

local boss_group_boss = enemy_army:item(1) -- Skollden
local boss_group_unit_1 = enemy_army:item(14) -- Wolves
local sunits_boss_group = script_units:new(
	"boss_group",
	boss_group_boss,
	boss_group_unit_1
)
boss_group_boss.uc:teleport_to_location(v(-5, 277), 180, 30)
boss_group_unit_1.uc:teleport_to_location(v(15, 277), 180, 15)
sunits_boss_group:set_always_visible(true)



local north_west_unit_1 = enemy_army:item(2) -- Spearmen
local north_west_unit_2 = enemy_army:item(8) -- Javelins
local sunits_north_west = script_units:new(
	"north_west",
	north_west_unit_1,
	north_west_unit_2
)
north_west_unit_1.uc:teleport_to_location(v(-295, 272), 270, 30)
north_west_unit_2.uc:teleport_to_location(v(-290, 272), 270, 30)
sunits_north_west:set_always_visible(true)



local north_east_unit_1 = enemy_army:item(3) -- Spearmen
local north_east_unit_2 = enemy_army:item(9) -- Javelins
local sunits_north_east = script_units:new(
	"north_east",
	north_east_unit_1,
	north_east_unit_2
)
north_east_unit_1.uc:teleport_to_location(v(93, 165), 90, 30)
north_east_unit_2.uc:teleport_to_location(v(77, 165), 90, 30)
sunits_north_east:set_always_visible(true)



local marauders_unit_1 = enemy_army:item(5) -- Marauders
local marauders_unit_2 = enemy_army:item(6) -- Marauders
local sunits_marauders = script_units:new(
	"marauders",
	marauders_unit_1,
	marauders_unit_2

)
marauders_unit_1.uc:teleport_to_location(v(-24.5, -58), 180, 30)
marauders_unit_2.uc:teleport_to_location(v(26, -58), 180, 30)
sunits_marauders:set_always_visible(true)



-- This group.
local valley_unit_1 = enemy_army:item(10) -- Cavalry
local valley_unit_2 = enemy_army:item(11) -- Cavalry
local sunits_valley = script_units:new(
	"valley",
	valley_unit_1,
	valley_unit_2
)
valley_unit_1.uc:teleport_to_location(v(-242.5, 67), 160, 35)
valley_unit_2.uc:teleport_to_location(v(-240.5, 75), 160, 30)
sunits_valley:set_always_visible(true)
sunits_valley:change_behaviour_active("skirmish", false);
sunits_valley:modify_ammo(0)



local wolves_unit_1 = enemy_army:item(12) -- Wolves
local wolves_unit_2 = enemy_army:item(13) -- Wolves
--local wolves_unit_3 = enemy_army:item(14) -- Wolves
local sunits_wolves = script_units:new(
	"wolves",
	wolves_unit_1,
	wolves_unit_2
)
sunits_wolves:set_enabled(false, false, true)
bm:register_phase_change_callback(
	"Deployed",
	function()
		wolves_unit_1.uc:teleport_to_location(v(-163, -333), 20, 15)
		wolves_unit_2.uc:teleport_to_location(v(-159.5, -345), 20, 15)
		sunits_wolves:set_always_visible(true)
    end
)




local middle_east_unit_1 = enemy_army:item(7) -- Marauders
local sunits_middle_east = script_units:new(
	"middle_east",
	middle_east_unit_1
)
middle_east_unit_1.uc:teleport_to_location(v(-18, 88), 235, 30)
sunits_middle_east:set_always_visible(true)



local middle_west_unit_1 = enemy_army:item(4) -- Spearmen
local sunits_middle_west = script_units:new(
	"middle_west",
	middle_west_unit_1
)
middle_west_unit_1.uc:teleport_to_location(v(-204, 133), 180, 30)
sunits_middle_west:set_always_visible(true)



-- Delete the garrison, which are any units after 14.
for i = 1, enemy_army:count() do
	if i > 14 then
		enemy_army:item(i):kill(true)
	end
end

YuriInvulernableWhenRouting() -- Stop Yuri from being wounded.


---------------------------------------------------------------------------
---------------------------------------------------------------------------
--
-- AI Commands
--
---------------------------------------------------------------------------
---------------------------------------------------------------------------

-- Skollden unbreakable.
boss_group_boss:morale_behavior_fearless()

-- Stop units from rallying.
enemy_army:prevent_rallying_if_routing(true)

-- Apply AI planners and orders
bm:register_phase_change_callback(
	"Deployed",
	function()
		-- Release enemy to AI control.
		enemy_army:take_control()
    end
)

-- Area at the front of the settlement.
local ca_player_front_spawn = convex_area:new({
	v(805, -265),
	v(805, -745),
	v(-795, -745),
	v(-795, -265)

})


bm:register_phase_change_callback(
	"Deployed", 
	function()
		-- Cavalry charges if player has spawned at the front.
		bm:callback(
			function()
				bm:watch(
					function()
						return ca_player_front_spawn:standing_is_in_area(player_army)
					end,
					0,
					function()
						player_spawned_at_front = true
						sunits_valley:take_control()
						sunits_valley:start_attack_closest_enemy()
					end
				)
			end,
			1000
		)
	end
)


-- Start wolves once combat begins.
bm:watch(
	function()
		if player_spawned_at_front then
			-- If player spawns at front, ignore charging cav. Listen for everything else.
			return sunits_middle_east:is_under_attack() or sunits_middle_west:is_under_attack() or sunits_wolves:is_under_attack() or sunits_marauders:is_under_attack() or
			sunits_north_east:is_under_attack() or sunits_north_west:is_under_attack() or sunits_boss_group:is_under_attack()
		else
			return enemy_army:is_under_attack()
		end
	end,
	15000,
	function()
		DeployWolves()
	end
)

-- Once Skollen under attack, send support.
bm:watch(
	function()
		return boss_group_boss:is_under_attack()
	end,
	0,
	function()
		enemy_army:take_control()
		enemy_army:start_attack_closest_enemy()
	end
)

-- Send support if wings are under attack.
bm:watch(
	function()
		return sunits_north_west:is_under_attack() or sunits_north_east:is_under_attack()
	end,
	0,
	function()
		sunits_middle_west:take_control()
		sunits_middle_west:start_attack_closest_enemy()
		sunits_middle_east:take_control()
		sunits_middle_east:start_attack_closest_enemy()
	end
)


-- Send support if top wings are under attack.
bm:watch(
	function()
		return sunits_north_west:is_under_attack() or sunits_north_east:is_under_attack()
	end,
	0,
	function()
		sunits_north_west:take_control()
		sunits_north_west:start_attack_closest_enemy()
		sunits_north_east:take_control()
		sunits_north_east:start_attack_closest_enemy()
	end
)

-- Mutual support if groups under attack.
bm:watch(
	function()
		return sunits_marauders:is_under_attack() or sunits_valley:is_under_attack() and player_spawned_at_front == false
	end,
	0,
	function()
		sunits_marauders:take_control()
		sunits_marauders:start_attack_closest_enemy()
		sunits_valley:take_control()
		sunits_valley:start_attack_closest_enemy()
	end
)

-- Mutual support if groups under attack.
bm:watch(
	function()
		return sunits_middle_west:is_under_attack() or sunits_middle_east:is_under_attack()
	end,
	0,
	function()
		sunits_middle_west:take_control()
		sunits_middle_west:start_attack_closest_enemy()
		sunits_middle_east:take_control()
		sunits_middle_east:start_attack_closest_enemy()
	end
)

---------------------------------------------------------------------------
---------------------------------------------------------------------------
--
-- Disable capture points and Toggleables
--
---------------------------------------------------------------------------
---------------------------------------------------------------------------

local cl_1 = bm:get_closest_capture_location(v(80, 137, 408))
local cl_2 = bm:get_closest_capture_location(v(0, 110, 280))
local cl_3 = bm:get_closest_capture_location(v(-150, 108, 115))
local cl_4 = bm:get_closest_capture_location(v(140, 97, 124))
local cl_5 = bm:get_closest_capture_location(v(-26, 93, -26))
if cl_1 then cl_1:set_enabled(false) end
if cl_2 then cl_2:set_enabled(false) end
if cl_3 then cl_3:set_enabled(false) end
if cl_4 then cl_4:set_enabled(false) end
if cl_5 then cl_5:set_enabled(false) end

-- Stop enemy using toggleables
local my_test_army = bm:alliances():item(1):armies():item(1);
my_test_army:allow_use_toggleables(false)

-- Stop everything using toggleables
local my_toggle_system = bm:toggle_system();
my_toggle_system:allow_army_interaction(false);

my_toggle_system:disable_and_refund_all_buildings();

---------------------------------------------------------------------------
---------------------------------------------------------------------------
--
-- Battle Speed scripted tour
--
---------------------------------------------------------------------------
---------------------------------------------------------------------------


bm:register_phase_change_callback(
	"Deployed",
	function()
		bm:callback(function()
			AddObjectiveDefeatSkollden()
		end, 1500)
    end
)


---------------------------------------------------------------------------
---------------------------------------------------------------------------
--
-- Objectives and Messaging
--
---------------------------------------------------------------------------
---------------------------------------------------------------------------

-- Give player objective to defeat Skollden and alert them to his position.
function AddObjectiveDefeatSkollden()
	local defeat_skollden_objective = "wh3_prologue_objective_dervingard_defeat_skollden" 

	bm:queue_help_message("wh3_prologue_help_message_dervingard_skollden", 5000, 2000, true, false)
	bm:callback(function() bm:set_objective_with_leader(defeat_skollden_objective) end, 7000)
	bm:callback(
		function() 
			-- Play Yuri advice line.
			bm:queue_advisor(
				-- The Wolf limps into his lair. I will not give him a chance to lick his wounds. Draw your weapons – we take Dervingard back in Ursun's name!
				"wh3_main_prologue_battle_dervingard_001"
			)
		end, 
		9500
	)

	local ping_position = battle_vector:new(boss_group_boss:position_offset(0, 0, 0):get_x(), boss_group_boss:position_offset(0, 5, 0):get_y(), boss_group_boss:position_offset(0, 0, 0):get_z())
	bm:add_ping_icon(ping_position:get_x(), ping_position:get_y(), ping_position:get_z(), false)
	bm:callback(function() bm:remove_ping_icon(ping_position:get_x(), ping_position:get_y(), ping_position:get_z()) end, 15000)

	bm:watch(
		function()
			return is_routing_or_dead(boss_group_boss)
		end,
		0,
		function()
			bm:remove_process("SkollDeath")
			bm:queue_help_message("wh3_prologue_help_message_dervingard_skollden_defeated", 5000, 2000, true, false)
			bm:complete_objective(defeat_skollden_objective)
			bm:callback(function() bm:remove_objective(defeat_skollden_objective) end, 7000)
		end,
		"SkollDeath"
	)
end

function DeployWolves()
	bm:queue_help_message("wh3_prologue_help_message_dervingard_skollden_wolves", 5000, 2000, true, false)
	bm:add_ping_icon(-165, 100, -594.5, false)
	bm:callback(function() bm:remove_ping_icon(-165, 100, -594.5) end, 10000)
	sunits_wolves:set_enabled(true)
	sunits_wolves:set_always_visible(true)
	-- Start attack.
	sunits_wolves:take_control()
	sunits_wolves:start_attack_closest_enemy()
	--Set up a metric variable to be used in campaign later
	core:svr_save_bool("sbool_prologue_dervingard_battle_wolves_attacked", true);
end

---------------------------------------------------------------------------
---------------------------------------------------------------------------
--
-- End of Battle
--
---------------------------------------------------------------------------
---------------------------------------------------------------------------

-- Set loading screen for rematch.
core:add_listener(
	"post_battle_button_listener",
	"ComponentLClickUp",
	function(context) return context.string == "button_rematch" end,
	function() 
		common.setup_dynamic_loading_screen("prologue_battle_dervingard_intro", "prologue") 
		--Set up a metric variable to be used in campaign later
		core:svr_save_bool("sbool_prologue_dervingard_battle_rematched", true);
	end,
	false
)

bm:register_phase_change_callback(
    "Complete",
	function()
		if bm:victorious_alliance() == yuri.alliance_num then
			bm:out("Player has won!");
		   -- set variable
			core:svr_save_bool("sbool_load_post_open_campaign", true)
	
			common.setup_dynamic_loading_screen("prologue_battle_dervingard_outro", "prologue")

			--Set up a metric variable to be used in campaign later
			core:svr_save_bool("sbool_prologue_dervingard_battle_won", true);
		else
			bm:out("Player has lost!");
		end;
    end
);
