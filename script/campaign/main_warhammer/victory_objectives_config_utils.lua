-- general helpers
local function new_objective(type_key)
	return {
		type = type_key,
		conditions = {},
	}
end

--- @set_environment campaign
--- @data_interface victory_objective_helpers Victory Objective Helpers
--- @dont_prepend_class

----------------------------------------------------------------------------
--- @section Objective and Payload Generators
----------------------------------------------------------------------------
--- @desc Mission objectives are created using generator functions that follow a consistent pattern. Each function returns an objective table with a `type` field and a `conditions` table containing parameter strings.
--- @desc Objectives can be simple (requiring just a type) or complex (requiring multiple parameters like regions, factions, or an amount).
----------------------------------------------------------------------------

--- @function generate_HAVE_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective
--- @desc Accumulate X of a pooled resource
--- @p @string resource_key, Pooled resource (momentum, rampage, etc)
--- @p @number amount, Amount required
--- @p [opt=nil] @boolean additive, Count current total towards objective progress
--- @p [opt=nil] @string override_text, Localised name key, in the [table]_[key]_[field] format.
--- @r table objective and conditions pooled resource
generate_HAVE_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective = function(resource_key, amount, additive, override_text)
	local objective = new_objective("HAVE_AT_LEAST_X_OF_A_POOLED_RESOURCE")
	table.insert(objective.conditions, "pooled_resource " .. resource_key)
	table.insert(objective.conditions, "total " .. tostring(amount))
	if additive then
		table.insert(objective.conditions, "additive " .. tostring(additive))
	end
	if override_text then
		table.insert(objective.conditions, "override_text " .. override_text)
	end

	return objective
end

--- @function generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective
--- @desc All players collectively raze/sack/own X settlements
--- @p @number amount, Total settlements (cooperative)
--- @r table objective and conditions cooperative settlements
generate_ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS_objective = function(amount)
	return {
		type = "ALL_PLAYERS_RAZE_SACK_OR_OWN_X_SETTLEMENTS",
		conditions = {
			"total " .. tostring(amount)
		}
	}
end

--- @function generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective
--- @desc Occupy, loot, raze or sack X settlements
--- @p @number amount, Number of settlements
--- @p [opt=nil] @boolean port_only, Port settlements only
--- @p [opt=nil] @string override_text, Localised name key, in the [table]_[key]_[field] format.
--- @r table objective and conditions settlement actions
generate_OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS_objective = function(amount, port_only, override_text)
	local objective = new_objective("OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS")
	table.insert(objective.conditions, "total " .. tostring(amount))
	if port_only then
		table.insert(objective.conditions, "port_settlements_only " .. tostring(port_only))
	end
	if override_text then
		table.insert(objective.conditions, "override_text " .. override_text)
	end

	return objective
end


--- @function generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective
--- @desc Complete short victory objectives
--- @r table objective and conditions scripted short victory
generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective = function()
	return {
		type = "SCRIPTED",
		conditions = {
			"script_key complete_faction_victory",
			"override_text mission_text_text_ie_attain_faction_victory",
		}
	}
end

--- @function generate_SCRIPTED_MISSION_objective
--- @desc Scripted condition
--- @p @string script_key, Key of the particular scripted objective associated with the mission
--- @p [opt=nil] @string override_text, Localised name key, in the [table]_[key]_[field] format
--- @p [opt=nil] @number total, Total amount of condition completions
--- @p [opt=nil] @number count, Condition completion increased by
--- @p [opt=nil] @boolean count_completion, Automatically set objective completed on once "count" reaches "total"
--- @r table conditions by scripted key
generate_SCRIPTED_MISSION_objective = function(script_key, override_text, total, count, count_completion )
	local objective = new_objective("SCRIPTED")
	table.insert(objective.conditions, "script_key " .. tostring(script_key))
	if override_text then
		table.insert(objective.conditions, "override_text " .. override_text)
	end
	if total then
		table.insert(objective.conditions, "total " .. tostring(total))
	end
	if count then
		table.insert(objective.conditions, "count " .. tostring(count))
	end
	if count_completion then
		table.insert(objective.conditions, "count_completion")
	end

	return objective
end

--- @function generate_DESTROY_FACTION_objective
--- @desc Destroy specific factions completely
--- @p @table factions_table, Table of faction keys to destroy
--- @p [opt=nil] @boolean confederation_valid, Allow confederations to count as destruction
--- @p [opt=nil] @boolean vassalization_valid, Allow vassalization to count
--- @r table objective and conditions destroy faction
generate_DESTROY_FACTION_objective = function(factions_table, confederation_valid, vassalization_valid)
	local objective = new_objective("DESTROY_FACTION")
	for i = 1, #factions_table do
		table.insert(objective.conditions, "faction " .. factions_table[i])
	end
	if confederation_valid then
		table.insert(objective.conditions, "confederation_valid")
	end
	if vassalization_valid then
		table.insert(objective.conditions, "vassalization_valid")
	end

	return objective
end

--- @function generate_PERFORM_RITUAL_BY_CATEGORY_objective
--- @desc Perform ritual by category
--- @p @string ritual_category, Ritual category
--- @p [opt=nil] @number amount, Number to perform
--- @p [opt=nil] @string override_text, Localised name key, in the [table]_[key]_[field] format
--- @r table objective and conditions perform ritual
generate_PERFORM_RITUAL_BY_CATEGORY_objective = function(ritual_category, amount, override_text)
	local objective = new_objective("PERFORM_RITUAL")
	table.insert(objective.conditions, "ritual_category " .. ritual_category)
	if amount ~= nil then
		table.insert(objective.conditions, "total " .. tostring(amount))
	end

	if override_text then
		table.insert(objective.conditions, "override_text " .. override_text)
	end
	return objective
end

--- @function generate_PERFORM_RITUAL_BY_KEY_LIST_objective
--- @desc Perform rituals by specific keys
--- @p @string rituals_list, List of specific ritual keys
--- @p [opt=nil] @number amount, Number to perform
--- @p [opt=nil] @boolean different_types, Count only first completion of each ritual from the list
--- @p [opt=nil] @string override_text, Localised name key, in the [table]_[key]_[field] format
--- @r table objective and conditions perform ritual
generate_PERFORM_RITUAL_BY_KEY_LIST_objective = function(rituals_list, amount, different_types, override_text)
	local objective = new_objective("PERFORM_RITUAL")
	for i = 1, #rituals_list do
		table.insert(objective.conditions, "ritual " .. rituals_list[i])
	end
	if amount ~= nil then
		table.insert(objective.conditions, "total " .. tostring(amount))
	end
	if different_types ~= nil then
		table.insert(objective.conditions, "different_types")
	end

	if override_text then
		table.insert(objective.conditions, "override_text " .. override_text)
	end

	return objective
end

--- @function generate_CONTROL_N_REGIONS_FROM_objective
--- @desc Control N regions from a pool of specific regions
--- @p @table region_list, Table of region keys
--- @p @number amount, Number to control
--- @p [opt=nil] @string override_text, Localised name key, in the [table]_[key]_[field] format.
--- @r table objective and conditions control from regions
generate_CONTROL_N_REGIONS_FROM_objective = function(region_list, amount, override_text)
	local objective = new_objective("CONTROL_N_REGIONS_FROM")
	for i = 1, #region_list do
		table.insert(objective.conditions, "region " .. region_list[i])
	end
	table.insert(objective.conditions, "total " .. tostring(amount))
	if override_text then
		table.insert(objective.conditions, "override_text " .. override_text)
	end

	return objective
end

--- @function generate_CAPTURE_REGIONS_objective
--- @desc Capture specified regions from enemies
--- @p @table region_list, Regions to capture
--- @p [opt=nil] @number amount, Number of regions that must be captured
--- @p [opt=nil] @string faction, Faction to capture from
--- @p [opt=nil] @string enemy_of_faction, Capture regions from this faction's enemies
--- @p [opt=nil] @string subculture, Subculture to capture from
--- @p [opt=nil] @string override_text, Localised name key, in the [table]_[key]_[field] format.
--- @p [opt=nil] @boolean abort_on_allied_capture, Abort the mission if an ally captures regions
--- @p [opt=nil] @boolean ignore_issuer_faction, Ignore issuer faction regions
--- @r table objective and conditions capture regions
generate_CAPTURE_REGIONS_objective = function(region_list, amount, faction, enemy_of_faction, subculture, override_text, abort_on_allied_capture, ignore_issuer_faction)
	local objective = new_objective("CAPTURE_REGIONS")
	for i = 1, #region_list do
		table.insert(objective.conditions, "region " .. region_list[i])
	end
	if faction then
		table.insert(objective.conditions, "faction " .. faction)
	end
	if enemy_of_faction then
		table.insert(objective.conditions, "enemy_of_faction " .. enemy_of_faction)
	end
	if subculture then
		table.insert(objective.conditions, "subculture " .. subculture)
	end
	if amount then
		table.insert(objective.conditions, "total " .. tostring(amount))
	end
	if override_text then
		table.insert(objective.conditions, "override_text " .. override_text)
	end
	if not abort_on_allied_capture then
		table.insert(objective.conditions, "ignore_allies")
	end
	if ignore_issuer_faction then
		table.insert(objective.conditions, "ignore_issuer_faction")
	end

	return objective
end

--- @function generate_RAZE_OR_SACK_N_DIFFERENT_SETTLEMENTS_INCLUDING_objective
--- @desc Raze or sack N different settlements including specific ones
--- @p @table region_list, Required settlements
--- @p @number amount, Total to raze/sack
--- @p [opt=nil] @string enemy_of_faction, Capture regions from this faction's enemies
--- @p [opt=nil] @string override_text, Localised name key, in the [table]_[key]_[field] format.
--- @p [opt=nil] @boolean process_listed_regions_only, Restrict to regions specified in region_list
--- @p [opt=nil] @boolean ignore_issuer_faction, Abort if the issuer faction captures any of the settlements
--- @p [opt=nil] @boolean prevent_fail_if_sacked_or_razed_by_other, Do not fail if another faction razes/sacks the settlements
--- @r table objective and conditions raze settlements
generate_RAZE_OR_SACK_N_DIFFERENT_SETTLEMENTS_INCLUDING_objective = function(region_list, amount, enemy_of_faction, override_text, ignore_issuer_faction, prevent_fail_if_sacked_or_razed_by_other)
	local objective = new_objective("RAZE_OR_SACK_N_DIFFERENT_SETTLEMENTS_INCLUDING")
	for i = 1, #region_list do
		table.insert(objective.conditions, "region " .. region_list[i])
	end
	table.insert(objective.conditions, "total " .. tostring(amount))
	if enemy_of_faction then
		table.insert(objective.conditions, "enemy_of_faction " .. enemy_of_faction)
	end
	if override_text then
		table.insert(objective.conditions, "override_text " .. override_text)
	end
	if ignore_issuer_faction then
		table.insert(objective.conditions, "ignore_issuer_faction " .. tostring(ignore_issuer_faction))
	end
	if prevent_fail_if_sacked_or_razed_by_other then
		table.insert(objective.conditions, "prevent_fail_if_sacked_or_razed_by_other " .. tostring(prevent_fail_if_sacked_or_razed_by_other))
	end

	return objective
end


--- @function generate_OWN_AT_LEAST_ONE_SOURCE_OF_EACH_RESOURCE_objective
--- @desc Control at least one source of each strategic resource
--- @r table objective and conditions resource control
generate_OWN_AT_LEAST_ONE_SOURCE_OF_EACH_RESOURCE_objective = function()
	return new_objective("OWN_AT_LEAST_ONE_SOURCE_OF_EACH_RESOURCE")
end

--- @function generate_END_REBELLION_objective
--- @desc End rebellion in a region
--- @p @string region_key, Region key from campaign_map_settlements table
--- @r table objective and conditions end rebellion
generate_END_REBELLION_objective = function(region_key)
	local objective = new_objective("END_REBELLION")
	table.insert(objective.conditions, "region " .. region_key)
	return objective
end

--- @function generate_LIFT_BLOCKADE_objective
--- @desc Lift a blockade from a region
--- @p @string region_key, Region to lift blockade from
--- @r table objective and conditions lift blockade
generate_LIFT_BLOCKADE_objective = function(region_key)
	local objective = new_objective("LIFT_BLOCKADE")
	table.insert(objective.conditions, "region " .. region_key)
	return objective
end

--- @function generate_FULLY_OWN_N_SEA_REGIONS_objective
--- @desc Fully control N sea regions with no contested areas
--- @desc Control of sea region means controlling all adjoining port regions
--- @p @number amount, Number of sea regions to control
--- @r table objective and conditions sea regions
generate_FULLY_OWN_N_SEA_REGIONS_objective = function(amount)
	local objective = new_objective("FULLY_OWN_N_SEA_REGIONS")
	table.insert(objective.conditions, "total " .. tostring(amount))
	return objective
end

--- @function generate_MAKE_ALLIANCE_objective
--- @desc Form an alliance with a specific faction
--- @p @string faction_key, Target faction key
--- @r table objective and conditions alliance
generate_MAKE_ALLIANCE_objective = function(faction_key)
	local objective = new_objective("MAKE_ALLIANCE")
	table.insert(objective.conditions, "faction " .. faction_key)
	return objective
end

--- @function generate_MAKE_TRADE_AGREEMENT_objective
--- @desc Establish a trade agreement with a faction
--- @p @string faction_key, Target faction key
--- @r table objective and conditions trade agreement
generate_MAKE_TRADE_AGREEMENT_objective = function(faction_key)
	local objective = new_objective("MAKE_TRADE_AGREEMENT")
	table.insert(objective.conditions, "faction " .. faction_key)
	return objective
end

--- @function generate_MAKE_PEACE_objective
--- @desc Make peace with an enemy faction
--- @p @string faction_key, Enemy faction key
--- @r table objective and conditions peace
generate_MAKE_PEACE_objective = function(faction_key)
	local objective = new_objective("MAKE_PEACE")
	table.insert(objective.conditions, "faction " .. faction_key)
	return objective
end

--- @function generate_DECLARE_WAR_objective
--- @desc Declare war on a faction
--- @p @string faction_key, Target faction key
--- @r table objective and conditions declare war
generate_DECLARE_WAR_objective = function(faction_key)
	local objective = new_objective("DECLARE_WAR")
	table.insert(objective.conditions, "faction " .. faction_key)
	return objective
end

--- @function generate_SIGN_NON_AGGRESSION_PACT_objective
--- @desc Sign a non-aggression pact with a faction
--- @p @string faction_key, Target faction key
--- @r table objective and conditions non-aggression pact
generate_SIGN_NON_AGGRESSION_PACT_objective = function(faction_key)
	local objective = new_objective("SIGN_NON_AGGRESSION_PACT")
	table.insert(objective.conditions, "faction " .. faction_key)
	return objective
end

--- @function generate_BE_AT_WAR_WITH_FACTION_objective
--- @desc Be at war with a specific faction
--- @p @string faction_key, Faction that player must be at war with
--- @r table objective and conditions war with faction
generate_BE_AT_WAR_WITH_FACTION_objective = function(faction_key)
	local objective = new_objective("BE_AT_WAR_WITH_FACTION")
	table.insert(objective.conditions, "faction " .. faction_key)
	return objective
end

