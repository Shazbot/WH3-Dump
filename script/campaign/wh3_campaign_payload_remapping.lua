
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	PAYLOAD REMAPPING
--
--	PURPOSE
--	Uses of the payload remapping system should be placed here. Payload remapping is where we remap a particular type 
--	of mission reward (payload) for a particular faction. For example, we might say that a Daemon faction does not
--	earn money, but instead earns a type of Daemonic Currency.
--
--	See the script documentation for the payload utility library for more information about payload remapping.
--
--	LOADED
--	Loaded on start of script when playing any major campaign.
--	
--	AUTHORS
--	SV
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------





-- Mapping of string values that express how much of a particular type of resource to add.
-- Please keep these tables in-sync.
local VALID_MISSION_REWARD_VALUES_INDEXED = {
	"v_low",
	"low",
	"med",
	"high",
	"v_high"
};









-------------------------------------------------
-------------------------------------------------
-- DAEMONIC GLORY
-- For Daemon Prince factions
-------------------------------------------------
-------------------------------------------------

-- Daemonic Glory mapping
local VALID_MISSION_REWARD_GLORY_VALUES = {
	-- ideally all of these values should be divisible by 2, 3, 4 and 5
	["v_low"] 	= 60,
	["low"] 	= 120,
	["med"] 	= 180,
	["high"] 	= 240,
	["v_high"] 	= 300
};

-- Mapping of string glory types to functions in the payload table that deliver glory of that type
-- Please keep these two tables in-sync
local VALID_GLORY_TYPES = {
	["khorne"] = payload.khorne_glory,
	["nurgle"] = payload.nurgle_glory,
	["slaanesh"] = payload.slaanesh_glory,
	["tzeentch"] = payload.tzeentch_glory,
	["undivided"] = payload.undivided_glory
};
local VALID_GLORY_TYPES_INDEXED = {
	"khorne",
	"nurgle",
	"slaanesh",
	"tzeentch",
	"undivided"
};

