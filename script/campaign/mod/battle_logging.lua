local log_filename = "_LUA_BattleLog";
local log_path = "\\The Creative Assembly\\Warhammer3\\logs\\campaign_ai";
local log_filetype = ".csv";
local log_data = {};

function battle_logging()
	if core:is_tweaker_set("SCRIPTED_TWEAKER_18") then
		local session_id = cm:model():session_id();

		log_path = os.getenv("APPDATA")..log_path;
		os.execute("mkdir \""..log_path.."\"");
		log_path = log_path .. "\\"..session_id..log_filename;

		core:add_listener(
			"BattleCompletedAutoRun",
			"BattleCompleted",
			true,
			function(context) LogBattle(context) end,
			true
		);
		core:add_listener(
			"PrintBattleLog",
			"WorldStartRound",
			true,
			function()
				local turn = cm:turn_number();

				if turn % 50 == 0 then
					PrintBattleLog("_"..tostring(turn));
				end

				PrintBattleLog("");
			end,
			true
		);
	end
end

function LogBattle(context)
	local pb = cm:model():pending_battle();
	
	if pb:has_been_fought() and pb:ended_with_withdraw() == false then
		local attacker_list = {};
		local defender_list = {};
		local attacker_list_is_major = {};
		local defender_list_is_major = {};
		local attacker_won = cm:pending_battle_cache_attacker_victory();
		local defender_won = cm:pending_battle_cache_defender_victory();
		local attacker_result = pb:attacker_battle_result();
		local defender_result = pb:defender_battle_result();
		local attacker_stronger = pb:attacker_is_stronger();
		local defender_stronger = pb:attacker_is_stronger() == false;
		local attacker_strength = pb:attacker_strength() / pb:defender_strength(); -- What even is strength rating?
		local defender_strength = pb:defender_strength() / pb:attacker_strength();
		local attacker_value = cm:pending_battle_cache_attacker_value() / cm:pending_battle_cache_defender_value();
		local defender_value = cm:pending_battle_cache_defender_value() / cm:pending_battle_cache_attacker_value();
		local battle_type = pb:battle_type();
		local region_owner = "";
		local region_data = pb:region_data();

		if region_data:is_null_interface() == false then
			if region_data:region():is_null_interface() == false then
				if region_data:region():is_abandoned() == false then
					if region_data:region():owning_faction():is_null_interface() == false then
						region_owner = cm:model():pending_battle():region_data():region():owning_faction():name();
					end
				end
			end
		end

		for i = 1, cm:pending_battle_cache_num_attackers() do
			local char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_attacker(i); 				--Produces the list of attackers/defenders which oppose the faction which we want to log,
			local attacker_opponent_is_major = false;
			if cm:get_faction(faction_name) then
				attacker_opponent_is_major = cm:get_faction(faction_name):can_be_human();					--and a list of wether they are major factions or not
			end
			table.insert(attacker_list_is_major, attacker_opponent_is_major);	
			table.insert(attacker_list, faction_name);										
		end
		for i = 1, cm:pending_battle_cache_num_defenders() do
			local char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_defender(i);
			local defender_opponent_is_major = false;
			if cm:get_faction(faction_name) then
				defender_opponent_is_major = cm:get_faction(faction_name):can_be_human();
			end
			table.insert(defender_list_is_major, defender_opponent_is_major);	
			table.insert(defender_list, faction_name);
		end
		
		for i = 1, cm:pending_battle_cache_num_attackers() do
			local char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_attacker(i);
			local attacker_is_major = false;
			if cm:get_faction(faction_name) then
				 attacker_is_major = cm:get_faction(faction_name):can_be_human();
			end
			LogBattleFaction(faction_name, defender_list, true, attacker_won, attacker_stronger, attacker_result, attacker_strength, attacker_value, battle_type, region_owner, attacker_is_major, defender_list_is_major);
		end
		for i = 1, cm:pending_battle_cache_num_defenders() do
			local char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_defender(i);
			local defender_is_major = false;
			if cm:get_faction(faction_name) then
				defender_is_major = cm:get_faction(faction_name):can_be_human();
			end
			LogBattleFaction(faction_name, attacker_list, false, defender_won, defender_stronger, defender_result, defender_strength, defender_value, battle_type, region_owner, defender_is_major, attacker_list_is_major);
		end
	end
end