--- @function generate_BE_AT_WAR_WITH_N_FACTIONS_objective
--- @desc Be at war with N factions
--- @desc Ostensibly this objective supports a religion parameter, but the underlying system is deprecated so consider it not implemented
--- @p @number amount, Number of concurrent wars to maintain
--- @p [opt=nil] @string faction_key, Optional specific faction to target
--- @r table objective and conditions multiple wars
generate_BE_AT_WAR_WITH_N_FACTIONS_objective = function(amount, faction_key)
	local objective = new_objective("BE_AT_WAR_WITH_N_FACTIONS")
	table.insert(objective.conditions, "total " .. tostring(amount))
	if faction_key then
		table.insert(objective.conditions, "faction " .. faction_key)
	end
	return objective
end

--- @function generate_MAKE_CLIENT_STATE_OF_FACTION_objective
--- @desc Make a faction a client state
--- @p @string faction_key, Target faction to become client state
--- @r table objective and conditions client state
generate_MAKE_CLIENT_STATE_OF_FACTION_objective = function(faction_key)
	local objective = new_objective("MAKE_CLIENT_STATE_OF_FACTION")
	table.insert(objective.conditions, "faction " .. faction_key)
	return objective
end

--- @function generate_MAINTAIN_N_CLIENT_STATES_objective
--- @desc Maintain N client state relationships
--- @p @number amount, Number of client states to maintain
--- @r table objective and conditions client states
generate_MAINTAIN_N_CLIENT_STATES_objective = function(amount)
	local objective = new_objective("MAINTAIN_N_CLIENT_STATES")
	table.insert(objective.conditions, "total " .. tostring(amount))
	return objective
end

--- @function generate_MAINTAIN_N_ALLIANCES_objective
--- @desc Maintain N alliance agreements
--- @p @number amount, Number of alliances to maintain
--- @r table objective and conditions alliances
generate_MAINTAIN_N_ALLIANCES_objective = function(amount)
	local objective = new_objective("MAINTAIN_N_ALLIANCES")
	table.insert(objective.conditions, "total " .. tostring(amount))
	return objective
end

--- @function generate_CONFEDERATE_FACTIONS_objective
--- @desc Confederate N factions
--- @p @number amount, Number of confederations to complete
--- @p [opt=nil] @string faction_key, Optional specific faction to confederate
--- @r table objective and conditions confederations
generate_CONFEDERATE_FACTIONS_objective = function(amount, faction_key)
	local objective = new_objective("CONFEDERATE_FACTIONS")
	table.insert(objective.conditions, "total " .. tostring(amount))
	if faction_key then
		table.insert(objective.conditions, "faction " .. faction_key)
	end
	return objective
end

--- @function generate_SUBJUGATE_FACTIONS_objective
--- @desc Subjugate N factions via defeat, vassalization, client state, or confederation
--- @p @number amount, Number of factions to subjugate
--- @p [opt=nil] @string faction_key, Optional specific faction
--- @r table objective and conditions subjugation
generate_SUBJUGATE_FACTIONS_objective = function(amount, faction_key)
	local objective = new_objective("SUBJUGATE_FACTIONS")
	table.insert(objective.conditions, "total " .. tostring(amount))
	if faction_key then
		table.insert(objective.conditions, "faction " .. faction_key)
	end
	return objective
end

--- @function generate_LIMIT_FACTION_TO_REGIONS_objective
--- @desc Restrict factions to specific regions, includes both regions owned and military force locations
--- @p @table faction_list, Factions to limit
--- @p @string region_key, Bounding region
--- @r table objective and conditions faction limit
generate_LIMIT_FACTION_TO_REGIONS_objective = function(faction_list, region_key)
	local objective = new_objective("LIMIT_FACTION_TO_REGIONS")
	for i = 1, #faction_list do
		table.insert(objective.conditions, "faction " .. faction_list[i])
	end
	table.insert(objective.conditions, "region " .. region_key)
	return objective
end

--- @function generate_GIVE_TRIBUTE_objective
--- @desc Give tribute (via diplomatic payment) to a faction
--- @p @number amount, Amount of gold to give
--- @p [opt=nil] @string faction_key, Optional target faction
--- @r table objective and conditions give tribute
generate_GIVE_TRIBUTE_objective = function(amount, faction_key)
	local objective = new_objective("GIVE_TRIBUTE")
	table.insert(objective.conditions, "total " .. tostring(amount))
	if faction_key then
		table.insert(objective.conditions, "faction " .. faction_key)
	end
	return objective
end

--- @function generate_DEMAND_TRIBUTE_objective
--- @desc Demand tribute (via diplomatic payment) from a faction
--- @p @number amount, Amount of gold to demand
--- @p [opt=nil] @string faction_key, Optional target faction
--- @r table objective and conditions demand tribute
generate_DEMAND_TRIBUTE_objective = function(amount, faction_key)
	local objective = new_objective("DEMAND_TRIBUTE")
	table.insert(objective.conditions, "total " .. tostring(amount))
	if faction_key then
		table.insert(objective.conditions, "faction " .. faction_key)
	end
	return objective
end

--- @function generate_CONTROL_N_REGIONS_INCLUDING_objective
--- @desc Control N regions including specific required regions
--- @desc Control can be either direct ownership or via vassal/client state
--- @p @table region_list, Table of required region keys
--- @p @number amount, Total regions to control
--- @p [opt=nil] @string override_text, Localised name key, in the [table]_[key]_[field] format.
--- @r table objective and conditions control regions
generate_CONTROL_N_REGIONS_INCLUDING_objective = function(region_list, amount, override_text)
	local objective = new_objective("CONTROL_N_REGIONS_INCLUDING")
	for i = 1, #region_list do
		table.insert(objective.conditions, "region " .. region_list[i])
	end
	table.insert(objective.conditions, "total " .. tostring(amount))
	if override_text then
		table.insert(objective.conditions, "override_text " .. override_text)
	end
	return objective
end

--- @function generate_CONTROL_N_PROVINCES_INCLUDING_objective
--- @desc Control N provinces including specific ones
--- @desc Control can be either direct ownership or via vassal/client state
--- @p @table province_list, Required provinces
--- @p @number amount, Total to control
--- @p [opt=nil] @string override_text, Localised name key, in the [table]_[key]_[field] format.
--- @r table objective and conditions control provinces
generate_CONTROL_N_PROVINCES_INCLUDING_objective = function(province_list, amount, override_text)
	local objective = new_objective("CONTROL_N_PROVINCES_INCLUDING")
	for i = 1, #province_list do
		table.insert(objective.conditions, "province " .. province_list[i])
	end
	table.insert(objective.conditions, "total " .. tostring(amount))
	if override_text then
		table.insert(objective.conditions, "override_text " .. override_text)
	end
	return objective
end

--- @function generate_OWN_N_REGIONS_INCLUDING_objective
--- @desc Own N regions including specific ones
--- @p @table region_list, Required regions
--- @p @number amount, Total to own
--- @p [opt=nil] @string override_text, Localised name key, in the [table]_[key]_[field] format.
--- @p [opt=nil] @string subculture_key, Subculture proxy for ownership check
--- @r table objective and conditions own regions
generate_OWN_N_REGIONS_INCLUDING_objective = function(region_list, amount, override_text, subculture_key)
	local objective = new_objective("OWN_N_REGIONS_INCLUDING")
	for i = 1, #region_list do
		table.insert(objective.conditions, "region " .. region_list[i])
	end
	table.insert(objective.conditions, "total " .. tostring(amount))
	if override_text then
		table.insert(objective.conditions, "override_text " .. override_text)
	end
	if subculture_key then
		table.insert(objective.conditions, "subculture " .. subculture_key)
	end
	return objective
end

--- @function generate_OWN_A_PORT_ADJOINING_SEA_REGIONS_INCLUDING_objective
--- @desc Own a port adjoining specified sea regions
--- @p @table region_list, Sea regions to own a port on
--- @r table objective and conditions port near sea
generate_OWN_A_PORT_ADJOINING_SEA_REGIONS_INCLUDING_objective = function(region_list)
	local objective = new_objective("OWN_A_PORT_ADJOINING_SEA_REGIONS_INCLUDING")
	for i = 1, #region_list do
		table.insert(objective.conditions, "region " .. region_list[i])
	end
	return objective
end

--- @function generate_OWN_A_REGION_IN_N_PROVINCES_INCLUDING_objective
--- @desc Own a region in N specified provinces
--- @p @table province_list, Provinces to control in
--- @p @number amount, Number of provinces
--- @r table objective and conditions province regions
generate_OWN_A_REGION_IN_N_PROVINCES_INCLUDING_objective = function(province_list, amount)
	local objective = new_objective("OWN_A_REGION_IN_N_PROVINCES_INCLUDING")
	for i = 1, #province_list do
		table.insert(objective.conditions, "province " .. province_list[i])
	end
	table.insert(objective.conditions, "total " .. tostring(amount))
	return objective
end

--- @function generate_HOLD_ENTIRETY_OF_N_PROVINCES_INCLUDING_objective
--- @desc Hold all regions of N provinces
--- @desc Hold in this context is equivalent to control - direct ownership or client state/vassal
--- @p @table province_list, Required provinces
--- @p @number amount, Total provinces
--- @r table objective and conditions entire province control
generate_HOLD_ENTIRETY_OF_N_PROVINCES_INCLUDING_objective = function(province_list, amount)
	local objective = new_objective("HOLD_ENTIRETY_OF_N_PROVINCES_INCLUDING")
	for i = 1, #province_list do
		table.insert(objective.conditions, "province " .. province_list[i])
	end
	table.insert(objective.conditions, "total " .. tostring(amount))
	return objective
end

--- @function generate_KEEP_ARMY_IN_PROVINCE_objective
--- @desc Keep military force within province boundaries
--- @p @table province_list, Provinces to stay within
--- @r table objective and conditions province containment
generate_KEEP_ARMY_IN_PROVINCE_objective = function(province_list)
	local objective = new_objective("KEEP_ARMY_IN_PROVINCE")
	for i = 1, #province_list do
		table.insert(objective.conditions, "province " .. province_list[i])
	end
	return objective
end

--- @function generate_ABANDON_N_REGIONS_INCLUDING_objective
--- @desc Abandon/lose control of N specific regions
--- @p @table region_list, Regions to abandon
--- @p @number amount, Number to abandon
--- @r table objective and conditions abandon regions
generate_ABANDON_N_REGIONS_INCLUDING_objective = function(region_list, amount)
	local objective = new_objective("ABANDON_N_REGIONS_INCLUDING")
	table.insert(objective.conditions, "total " .. tostring(amount))
	for i = 1, #region_list do
		table.insert(objective.conditions, "region " .. region_list[i])
	end
	return objective
end

--- @function generate_DO_NOT_LOSE_REGION_objective
--- @desc Never lose control of specified regions
--- @p @table region_list, Regions to maintain control of
--- @r table objective and conditions protect regions
generate_DO_NOT_LOSE_REGION_objective = function(region_list)
	local objective = new_objective("DO_NOT_LOSE_REGION")
	for i = 1, #region_list do
		table.insert(objective.conditions, "region " .. region_list[i])
	end
	return objective
end

--- @function generate_RAZE_OR_OWN_X_SETTLEMENTS_objective
--- @desc Raze or own X settlements (any)
--- @desc Own here means direct control
--- @p @number amount, Number of settlements
--- @r table objective and conditions settlements
generate_RAZE_OR_OWN_X_SETTLEMENTS_objective = function(amount)
	local objective = new_objective("RAZE_OR_OWN_X_SETTLEMENTS")
	table.insert(objective.conditions, "total " .. tostring(amount))
	return objective
end

--- @function generate_RAZE_OR_OWN_SETTLEMENTS_objective
--- @desc Raze or own specified settlements
--- @desc Map position parameter is also ostensibly supported, but implementation is incomplete, use with caution
--- @p @table region_list, List of region keys
--- @p [opt=nil] @string position, Map position
--- @r table objective and conditions specific settlements
generate_RAZE_OR_OWN_SETTLEMENTS_objective = function(region_list, position)
	local objective = new_objective("RAZE_OR_OWN_SETTLEMENTS")
	for i = 1, #region_list do
		table.insert(objective.conditions, "region " .. region_list[i])
	end
	if position then
		table.insert(objective.conditions, "position " .. position)
	end
	return objective
end

--- @function generate_LOOT_OR_SACK_N_DIFFERENT_SETTLEMENTS_INCLUDING_objective
--- @desc Loot or sack N different settlements
--- @p @table region_list, Target regions
--- @p @number amount, Number to affect
--- @r table objective and conditions loot settlements
generate_LOOT_OR_SACK_N_DIFFERENT_SETTLEMENTS_INCLUDING_objective = function(region_list, amount)
	local objective = new_objective("LOOT_OR_SACK_N_DIFFERENT_SETTLEMENTS_INCLUDING")
	table.insert(objective.conditions, "total " .. tostring(amount))
	for i = 1, #region_list do
		table.insert(objective.conditions, "region " .. region_list[i])
	end
	return objective
end

--- @function generate_OWN_N_PORTS_INCLUDING_objective
--- @desc Own N port settlements including specific ones
--- @desc Own means direct control
--- @p @table region_list, Required port regions
--- @p @number amount, Total ports to own
--- @r table objective and conditions own ports
generate_OWN_N_PORTS_INCLUDING_objective = function(region_list, amount)
	local objective = new_objective("OWN_N_PORTS_INCLUDING")
	table.insert(objective.conditions, "total " .. tostring(amount))
	for i = 1, #region_list do
		table.insert(objective.conditions, "region " .. region_list[i])
	end
	return objective
end

--- @function generate_CONTROL_N_PORTS_INCLUDING_objective
--- @desc Control N port settlements
--- @desc Control can be either direct ownership or via vassal/client state
--- @p @table region_list, Required ports
--- @p @number amount, Total to control
--- @r table objective and conditions control ports
generate_CONTROL_N_PORTS_INCLUDING_objective = function(region_list, amount)
	local objective = new_objective("CONTROL_N_PORTS_INCLUDING")
	table.insert(objective.conditions, "total " .. tostring(amount))
	for i = 1, #region_list do
		table.insert(objective.conditions, "region " .. region_list[i])
	end
	return objective
end

--- @function generate_BLOCKADE_PORT_objective
--- @desc Blockade a port region
--- @p [opt=nil] @string faction_key, Faction to blockade
--- @p [opt=nil] @string region_key, Port region to blockade
--- @r table objective and conditions blockade port
generate_BLOCKADE_PORT_objective = function(faction_key, region_key)
	local objective = new_objective("BLOCKADE_PORT")
	if faction_key then
		table.insert(objective.conditions, "faction " .. faction_key)
	end
	if region_key then
		table.insert(objective.conditions, "region " .. region_key)
	end
	return objective
end

--- @function generate_BLOCKADE_X_SETTLEMENTS_objective
--- @desc Blockade X settlements of a faction
--- @p @number amount, Number to blockade
--- @p @string faction_key, Target faction
--- @r table objective and conditions blockade settlements
generate_BLOCKADE_X_SETTLEMENTS_objective = function(amount, faction_key)
	local objective = new_objective("BLOCKADE_X_SETTLEMENTS")
	table.insert(objective.conditions, "total " .. tostring(amount))
	table.insert(objective.conditions, "faction " .. faction_key)
	return objective
end