local function daemon_prince_glory_money_equivalence_mapping(money_value, faction_key, params)

	if not params then
		script_error("WARNING: daemon_prince_glory_money_equivalence_mapping() called but no params passed in which are required to determine a glory reward type. Will just add money.")
		return payload.money_direct(money_value);
	end;

	-- Determine amount of glory to award
	local glory_value_lookup = params.value;
	local glory_value = VALID_MISSION_REWARD_GLORY_VALUES[glory_value_lookup];

	if not glory_value then
		script_error("WARNING: daemon_prince_glory_money_equivalence_mapping() called but couldn't determine a glory amount to add based on glory value [" .. tostring(glory_value_lookup) .. "] - valid glory values are [" .. table.concat(VALID_MISSION_REWARD_VALUES_INDEXED, ", ") .. "], one of these should be specified as \"params.value\", where params is a table argument to this function. Will just add a very low amount of glory");
		glory_value = VALID_MISSION_REWARD_GLORY_VALUES[VALID_MISSION_REWARD_VALUES_INDEXED[1]];		-- add the lowest amount (assuming they are in ascending order!)
	end;

	local glory_types = {};

	-- parse glory_type as a comma separated string
	for glory_type in string.gmatch(params.glory_type, "%a+") do
		if VALID_GLORY_TYPES[glory_type] then
			table.insert(glory_types, glory_type);
		else
			script_error("WARNING: daemon_prince_glory_money_equivalence_mapping() called but glory type [" .. glory_type .. "] is not a valid glory type. Valid glory type values are [" .. table.concat(VALID_MISSION_REWARD_VALUES_INDEXED, ", ") .. "]");
		end;
	end

	if #glory_types == 0 then
		script_error("WARNING: daemon_prince_glory_money_equivalence_mapping() called but couldn't determine a glory type - a value should be specified as the 'glory_type' element of the params table that is specified with the mission reward. Valid glory type values are [" .. table.concat(VALID_MISSION_REWARD_VALUES_INDEXED, ", ") .. "]. Will just add money instead in this case.");
		return payload.money_direct(money_value);
	end;

	local glory_value_per_glory_type = math.floor(glory_value / #glory_types);

	local payload_str_table = {};

	for i = 1, #glory_types do
		local glory_type = glory_types[i];
		local glory_function_name = glory_type .. "_glory";

		if not payload[glory_function_name] then
			script_error("WARNING: daemon_prince_glory_money_equivalence_mapping() called but couldn't determine a glory applicator function from supplied glory type value [" .. tostring(glory_type) .. "]. Valid glory type values are [" .. table.concat(VALID_MISSION_REWARD_VALUES_INDEXED, ", ") .. "]. Will just add money instead in this case.");
			return payload.money_direct(money_value);
		end;

		local payload_str = payload[glory_function_name](glory_value_per_glory_type);
		table.insert(payload_str_table, payload_str);
	end;

	return unpack(payload_str_table);
end;


local function daemon_prince_ancillary_equivalence_mapping(faction_key, category, rarity)

	local glory_value;

	if rarity == "rare" then
		glory_value = 80;
	elseif rarity == "uncommon" then
		glory_value = 50;
	elseif rarity == "common" then
		glory_value = 20;
	else
		script_error("ERROR: daemon_prince_ancillary_equivalence_mapping() called but supplied ancillary rarity [" .. tostring(category) .. "] is not recognised. No reward will be generated");
		return;
	end;

	return payload.khorne_glory(glory_value), payload.nurgle_glory(glory_value), payload.slaanesh_glory(glory_value), payload.tzeentch_glory(glory_value), payload.undivided_glory(glory_value);
end;


payload.add_money_equivalence_mapping("wh3_main_dae_daemon_prince", daemon_prince_glory_money_equivalence_mapping);
payload.add_ancillary_equivalence_mapping("wh3_main_dae_daemon_prince", daemon_prince_ancillary_equivalence_mapping);









-------------------------------------------------
-------------------------------------------------
-- SKULLS
-- For Khorne factions
-------------------------------------------------
-------------------------------------------------

local function khorne_skulls_money_equivalence_mapping(money_value, faction_key, params)

	-- 1/5th of the money is re-allocated to skulls
	local skulls_value = money_value * 0.2;
	money_value = money_value * 0.8;
	
	return payload.money_direct(money_value) .. ";" .. payload.skulls(skulls_value)
end

payload.add_money_equivalence_mapping("wh3_main_kho_exiles_of_khorne", khorne_skulls_money_equivalence_mapping);








-------------------------------------------------
-------------------------------------------------
-- DEVOTEES
-- For Slaanesh factions
-------------------------------------------------
-------------------------------------------------

local function slaanesh_devotees_money_equivalence_mapping(money_value, faction_key, params)

	-- 1/4 of the money is re-allocated to devotees (at 1/10th the original money value)
	local devotees_value = money_value * 0.1;
	money_value = money_value * 0.75;
	
	return payload.money_direct(money_value) .. ";" .. payload.devotees(devotees_value)
end

payload.add_money_equivalence_mapping("wh3_main_sla_seducers_of_slaanesh", slaanesh_devotees_money_equivalence_mapping);









-------------------------------------------------
-------------------------------------------------
-- GRIMOIRES
-- For Tzeentch factions
-------------------------------------------------
-------------------------------------------------

local function tzeentch_grimoires_money_equivalence_mapping(money_value, faction_key, params)

	-- 1/4 of the money is re-allocated to grimoires (at 1/10th the original money value)
	local grimoires_value = money_value * 0.1;
	money_value = money_value * 0.75;
	
	return payload.money_direct(money_value) .. ";" .. payload.grimoires(grimoires_value)
end

payload.add_money_equivalence_mapping("wh3_main_tze_oracles_of_tzeentch", tzeentch_grimoires_money_equivalence_mapping);