--gets the data and stores it in a LUA table to be accessed later
function LogBattleFaction(faction_name, enemies, was_attacker, won, was_stronger, result_type, enemy_str, enemy_val, battle_type, region_owner, is_major, enemy_major_status)	
	if log_data[faction_name] == nil then
		log_data[faction_name] = {};
	end

	for i = 1, #enemies do
		local enemy_key = enemies[i];
		local enemy_major = enemy_major_status[i];

		if log_data[faction_name][enemy_key] == nil then
			log_data[faction_name][enemy_key] = {};
			log_data[faction_name][enemy_key].fought = 0;
			log_data[faction_name][enemy_key].won = 0;
			log_data[faction_name][enemy_key].attacker = 0;
			log_data[faction_name][enemy_key].won_attacker = 0;

			log_data[faction_name][enemy_key].stronger = 0;
			log_data[faction_name][enemy_key].enemy_str = 0;
			log_data[faction_name][enemy_key].enemy_val = 0;
			log_data[faction_name][enemy_key].own_region = 0;
			log_data[faction_name][enemy_key].is_major = false;
			log_data[faction_name][enemy_key].self_is_major = false;

			log_data[faction_name][enemy_key].type_land = 0;
			log_data[faction_name][enemy_key].type_siege_major = 0;
			log_data[faction_name][enemy_key].type_siege_minor = 0;
			log_data[faction_name][enemy_key].type_ambush = 0;
			log_data[faction_name][enemy_key].type_other = 0;
		end

		log_data[faction_name][enemy_key].fought = log_data[faction_name][enemy_key].fought + 1;

		if won == true then
			log_data[faction_name][enemy_key].won = log_data[faction_name][enemy_key].won + 1;
		end

		if was_attacker == true then
			log_data[faction_name][enemy_key].attacker = log_data[faction_name][enemy_key].attacker + 1;
		end
		
		if won == true and was_attacker == true then
			log_data[faction_name][enemy_key].won_attacker = log_data[faction_name][enemy_key].won_attacker + 1;
		end

		if was_stronger == true then
			log_data[faction_name][enemy_key].stronger = log_data[faction_name][enemy_key].stronger + 1;
		end

		log_data[faction_name][enemy_key].enemy_str = log_data[faction_name][enemy_key].enemy_str + enemy_str;
		log_data[faction_name][enemy_key].enemy_val = log_data[faction_name][enemy_key].enemy_val + enemy_val;

		log_data[faction_name][enemy_key].enemy_is_major = enemy_major;
		log_data[faction_name][enemy_key].self_is_major = is_major;

		if faction_name == region_owner then
			log_data[faction_name][enemy_key].own_region = log_data[faction_name][enemy_key].own_region + 1;
		end

		if battle_type == "land_normal" then
			log_data[faction_name][enemy_key].type_land = log_data[faction_name][enemy_key].type_land + 1;
		elseif battle_type == "settlement_standard" then
			log_data[faction_name][enemy_key].type_siege_major = log_data[faction_name][enemy_key].type_siege_major + 1;
		elseif battle_type == "settlement_unfortified" then
			log_data[faction_name][enemy_key].type_siege_minor = log_data[faction_name][enemy_key].type_siege_minor + 1;
		elseif battle_type == "land_ambush" then
			log_data[faction_name][enemy_key].type_ambush = log_data[faction_name][enemy_key].type_ambush + 1;
		else
			log_data[faction_name][enemy_key].type_other = log_data[faction_name][enemy_key].type_other + 1;
		end
	end
end