--- @function generate_OWN_N_UNITS_objective
--- @desc Own N units with optional type filters
--- @p @number amount, Number of units
--- @p [opt=nil] @table unit_list, Specific units by key
--- @p [opt=nil] @boolean naval, Naval units only
--- @p [opt=nil] @boolean mercenary, Mercenary units only
--- @p [opt=nil] @boolean different_types, Count different types separately
--- @p [opt=nil] @boolean additive, Count existing units towards total
--- @p [opt=nil] @string override_text, Localised name key, in the [table]_[key]_[field] format.
--- @r table objective and conditions own units
generate_OWN_N_UNITS_objective = function(amount, unit_list, naval, mercenary, different_types, additive, override_text)
	local objective = new_objective("OWN_N_UNITS")
	table.insert(objective.conditions, "total " .. tostring(amount))
	if unit_list then
		for i = 1, #unit_list do
			table.insert(objective.conditions, "unit " .. unit_list[i])
		end
	end
	if naval then
		table.insert(objective.conditions, "naval")
	end
	if mercenary then
		table.insert(objective.conditions, "mercenary")
	end
	if different_types then
		table.insert(objective.conditions, "different_types")
	end
	if additive then
		table.insert(objective.conditions, "additive")
	end
	if override_text then
		table.insert(objective.conditions, "override_text " .. override_text)
	end
	return objective
end

--- @function generate_OWN_N_NAVAL_UNITS_objective
--- @desc Own N naval units
--- @p @number amount, Number of naval units
--- @p [opt=nil] @boolean additive, Count existing units towards total
--- @r table objective and conditions naval units
generate_OWN_N_NAVAL_UNITS_objective = function(amount, additive)
	local objective = new_objective("OWN_N_NAVAL_UNITS")
	table.insert(objective.conditions, "total " .. tostring(amount))
	if additive then
		table.insert(objective.conditions, "additive")
	end
	return objective
end

--- @function generate_RECRUIT_UNIT_objective
--- @desc Recruit a specific unit type
--- @p [opt=nil] @string unit_key, Specific unit from units table
--- @p [opt=nil] @string unit_caste, Unit caste type
--- @p [opt=nil] @string unit_category, Unit category
--- @p [opt=nil] @string unit_class, Unit class
--- @p [opt=nil] @string start_pos_character_id, Character to recruit for
--- @p [opt=nil] @string override_text, Localised name key, in the [table]_[key]_[field] format.
--- @r table objective and conditions recruit unit
generate_RECRUIT_UNIT_objective = function(unit_key, unit_caste, unit_category, unit_class, start_pos_character_id, override_text)
	local objective = new_objective("RECRUIT_UNIT")
	if unit_key then
		table.insert(objective.conditions, "unit " .. unit_key)
	end
	if unit_caste then
		table.insert(objective.conditions, "unit_caste " .. unit_caste)
	end
	if unit_category then
		table.insert(objective.conditions, "unit_category " .. unit_category)
	end
	if unit_class then
		table.insert(objective.conditions, "unit_class " .. unit_class)
	end
	if start_pos_character_id then
		table.insert(objective.conditions, "start_pos_character " .. start_pos_character_id)
	end
	if override_text then
		table.insert(objective.conditions, "override_text " .. override_text)
	end
	return objective
end

--- @function generate_RECRUIT_N_UNITS_FROM_objective
--- @desc Recruit N units from specific types
--- @p @table unit_list, Pool of unit types
--- @p @number amount, Number to recruit
--- @p [opt=nil] @boolean exclude_existing, Exclude already owned
--- @p [opt=nil] @string override_text, Localised name key, in the [table]_[key]_[field] format.
--- @p [opt=nil] @boolean mercenary, Mercenary units only
--- @p [opt=nil] @boolean count_unit_upgrades_as_recruitment, Count vertical upgrades into the listed unit types as recruitment
--- @r table objective and conditions recruit units
generate_RECRUIT_N_UNITS_FROM_objective = function(unit_list, amount, exclude_existing, override_text, mercenary, count_unit_upgrades_as_recruitment)
	local objective = new_objective("RECRUIT_N_UNITS_FROM")
	table.insert(objective.conditions, "total " .. tostring(amount))
	for i = 1, #unit_list do
		table.insert(objective.conditions, "unit " .. unit_list[i])
	end
	if exclude_existing then
		table.insert(objective.conditions, "exclude_existing")
	end
	if override_text then
		table.insert(objective.conditions, "override_text " .. override_text)
	end
	if mercenary then
		table.insert(objective.conditions, "mercenary")
	end
	if count_unit_upgrades_as_recruitment then
		table.insert(objective.conditions, "count_unit_upgrades_as_recruitment")
	end
	return objective
end

--- @function generate_RECRUIT_AGENT_objective
--- @desc Recruit N agents of optional type
--- @p @number amount, Number of agents to recruit
--- @p [opt=nil] @string agent_key, Specific agent type
--- @p [opt=nil] @string agent_subtype, Agent subtype
--- @p [opt=nil] @string region_key, Region to recruit in
--- @r table objective and conditions recruit agent
generate_RECRUIT_AGENT_objective = function(amount, agent_key, agent_subtype, region_key)
	local objective = new_objective("RECRUIT_AGENT")
	table.insert(objective.conditions, "total " .. tostring(amount))
	if agent_key then
		table.insert(objective.conditions, "agent " .. agent_key)
	end
	if agent_subtype then
		table.insert(objective.conditions, "agent_subtype " .. agent_subtype)
	end
	if region_key then
		table.insert(objective.conditions, "region " .. region_key)
	end
	return objective
end

--- @function generate_MOVE_X_AGENTS_TO_Y_REGIONS_OWNED_BY_Z_objective
--- @desc Move X agents to Y regions owned by Z
--- @desc Faction and subculture are both optional but please ensure you provide at least one for proper functioning
--- @p @number num_agents, Agents to move
--- @p @number num_regions, Regions count
--- @p [opt=nil] @string faction_key, Faction ownership of regions filter
--- @p [opt=nil] @string subculture_key, Subculture ownership of regions filter
--- @r table objective and conditions move agents
generate_MOVE_X_AGENTS_TO_Y_REGIONS_OWNED_BY_Z_objective = function(num_agents, num_regions, faction_key, subculture_key)
	local objective = new_objective("MOVE_X_AGENTS_TO_Y_REGIONS_OWNED_BY_Z")
	table.insert(objective.conditions, "total " .. tostring(num_agents))
	table.insert(objective.conditions, "total2 " .. tostring(num_regions))
	if faction_key then
		table.insert(objective.conditions, "faction " .. faction_key)
	end
	if subculture_key then
		table.insert(objective.conditions, "subculture " .. subculture_key)
	end
	return objective
end

--- @function generate_ENGAGE_FORCE_objective
--- @desc Engage an enemy military force
--- @p [opt=nil] @string faction_key, Enemy faction
--- @p [opt=nil] @boolean requires_victory, Must win battle
--- @p [opt=nil] @boolean armies_only, Armies not navies
--- @p [opt=nil] @boolean navies_only, Navies not armies
--- @p [opt=nil] @string enemy_of_faction_key, Engage forces of enemies of this faction
--- @p [opt=nil] @string cqi, Specific enemy force cqi
--- @p [opt=nil] @string override_text, Localised name key, in the [table]_[key]_[field] format.
--- @r table objective and conditions engage force
generate_ENGAGE_FORCE_objective = function(faction_key, requires_victory, armies_only, navies_only, enemy_of_faction_key, cqi, override_text)
	local objective = new_objective("ENGAGE_FORCE")
	if faction_key then
		table.insert(objective.conditions, "faction " .. faction_key)
	end
	if requires_victory then
		table.insert(objective.conditions, "requires_victory")
	end
	if armies_only then
		table.insert(objective.conditions, "armies_only")
	end
	if navies_only then
		table.insert(objective.conditions, "navies_only")
	end
	if enemy_of_faction_key then
		table.insert(objective.conditions, "enemy_of_faction " .. enemy_of_faction_key)
	end
	if cqi then
		table.insert(objective.conditions, "cqi " .. cqi)
	end
	if override_text then
		table.insert(objective.conditions, "override_text " .. override_text)
	end
	return objective
end

--- @function generate_DEFEAT_N_ARMIES_OF_FACTION_objective
--- @desc Defeat N armies belonging to a faction
--- @p @number amount, Number of armies
--- @p [opt=nil] @string faction_key, Target faction
--- @p [opt=nil] @string subculture_key, Subculture filter
--- @p [opt=nil] @string start_pos_character_id, Specific general
--- @p [opt=nil] @string victory_type, Battle result type required
--- @r table objective and conditions defeat armies
generate_DEFEAT_N_ARMIES_OF_FACTION_objective = function(amount, faction_key, subculture_key, start_pos_character_id, victory_type)
	local objective = new_objective("DEFEAT_N_ARMIES_OF_FACTION")
	table.insert(objective.conditions, "total " .. tostring(amount))
	if faction_key then
		table.insert(objective.conditions, "faction " .. faction_key)
	end
	if subculture_key then
		table.insert(objective.conditions, "subculture " .. subculture_key)
	end
	if start_pos_character_id then
		table.insert(objective.conditions, "start_pos_character " .. start_pos_character_id)
	end
	if victory_type then
		table.insert(objective.conditions, "victory_type " .. victory_type)
	end
	return objective
end

--- @function generate_AMBUSH_ARMY_objective
--- @desc Ambush N armies in surprise attacks
--- @p @number amount, Number of armies to ambush
--- @p [opt=nil] @string faction_key, Faction to ambush
--- @p [opt=nil] @string subculture_key, Subculture filter
--- @p [opt=nil] @string culture_key, Culture filter
--- @r table objective and conditions ambush armies
generate_AMBUSH_ARMY_objective = function(amount, faction_key, subculture_key, culture_key)
	local objective = new_objective("AMBUSH_ARMY")
	table.insert(objective.conditions, "total " .. tostring(amount))
	if faction_key then
		table.insert(objective.conditions, "faction " .. faction_key)
	end
	if subculture_key then
		table.insert(objective.conditions, "subculture " .. subculture_key)
	end
	if culture_key then
		table.insert(objective.conditions, "culture " .. culture_key)
	end
	return objective
end

--- @function generate_RAID_X_REGIONS_objective
--- @desc Raid X regions of enemy factions
--- @p @number amount, Number of regions to raid
--- @p @table faction_list, Factions to raid
--- @r table objective and conditions raid regions
generate_RAID_X_REGIONS_objective = function(amount, faction_list)
	local objective = new_objective("RAID_X_REGIONS")
	table.insert(objective.conditions, "total " .. tostring(amount))
	for i = 1, #faction_list do
		table.insert(objective.conditions, "faction " .. faction_list[i])
	end
	return objective
end

--- @function generate_RAID_SUBCULTURE_objective
--- @desc Raid settlements of a specific subculture
--- @p @string subculture_key, Target subculture
--- @p [opt=nil] @string start_pos_character_id, Raiding general
--- @r table objective and conditions raid subculture
generate_RAID_SUBCULTURE_objective = function(subculture_key, start_pos_character_id)
	local objective = new_objective("RAID_SUBCULTURE")
	table.insert(objective.conditions, "subculture " .. subculture_key)
	if start_pos_character_id then
		table.insert(objective.conditions, "start_pos_character " .. start_pos_character_id)
	end
	return objective
end

--- @function generate_RAISE_FORCE_objective
--- @desc Raise a new military force in region
--- @p [opt=nil] @string region_key, Region to raise in
--- @p [opt=nil] @boolean armies_only, Land armies only
--- @p [opt=nil] @boolean navies_only, Naval forces only
--- @r table objective and conditions raise force
generate_RAISE_FORCE_objective = function(region_key, armies_only, navies_only)
	local objective = new_objective("RAISE_FORCE")
	if region_key then
		table.insert(objective.conditions, "region " .. region_key)
	end
	if armies_only then
		table.insert(objective.conditions, "armies_only")
	end
	if navies_only then
		table.insert(objective.conditions, "navies_only")
	end
	return objective
end

--- @function generate_HAVE_N_UNITS_IN_ARMY_objective
--- @desc Have N units in a specific army
--- @p @number amount, Number of units
--- @p @string start_pos_character_id, Army commander
--- @r table objective and conditions army composition
generate_HAVE_N_UNITS_IN_ARMY_objective = function(amount, start_pos_character_id)
	local objective = new_objective("HAVE_N_UNITS_IN_ARMY")
	table.insert(objective.conditions, "total " .. tostring(amount))
	table.insert(objective.conditions, "start_pos_character " .. start_pos_character_id)
	return objective
end

--- @function generate_ARMY_CONTAINS_N_UNITS_OF_TYPE_objective
--- @desc Ensure  army contains N units of a specific type
--- @p @number amount, Number of unit types
--- @p @string start_pos_character_id, Army commander
--- @p [opt=nil] @string unit_key, Specific unit
--- @p [opt=nil] @string unit_class, Unit class filter
--- @r table objective and conditions specific unit types
generate_ARMY_CONTAINS_N_UNITS_OF_TYPE_objective = function(amount, start_pos_character_id, unit_key, unit_class)
	local objective = new_objective("ARMY_CONTAINS_N_UNITS_OF_TYPE")
	table.insert(objective.conditions, "total " .. tostring(amount))
	table.insert(objective.conditions, "start_pos_character " .. start_pos_character_id)
	if unit_key then
		table.insert(objective.conditions, "unit " .. unit_key)
	end
	if unit_class then
		table.insert(objective.conditions, "unit_class " .. unit_class)
	end
	return objective
end

--- @function generate_DEFEAT_ROGUE_ARMY_objective
--- @desc Defeat N rogue armies
--- @p @number amount, Rogue armies
--- @r table objective and conditions rogue armies
generate_DEFEAT_ROGUE_ARMY_objective = function(amount)
	local objective = new_objective("DEFEAT_ROGUE_ARMY")
	table.insert(objective.conditions, "total " .. tostring(amount))
	return objective
end

--- @function generate_KILL_X_ENTITIES_objective
--- @desc Kill X unit models in any combat
--- @p @number amount, Unit models to kill
--- @r table objective and conditions entity kills
generate_KILL_X_ENTITIES_objective = function(amount)
	local objective = new_objective("KILL_X_ENTITIES")
	table.insert(objective.conditions, "total " .. tostring(amount))
	return objective
end

--- @function generate_KILL_X_ENTITIES_BY_objective
--- @desc Kill X unit models using specific unit type
--- @p @number amount, Kills required
--- @p @string unit_set_key, Unit set to use
--- @p @string override_text, Localised name key, in the [table]_[key]_[field] format.
--- @p [opt=nil] @boolean include_unit_size, set true to multiply amount by unit_size_multiplier
--- @r table objective and conditions unit kills
generate_KILL_X_ENTITIES_BY_objective = function(amount, unit_set_key, override_text, include_unit_size)
	local objective = new_objective("KILL_X_ENTITIES_BY")
	if include_unit_size then
		amount = amount * cm:model():unit_size_multiplier()
	end
	table.insert(objective.conditions, "total " .. tostring(amount))
	table.insert(objective.conditions, "unit_set " .. unit_set_key)
	table.insert(objective.conditions, "override_text " .. override_text)
	return objective
end

--- @function generate_ASSASSINATE_CHARACTER_objective
--- @desc Assassinate a specific enemy character
--- @p [opt=nil] @string faction_key, Any character of this faction
--- @p [opt=nil] @string character_cqi, Specific character
--- @p [opt=nil] @string enemy_of_faction, Any character from a faction that's an enemy of this faction
--- @r table objective and conditions assassinate
generate_ASSASSINATE_CHARACTER_objective = function(faction_key, character_cqi, enemy_of_faction)
	local objective = new_objective("ASSASSINATE_CHARACTER")
	if faction_key then
		table.insert(objective.conditions, "faction " .. faction_key)
	end
	if character_cqi then
		table.insert(objective.conditions, "character " .. character_cqi)
	end
	if enemy_of_faction then
		table.insert(objective.conditions, "enemy_of_faction " .. enemy_of_faction)
	end
	return objective
end

