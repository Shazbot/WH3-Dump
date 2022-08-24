-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	CAMPAIGN AI SCRIPT
--	Called by start_game_all_factions() in wh_start.lua, so it runs at start/load of the game
--
--  Handles the following parts of the CAI behaviour:
--  - Adjusting the global script controlled context of the campaign based on game phase (early/mid/late)
--  - Norsca VS Cathay bastion AI logic
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local soul_threat_modifier = 100;

local bastion_related_factions_list = {
	"wh3_main_rogue_kurgan_warband",
	"wh3_main_cth_celestial_loyalists",
	"wh3_main_cth_imperial_wardens",
	"wh3_main_cth_the_jade_custodians",
	"wh3_main_cth_the_northern_provinces",
	"wh3_main_cth_the_western_provinces",
};

local bastions_list = {
	"wh3_main_chaos_region_dragon_gate",
	"wh3_main_chaos_region_snake_gate",
	"wh3_main_chaos_region_turtle_gate",
};


-- ================================= BASTION RELATED FUNCTIONS ================================= --
function count_standing_bastions()
	local cnt = 0;
	for i, v in pairs(bastions_list) do
		-- Get region by name, check if it's not a ruin
		local region = cm:model():world():region_manager():region_by_key(v);
		if (region~=null) then
			if (region:is_abandoned()) then 
				out.design("Region: "..region:name().." ABANDONED");
			else 
				out.design("Region: "..region:name().." NOT abandoned");
			end;
			
			if (region:is_abandoned() == false) then
				cnt = cnt+1;
			end;
		end;
	end;
	
	return cnt;
end;

function set_bastion_related_factions_to_context(target_context)
	for i, v in pairs(bastion_related_factions_list) do
		cm:cai_set_faction_script_context(v, target_context);
		out.design("============== This faction: "..v.." is now using this context: "..cm:cai_get_faction_script_context(v).." ==============");
	end;
end;

function count_souls_for_faction(faction)
	local cnt = 0;
	local soul_keys = {
		"wh3_main_realm_complete_khorne",
		"wh3_main_realm_complete_nurgle",
		"wh3_main_realm_complete_slaanesh",
		"wh3_main_realm_complete_tzeentch"
	}

	for i = 1, #soul_keys do 
		if faction:pooled_resource_manager():resource(soul_keys[i]):is_null_interface() and faction:pooled_resource_manager():resource(soul_keys[i]) == 1 then
			cnt = cnt+1
		end
	end

	return cnt;
end;

function setup_campaign_ai()
	out.design("*********************************");
	out.design("===== SETUP CAMPAIGN AI =====");
	
	out.design("Initial Bastion state check");
	if (count_standing_bastions() ~= (table.getn(bastions_list))) then
		out.design("============== Campaign started with at least razed Bastion settlement, switching related AI factions to appropriate context ==============");
		set_bastion_related_factions_to_context("cai_faction_script_context_special_2")
	end;
	
	
	out.design("===== CHAOS VS CATHAY BASTION SETUP =====");
	-- BASTION RAZED
	core:add_listener(
		"bastion_settlement_razed",
		"CharacterRazedSettlement",
		function(context)
			local region = context:garrison_residence():region();
			return ((region:name() == "wh3_main_chaos_region_dragon_gate") or (region:name() == "wh3_main_chaos_region_snake_gate") or (region:name() == "wh3_main_chaos_region_turtle_gate"));
		end,
		function(context)
			--If the Kurgan Warband is not already in "special_2" context, switch to it; Same with Cathay factions
			out.design("============== Bastion settlement razed script running ==============");
			local warband = cm:model():world():faction_by_key("wh3_main_rogue_kurgan_warband");
			if not (warband == null) then
				if not (cm:cai_get_faction_script_context("wh3_main_rogue_kurgan_warband") == "cai_faction_script_context_special_2") then
					--Kurgan Warband now switches to "free for all" mode, Cathay factions try to capture back the gates
					out.design("============== Bastion settlement was destroyed, related factions will now be set to cai_faction_script_context_special_2 context ==============");
					set_bastion_related_factions_to_context("cai_faction_script_context_special_2")
				end;
			end;
			
		end,
		true
	);
	
	-- BASTION COLONISED
	core:add_listener(
		"bastion_settlement_colonised",
		"CharacterPerformsSettlementOccupationDecision",
		function(context)
			local region = context:garrison_residence():region();
			local is_colonised = ((context:settlement_option() == "occupation_decision_colonise") or (context:settlement_option() == "occupation_decision_resettle"));
			local is_bastion = ((region:name() == "wh3_main_chaos_region_dragon_gate") or (region:name() == "wh3_main_chaos_region_snake_gate") or (region:name() == "wh3_main_chaos_region_turtle_gate"));
			return (is_colonised and is_bastion);
		end,
		function(context)
			out.design("============== Bastion settlement colonised script running ==============");
			if not ((cm:model():world():faction_by_key("wh3_main_rogue_kurgan_warband") == null) or (cm:cai_get_faction_script_context("wh3_main_rogue_kurgan_warband") == "cai_faction_script_context_type_default")) then
				-- Check number of "standing" gates, if it's N-1, then change the context back to default
				out.design("============== Bastion settlement was colonised, checking if all bastions are standing ==============");
				if (count_standing_bastions() == (table.getn(bastions_list))) then
					out.design("============== No more ruined gates, related factions will now be set to default faction context ==============");
					set_bastion_related_factions_to_context("cai_faction_script_context_type_default")
				end;
			end;
		end,
		true
	);
	
	
	-- FACTION TURN START - update threat score penalty for souls
	out.design("===== THREAT INCREASE FOR EACH SOUL SETUP =====");
	core:add_listener(
		"update_threat_score_for_souls",
		"FactionTurnStart",
		function(context)
			local faction = context:faction();
			return faction:can_be_human(); -- this should filter for only major factions
		end,
		function(context)
			local faction = context:faction();
			local faction_name = faction:name();
			-- run a function that counts souls
			local soul_cnt = count_souls_for_faction(faction);
			if soul_cnt > 0 then
				-- set threat level modifier based on souls
				local modifier = soul_cnt * soul_threat_modifier;
				out.design("============== Updated base threat score for faction: "..faction_name.." == "..modifier.."  ==============");
				cm:set_base_strategic_threat_score(faction, modifier);
			end;
		end,
		true
	);
end;