--Actually creates the log using the data from the LUA table.
function PrintBattleLog(turn_num)
	local log_interface = io.open(log_path..turn_num..log_filetype, "w");

	if log_interface then
		local header = "FACTION,";
		header = header.."FACTION IS MAJOR,";
		header = header.."OPPONENT,";
		header = header.."OPPONENT IS MAJOR,";
		header = header.."BATTLES,";
		header = header.."WIN %,";
		header = header.."WAS ATTACKER %,";
		header = header.."WON AS ATTACKER %,";
		header = header.."WAS STRONGER %,";
		--header = header.."AVG STRENGTH RATIO,";
		header = header.."AVG VALUE RATIO,";
		header = header.."OWN REGION %,";
		header = header.."LAND BATTLE %,";
		header = header.."SIEGE MAJOR %,";
		header = header.."SIEGE MINOR %,";
		header = header.."AMBUSH %,";
		header = header.."OTHER %,";
		log_interface:write(header.."\n");

		for faction_key, enemy in pairs(log_data) do
			local total_fought = 0;
			local total_won = 0;
			local total_attacker = 0;
			local total_won_attacker = 0;
	
			local total_stronger = 0;
			local total_enemy_str = 0;
			local total_enemy_val = 0;
			local total_own_region = 0;
	
			local total_type_land = 0;
			local total_type_siege_major = 0;
			local total_type_siege_minor = 0;
			local total_type_ambush = 0;
			local total_type_other = 0;

			for enemy_key, battles in pairs(enemy) do
				total_fought = total_fought + battles.fought;
				total_won = total_won + battles.won;
				total_attacker = total_attacker + battles.attacker;
				total_won_attacker = total_won_attacker + battles.won_attacker;
				faction_is_major = tostring(battles.self_is_major);

				total_stronger = total_stronger + battles.stronger;
				total_enemy_str = total_enemy_str + battles.enemy_str;
				total_enemy_val = total_enemy_val + battles.enemy_val;
				total_own_region = total_own_region + battles.own_region;

				total_type_land = total_type_land + battles.type_land;
				total_type_siege_major = total_type_siege_major + battles.type_siege_major;
				total_type_siege_minor = total_type_siege_minor + battles.type_siege_minor;
				total_type_ambush = total_type_ambush + battles.type_ambush;
				total_type_other = total_type_other + battles.type_other;

				local win_percent = (battles.won / battles.fought) * 100;
				local attacker_percent = (battles.attacker / battles.fought) * 100;
				local won_attacker_percent = (battles.won_attacker / battles.attacker) * 100;

				local stronger_ratio = (battles.stronger / battles.fought) * 100;
				local str_ratio = (battles.enemy_str / battles.fought) * 100;
				local val_ratio = (battles.enemy_val / battles.fought) * 100;
				local own_region_ratio = (battles.own_region / battles.fought) * 100;
				
				local type_land_ratio = (battles.type_land / battles.fought) * 100;
				local type_siege_major_ratio = (battles.type_siege_major / battles.fought) * 100;
				local type_siege_minor_ratio = (battles.type_siege_minor / battles.fought) * 100;
				local type_ambush_ratio = (battles.type_ambush / battles.fought) * 100;
				local type_other_ratio = (battles.type_other / battles.fought) * 100;

				local output = faction_key..",";
				output = output..tostring(battles.self_is_major)..",";
				output = output..enemy_key..",";
				output = output..tostring(battles.enemy_is_major)..",";
				output = output..battles.fought..",";
				output = output..rti(win_percent).."%,";
				output = output..rti(attacker_percent).."%,";
				output = output..rti(won_attacker_percent).."%,";
				output = output..rti(stronger_ratio).."%,";
				--output = output..rti(str_ratio).."%,";
				output = output..rti(val_ratio).."%,";
				output = output..rti(own_region_ratio).."%,";
				output = output..rti(type_land_ratio).."%,";
				output = output..rti(type_siege_major_ratio).."%,";
				output = output..rti(type_siege_minor_ratio).."%,";
				output = output..rti(type_ambush_ratio).."%,";
				output = output..rti(type_other_ratio).."%,";
				log_interface:write(output.."\n");
			end

			local total_win_percent = (total_won / total_fought) * 100;
			local total_attacker_percent = (total_attacker / total_fought) * 100;
			local total_won_attacker_percent = (total_won_attacker / total_attacker) * 100;

			local total_stronger_ratio = (total_stronger / total_fought) * 100;
			local total_str_ratio = (total_enemy_str / total_fought) * 100;
			local total_val_ratio = (total_enemy_val / total_fought) * 100;
			local total_own_region_ratio = (total_own_region / total_fought) * 100;
				
			local total_type_land_ratio = (total_type_land / total_fought) * 100;
			local total_type_siege_major_ratio = (total_type_siege_major / total_fought) * 100;
			local total_type_siege_minor_ratio = (total_type_siege_minor / total_fought) * 100;
			local total_type_ambush_ratio = (total_type_ambush / total_fought) * 100;
			local total_type_other_ratio = (total_type_other / total_fought) * 100;

			local total_output = faction_key..","..faction_is_major..",TOTAL,0,";
			total_output = total_output..total_fought..",";
			total_output = total_output..rti(total_win_percent).."%,";
			total_output = total_output..rti(total_attacker_percent).."%,";
			total_output = total_output..rti(total_won_attacker_percent).."%,";
			total_output = total_output..rti(total_stronger_ratio).."%,";
			--total_output = total_output..rti(total_str_ratio).."%,";
			total_output = total_output..rti(total_val_ratio).."%,";
			total_output = total_output..rti(total_own_region_ratio).."%,";
			total_output = total_output..rti(total_type_land_ratio).."%,";
			total_output = total_output..rti(total_type_siege_major_ratio).."%,";
			total_output = total_output..rti(total_type_siege_minor_ratio).."%,";
			total_output = total_output..rti(total_type_ambush_ratio).."%,";
			total_output = total_output..rti(total_type_other_ratio).."%,";
			log_interface:write(total_output.."\n");
		end
		log_interface:flush();
		log_interface:close();
	end
end

function rti(num)
	return math.round(num);
end  