--- @function generate_ASSASSINATE_X_CHARACTERS_objective
--- @desc Assassinate X characters
--- @p @number amount, Number to assassinate
--- @p [opt=nil] @string agent_key, Target agent type
--- @p [opt=nil] @string faction_key, Target faction
--- @p [opt=nil] @string subculture_key, Target subculture
--- @r table objective and conditions assassinate multiple
generate_ASSASSINATE_X_CHARACTERS_objective = function(amount, agent_key, faction_key, subculture_key)
	local objective = new_objective("ASSASSINATE_X_CHARACTERS")
	table.insert(objective.conditions, "total " .. tostring(amount))
	if agent_key then
		table.insert(objective.conditions, "agent " .. agent_key)
	end
	if faction_key then
		table.insert(objective.conditions, "faction " .. faction_key)
	end
	if subculture_key then
		table.insert(objective.conditions, "subculture " .. subculture_key)
	end
	return objective
end

--- @function generate_ELIMINATE_CHARACTER_IN_BATTLE_objective
--- @desc Eliminate a character in battle
--- @p [opt=nil] @string faction_key, Target faction
--- @p [opt=nil] @string character_cqi, Specific character
--- @p [opt=nil] @string enemy_of_faction, Character enemy of this faction
--- @r table objective and conditions eliminate in battle
generate_ELIMINATE_CHARACTER_IN_BATTLE_objective = function(faction_key, character_cqi, enemy_of_faction)
	local objective = new_objective("ELIMINATE_CHARACTER_IN_BATTLE")
	if faction_key then
		table.insert(objective.conditions, "faction " .. faction_key)
	end
	if character_cqi then
		table.insert(objective.conditions, "character " .. character_cqi)
	end
	if enemy_of_faction then
		table.insert(objective.conditions, "enemy_of_faction " .. enemy_of_faction)
	end
	return objective
end

--- @function generate_KILL_CHARACTER_BY_ANY_MEANS_objective
--- @desc Kill a specific character by any means
--- @p @string family_member_cqi, Family member command queue index
--- @r table objective and conditions kill family
generate_KILL_CHARACTER_BY_ANY_MEANS_objective = function(family_member_cqi)
	local objective = new_objective("KILL_CHARACTER_BY_ANY_MEANS")
	table.insert(objective.conditions, "family_member " .. tostring(family_member_cqi))
	return objective
end

--- @function generate_HAVE_CHARACTER_WOUNDED_objective
--- @desc Have a character wounded
--- @p @string start_pos_character_id, Character to wound
--- @p [opt=nil] @string override_text, Localised name key, in the [table]_[key]_[field] format.
--- @r table objective and conditions wound character
generate_HAVE_CHARACTER_WOUNDED_objective = function(start_pos_character_id, override_text)
	local objective = new_objective("HAVE_CHARACTER_WOUNDED")
	table.insert(objective.conditions, "start_pos_character " .. start_pos_character_id)
	if override_text then
		table.insert(objective.conditions, "override_text " .. override_text)
	end
	return objective
end

--- @function generate_HAVE_CHARACTER_WITHIN_RANGE_OF_POSITION_objective
--- @desc Have a character within hex radius of position
--- @p @table position, Map position {x, y}
--- @p @number radius, Hex radius
--- @p [opt=nil] @string override_text, Localised name key, in the [table]_[key]_[field] format.
--- @p [opt=nil] @number max_distance, Max distance to position
--- @p [opt=nil] @table force_stance_list, Required force stances
--- @p [opt=nil] @boolean trigger_immediately, Immediate trigger
--- @r table objective and conditions position range
generate_HAVE_CHARACTER_WITHIN_RANGE_OF_POSITION_objective = function(position, radius, override_text, max_distance, force_stance_list, trigger_immediately)
	local objective = new_objective("HAVE_CHARACTER_WITHIN_RANGE_OF_POSITION")
	table.insert(objective.conditions, "position " .. position)
	table.insert(objective.conditions, "radius " .. tostring(radius))
	if override_text then
		table.insert(objective.conditions, "override_text " .. override_text)
	end
	if max_distance then
		table.insert(objective.conditions, "max_distance_to_decoy " .. tostring(max_distance))
	end
	if force_stance_list then
		for i = 1, #force_stance_list do
			table.insert(objective.conditions, "force_stance_record " .. force_stance_list[i])
		end
	end
	if trigger_immediately then
		table.insert(objective.conditions, "trigger_immediately")
	end
	return objective
end

--- @function generate_MOVE_TO_REGION_objective
--- @desc Move a character to a specific region
--- @p @string region_key, Target region
--- @p [opt=nil] @string start_pos_character_id, Army character
--- @r table objective and conditions move region
generate_MOVE_TO_REGION_objective = function(region_key, start_pos_character_id)
	local objective = new_objective("MOVE_TO_REGION")
	table.insert(objective.conditions, "region " .. region_key)
	if start_pos_character_id then
		table.insert(objective.conditions, "start_pos_character " .. start_pos_character_id)
	end
	return objective
end

--- @function generate_MOVE_TO_PROVINCE_objective
--- @desc Move a character to a province
--- @p @string province_key, Target province
--- @p [opt=nil] @string agent_subtype, Required agent by subtype
--- @p [opt=nil] @string start_pos_character_id, Specific character
--- @r table objective and conditions move province
generate_MOVE_TO_PROVINCE_objective = function(province_key, agent_subtype, start_pos_character_id)
	local objective = new_objective("MOVE_TO_PROVINCE")
	table.insert(objective.conditions, "province " .. province_key)
	if agent_subtype then
		table.insert(objective.conditions, "agent_subtype " .. agent_subtype)
	end
	if start_pos_character_id then
		table.insert(objective.conditions, "start_pos_character " .. start_pos_character_id)
	end
	return objective
end

--- @function generate_HAVE_N_AGENTS_OF_TYPE_objective
--- @desc Have N agents of a specific type
--- @p @number amount, Number of agents
--- @p [opt=nil] @string agent_key, Required agent type
--- @p [opt=nil] @string agent_subtype_key, Required agent subtype
--- @r table objective and conditions agent count
generate_HAVE_N_AGENTS_OF_TYPE_objective = function(amount, agent_key, agent_subtype_key)
	local objective = new_objective("HAVE_N_AGENTS_OF_TYPE")
	table.insert(objective.conditions, "total " .. tostring(amount))
	if agent_key then
		table.insert(objective.conditions, "agent " .. agent_key)
	end
	if agent_subtype_key then
		table.insert(objective.conditions, "agent_subtype " .. agent_subtype_key)
	end
	return objective
end

--- @function generate_EMBED_AGENT_objective
--- @desc Embed an agent in a character's court
--- @p @string start_pos_character_id, Host character
--- @p @string agent_key, Agent type to embed
--- @p [opt=nil] @string agent_subtype_key, Required agent subtype
--- @r table objective and conditions embed agent
generate_EMBED_AGENT_objective = function(start_pos_character_id, agent_key, agent_subtype_key)
	local objective = new_objective("EMBED_AGENT")
	table.insert(objective.conditions, "start_pos_character " .. start_pos_character_id)
	table.insert(objective.conditions, "agent " .. agent_key)
	if agent_subtype_key then
		table.insert(objective.conditions, "agent_subtype " .. agent_subtype_key)
	end
	return objective
end

--- @function generate_PERFORM_ANY_AGENT_ACTION_objective
--- @desc Perform agent actions (block, steal tech, etc.)
--- @p [opt=nil] @number amount, Number of actions
--- @r table objective and conditions agent actions
generate_PERFORM_ANY_AGENT_ACTION_objective = function(amount)
	local objective = new_objective("PERFORM_ANY_AGENT_ACTION")
	if amount then
		table.insert(objective.conditions, "total " .. tostring(amount))
	end
	return objective
end

--- @function generate_ACHIEVE_CHARACTER_RANK_objective
--- @desc Achieve character rank/experience level
--- @p @number target_number, Number of characters to level up
--- @p @number target_level, Target level to achieve
--- @p [opt=nil] @string agent_key, Agent type
--- @p [opt=nil] @string agent_subtype, Agent subtype
--- @p [opt=nil] @boolean include_generals, Count generals
--- @p [opt=nil] @string start_pos_character_id, Specific character
--- @r table objective and conditions character rank
generate_ACHIEVE_CHARACTER_RANK_objective = function(target_number, target_level, agent_key, agent_subtype, include_generals, start_pos_character_id)
	local objective = new_objective("ACHIEVE_CHARACTER_RANK")
	table.insert(objective.conditions, "total " .. tostring(target_number))
	table.insert(objective.conditions, "total2 " .. tostring(target_level))
	if agent_key then
		table.insert(objective.conditions, "agent " .. agent_key)
	end
	if agent_subtype then
		table.insert(objective.conditions, "agent_subtype " .. agent_subtype)
	end
	if include_generals then
		table.insert(objective.conditions, "include_generals")
	end
	if start_pos_character_id then
		table.insert(objective.conditions, "start_pos_character " .. start_pos_character_id)
	end
	return objective
end

--- @function generate_INCOME_AT_LEAST_X_objective
--- @desc Achieve at least X income per turn
--- @p @number amount, Income amount required
--- @p [opt=nil] @boolean trade_only, Trade income only
--- @r table objective and conditions income level
generate_INCOME_AT_LEAST_X_objective = function(amount, trade_only)
	local objective = new_objective("INCOME_AT_LEAST_X")
	table.insert(objective.conditions, "income " .. tostring(amount))
	if trade_only then
		table.insert(objective.conditions, "trade")
	end
	return objective
end

--- @function generate_TRADE_INCOME_AT_LEAST_X_objective
--- @desc Achieve at least X income from trade
--- @p @number amount, Trade income required
--- @r table objective and conditions trade income
generate_TRADE_INCOME_AT_LEAST_X_objective = function(amount)
	local objective = new_objective("TRADE_INCOME_AT_LEAST_X")
	table.insert(objective.conditions, "total " .. tostring(amount))
	return objective
end

--- @function generate_HAVE_AT_LEAST_X_MONEY_objective
--- @desc Have at least X gold in treasury
--- @p @number amount, Gold amount
--- @p [opt=nil] @boolean additive, Current treasury counts towards total
--- @r table objective and conditions treasury
generate_HAVE_AT_LEAST_X_MONEY_objective = function(amount, additive)
	local objective = new_objective("HAVE_AT_LEAST_X_MONEY")
	table.insert(objective.conditions, "total " .. tostring(amount))
	if additive then
		table.insert(objective.conditions, "additive")
	end
	return objective
end

--- @function generate_EARN_X_AMOUNT_FROM_RAIDING_objective
--- @desc Earn X gold from raiding
--- @p @number amount, Gold from raids
--- @p [opt=nil] @boolean additive, Current treasury counts towards total
--- @r table objective and conditions raid income
generate_EARN_X_AMOUNT_FROM_RAIDING_objective = function(amount, additive)
	local objective = new_objective("EARN_X_AMOUNT_FROM_RAIDING")
	table.insert(objective.conditions, "total " .. tostring(amount))
	if additive then
		table.insert(objective.conditions, "additive")
	end
	return objective
end

--- @function generate_HAVE_AT_LEAST_X_INFLUENCE_objective
--- @desc Accumulate X influence (HEF feature) points
--- @p @number amount, Influence to accumulate
--- @p [opt=nil] @boolean additive, Current influence counts towards total
--- @r table objective and conditions influence
generate_HAVE_AT_LEAST_X_INFLUENCE_objective = function(amount, additive)
	local objective = new_objective("HAVE_AT_LEAST_X_INFLUENCE")
	table.insert(objective.conditions, "total " .. tostring(amount))
	if additive then
		table.insert(objective.conditions, "additive")
	end
	return objective
end

--- @function generate_CAPTURE_X_BATTLE_CAPTIVES_objective
--- @desc Capture X prisoners from battles
--- @p @number amount, Prisoners to capture
--- @p [opt=nil] @boolean additive, Current captives count towards total
--- @r table objective and conditions captives
generate_CAPTURE_X_BATTLE_CAPTIVES_objective = function(amount, additive)
	local objective = new_objective("CAPTURE_X_BATTLE_CAPTIVES")
	table.insert(objective.conditions, "total " .. tostring(amount))
	if additive then
		table.insert(objective.conditions, "additive")
	end
	return objective
end

--- @function generate_HAVE_RESOURCES_objective
--- @desc Control all specified resources
--- @p @table resource_list, List of resources to control by key
--- @r table objective and conditions resource control
generate_HAVE_RESOURCES_objective = function(resource_list)
	local objective = new_objective("HAVE_RESOURCES")
	for i = 1, #resource_list do
		table.insert(objective.conditions, "resource " .. resource_list[i])
	end
	return objective
end

--- @function generate_CONSTRUCT_BUILDINGS_objective
--- @desc Construct N buildings of any type
--- @p @number amount, Number of buildings
--- @p [opt=nil] @boolean additive, Currently constructed buildings count towards total
--- @r table objective and conditions construct
generate_CONSTRUCT_BUILDINGS_objective = function(amount, additive)
	local objective = new_objective("CONSTRUCT_BUILDINGS")
	table.insert(objective.conditions, "total " .. tostring(amount))
	if additive then
		table.insert(objective.conditions, "additive")
	end
	return objective
end

--- @function generate_CONSTRUCT_BUILDINGS_FROM_objective
--- @desc Construct N buildings from pool of types
--- @p @number amount, Number to construct
--- @p @string faction_key, Building faction
--- @p @table building_level_list, Building levels by key to construct from
--- @p [opt=nil] @table building_chain_list, Building chains by key to construct from
--- @p [opt=nil] @string override_text, Localised name key, in the [table]_[key]_[field] format.
--- @r table objective and conditions construct from pool
generate_CONSTRUCT_BUILDINGS_FROM_objective = function(amount, faction_key, building_level_list, building_chain_list, override_text)
	local objective = new_objective("CONSTRUCT_N_BUILDINGS_FROM")
	table.insert(objective.conditions, "total " .. tostring(amount))
	table.insert(objective.conditions, "faction " .. faction_key)
	for i = 1, #building_level_list do
		table.insert(objective.conditions, "building_level " .. building_level_list[i])
	end
	if building_chain_list then
		for i = 1, #building_chain_list do
			table.insert(objective.conditions, "building_chain " .. building_chain_list[i])
		end
	end
	if override_text then
		table.insert(objective.conditions, "override_text " .. override_text)
	end
	return objective
end

--- @function generate_CONSTRUCT_BUILDINGS_INCLUDING_objective
--- @desc Construct buildings including specific types
--- @p @number amount, Number to construct
--- @p @string faction_key, Faction
--- @p @table building_level_list, Building levels by key to construct from
--- @p [opt=nil] @table building_chain_list, Building chains by key to construct from
--- @p [opt=nil] @string override_text, Localised name key, in the [table]_[key]_[field] format.
--- @r table objective and conditions construct including
generate_CONSTRUCT_BUILDINGS_INCLUDING_objective = function(amount, faction_key, building_level_list, building_chain_list, override_text)
	local objective = new_objective("CONSTRUCT_N_BUILDINGS_INCLUDING")
	table.insert(objective.conditions, "total " .. tostring(amount))
	table.insert(objective.conditions, "faction " .. faction_key)
	if building_level_list then
		for i = 1, #building_level_list do
			table.insert(objective.conditions, "building_level " .. building_level_list[i])
		end
	end
	if building_chain_list then
		for i = 1, #building_chain_list do
			table.insert(objective.conditions, "building_chain " .. building_chain_list[i])
		end
	end
	if override_text then
		table.insert(objective.conditions, "override_text " .. override_text)
	end
	return objective
end

--- @function generate_CONSTRUCT_BUILDING_IN_PROVINCES_objective
--- @desc Construct a specific building in provinces
--- @p @string building_level_key, Building to construct
--- @p @table province_list, Target provinces
--- @p @string faction_key, Building faction
--- @p [opt=nil] @string override_text, Localised name key, in the [table]_[key]_[field] format.
--- @r table objective and conditions building in province
generate_CONSTRUCT_BUILDING_IN_PROVINCES_objective = function(building_level_key, province_list, faction_key, override_text)
	local objective = new_objective("CONSTRUCT_BUILDING_IN_PROVINCES")
	table.insert(objective.conditions, "faction " .. faction_key)
	table.insert(objective.conditions, "building_level " .. building_level_key)
	for i = 1, #province_list do
		table.insert(objective.conditions, "province " .. province_list[i])
	end
	if override_text then
		table.insert(objective.conditions, "override_text " .. override_text)
	end
	return objective
end

--- @function generate_CONSTRUCT_BUILDING_CHAIN_IN_PROVINCES_objective
--- @desc Construct a building chain in provinces
--- @p @string chain_key, Building chain key
--- @p @table province_list, Target provinces
--- @r table objective and conditions chain in province
generate_CONSTRUCT_BUILDING_CHAIN_IN_PROVINCES_objective = function(chain_key, province_list)
	local objective = new_objective("CONSTRUCT_BUILDING_CHAIN_IN_PROVINCES")
	table.insert(objective.conditions, "building_chain " .. chain_key)
	for i = 1, #province_list do
		table.insert(objective.conditions, "province " .. province_list[i])
	end
	return objective
end

--- @function generate_CONSTRUCT_N_OF_A_BUILDING_objective
--- @desc Construct N of a specific building
--- @p @number amount, Number to construct
--- @p @string faction_key, Faction
--- @p @string building_level_key, Building level
--- @p [opt=nil] @boolean additive, Add existing buildings to total
--- @p [opt=nil] @string override_text, Localised name key, in the [table]_[key]_[field] format.
--- @r table objective and conditions construct building
generate_CONSTRUCT_N_OF_A_BUILDING_objective = function(amount, faction_key, building_level_key, additive, override_text)
	local objective = new_objective("CONSTRUCT_N_OF_A_BUILDING")
	table.insert(objective.conditions, "total " .. tostring(amount))
	table.insert(objective.conditions, "faction " .. faction_key)
	table.insert(objective.conditions, "building_level " .. building_level_key)
	if additive then
		table.insert(objective.conditions, "additive")
	end
	if override_text then
		table.insert(objective.conditions, "override_text " .. override_text)
	end
	return objective
end

--- @function generate_CONSTRUCT_N_OF_A_BUILDING_CHAIN_objective
--- @desc Construct N buildings from a chain
--- @p @number amount, Number to construct
--- @p @table building_chain_list, Building chains by key to construct from
--- @p [opt=nil] @boolean exclude_existing, Don't count existing buildings for total
--- @r table objective and conditions construct chain
generate_CONSTRUCT_N_OF_A_BUILDING_CHAIN_objective = function(amount, building_chain_list, exclude_existing)
	local objective = new_objective("CONSTRUCT_N_OF_A_BUILDING_CHAIN")
	table.insert(objective.conditions, "total " .. tostring(amount))
	for i = 1, #building_chain_list do
		table.insert(objective.conditions, "building_chain " .. building_chain_list[i])
	end
	if exclude_existing then
		table.insert(objective.conditions, "exclude_existing")
	end
	return objective
end

--- @function generate_CONSTRUCT_NO_BUILDINGS_OF_TYPE_objective
--- @desc Fail if buildings of type are constructed
--- @p @table building_level_key, Forbidden building by key
--- @p @string faction_key, Faction to check
--- @r table objective and conditions forbidden buildings
generate_CONSTRUCT_NO_BUILDINGS_OF_TYPE_objective = function(building_level_key, faction_key)
	local objective = new_objective("CONSTRUCT_NO_BUILDINGS_OF_TYPE")
	table.insert(objective.conditions, "faction " .. faction_key)
	if building_level_key then
		table.insert(objective.conditions, "building_level " .. building_level_key)
	end
	return objective
end

--- @function generate_CONSTRUCT_NO_BUILDINGS_OF_CHAIN_objective
--- @desc Fail if building chain is constructed
--- @p @table building_chain_key, Forbidden chain by key
--- @r table objective and conditions forbidden chain
generate_CONSTRUCT_NO_BUILDINGS_OF_CHAIN_objective = function(building_chain_key)
	local objective = new_objective("CONSTRUCT_NO_BUILDINGS_OF_CHAIN")
	if building_chain_key then
		table.insert(objective.conditions, "building_chain " .. building_chain_key)
	end
	return objective
end

--- @function generate_VASSALS_OWN_BUILDINGS_objective
--- @desc Vassal factions own N buildings
--- @p @number amount, Number required
--- @p @table building_level_list, Building levels by key to construct from
--- @r table objective and conditions vassal buildings
generate_VASSALS_OWN_BUILDINGS_objective = function(amount, building_level_list)
	local objective = new_objective("VASSALS_OWN_BUILDINGS")
	table.insert(objective.conditions, "total " .. tostring(amount))
	for i = 1, #building_level_list do
		table.insert(objective.conditions, "building_level " .. building_level_list[i])
	end
	return objective
end

--- @function generate_RESEARCH_TECHNOLOGY_objective
--- @desc Research a specific technology
--- @p [opt=nil] @string technology_key, Specific technology by key
--- @p [opt=nil] @string tech_category, Technology category
--- @p [opt=nil] @string override_text, Localised name key, in the [table]_[key]_[field] format.
--- @r table objective and conditions research tech
generate_RESEARCH_TECHNOLOGY_objective = function(technology_key, tech_category, override_text)
	local objective = new_objective("RESEARCH_TECHNOLOGY")
	if technology_key then
		table.insert(objective.conditions, "technology " .. technology_key)
	end
	if tech_category then
		table.insert(objective.conditions, "technology_category " .. tech_category)
	end
	if override_text then
		table.insert(objective.conditions, "override_text " .. override_text)
	end
	return objective
end

--- @function generate_RESEARCH_N_TECHS_INCLUDING_objective
--- @desc Research N technologies including specific ones
--- @p @number amount, Total to research
--- @p @table technologies_list, Required technologies list by key
--- @p [opt=nil] @boolean additive, Count already researched technologies
--- @r table objective and conditions research techs
generate_RESEARCH_N_TECHS_INCLUDING_objective = function(amount, technologies_list, additive)
	local objective = new_objective("RESEARCH_N_TECHS_INCLUDING")
	table.insert(objective.conditions, "total " .. tostring(amount))
	for i = 1, #technologies_list do
		table.insert(objective.conditions, "technology " .. technologies_list[i])
	end
	if additive then
		table.insert(objective.conditions, "additive")
	end
	return objective
end

--- @function generate_COMPLETE_RITUAL_CHAIN_objective
--- @desc Complete an all rituals in a ritual chain
--- @p @string ritual_chain_key, Chain to complete
--- @p [opt=nil] @boolean is_coop, Count ritual performs from other human factions
--- @r table objective and conditions ritual chain
generate_COMPLETE_RITUAL_CHAIN_objective = function(ritual_chain_key, is_coop)
	local objective = new_objective("COMPLETE_RITUAL_CHAIN")
	table.insert(objective.conditions, "ritual_chain " .. ritual_chain_key)
	if is_coop then
		table.insert(objective.conditions, "is_co_op")
	end
	return objective
end

--- @function generate_SEARCH_RUINS_objective
--- @desc Search ancient ruins for treasures (via agent action)
--- @p [opt=nil] @table region_list, Specific regions by key
--- @p [opt=nil] @number amount, Number to search
--- @r table objective and conditions search ruins
generate_SEARCH_RUINS_objective = function(region_list, amount)
	local objective = new_objective("SEARCH_RUINS")
	if region_list then
		for i = 1, #region_list do
			table.insert(objective.conditions, "region " .. region_list[i])
		end
	end
	if amount then
		table.insert(objective.conditions, "total " .. tostring(amount))
	end
	return objective
end

--- @function generate_AT_LEAST_X_PUBLIC_ORDER_IN_ALL_PROVINCES_objective
--- @desc Maintain at least X public order in all provinces
--- @p @number order_level, Public order required
--- @r table objective and conditions global order
generate_AT_LEAST_X_PUBLIC_ORDER_IN_ALL_PROVINCES_objective = function(order_level)
	local objective = new_objective("AT_LEAST_X_PUBLIC_ORDER_IN_ALL_PROVINCES")
	table.insert(objective.conditions, "total " .. tostring(order_level))
	return objective
end

--- @function generate_AT_LEAST_X_PUBLIC_ORDER_IN_PROVINCES_objective
--- @desc Maintain X public order in specific provinces
--- @p @number order_level, Public order required
--- @p @table province_list, Target provinces by key
--- @p [opt=nil] @boolean additive, Count provinces already at the required public order
--- @r table objective and conditions province order
generate_AT_LEAST_X_PUBLIC_ORDER_IN_PROVINCES_objective = function(order_level, province_list, additive)
	local objective = new_objective("AT_LEAST_X_PUBLIC_ORDER_IN_PROVINCES")
	table.insert(objective.conditions, "total " .. tostring(order_level))
	for i = 1, #province_list do
		table.insert(objective.conditions, "province " .. province_list[i])
	end
	if additive then
		table.insert(objective.conditions, "additive")
	end
	return objective
end

--- @function generate_COMPLETE_N_MISSIONS_OF_CATEGORY_objective
--- @desc Complete N missions of a category
--- @p @number amount, Missions to complete
--- @p @table category_list, Mission categories
--- @r table objective and conditions missions category
generate_COMPLETE_N_MISSIONS_OF_CATEGORY_objective = function(amount, category_list)
	local objective = new_objective("COMPLETE_N_MISSIONS_OF_CATEGORY")
	table.insert(objective.conditions, "total " .. tostring(amount))
	for i = 1, #category_list do
		table.insert(objective.conditions, "event_category " .. category_list[i])
	end
	return objective
end

--- @function generate_HAVE_NO_ACTIVE_MISSIONS_OF_CATEGORY_objective
--- @desc Have no active missions in a category
--- @p @string category_key, Mission category
--- @r table objective and conditions no missions
generate_HAVE_NO_ACTIVE_MISSIONS_OF_CATEGORY_objective = function(category_key)
	local objective = new_objective("HAVE_NO_ACTIVE_MISSIONS_OF_CATEGORY")
	table.insert(objective.conditions, "event_category " .. category_key)
	return objective
end

--- @function generate_AQUIRE_MISSION_CATEGORY_WEIGHT_objective
--- @desc Accumulate mission weight in category
--- @p @number value, Number of categories
--- @p @table category_list, Target categories
--- @p @boolean value_minimum, Weight value to achieve
--- @p [opt=nil] @string override_text, Localised name key, in the [table]_[key]_[field] format.
--- @r table objective and conditions mission weight
generate_AQUIRE_MISSION_CATEGORY_WEIGHT_objective = function(value, category_list, value_minimum, override_text)
	local objective = new_objective("AQUIRE_MISSION_CATEGORY_WEIGHT")
	table.insert(objective.conditions, "value " .. tostring(value))
	for i = 1, #category_list do
		table.insert(objective.conditions, "event_category " .. category_list[i])
	end
	table.insert(objective.conditions, "value_minimum " .. tostring(value_minimum))
	if override_text then
		table.insert(objective.conditions, "override_text " .. override_text)
	end
	return objective
end

--- @function generate_ISSUE_PROVINCE_INITIATIVE_objective
--- @desc Issue N province initiatives (edicts)
--- @p @number amount, Initiatives (edicts) to issue
--- @p [opt=nil] @string initiative_key, Specific initiative (edict)
--- @r table objective and conditions province initiative
generate_ISSUE_PROVINCE_INITIATIVE_objective = function(amount, initiative_key)
	local objective = new_objective("ISSUE_PROVINCE_INITIATIVE")
	table.insert(objective.conditions, "total " .. tostring(amount))
	if initiative_key then
		table.insert(objective.conditions, "province_initiative " .. initiative_key)
	end
	return objective
end

--- @function generate_FIGHT_SET_PIECE_BATTLE_objective
--- @desc Fight a specific set piece battle
--- @p @string battle_key, Set piece battle key
--- @p [opt=nil] @string start_pos_character_id, Character to fight with
--- @p [opt=nil] @string override_text, Localised name key, in the [table]_[key]_[field] format.
--- @r table objective and conditions fight battle
generate_FIGHT_SET_PIECE_BATTLE_objective = function(battle_key, start_pos_character_id, override_text)
	local objective = new_objective("FIGHT_SET_PIECE_BATTLE")
	table.insert(objective.conditions, "set_piece_battle " .. battle_key)
	if start_pos_character_id then
		table.insert(objective.conditions, "start_pos_character " .. start_pos_character_id)
	end
	if override_text then
		table.insert(objective.conditions, "override_text " .. override_text)
	end
	return objective
end

--- @function generate_DO_NOT_LOSE_SET_PIECE_BATTLE_objective
--- @desc Do not lose specific set piece battles
--- @p @table battle_list, Required battles to win by key
--- @r table objective and conditions keep battles
generate_DO_NOT_LOSE_SET_PIECE_BATTLE_objective = function(battle_list)
	local objective = new_objective("DO_NOT_LOSE_SET_PIECE_BATTLE")
	for i = 1, #battle_list do
		table.insert(objective.conditions, "set_piece_battle " .. battle_list[i])
	end
	return objective
end

--- @function generate_RAZE_OR_SACK_N_DIFFERENT_SETTLEMENTS_OF_SUBCULTURE_objective
--- @desc Raze or sack N settlements of a specific subculture
--- @p @number amount, Number to raze/sack
--- @p @string subculture_key, Subculture to target
--- @p [opt=nil] @boolean any_faction, Count any faction doing the raze/sack
--- @r table objective and conditions subculture settlements
generate_RAZE_OR_SACK_N_DIFFERENT_SETTLEMENTS_OF_SUBCULTURE_objective = function(amount, subculture_key, any_faction)
	local objective = new_objective("RAZE_OR_SACK_N_DIFFERENT_SETTLEMENTS_OF_SUBCULTURE")
	table.insert(objective.conditions, "total " .. tostring(amount))
	table.insert(objective.conditions, "subculture " .. subculture_key)
	if any_faction then
		table.insert(objective.conditions, "any_faction")
	end
	return objective
end

--- @function generate_ENSURE_FACTIONS_HAVE_NO_MILITARY_PRESENCE_objective
--- @desc Factions have no military presence at all
--- @p @number amount, How many factions
--- @p @table faction_list, Factions to ensure have no presence, by key
--- @r table objective and conditions eliminate presence
generate_ENSURE_FACTIONS_HAVE_NO_MILITARY_PRESENCE_objective = function(amount, faction_list)
	local objective = new_objective("ENSURE_FACTIONS_HAVE_NO_MILITARY_PRESENCE")
	table.insert(objective.conditions, "total " .. tostring(amount))
	for i = 1, #faction_list do
		table.insert(objective.conditions, "faction " .. faction_list[i])
	end
	return objective
end

--- @function generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective
--- @desc Spend at least X of a pooled resource
--- @p @number amount, Amount of resource to spend
--- @p @string resource_key, Pooled resource key
--- @p [opt=nil] @string override_text, Localised name key, in the [table]_[key]_[field] format.
--- @p [opt=nil] @string pooled_resource_factor_key_list, Optional pooled resource factor to track instead of all factors of the resource. Both single factor and table of factors are accepted
--- @r table objective and conditions spend pooled resource
generate_SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE_objective = function(amount, resource_key, override_text, pooled_resource_factor_key_list)
	local objective = new_objective("SPEND_AT_LEAST_X_OF_A_POOLED_RESOURCE")
	table.insert(objective.conditions, "total " .. tostring(amount))
	table.insert(objective.conditions, "pooled_resource " .. resource_key)
	if override_text then
		table.insert(objective.conditions, "override_text " .. override_text)
	end
	if pooled_resource_factor_key_list and is_table(pooled_resource_factor_key_list) then
		for i = 1, #pooled_resource_factor_key_list do
			table.insert(objective.conditions, "pooled_resource_factor " .. pooled_resource_factor_key_list[i])
		end
	elseif pooled_resource_factor_key_list then
		table.insert(objective.conditions, "pooled_resource_factor " .. pooled_resource_factor_key_list)
	end

	return objective
end

----------------------------------------------------------------------------
--- @section Old and potentially deprecated objectives
--- @desc These objectives are implemented, but the underlying systems they reference may no longer be supported.
--- @desc Use with caution and verify functionality in the current game context.
----------------------------------------------------------------------------

--- @function generate_MAINTAIN_TRADE_WITH_N_FACTIONS_objective
--- @desc Maintain active trade with N factions
--- @desc Relies on trade route system
--- @p @number amount, Number of trade agreements to maintain
--- @r table objective and conditions maintain trade
generate_MAINTAIN_TRADE_WITH_N_FACTIONS_objective = function(amount)
	local objective = new_objective("MAINTAIN_TRADE_WITH_N_FACTIONS")
	table.insert(objective.conditions, "total " .. tostring(amount))
	return objective
end

--- @function generate_ACHIEVE_VICTORY_objective
--- @desc Complete all other victory objectives to achieve overall victory
--- @r table objective and conditions achieved victory
generate_ACHIEVE_VICTORY_objective = function()
	return new_objective("ACHIEVE_VICTORY")
end

--- @function generate_ACHIEVE_GLOBAL_FOOD_SURPLUS_objective
--- @desc Achieve a global food (pre-pooled resource system) surplus
--- @r table objective and conditions global food surplus
generate_ACHIEVE_GLOBAL_FOOD_SURPLUS_objective = function()
	return new_objective("ACHIEVE_GLOBAL_FOOD_SURPLUS")
end

--- @function generate_END_CIVIL_WAR_objective
--- @desc End a civil war (old politics system) faction split
--- @r table objective and conditions end civil war
generate_END_CIVIL_WAR_objective = function()
	return new_objective("END_CIVIL_WAR")
end

--- @function generate_STAY_HORDE_objective
--- @desc Maintain horde status throughout campaign
--- @r table objective and conditions stay horde
generate_STAY_HORDE_objective = function()
	return new_objective("STAY_HORDE")
end

--- @function generate_MP_COMPETITIVE_objective
--- @desc Unused, cannot be completed
--- @r table objective and conditions multiplayer
generate_MP_COMPETITIVE_objective = function()
	return new_objective("MP_COMPETITIVE")
end

--- @function generate_LIBERATE_N_REGIONS_TO_FACTION_objective
--- @desc Liberate N regions to allied faction (requires separate implementation)
--- @r table objective and conditions liberate regions
generate_LIBERATE_N_REGIONS_TO_FACTION_objective = function()
	return new_objective("LIBERATE_N_REGIONS_TO_FACTION")
end

--- @function generate_ATTAIN_FACTION_LEVEL_objective
--- @desc Attain a specific faction level
--- @p @number level, Faction level to achieve
--- @r table objective and conditions faction level
generate_ATTAIN_FACTION_LEVEL_objective = function(level)
	local objective = new_objective("ATTAIN_FACTION_LEVEL")
	table.insert(objective.conditions, "faction_level " .. tostring(level))
	return objective
end

--- @function generate_DEPLOY_N_AGENTS_TO_REGIONS_objective
--- @desc Deploy N agents to specified regions
--- @p @table agent_list, Agent types
--- @p @table region_list, Target regions
--- @p @number amount, Total deployments
--- @r table objective and conditions deploy agents
generate_DEPLOY_N_AGENTS_TO_REGIONS_objective = function(agent_list, region_list, amount)
	local objective = new_objective("DEPLOY_N_AGENTS_TO_REGIONS")
	table.insert(objective.conditions, "total " .. tostring(amount))
	for i = 1, #agent_list do
		table.insert(objective.conditions, "agent " .. agent_list[i])
	end
	for i = 1, #region_list do
		table.insert(objective.conditions, "region " .. region_list[i])
	end
	return objective
end

--- @function generate_DEPLOY_AGENT_TYPE_IN_PROVINCE_objective
--- @desc Deploy agent type in a province
--- @p @string province_key, Target province
--- @p @table agent_list, Agent types to deploy
--- @r table objective and conditions agent in province
generate_DEPLOY_AGENT_TYPE_IN_PROVINCE_objective = function(province_key, agent_list)
	local objective = new_objective("DEPLOY_AGENT_TYPE_IN_PROVINCE")
	table.insert(objective.conditions, "province " .. province_key)
	for i = 1, #agent_list do
		table.insert(objective.conditions, "agent " .. agent_list[i])
	end
	return objective
end

--- @function generate_DEPLOY_X_AGENTS_TO_Y_REGIONS_OWNED_BY_Z_objective
--- @desc Deploy X agents to Y regions owned by faction Z
--- @p @number num_agents, Number of agents to deploy
--- @p @number num_regions, Number of regions to use
--- @p [opt=nil] @string faction_key, Owning faction filter
--- @p [opt=nil] @string subculture_key, Subculture filter
--- @r table objective and conditions deploy with filter
generate_DEPLOY_X_AGENTS_TO_Y_REGIONS_OWNED_BY_Z_objective = function(num_agents, num_regions, faction_key, subculture_key)
	local objective = new_objective("DEPLOY_X_AGENTS_TO_Y_REGIONS_OWNED_BY_Z")
	table.insert(objective.conditions, "total " .. tostring(num_agents))
	table.insert(objective.conditions, "total2 " .. tostring(num_regions))
	if faction_key then
		table.insert(objective.conditions, "faction " .. faction_key)
	end
	if subculture_key then
		table.insert(objective.conditions, "subculture " .. subculture_key)
	end
	return objective
end

--- @function generate_BRIBE_FORCE_objective
--- @desc Bribe an enemy military force (via agent actions)
--- @p @string faction_key, Target faction
--- @r table objective and conditions bribe force
generate_BRIBE_FORCE_objective = function(faction_key)
	local objective = new_objective("BRIBE_FORCE")
	table.insert(objective.conditions, "faction " .. faction_key)
	return objective
end


--- @function generate_SABOTAGE_FORCE_objective
--- @desc Sabotage an enemy military force
--- @p [opt=nil] @string faction_key, Target faction
--- @r table objective and conditions sabotage force
generate_SABOTAGE_FORCE_objective = function(faction_key)
	local objective = new_objective("SABOTAGE_FORCE")
	if faction_key then
		table.insert(objective.conditions, "faction " .. faction_key)
	end
	return objective
end

--- @function generate_DEMORALISE_FORCE_objective
--- @desc Demoralise an enemy military force
--- @p [opt=nil] @string faction_key, Target faction
--- @r table objective and conditions demoralise force
generate_DEMORALISE_FORCE_objective = function(faction_key)
	local objective = new_objective("DEMORALISE_FORCE")
	if faction_key then
		table.insert(objective.conditions, "faction " .. faction_key)
	end
	return objective
end

--- @function generate_TRIGGER_WAAAGH_objective
--- @desc Trigger N WAAAGH events
--- @p @number amount, WAAAGH events
--- @r table objective and conditions waaagh events
generate_TRIGGER_WAAAGH_objective = function(amount)
	local objective = new_objective("TRIGGER_WAAAGH")
	table.insert(objective.conditions, "total " .. tostring(amount))
	return objective
end


--- @function generate_SABOTAGE_BUILDING_objective
--- @desc Sabotage a building in a region (via agent action or payload)
--- @p [opt=nil] @string region_key, Region key
--- @p [opt=nil] @string faction_key, Faction filter
--- @r table objective and conditions sabotage building
generate_SABOTAGE_BUILDING_objective = function(region_key, faction_key)
	local objective = new_objective("SABOTAGE_BUILDING")
	if region_key then
		table.insert(objective.conditions, "region " .. region_key)
	end
	if faction_key then
		table.insert(objective.conditions, "faction " .. faction_key)
	end
	return objective
end

--- @function generate_BRIBE_GARRISON_objective
--- @desc Bribe a garrison in a region (via agent action or payload)
--- @p [opt=nil] @string region_key, Region key
--- @p [opt=nil] @string faction_key, Garrison faction
--- @r table objective and conditions bribe garrison
generate_BRIBE_GARRISON_objective = function(region_key, faction_key)
	local objective = new_objective("BRIBE_GARRISON")
	table.insert(objective.conditions, "region " .. region_key)
	if faction_key then
		table.insert(objective.conditions, "faction " .. faction_key)
	end
	return objective
end

--- @function generate_INCITE_REVOLT_objective
--- @desc Incite a revolt in a settlement
--- @p @string region_key, Target region
--- @p [opt=nil] @string faction_key, Current owner
--- @r table objective and conditions incite revolt
generate_INCITE_REVOLT_objective = function(region_key, faction_key)
	local objective = new_objective("INCITE_REVOLT")
	table.insert(objective.conditions, "region " .. region_key)
	if faction_key then
		table.insert(objective.conditions, "faction " .. faction_key)
	end
	return objective
end

--- @function generate_HINDER_SETTLEMENT_objective
--- @desc Hinder development of a settlement
--- @p [opt=nil] @string subculture_key, Settlement subculture
--- @p [opt=nil] @string region_key, Settlement region
--- @r table objective and conditions hinder settlement
generate_HINDER_SETTLEMENT_objective = function(subculture_key, region_key)
	local objective = new_objective("HINDER_SETTLEMENT")
	if subculture_key then
		table.insert(objective.conditions, "subculture " .. subculture_key)
	end
	if region_key then
		table.insert(objective.conditions, "region " .. region_key)
	end
	return objective
end

--- @function generate_ASSIGN_CHARACTER_TO_OFFICE_objective
--- @desc Assign a character to a government post
--- @p @string position_key, Ministerial position key
--- @p [opt=nil] @string character_key, Character to assign
--- @r table objective and conditions assign post
generate_ASSIGN_CHARACTER_TO_OFFICE_objective = function(position_key, character_key)
	local objective = new_objective("ASSIGN_CHARACTER_TO_OFFICE")
	table.insert(objective.conditions, "ministerial_position " .. position_key)
	if character_key then
		table.insert(objective.conditions, "character " .. character_key)
	end
	return objective
end

--- @function generate_EARN_X_AMOUNT_FROM_BUILDING_WEALTH_objective
--- @desc Earn X gold from wealth generation
--- @p @number amount, Gold from wealth
--- @r table objective and conditions wealth income
generate_EARN_X_AMOUNT_FROM_BUILDING_WEALTH_objective = function(amount)
	local objective = new_objective("EARN_X_AMOUNT_FROM_BUILDING_WEALTH")
	table.insert(objective.conditions, "total " .. tostring(amount))
	return objective
end

--- @function generate_COMPLETE_N_QUEST_CHAINS_objective
--- @desc Complete N quest chains
--- @p @number amount, Quest chains
--- @r table objective and conditions quest chains
generate_COMPLETE_N_QUEST_CHAINS_objective = function(amount)
	local objective = new_objective("COMPLETE_N_QUEST_CHAINS")
	table.insert(objective.conditions, "total " .. tostring(amount))
	return objective
end

--- @function generate_REACH_SPECIFIED_DATE_objective
--- @desc Reach a specific date on campaign calendar
--- @p @number year, Target year
--- @p @number week, Week of year (1-52)
--- @r table objective and conditions reach date
generate_REACH_SPECIFIED_DATE_objective = function(year, week)
	local objective = new_objective("REACH_SPECIFIED_DATE")
	table.insert(objective.conditions, "year " .. tostring(year))
	table.insert(objective.conditions, "week_of_year " .. tostring(week))
	return objective
end

--- @function generate_MEET_ALL_OTHER_OBJECTIVES_WITHIN_X_TURNS_objective
--- @desc Complete all other objectives within X turns
--- @p @number turns, Turn limit
--- @r table objective and conditions time limit
generate_MEET_ALL_OTHER_OBJECTIVES_WITHIN_X_TURNS_objective = function(turns)
	local objective = new_objective("MEET_ALL_OTHER_OBJECTIVES_WITHIN_X_TURNS")
	table.insert(objective.conditions, "total " .. tostring(turns))
	return objective
end

-- MISC
region_key_list_from_region_group = function(region_group_key)
	local region_list = {}
	local regions = cm:model():world():lookup_regions_from_region_group(region_group_key)
	for i = 0, regions:num_items() - 1 do
		local region = regions:item_at(i)
		table.insert(region_list, region:name())
	end
	return region_list
end

province_key_list_from_region_group = function(region_group_key)
	local province_list = {}
	local region_interface_list = cm:model():world():lookup_regions_from_region_group(region_group_key)
	for i = 0, region_interface_list:num_items() - 1 do
		local province = region_interface_list:item_at(i):province_name()
		if not table.contains(province_list, province) then
			table.insert(province_list, province)
		end
	end
	return province_list
end

--- @function update_mission_entity_completion_states
--- @desc Utility function to show and mark completion states in mission UI of different entity types. Allows passing objects or entity keys as arguments.
--- @p @table full_entity_list table of all required entities to be shown in mission UI.
--- @p @table completed_entity_list table of entities which should be marked completed. Initially can be set as empty table.
--- @p @string entity_type Entity type to show. Supported types - object, region_key, province_key, faction_key, character_cqi.
--- @p @string mission_key Mission key to update.
--- @p @string script_key Script key to update.
update_mission_entity_completion_states = function(full_entity_list, completed_entity_list, entity_type, mission_key, script_key)

	local function get_object_from_entity_key(entity_key, entity_type)
		if entity_type == "object" then return entity_key end
		if entity_type == "region_key" then return cm:get_region(entity_key) end
		if entity_type == "province_key" then return cm:get_province(entity_key) end
		if entity_type == "faction_key" then return cm:get_faction(entity_key) end
		if entity_type == "character_cqi" then return cm:get_character_by_cqi(entity_key) end
	end

	local entity_to_completion_pair_list = {}
	for i = 1, #full_entity_list do
		if table.contains(completed_entity_list, full_entity_list[i]) then
			table.insert(entity_to_completion_pair_list, {get_object_from_entity_key(full_entity_list[i], entity_type), true})
		else
			table.insert(entity_to_completion_pair_list, {get_object_from_entity_key(full_entity_list[i], entity_type), false})
		end
	end

	cm:set_scripted_mission_entity_completion_states(mission_key, script_key, entity_to_completion_pair_list)
end

victory_objectives_scripted_listeners = {

--- @function victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION
--- @desc Creates listener for scripted mission objective to build specific buildings in specified region. Mission objective override_text has to contain names of the buildings.
--- @desc Listener creates region entity button in objective description to click on and zoom into region. Entity button will be marked completed once all buildings are constructed/owned.
--- @p @string listener_name Name of created listener.
--- @p @string mission_key Mission key of objective to create listener for.
--- @p @string script_key Script key of objective to create listener for.
--- @p @string faction_key Faction key for whom mission is created.
--- @p @string region_key Region to construct buildings in.
--- @p @table building_level_list table of buildings to construct.
	add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_REGION = function(listener_name, mission_key, script_key, faction_key, region_key, building_level_list)

		local buildings_constructed = cm:get_saved_value(faction_key .. mission_key .. script_key) or {}
		cm:set_scripted_mission_entity_completion_states(mission_key, script_key, {{cm:get_region(region_key), table.size(buildings_constructed) >= table.size(building_level_list)}})

		core:add_listener(
			listener_name,
			"BuildingCompleted",
			function(context)
				return table.contains(building_level_list, context:building():name()) and context:building():faction():name() == faction_key and context:building():region():name() == region_key
			end,
			function(context)
				local buildings_constructed = cm:get_saved_value(faction_key .. mission_key .. script_key) or {}
				local current_building_level_key = context:building():name()
				if not table.contains(buildings_constructed, current_building_level_key) then
					table.insert(buildings_constructed, current_building_level_key)
					cm:set_saved_value(faction_key .. mission_key .. script_key, buildings_constructed)
					if table.size(buildings_constructed) >= table.size(building_level_list) then
						cm:set_scripted_mission_entity_completion_states(mission_key, script_key, {{cm:get_region(region_key), table.size(buildings_constructed) >= table.size(building_level_list)}})
						cm:complete_scripted_mission_objective(faction_key, mission_key, script_key, true)
					end
				end
			end,
			true
		)

		core:add_listener(
			listener_name,
			"RegionFactionChangeEvent",
			function(context)
				local region = context:region()
				return region:name() == region_key and region:owning_faction():name() == faction_key
			end,
			function(context)
				local buildings_constructed = cm:get_saved_value(faction_key .. mission_key .. script_key) or {}
				for i = 1, #building_level_list do
					if cm:region_has_building(context:region(), building_level_list[i]) then
						if not table.contains(buildings_constructed, building_level_list[i]) then
							table.insert(buildings_constructed, building_level_list[i])
							cm:set_saved_value(faction_key .. mission_key .. script_key, buildings_constructed)
							if table.size(buildings_constructed) >= table.size(building_level_list) then
								cm:set_scripted_mission_entity_completion_states(mission_key, script_key, {{cm:get_region(region_key), table.size(buildings_constructed) >= table.size(building_level_list)}})
								cm:complete_scripted_mission_objective(faction_key, mission_key, script_key, true)
							end
							return
						end
					end
				end
			end,
			true
		)
	end,

--- @function victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_MULTIPLE_REGIONS
--- @desc Creates listener for scripted mission objective to build specific buildings in specified regions. Mission objective override_text has to contain names of the buildings.
--- @desc Listener creates region entity buttons in objective description to click on and zoom into region. Entity button will be marked completed once all buildings in this region are constructed/owned.
--- @p @string listener_name Name of created listener.
--- @p @string mission_key Mission key of objective to create listener for.
--- @p @string script_key Script key of objective to create listener for.
--- @p @string faction_key Faction key for whom mission is created.
--- @p @table region_to_building_levels_list table of regions and related building_level_keys to construct. {{region_x_key = {"building_level_1", "building_level_2"}, {region_y_key = {"building_level_1"}}}
--- @p [opt=nil] @number total Total amount of buildings to construct to complete objective.
	add_listener_SCRIPTED_CONSTRUCT_BUILDINGS_IN_MULTIPLE_REGIONS = function(listener_name, mission_key, script_key, faction_key, region_to_building_levels_list, total)

		local region_list = {}
		local building_level_list = {}

		for region_key, building_levels_key in dpairs(region_to_building_levels_list) do
			if not table.contains(region_list, region_key) then
				table.insert(region_list, region_key)
			end
			if is_table(building_levels_key) then
				for _, v in dpairs(building_levels_key) do
					table.insert(building_level_list, v)
				end
			else
				table.insert(building_level_list, building_levels_key)
			end
		end

		local completed_region_list = cm:get_saved_value("completed_regions" .. faction_key .. mission_key .. script_key) or {}
		update_mission_entity_completion_states(region_list, completed_region_list, "region_key", mission_key, script_key)

		local function update_objective_completion_states(current_building_level_key, current_building_region)
			local completed_building_level_list = cm:get_saved_value("completed_buildings" .. faction_key .. mission_key .. script_key) or {}
			if not table.contains(completed_building_level_list, current_building_level_key .. current_building_region) then
				table.insert(completed_building_level_list, current_building_level_key .. current_building_region)
				cm:set_saved_value("completed_buildings" .. faction_key .. mission_key .. script_key, completed_building_level_list)

				-- If region has more than one building to construct - check if all buildings in this region are constructed
				if is_table(region_to_building_levels_list[current_building_region]) and table.size(region_to_building_levels_list[current_building_region]) > 1 then
					for _ , building_level_key in dpairs(region_to_building_levels_list[current_building_region]) do
						if not table.contains(completed_building_level_list, building_level_key .. current_building_region) then
							return
						end
					end
				end

				local completed_region_list = cm:get_saved_value("completed_regions" .. faction_key .. mission_key .. script_key) or {}
				table.insert(completed_region_list, current_building_region)
				cm:set_saved_value("completed_regions" .. faction_key .. mission_key .. script_key, completed_region_list)
				update_mission_entity_completion_states(region_list, completed_region_list, "region_key", mission_key, script_key)

				if total and table.size(completed_building_level_list) >= total then
					cm:complete_scripted_mission_objective(faction_key, mission_key, script_key, true)
				elseif table.size(completed_building_level_list) >= table.size(building_level_list) then
					cm:complete_scripted_mission_objective(faction_key, mission_key, script_key, true)
				end
			end
		end

		core:add_listener(
			listener_name,
			"BuildingCompleted",
			function(context)
				return context:building():faction():name() == faction_key and table.contains(building_level_list, context:building():name()) and table.contains(region_list, context:building():region():name())
			end,
			function(context)
				local current_building_level_key = context:building():name()
				local current_building_region = context:building():region():name()
				update_objective_completion_states(current_building_level_key, current_building_region)
			end,
			true
		)

		core:add_listener(
			listener_name,
			"RegionFactionChangeEvent",
			function(context)
				local region = context:region()
				return region:owning_faction():name() == faction_key and table.contains(region_list, region:name())
			end,
			function(context)
				local region_obj = context:region()
				for i = 1, #building_level_list do
					if cm:region_has_building(region_obj, building_level_list[i]) then
						update_objective_completion_states(building_level_list[i], region_obj:name())
						return
					end
				end
			end,
			true
		)
	end,

--- @function victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_N_OF_A_FOREIGN_SLOT_BUILDING
--- @desc Creates a listener for a scripted mission objective to construct multiple instances of a building in foreign slots.
--- @p @string listener_name Name of created listener.
--- @p @string mission_key Mission key of objective to create listener for.
--- @p @string script_key Script key of objective to create listener for.
--- @p @string faction_key Faction key for whom mission is created.
--- @p @string building_level_key Building level key to construct.
	add_listener_SCRIPTED_CONSTRUCT_N_OF_A_FOREIGN_SLOT_BUILDING = function(listener_name, mission_key, script_key, faction_key, building_level_key)
		local saved_value_key = faction_key .. mission_key .. script_key .. "_foreign_slot_cqis"

		local function update_constructed_buildings()
			local constructed_slot_cqis = cm:get_saved_value(saved_value_key) or {}
			local foreign_slot_managers = cm:get_faction(faction_key):foreign_slot_managers()

			for i = 0, foreign_slot_managers:num_items() - 1 do
				local foreign_slots = foreign_slot_managers:item_at(i):slots()
				for j = 0, foreign_slots:num_items() - 1 do
					local foreign_slot = foreign_slots:item_at(j)
					if foreign_slot:has_building() and foreign_slot:building() == building_level_key and not table.contains(constructed_slot_cqis, foreign_slot:cqi()) then
						table.insert(constructed_slot_cqis, foreign_slot:cqi())
						cm:increase_scripted_mission_count(mission_key, script_key, 1)
					end
				end
			end

			cm:set_saved_value(saved_value_key, constructed_slot_cqis)
		end

		update_constructed_buildings()

		core:add_listener(
			listener_name,
			"ForeignSlotBuildingCompleteEvent",
			function(context)
				return context:slot_manager():faction():name() == faction_key and context:building() == building_level_key
			end,
			function()
				update_constructed_buildings()
			end,
			true
		)
	end,

--- @function victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONSTRUCT_N_OF_A_MILITARY_FORCE_BUILDING
--- @desc Creates a listener for a scripted mission objective to construct multiple instances of a building in military force slots (e.g. horde camps).
--- @p @string listener_name Name of created listener.
--- @p @string mission_key Mission key of objective to create listener for.
--- @p @string script_key Script key of objective to create listener for.
--- @p @string faction_key Faction key for whom mission is created.
--- @p @string building_level_key Building level key to construct.
	add_listener_SCRIPTED_CONSTRUCT_N_OF_A_MILITARY_FORCE_BUILDING = function(listener_name, mission_key, script_key, faction_key, building_level_key)
		local saved_value_key = faction_key .. mission_key .. script_key .. "_military_force_cqis"

		local function update_constructed_buildings()
			local constructed_force_cqis = cm:get_saved_value(saved_value_key) or {}
			local military_force_list = cm:get_faction(faction_key):military_force_list()

			for i = 0, military_force_list:num_items() - 1 do
				local military_force = military_force_list:item_at(i)
				local horde_details = military_force:horde_details()
				if not horde_details:is_null_interface() then
					local slot_list = horde_details:military_force_slot_list()
					for j = 0, slot_list:num_items() - 1 do
						local slot = slot_list:item_at(j)
						if slot:has_building() and slot:building() == building_level_key and not table.contains(constructed_force_cqis, military_force:command_queue_index()) then
							table.insert(constructed_force_cqis, military_force:command_queue_index())
							cm:increase_scripted_mission_count(mission_key, script_key, 1)
						end
					end
				end
			end

			cm:set_saved_value(saved_value_key, constructed_force_cqis)
		end

		update_constructed_buildings()

		core:add_listener(
			listener_name,
			"MilitaryForceBuildingCompleteEvent",
			function(context)
				return context:character():faction():name() == faction_key and context:building() == building_level_key
			end,
			function()
				update_constructed_buildings()
			end,
			true
		)
	end,

--- @function victory_objectives_scripted_listeners.add_listener_SCRIPTED_PERFORM_RITUALS_IN_REGIONS
--- @desc Creates listener for scripted mission objective to perform rituals linked to specific regions. Mission objective override_text has to contain names of the rituals.
--- @desc Listener creates regions entity buttons in objective description to click on and zoom into. Entity buttons will be marked when corresponding ritual is completed.
--- @p @string listener_name Name of created listener.
--- @p @string mission_key Mission key of objective to create listener for.
--- @p @string script_key Script key of objective to create listener for.
--- @p @string faction_key Faction key for whom mission is created.
--- @p @table region_to_ritual_key_list table containing pairs with named fields {region_key = "region_key", ritual_key = "ritual_key"}
--- @p @number required_amount total amount of rituals to complete for objective completion
--- @p @boolean use_ritual_target if set to true - ritual target region will be used to determine if competed ritual was targeted at linked regions.
	add_listener_SCRIPTED_PERFORM_RITUALS_IN_REGIONS = function(listener_name, mission_key, script_key, faction_key, region_to_ritual_key_list, required_amount, use_ritual_target)

		local regions_completed = cm:get_saved_value(faction_key .. mission_key .. script_key) or {}
		local required_regions_list = {}
		local required_rituals_list = {}
		for i = 1, #region_to_ritual_key_list do
			table.insert(required_regions_list, region_to_ritual_key_list[i].region_key)
			table.insert(required_rituals_list, region_to_ritual_key_list[i].ritual_key)
		end

		update_mission_entity_completion_states(required_regions_list, regions_completed, "region_key", mission_key, script_key)

		core:add_listener(
			listener_name,
			"RitualCompletedEvent",
			function(context)
				return context:performing_faction():name() == faction_key and table.contains(required_rituals_list, context:ritual():ritual_key())
			end,
			function(context)
				local current_ritual_key = context:ritual():ritual_key()
				local regions_completed = cm:get_saved_value(faction_key .. mission_key .. script_key) or {}
				local ritual_target_region = nil

				if use_ritual_target then
					ritual_target_region = context:ritual_target_region()
					if ritual_target_region:is_null_interface() then
						use_ritual_target = false
						script_error(string.format("ERROR: Could not retrieve ritual target region for objective listener '%s' (which is supposed to have it)", listener_name))
					end
				end

				if use_ritual_target then
					if ritual_target_region then
						if not table.contains(regions_completed, ritual_target_region:name()) and table.contains(required_regions_list, ritual_target_region:name()) then
							table.insert(regions_completed, ritual_target_region:name())
							cm:set_saved_value(faction_key .. mission_key .. script_key, regions_completed)
							cm:set_scripted_mission_entity_completion_states(mission_key, script_key, {{ritual_target_region, true}})
							if table.size(regions_completed) >= required_amount then
								cm:complete_scripted_mission_objective(faction_key, mission_key, script_key, true)
							end
						end
					end
				else
					for i = 1, #region_to_ritual_key_list do
						if region_to_ritual_key_list[i].ritual_key == current_ritual_key then
							if not table.contains(regions_completed, region_to_ritual_key_list[i].region_key) then
								table.insert(regions_completed, region_to_ritual_key_list[i].region_key)
								cm:set_saved_value(faction_key .. mission_key .. script_key, regions_completed)
								cm:set_scripted_mission_entity_completion_states(mission_key, script_key, {{cm:get_region(region_to_ritual_key_list[i].region_key), true}})
								if table.size(regions_completed) >= required_amount then
									cm:complete_scripted_mission_objective(faction_key, mission_key, script_key, true)
								end
							end
						end
					end
				end
			end,
			true
		)

	end,

--- @function victory_objectives_scripted_listeners.add_listener_SCRIPTED_RANKUP_N_UNITS
--- @desc Creates listener for scripted mission objective to rank up units. Mission has to be set up with counter and override_text has to contain names of the units.
--- @p @string listener_name Name of created listener.
--- @p @string mission_key Mission key of objective to create listener for.
--- @p @string script_key Script key of objective to create listener for.
--- @p @string faction_key Faction key for whom mission is created.
--- @p @table unit_list table containing unit keys.
--- @p @number required_rank required unit rank for ojective.
	add_listener_SCRIPTED_RANKUP_N_UNITS = function(listener_name, mission_key, script_key, faction_key, unit_list, required_rank)

		core:add_listener(
			listener_name,
			"UnitExperienceLevelChanged",
			function(context)
				return context:unit():faction():name() == faction_key and table.contains(unit_list, context:unit():unit_key()) and context:unit():experience_level() >= required_rank and context:previous_level() < required_rank
			end,
			function(context)
				cm:increase_scripted_mission_count(mission_key, script_key, 1)
			end,
			true
		)
	end,

--- @function victory_objectives_scripted_listeners.add_listener_SCRIPTED_PERFORM_UNIQUE_RITUALS
--- @desc Creates listener for scripted mission objective to perform unique rituals. Mission has to be set up with counter and override_text has to specify ritual names or category.
--- @p @string listener_name Name of created listener.
--- @p @string mission_key Mission key of objective to create listener for.
--- @p @string script_key Script key of objective to create listener for.
--- @p @string faction_key Faction key for whom mission is created.
--- @p @table @string ritual_key_list_or_prefix either a table of ritual keys or string - common part of ritual keys to check against with string.starts_with
--- @p [opt=nil] @string upgraded_suffix ritual key suffix for upgraded version of ritual, usually "_upgraded". If specified - both upgraded and default versions of ritual will be considered as the same ritual and contribute towards objective completion only once.
	add_listener_SCRIPTED_PERFORM_UNIQUE_RITUALS = function(listener_name, mission_key, script_key, faction_key, ritual_key_list_or_prefix, upgraded_suffix)

		local function is_objective_related_ritual(ritual_key)
			return string.starts_with(ritual_key, ritual_key_list_or_prefix)
		end

		if is_table(ritual_key_list_or_prefix) then
			is_objective_related_ritual = function(ritual_key)
				return table.contains(ritual_key_list_or_prefix, ritual_key)
			end
		end

		core:add_listener(
			listener_name,
			"RitualStartedEvent",
			function(context)
				return context:performing_faction():name() == faction_key and is_objective_related_ritual(context:ritual():ritual_key())
			end,
			function(context)
				local performed_rituals = cm:get_saved_value(faction_key .. mission_key .. script_key) or {}
				local current_ritual = context:ritual():ritual_key()

				if upgraded_suffix and string.ends_with(current_ritual, upgraded_suffix) then
					current_ritual = string.gsub(current_ritual, upgraded_suffix, "")
				end

				if not table.contains(performed_rituals, current_ritual) then
					cm:increase_scripted_mission_count(mission_key, script_key, 1)
					table.insert(performed_rituals, current_ritual)
					cm:set_saved_value(faction_key .. mission_key .. script_key, performed_rituals)
				end
			end,
			true
		)
	end,

--- @function victory_objectives_scripted_listeners.add_listener_SCRIPTED_PERFORM_RITUALS_FROM_CATEGORIES
--- @desc Creates listener for scripted mission objective to perform rituals from a list of categories. Mission has to be set up with counter and override_text has to specify ritual category.
--- @p @string listener_name Name of created listener.
--- @p @string mission_key Mission key of objective to create listener for.
--- @p @string script_key Script key of objective to create listener for.
--- @p @string faction_key Faction key for whom mission is created.
--- @p @table @string ritual_category_list_or_common either a table of ritual category keys or string - common part of ritual category keys to check against with string.find
	add_listener_SCRIPTED_PERFORM_RITUALS_FROM_CATEGORIES = function(listener_name, mission_key, script_key, faction_key, ritual_category_list_or_common)

		local function is_objective_related_ritual(ritual_category_key)
			return string.find(ritual_category_key, ritual_category_list_or_common)
		end

		if is_table(ritual_category_list_or_common) then
			is_objective_related_ritual = function(ritual_category_key)
				return table.contains(ritual_category_list_or_common, ritual_category_key)
			end
		end

		core:add_listener(
			listener_name,
			"RitualCompletedEvent",
			function(context)
				return context:succeeded() and context:performing_faction():name() == faction_key and is_objective_related_ritual(context:ritual():ritual_category())
			end,
			function(context)
				cm:increase_scripted_mission_count(mission_key, script_key, 1)
			end,
			true
		)
	end,

--- @function victory_objectives_scripted_listeners.add_listener_SCRIPTED_RANK_UP_AGENTS
--- @desc Creates listener for scripted mission objective to reach specified ranks with agents of specified subtype. Mission has to be set up with counter and override_text has to specify agent names or their category.
--- @p @string listener_name Name of created listener.
--- @p @string mission_key Mission key of objective to create listener for.
--- @p @string script_key Script key of objective to create listener for.
--- @p @string faction_key Faction key for whom mission is created.
--- @p @table character_subtype_key_list Table of character subtype keys to rank up.
--- @p @number required_rank required agent rank for ojective.
--- @p @number total total amount of agents to maintaion.
--- @p [opt=nil] @boolean should_maintain setting to true modifies objective to subtract completion progress if mortal agent who reached specified rank died.
--- @p [opt=nil] @string mission_text_description Localised name key, in the [table]_[key]_[field] format. Relevant only when setting should_maintain to true.
--- @p [opt=nil] @boolean unique_only Set true to count only unique agent subtypes provided in character_subtype_key_list
	add_listener_SCRIPTED_RANK_UP_AGENTS = function(listener_name, mission_key, script_key, faction_key, character_subtype_key_list, required_rank, total, should_maintain, mission_text_description, unique_only)

		local function update_rank_up_agents_objective(context)
			if context:character():rank() >= required_rank then
				local ranked_up_agent_fm_list = cm:get_saved_value(faction_key .. mission_key .. script_key) or {}
				local agent_fm_cqi = context:character():family_member():command_queue_index()
				if not table.contains(ranked_up_agent_fm_list, agent_fm_cqi) then

					if unique_only then
						local new_subtype_key = context:character():character_subtype_key()
						local ranked_agents_subtypes = cm:get_saved_value("Ranked_subtype_" .. faction_key .. mission_key .. script_key) or {}
						if table.contains(ranked_agents_subtypes, new_subtype_key) then
							return
						else
							table.insert(ranked_agents_subtypes, new_subtype_key)
							cm:set_saved_value("Ranked_subtype_" .. faction_key .. mission_key .. script_key, ranked_agents_subtypes)
						end
					end

					cm:increase_scripted_mission_count(mission_key, script_key, 1)
					table.insert(ranked_up_agent_fm_list, agent_fm_cqi)
					cm:set_saved_value(faction_key .. mission_key .. script_key, ranked_up_agent_fm_list)
				end

				if table.size(ranked_up_agent_fm_list) >= total then
					core:remove_listener(listener_name .. "RankUp")
					core:remove_listener(listener_name .. "Recruited")
					core:remove_listener(listener_name .. "Killed")
				end
			end
		end

		core:add_listener(
			listener_name .. "RankUp",
			"CharacterRankUp",
			function(context)
				return context:character():faction():name() == faction_key and table.contains(character_subtype_key_list, context:character():character_subtype_key())
			end,
			function(context)
				update_rank_up_agents_objective(context)
			end,
			true
		)

		core:add_listener(
			listener_name .. "Recruited",
			"CharacterRecruited",
			function(context)
				return context:character():faction():name() == faction_key and table.contains(character_subtype_key_list, context:character():character_subtype_key())
			end,
			function(context)
				update_rank_up_agents_objective(context)
			end,
			true
		)

		if should_maintain and mission_text_description then
			core:add_listener(
				listener_name .. "Killed",
				"CharacterDestroyed",
				function(context)
					local character_details = context:family_member():character_details()
					return character_details and not character_details:is_null_interface() and character_details:faction():name() == faction_key and not character_details:is_immortal()
				end,
				function(context)
					local ranked_up_agent_fm_list = cm:get_saved_value(faction_key .. mission_key .. script_key) or {}
					local agent_fm_to_remove = table.contains(ranked_up_agent_fm_list, context:family_member():command_queue_index())
					if agent_fm_to_remove then
						table.remove(ranked_up_agent_fm_list, agent_fm_to_remove)
						cm:set_saved_value(faction_key .. mission_key .. script_key, ranked_up_agent_fm_list)
						local current_total = table.size(ranked_up_agent_fm_list)
						cm:set_scripted_mission_text(mission_key, script_key, mission_text_description, current_total, total)
					end
				end,
				true
			)
		end

	end,

--- @function victory_objectives_scripted_listeners.add_listener_SCRIPTED_DEFEAT_LEGENDARY_LORDS
--- @desc Creates listener for scripted mission objective to defeat legendary lords in battle. Mission has to be set up with counter.
--- @p @string listener_name Name of created listener.
--- @p @string mission_key Mission key of objective to create listener for.
--- @p @string script_key Script key of objective to create listener for.
--- @p @string faction_key Faction key for whom mission is created.
--- @p [opt=nil] @boolean unique_only Set true to count unique Legendary Lords kills only.
--- @p [opt=nil] @string culture Culture of defeated Legendary Lords.
	add_listener_SCRIPTED_DEFEAT_LEGENDARY_LORDS = function(listener_name, mission_key, script_key, faction_key, unique_only, culture)

		if is_nil(unique_only) then
			unique_only = false
		end

		local function update_current_objective_status(defeated_character_details)

			if not is_nil(culture) then
				if defeated_character_details:faction():culture() ~= culture then
					return
				end
			end

			if unique_only then
				local defeated_legendary_lord_list = cm:get_saved_value(faction_key .. mission_key .. script_key) or {}
				local defeated_legendary_lord_key = defeated_character_details:character_subtype_key()
				if not table.contains(defeated_legendary_lord_list, defeated_legendary_lord_key) then
					table.insert(defeated_legendary_lord_list, defeated_legendary_lord_key)
					cm:increase_scripted_mission_count(mission_key, script_key, 1)
					cm:set_saved_value(faction_key .. mission_key .. script_key, defeated_legendary_lord_list)
				end
			else
				cm:increase_scripted_mission_count(mission_key, script_key, 1)
			end
		end

		core:add_listener(
			listener_name,
			"BattleCompleted",
			function()
				return cm:pending_battle_cache_faction_won_battle(faction_key)
			end,
			function()
				if cm:pending_battle_cache_attacker_victory() then
					for i = 1, cm:pending_battle_cache_num_defenders() do
						local defender_character_details = cm:get_family_member_by_cqi(cm:pending_battle_cache_get_defender_fm_cqi(i)):character_details()
						if not defender_character_details:is_null_interface() and defender_character_details:character_type("general") and campaign_traits.legendary_lord_defeated_traits[defender_character_details:character_subtype_key()] then
							update_current_objective_status(defender_character_details)
						end
					end
				elseif cm:pending_battle_cache_defender_victory() then
					for i = 1, cm:pending_battle_cache_num_attackers() do
						local attacker_character_details = cm:get_family_member_by_cqi(cm:pending_battle_cache_get_attacker_fm_cqi(i)):character_details()
						if not attacker_character_details:is_null_interface() and attacker_character_details:character_type("general") and campaign_traits.legendary_lord_defeated_traits[attacker_character_details:character_subtype_key()] then
							update_current_objective_status(attacker_character_details)
						end
					end
				end
			end,
			true
		)
	end,

--- @function victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONFEDERATE_FACTIONS_OF_CULTURE
--- @desc Creates listener for scripted mission objective to confederate factions of specific culture. If all factions of specified culture have died before objective was completed - objective will be automatically completed.
--- @p @string listener_name Name of created listener.
--- @p @string mission_key Mission key of objective to create listener for.
--- @p @string script_key Script key of objective to create listener for.
--- @p @string faction_key Faction key for whom mission is created.
--- @p @number total Amount of factions to confederate.
--- @p @string culture Culture of factions to confederate.
--- @p [opt=nil] @boolean different_culture False by default, set true if culture of mission owner differs from culture to confederate.
	add_listener_SCRIPTED_CONFEDERATE_FACTIONS_OF_CULTURE = function(listener_name, mission_key, script_key, faction_key, total, culture, different_culture)

		if is_nil(different_culture) then
			different_culture = false
		end

		core:add_listener(
			listener_name.."ConfederationCheck",
			"FactionJoinsConfederation",
			function(context)
				return context:confederation():name() == faction_key and context:faction():culture() == culture
			end,
			function(context)
				if total > 1 then
					cm:increase_scripted_mission_count(mission_key, script_key, 1)
				elseif total == 1 then
					cm:complete_scripted_mission_objective(faction_key, mission_key, script_key, true)
					core:remove_listener(listener_name.."ConfederationCheck")
					core:remove_listener(listener_name.."FactionDeathCheck")
				end
			end,
			true
		)

		core:add_listener(
			listener_name.."FactionDeathCheck",
			"FactionDeath",
			function(context)
				return context:faction():culture() == culture
			end,
			function(context)
				if cm:faction_of_culture_is_alive(culture) and different_culture then
					cm:complete_scripted_mission_objective(faction_key, mission_key, script_key, true)
				else
					local faction_list = context:faction():factions_of_same_culture()
					for i = 0, faction_list:num_items() - 1 do
						local current_faction = faction_list:item_at(i)
						if current_faction:name() ~= faction_key and
							not current_faction:is_dead() and
							not current_faction:is_quest_battle_faction() and
							not current_faction:is_rebel() and
							not current_faction:is_vassal() then
							return
						end
					end
					cm:complete_scripted_mission_objective(faction_key, mission_key, script_key, true)
				end
				core:remove_listener(listener_name.."ConfederationCheck")
				core:remove_listener(listener_name.."FactionDeathCheck")
			end,
			true
		)

	end,

--- @function victory_objectives_scripted_listeners.add_listener_SCRIPTED_CONFEDERATE_VASSALISE_OR_DESTROY_X_FACTIONS
--- @desc Creates listener for scripted mission objective to confederate, vassalise or destroy X factions.
--- @p @string listener_name Name of created listener.
--- @p @string mission_key Mission key of objective to create listener for.
--- @p @string script_key Script key of objective to create listener for.
--- @p @string faction_key Faction key for whom mission is created.
--- @p @table faction_key_list Table of faction keys to target.
--- @p @number total Number of factions from the list to confederate/vassalise/destroy.
	add_listener_SCRIPTED_CONFEDERATE_VASSALISE_OR_DESTROY_X_FACTIONS = function(listener_name, mission_key, script_key, faction_key, faction_key_list, total)
		-- copy the table of targets into a keyed table so can easily look them up later on
		local faction_key_list_keyed = {}

		for i = 1, #faction_key_list do
			local current_faction_key = faction_key_list[i]

			faction_key_list_keyed[current_faction_key] = true

			cm:set_scripted_mission_entity_completion_states(mission_key, script_key, {{cm:get_faction(current_faction_key), false}})
		end

		local function test_factions_status()
			local count = 0
			local player_faction = cm:get_faction(faction_key)

			for test_faction_key, _ in pairs(faction_key_list_keyed) do
				local current_test_faction = cm:get_faction(test_faction_key)

				if current_test_faction:is_dead() or current_test_faction:is_vassal_of(player_faction) then
					cm:set_scripted_mission_entity_completion_states(mission_key, script_key, {{current_test_faction, true}})
					count = count + 1
				else
					cm:set_scripted_mission_entity_completion_states(mission_key, script_key, {{current_test_faction, false}})
				end
			end

			if count >= total then
				cm:complete_scripted_mission_objective(faction_key, mission_key, script_key, true)
			else
				-- set it back to pending in case its complete!
			end
		end

		-- this also covers death via confederation
		core:add_listener(
			listener_name.."FactionDeathCheck",
			"FactionDeath",
			function(context)
				local faction = context:faction()
				return faction_key_list_keyed[faction:name()]
			end,
			function()
				test_factions_status()
			end,
			true
		)

		core:add_listener(
			listener_name.."FactionVassalCheck",
			"FactionBecomesVassal",
			function(context)
				return faction_key_list_keyed[context:vassal():name()] and context:faction():name() == faction_key
			end,
			function()
				test_factions_status()
			end,
			true
		)

		core:add_listener(
			listener_name.."FactionBreaksVassalCheck",
			"NegativeDiplomaticEvent",
			function(context)
				return context:was_vassalage() and (faction_key_list_keyed[context:proposer():name()] or faction_key_list_keyed[context:recipient():name()])
			end,
			function()
				test_factions_status()
			end,
			true
		)

		core:add_listener(
			listener_name.."FactionTurnStart",
			"FactionTurnStart",
			function(context)
				local factions_turn = context:faction():name()
				return factions_turn == faction_key or faction_key_list_keyed[factions_turn]
			end,
			function()
				test_factions_status()
			end,
			true
		)

		test_factions_status()
	end,
}