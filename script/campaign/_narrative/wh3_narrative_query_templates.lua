------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	NARRATIVE QUERY TEMPLATES
--
--	PURPOSE
--	This file defines narrative query templates. These templates can be used by any scripts that set up narrative 
--	event chains - either shared, racial, or campaign-specific.
--
--	See the script documentation for more information about the underlying narrative event system.
--
--	LOADED
--	This file is loaded by wh3_narrative_loader.lua, which in turn should be loaded by the per-campaign narrative 
--	script file.
--	
--	AUTHORS
--	SV
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


--- @set_environment campaign


--- @data_interface narrative_queries Narrative Query Templates
--- @function_separator .
--- @desc The <code>narrative_queries</code> table contains a list of narrative query templates that campaign scripts can use to create narrative queries. See the page on @narrative for an overview of the narrative event framework. See also the @narrative_query documentation for detailed information about the <code>narrative_query</code> object interface.
narrative_queries = {};













-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Savegame Value
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_query_savegame_value_exists(name, faction_key, trigger_messages, positive_trigger_messages, negative_trigger_messages, value_key, condition)

	if not validate.is_string(value_key) then
		return false;
	end;

	if condition and not validate.is_condition(condition) then
		return false;
	end;

	local query_records = {
		{
			message = positive_trigger_messages,
			fail_message = negative_trigger_messages,
			query = function(context, nq)
				-- Return false if we were supplied an additional condition and it fails
				if is_function(condition) then
					local result, result_str = condition(context, nq);
					if is_boolean(result) then
						return result, error_str;
					end;
				end;

				if cm:get_saved_value(value_key) then
					return true, "savegame value with key [" .. value_key .. "] exists";
				end;

				return false, "savegame value with key [" .. value_key .. "] does not exist";
			end;
		}
	};

	return narrative_query:new(name, faction_key, trigger_messages, query_records);
end;


--- @function savegame_value_exists
--- @desc Creates a narrative query that queries a value in the savegame, looked up by the supplied key, and acts upon the result. If the value exists then the positive trigger message(s) are fired, otherwise the negative trigger message(s) are fired, if any were supplied.
--- @p @string unique name, Unique name amongst other declared narrative queries.
--- @p @string faction key, Key of the faction to which this narrative query applies, from the <code>factions</code> database table.
--- @p @string trigger message, Message on which this narrative query should trigger. If multiple trigger messages are required a @table containing string message names can be supplied here instead.
--- @p @string positive trigger message, Positive trigger message to fire if the saved value exists. This can be a single string or a @table of strings if multiple messages are desired.
--- @p [opt=nil] @string negative trigger message, Negative trigger message to fire if the saved value does not exist. This can be a single string or a @table of strings if multiple messages are desired.
--- @p @string value key, Key of value to look up from the savegame. This is passed to @campaign_manager:get_saved_value to retrieve the value.
--- @p [opt=nil] @function additional condition, Additional condition function which can force a positive or negative result. If supplied, the function is called with the context and narrative query objects passed in as separate functions. If it returns <code>true</code> then a positive result is forced, if <code>false</code> then a negative result is forced. If it returns any other value then no result is forced.
--- @p_long_desc The condition function may also return a string as a second return value, which will be used for output.
function narrative_queries.savegame_value_exists(name, faction_key, trigger_messages, positive_target_messages, negative_target_messages, value_key, condition)
	local nq = construct_narrative_query_savegame_value_exists(name, faction_key, trigger_messages, positive_target_messages, negative_target_messages, value_key, condition);

	if nq then
		nq:start();
	end;
end;














-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Narrative Event Has Triggered
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_event_has_triggered(name, faction_key, trigger_messages, positive_target_messages, negative_target_messages, narrative_event_names, pass_on_all, condition)

	if is_string(narrative_event_names) then
		narrative_event_names = {narrative_event_names};
	elseif not validate.is_table_of_strings(narrative_event_names) then
		return false;
	end;

	if condition and not validate.is_condition(condition) then
		return false;
	end;

	local query_records = {
		{
			message = positive_target_messages,
			fail_message = negative_target_messages,
			query = function(context, nq)
				-- Return false if we were supplied an additional condition and it fails
				if is_function(condition) then
					local result, result_str = condition(context, nq);
					if result == false then
						return result, error_str;
					end;
				end;

				for i = 1, #narrative_event_names do
					local narrative_event_name = narrative_event_names[i];
					local _, full_name = assemble_narrative_name("EVENT", narrative_event_name, faction_key);

					local ne = core:get_static_object(full_name, "narrative_events");

					if ne then
						if ne:has_triggered_this_campaign() then
							if not pass_on_all then
								return true, "narrative event " .. full_name .. " has been triggered this campaign";
							end;
						else
							if pass_on_all then
								return false, "narrative event " .. full_name .. " has not been triggered this campaign";
							end;
						end;
					else
						script_error("WARNING: narrative_queries.narrative_event_has_triggered() has triggered, but no narrative event with the supplied name [" .. narrative_event_name .. "] for faction with key [" .. faction_key .. "] exists");
						if #narrative_event_names == 1 then
							return false, "no narrative event with the supplied name [" .. narrative_event_name .. "] for faction with key [" .. faction_key .. "] exists";
						end;
					end;
				end;

				if pass_on_all then
					return true, "all of the specified narrative events have been triggered this campaign";
				else
					return false, "none of the specified narrative events have been triggered this campaign";
				end;
			end;
		}
	};

	return narrative_query:new(name, faction_key, trigger_messages, query_records);
end;


--- @function narrative_event_has_triggered
--- @desc Creates a narrative query that queries whether a narrative event with the supplied name for the supplied faction has triggered in this savegame, and acts upon the result. If the narrative event has triggered then the positive trigger message(s) are fired, otherwise the negative trigger message(s) are fired, if any were supplied.
--- @p @string unique name, Unique name amongst other declared narrative queries.
--- @p @string faction key, Key of the faction to which this narrative query applies, from the <code>factions</code> database table.
--- @p @string trigger message, Message on which this narrative query should trigger. If multiple trigger messages are required a @table containing string message names can be supplied here instead.
--- @p @string positive trigger message, Positive trigger message to fire if the saved value exists. This can be a single string or a @table of strings if multiple messages are desired.
--- @p [opt=nil] @string negative trigger message, Negative trigger message to fire if the saved value does not exist. This can be a single string or a @table of strings if multiple messages are desired.
--- @p @string narrative event name, Name of narrative event to query. This may also be a @table of strings if multiple narrative events are to be queried.
--- @p [opt=false] @boolean pass on all, Trigger the positive message if all specified narrative events have fired. If <code>false</code> or <code>nil</code> is supplied here then the positive message will be triggered if any of the specified narrative events have fired.
--- @p [opt=nil] @function additional condition, Additional condition function which can force a positive or negative result. If supplied, the function is called with the context and narrative query objects passed in as separate functions. If it returns <code>true</code> then a positive result is forced, if <code>false</code> then a negative result is forced. If it returns any other value then no result is forced.
--- @p_long_desc The condition function may also return a string as a second return value, which will be used for output.
function narrative_queries.narrative_event_has_triggered(name, faction_key, trigger_messages, positive_target_messages, negative_target_messages, narrative_event_names, pass_on_all, condition)
	local nq = construct_narrative_event_has_triggered(name, faction_key, trigger_messages, positive_target_messages, negative_target_messages, narrative_event_names, pass_on_all, condition);

	if nq then
		nq:start();
	end;
end;
















-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Advice History
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------


local function construct_narrative_query_advice_history(name, faction_key, trigger_messages, positive_target_messages, negative_target_messages, any_advice_strings, all_advice_strings, any_advice_keys, all_advice_keys, condition)

	if all_advice_keys and not validate.is_table_of_strings_allow_empty(all_advice_keys) then
		return false;
	end;

	if any_advice_keys and not validate.is_table_of_strings_allow_empty(any_advice_keys) then
		return false;
	end;

	if all_advice_strings and not validate.is_table_of_strings_allow_empty(all_advice_strings) then
		return false;
	end;

	if any_advice_strings and not validate.is_table_of_strings_allow_empty(any_advice_strings) then
		return false;
	end;

	-- Assemble a query which checks all supplied advice keys and advice strings and returns true depending on whether they've been experienced
	local query_records = {
		{
			message = positive_target_messages,
			fail_message = negative_target_messages,
			query = function(context, nq)
				-- Return false if we were supplied an additional condition and it fails
				if is_function(condition) then
					local result, result_str = condition(context, nq);
					if is_boolean(result) then
						return result, error_str;
					end;
				end;

				-- Check any_advice_strings = return true if any of them have been experienced
				if is_table(any_advice_strings) and #any_advice_strings > 0 then
					local get_advice_history_string_seen = common.get_advice_history_string_seen;
					for i = 1, #any_advice_strings do
						if get_advice_history_string_seen(any_advice_strings[i]) then
							return true, "advice string \"" .. any_advice_string[i] .. "\" from any-advice-string list has been seen";
						end;
					end;
				end;

				-- Check all_advice_strings - return true if they've all been experienced
				if is_table(all_advice_strings) and #all_advice_strings > 0 then
					local get_advice_history_string_seen = common.get_advice_history_string_seen;
					local should_return = true;

					for i = 1, #all_advice_strings do
						if not get_advice_history_string_seen(all_advice_strings[i]) then
							should_return = false;
							break;
						end;
					end;

					if should_return then
						return true, "all advice strings in all-advice-strings list have been seen";
					end;
				end;

				-- Check any_advice_keys = return true if any of them have been experienced
				if is_table(any_advice_keys) and #any_advice_keys > 0 then
					local get_advice_thread_score = common.get_advice_thread_score;
					for i = 1, #any_advice_keys do
						if get_advice_thread_score(any_advice_keys[i]) > 0 then
							return true, "advice key \"" .. any_advice_keys[i] .. "\" from any-advice-keys list has been seen";
						end;
					end;
				end;

				-- Check all_advice_keys - return true if they've all been experienced
				if is_table(all_advice_keys) and #all_advice_keys > 0 then
					local get_advice_thread_score = common.get_advice_thread_score;
					local should_return = true;

					for i = 1, #all_advice_keys do
						if get_advice_thread_score(all_advice_keys[i]) == 0 then
							should_return = false;
							break;
						end;
					end;

					if should_return then
						return true, "all advice keys in all-advice-keys list have been seen";
					end;
				end;

				return false, "none of the advice-seen criteria have been met";
			end;
		}
	};

	local nq = narrative_query:new(name, faction_key, trigger_messages, query_records);

	return nq;
end;


--- @function advice_history
--- @desc Creates a narrative query that queries the player's advice history against a supplied set of advice strings and advice keys when triggered.
--- @desc Up to four sets of data can be passed to the function, representing any advice strings, all advice strings, any advice keys and all advice keys. When the narrative query is triggered the data collections are checked in this order. Where they are present, their contents are checked and the advice-experienced message may be triggered.
--- @desc If all four collections are checked and the advice-experienced message has not been triggered, then the advice-not-experienced message is triggered (if one has been supplied).
--- @desc If triggered in multiplayer mode the narrative query always behaves as if the advice has been experienced, as the advice history will be different on different machines in a multiplayer game so it would not be safe to do otherwise.
--- @p @string unique name, Unique name amongst other declared narrative queries.
--- @p @string faction key, Key of the faction to which this narrative query applies, from the <code>factions</code> database table.
--- @p @string trigger message, Message on which this narrative query should trigger. If multiple trigger messages are required a @table containing string message names can be supplied here instead.
--- @p @string experienced message, Message to trigger if the player has experienced the supplied advice. This can be a single string or a @table of strings if multiple messages are desired.
--- @p [opt=nil] @string not experienced message, Message to trigger if the player has not experienced the supplied advice. This can be a single string or a @table of strings if multiple messages are desired.
--- @p [opt=nil] @table any advice strings, Any advice strings table. When triggered, the narrative trigger will check the history of advice strings supplied in this table using the function @common:get_advice_history_string_seen. If any advice strings in this table have been experienced by the local player then the advice-experienced message is triggered.
--- @p [opt=nil] @table all advice strings, All advice strings table. When triggered, the narrative trigger will check the history of all advice keys supplied in this table using the function @common:get_advice_history_string_seen. If all advice strings in this table have been experienced by the local player then the advice-experienced message is triggered.
--- @p [opt=nil] @table any advice keys, Any advice keys table. When triggered, the narrative trigger will check the history of advice keys supplied in this table using the function @common:get_advice_thread_score. If any advice items represented by keys in this table have been experienced by the local player then the advice-experienced message is triggered.
--- @p [opt=nil] @table all advice keys, All advice keys table. When triggered, the narrative trigger will check the history of all advice keys supplied in this table using the function @common:get_advice_thread_score. If all advice items represented by keys in this table have been experienced by the local player then the advice-experienced message is triggered.
--- @p [opt=nil] @function additional condition, Additional condition function which can force a positive or negative result. If supplied, the function is called with the context and narrative query objects passed in as separate functions. If it returns <code>true</code> then a positive result is forced, if <code>false</code> then a negative result is forced. If it returns any other value then no result is forced.
--- @p_long_desc The condition function may also return a string as a second return value, which will be used for output.
function narrative_queries.advice_history(name, faction_key, trigger_messages, positive_target_messages, negative_target_messages, any_advice_strings, all_advice_strings, any_advice_keys, all_advice_keys, condition)
	
	local nq = construct_narrative_query_advice_history(name, faction_key, trigger_messages, positive_target_messages, negative_target_messages, any_advice_strings, all_advice_strings, any_advice_keys, all_advice_keys, condition);
	if nq then
		nq:start();
	end;
end;





--- @function advice_history_for_narrative_chain
--- @desc Creates a narrative query that interrogates the player's advice history for a narrative chain. If all of the supplied set of advice keys or any of the supplied set of advice strings are in the advice history, or it's a multiplayer game, or the campaign difficulty is very hard or above, then the positive target message(s) are triggered. Otherwise, the negative target message(s) are triggered, if any have been supplied.
--- @desc If triggered in multiplayer mode the narrative query always behaves as if the advice has been experienced, as the advice history will be different on different machines in a multiplayer game so it would not be safe to do otherwise.
--- @p @string unique name, Unique name amongst other declared narrative queries.
--- @p @string faction key, Key of the faction to which this narrative query applies, from the <code>factions</code> database table.
--- @p @string trigger message, Message on which this narrative query should trigger. If multiple trigger messages are required a @table containing string message names can be supplied here instead.
--- @p @string experienced message, Target message to trigger if the player has experienced the supplied advice. This can be a single string or a @table of strings if multiple messages are desired.
--- @p [opt=nil] @string not experienced message, Target message to trigger if the player has not experienced the supplied advice. This can be a single string or a @table of strings if multiple messages are desired.
--- @p [opt=nil] @table all advice strings, All advice strings table. When triggered, the narrative trigger will check the history of advice strings supplied in this table using the function @common:get_advice_history_string_seen. If all advice strings in this table have been experienced by the local player then the advice-experienced message is triggered.
--- @p [opt=nil] @function additional condition, Additional condition function which can force a positive or negative result. If supplied, the function is called with the context and narrative query objects passed in as separate functions. If it returns <code>true</code> then a positive result is forced, if <code>false</code> then a negative result is forced. If it returns any other value then no result is forced.
--- @p_long_desc The condition function may also return a string as a second return value, which will be used for output.
function narrative_queries.advice_history_for_narrative_chain(name, faction_key, trigger_messages, positive_target_messages, negative_target_messages, all_advice_strings, condition)
	
	if condition and not validate.is_function(condition) then
		return false;
	end;

	local function condition_inner(context, nq)
		if cm:get_difficulty() > 4 then					-- easy = 1, normal = 2, hard = 3, v hard = 4, legendary = 5
			return true, "difficulty level is very hard or above";
		end;

		if cm:is_multiplayer() then
			if is_boolean(nq.mp_result) then
				return nq.mp_result, "progress_on_mp_query() result";
			else
				nq:defer();

				cm:progress_on_mp_query(
					"all_advice_strings_seen",
					faction_key,
					all_advice_strings,
					function(result)
						nq.mp_result = result;
						nq:retrigger();
					end
				);
			end;
		end;

		if is_function(condition) then
			local result, result_str = condition(context, nq);
			if is_boolean(result) then
				return result, error_str;
			end;
		end;
	end;
	
	local nq = construct_narrative_query_advice_history(name, faction_key, trigger_messages, positive_target_messages, negative_target_messages, nil, all_advice_strings, nil, nil, condition_inner);
	if nq then
		nq:start();
	end;
end;
















-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	One Settlement From Completing Province
--	Indicates whether supplied faction is exactly one settlement away from completing any province.
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_query_one_settlement_from_completing_province(name, faction_key, trigger_messages, positive_target_messages, negative_target_messages, condition)

	if condition and not validate.is_condition(condition) then
		return false;
	end;

	local query_records = {
		{
			message = positive_target_messages, 		-- one settlement from completing province
			fail_message = negative_target_messages, 	-- not one settlement from completing province
			query = function(context, nq)

				if is_function(condition) then
					local result, result_str = condition(context, nq);
					if is_boolean(result) then
						return result, error_str;
					end;
				end;
				
				local faction = cm:get_faction(faction_key);
				
				if faction then
					-- Return false straight away if this faction is Horde
					if not faction:is_allowed_to_capture_territory() then
						return false, "faction is not allowed to capture territory";
					end;

					local checked_provinces = {};

					local region_list = faction:region_list();

					for i = 0, region_list:num_items() - 1 do
						local province = region_list:item_at(i):province();
						local province_key = province:key();
						if not checked_provinces[province_key] then
							checked_provinces[province_key] = true;
							
							if cm:num_regions_controlled_in_province_by_faction(province, faction) == province:regions():num_items() - 1 then
								return true, "faction is one settlement away from completing province with key [" .. province_key .. "]";
							end;
						end;
					end;
				end;

				return false, "faction is not one settlement away from completing any province";
			end;
		}
	};

	local nq = narrative_query:new(name, faction_key, trigger_messages, query_records);

	return nq;

end;


--- @function one_settlement_from_completing_province
--- @desc Creates a narrative query that queries the specified faction's territorial holdings and acts upon the result. Should the faction be exactly one settlement away from complete control of any province the positive message(s) are fired. Otherwise, the negative message(s) are fired, if any were supplied.
--- @p @string unique name, Unique name amongst other declared narrative queries.
--- @p @string faction key, Key of the faction to which this narrative query applies, from the <code>factions</code> database table.
--- @p @string trigger message, Message on which this narrative query should trigger. If multiple trigger messages are required a @table containing string message names can be supplied here instead.
--- @p @string positive message, Message to trigger if the faction is one settlement from completing a province. This can be a single string or a @table of strings if multiple messages are desired.
--- @p [opt=nil] @string negative message, Message to trigger if the faction is not one settlement from completing a province. This can be a single string or a @table of strings if multiple messages are desired.
--- @p [opt=nil] @function additional condition, Additional condition function which can force a positive or negative result. If supplied, the function is called with the context and narrative query objects passed in as separate functions. If it returns <code>true</code> then a positive result is forced, if <code>false</code> then a negative result is forced. If it returns any other value then no result is forced.
--- @p_long_desc The condition function may also return a string as a second return value, which will be used for output.
function narrative_queries.one_settlement_from_completing_province(name, faction_key, trigger_messages, positive_target_messages, negative_target_messages, condition)
	local nq = construct_narrative_query_one_settlement_from_completing_province(name, faction_key, trigger_messages, positive_target_messages, negative_target_messages, condition);

	if nq then
		nq:start();
	end;
end;












-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Control x provinces
--	Indicates whether supplied faction fully controls at least the supplied number of provinces.
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_query_controls_x_provinces(name, faction_key, trigger_messages, positive_target_messages, negative_target_messages, num_provinces, condition)

	if not validate.is_positive_number(num_provinces) then
		return false;
	end;
	
	if condition and not validate.is_condition(condition) then
		return false;
	end;

	local query_records = {
		{
			message = positive_target_messages,
			fail_message = negative_target_messages,
			query = function(context, nq)

				if is_function(condition) then
					local result, result_str = condition(context, nq);
					if is_boolean(result) then
						return result, error_str;
					end;
				end;
				
				local faction = cm:get_faction(faction_key);
				
				if faction then
					-- Return false straight away if this faction is Horde
					if not faction:is_allowed_to_capture_territory() then
						return false, "faction is not allowed to capture territory";
					end;

					local num_controlled_provinces = cm:num_provinces_controlled_by_faction(faction);

					if num_controlled_provinces >= num_provinces then
						return true, "faction controls [" .. num_controlled_provinces .. "] province" .. (num_controlled_provinces == 1 and "" or "s") .. " which meets threshold [" .. num_provinces .. "]";
					else
						return false, "faction only controls [" .. num_controlled_provinces .. "] province" .. (num_controlled_provinces == 1 and "" or "s") .. " which is less than threshold [" .. num_provinces .. "]";
					end;
				end;

				return false, "faction could not be found";
			end;
		}
	};

	local nq = narrative_query:new(name, faction_key, trigger_messages, query_records);

	return nq;

end;


--- @function controls_x_provinces
--- @desc Creates a narrative query that queries the specified faction's territorial holdings and acts upon the result. Should the faction already fully control at least the supplied number of provinces then the positive message(s) are fired. Otherwise, the negative message(s) are fired, if any were supplied.
--- @p @string unique name, Unique name amongst other declared narrative queries.
--- @p @string faction key, Key of the faction to which this narrative query applies, from the <code>factions</code> database table.
--- @p @string trigger message, Message on which this narrative query should trigger. If multiple trigger messages are required a @table containing string message names can be supplied here instead.
--- @p @string positive message, Message to trigger if the faction is one settlement from completing a province. This can be a single string or a @table of strings if multiple messages are desired.
--- @p [opt=nil] @string negative message, Message to trigger if the faction is not one settlement from completing a province. This can be a single string or a @table of strings if multiple messages are desired.
--- @p @number provinces, Number of provinces the faction has to fully control for the positive message to be forced.
--- @p [opt=nil] @function additional condition, Additional condition function which can force a positive or negative result. If supplied, the function is called with the context and narrative query objects passed in as separate functions. If it returns <code>true</code> then a positive result is forced, if <code>false</code> then a negative result is forced. If it returns any other value then no result is forced.
--- @p_long_desc The condition function may also return a string as a second return value, which will be used for output.
function narrative_queries.controls_x_provinces(name, faction_key, trigger_messages, positive_target_messages, negative_target_messages, num_provinces, condition)
	local nq = construct_narrative_query_controls_x_provinces(name, faction_key, trigger_messages, positive_target_messages, negative_target_messages, num_provinces, condition);

	if nq then
		nq:start();
	end;
end;














-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Highest Level Settlement for Faction
--	Acts on the settlement in the faction with the highest level
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_query_highest_level_settlement_for_faction(name, faction_key, trigger_messages, positive_messages, negative_messages, query_level, condition)

	if not validate.is_positive_number(query_level) then
		return false;
	end;

	if condition and not validate.is_condition(condition) then
		return false;
	end;

	local query_records = {
		{
			message = positive_messages,
			fail_message = negative_messages,
			query = function(context, nq)

				if is_function(condition) then
					local result, result_str = condition(context, nq);
					if is_boolean(result) then
						return result, error_str;
					end;
				end;

				local faction = cm:get_faction(faction_key, true);
				if not faction then
					return false, "no faction with key [" .. faction_key .. "] could be found - assuming they have died";
				end;

				local settlement, settlement_level = cm:get_highest_level_settlement_for_faction(faction);

				if not settlement_level then
					return false, "faction with key [" .. faction_key .. "] doesn't contain any settlements";
				end;

				local region_name = settlement:region():name();

				if settlement_level >= query_level then
					-- Store the region key of the settlement in the narrative query, so we can access it later if needs be
					nq.data = {region_name = region_name};
					return true, "highest-level settlement for faction [" .. faction_key .. "] is of level [" .. settlement_level .. "] in region [" .. region_name .. "] which is greater than/equal to query level [" .. query_level .. "]";
				end;
				
				return false, "highest-level settlement for faction [" .. faction_key .. "] is of level [" .. settlement_level .. "] in region [" .. region_name .. "] which is less than query level [" .. query_level .. "]";			
			end;
		}
	};

	local nq = narrative_query:new(name, faction_key, trigger_messages, query_records);

	return nq;

end;


--- @function highest_level_settlement_for_faction
--- @desc Creates a narrative query that queries the specified faction's highest-level settlement and acts on the result. Should the level of the highest-level settlement be equal to or greater than the supplied query level then the positive message(s) are fired. Otherwise, the negative message(s) are fired, if any were supplied.
--- @p @string unique name, Unique name amongst other declared narrative queries.
--- @p @string faction key, Key of the faction to which this narrative query applies, from the <code>factions</code> database table.
--- @p @string trigger message, Message on which this narrative query should trigger. If multiple trigger messages are required a @table containing string message names can be supplied here instead.
--- @p @string positive message, Message to trigger if the faction has a settlement at or above the query level. This can be a single string or a @table of strings if multiple messages are desired.
--- @p [opt=nil] @string negative message, Message to trigger if the faction does not have a settlement at or above the query level. This can be a single string or a @table of strings if multiple messages are desired.
--- @p @number query level, Minimum level the highest-level settlement of the faction must be in order to trigger the positive result message(s).
--- @p [opt=nil] @function additional condition, Additional condition function which can force a positive or negative result. If supplied, the function is called with the context and narrative query objects passed in as separate functions. If it returns <code>true</code> then a positive result is forced, if <code>false</code> then a negative result is forced. If it returns any other value then no result is forced.
--- @p_long_desc The condition function may also return a string as a second return value, which will be used for output.
function narrative_queries.highest_level_settlement_for_faction(name, faction_key, trigger_messages, positive_target_messages, negative_target_messages, query_level, condition)
	local nq = construct_narrative_query_highest_level_settlement_for_faction(name, faction_key, trigger_messages, positive_target_messages, negative_target_messages, query_level, condition);

	if nq then
		nq:start();
	end;
end;













-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Is Researching
--	Acts on whether the faction is researching a tech
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_query_is_researching(name, faction_key, trigger_messages, positive_messages, negative_messages, condition)

	local query_records = {
		{
			message = positive_messages,
			fail_message = negative_messages,
			query = function(context, nq)

				if is_function(condition) then
					local result, result_str = condition(context, nq);
					if is_boolean(result) then
						return result, error_str;
					end;
				end;

				local faction = cm:get_faction(faction_key, true);
				if not faction then
					return false, "no faction with key [" .. faction_key .. "] could be found - assuming they have died";
				end;

				if faction:is_currently_researching() then
					return true, "faction with key [" .. faction_key .. "] is currently researching";
				end;

				return false, "faction with key [" .. faction_key .. "] is not currently researching";
			end;
		}
	};

	local nq = narrative_query:new(name, faction_key, trigger_messages, query_records);

	return nq;

end;


--- @function is_researching
--- @desc Creates a narrative query that queries whether the specified faction is currently researching a technology and acts on the result.
--- @p @string unique name, Unique name amongst other declared narrative queries.
--- @p @string faction key, Key of the faction to which this narrative query applies, from the <code>factions</code> database table.
--- @p @string trigger message, Message on which this narrative query should trigger. If multiple trigger messages are required a @table containing string message names can be supplied here instead.
--- @p @string positive message, Message to trigger if the faction is currently researching a technology. This can be a single string or a @table of strings if multiple messages are desired.
--- @p [opt=nil] @string negative message, Message to trigger if the faction is not currently researching a technology. This can be a single string or a @table of strings if multiple messages are desired.
--- @p [opt=nil] @function additional condition, Additional condition function which can force a positive or negative result. If supplied, the function is called with the context and narrative query objects passed in as separate functions. If it returns <code>true</code> then a positive result is forced, if <code>false</code> then a negative result is forced. If it returns any other value then no result is forced.
--- @p_long_desc The condition function may also return a string as a second return value, which will be used for output.
function narrative_queries.is_researching(name, faction_key, trigger_messages, positive_target_messages, negative_target_messages, condition)
	local nq = construct_narrative_query_is_researching(name, faction_key, trigger_messages, positive_target_messages, negative_target_messages, condition);

	if nq then
		nq:start();
	end;
end;










-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Has Available Technologies
--	Acts on whether the faction has any technologies available for research
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_query_has_available_technologies(name, faction_key, trigger_messages, positive_messages, negative_messages, condition)

	local query_records = {
		{
			message = positive_messages,
			fail_message = negative_messages,
			query = function(context, nq)

				if is_function(condition) then
					local result, result_str = condition(context, nq);
					if is_boolean(result) then
						return result, error_str;
					end;
				end;

				local faction = cm:get_faction(faction_key, true);
				if not faction then
					return false, "no faction with key [" .. faction_key .. "] could be found - assuming they have died";
				end;

				if faction:has_available_technologies() then
					return true, "faction with key [" .. faction_key .. "] has available technologies";
				end;

				return false, "faction with key [" .. faction_key .. "] does not have available technologies";
			end;
		}
	};

	local nq = narrative_query:new(name, faction_key, trigger_messages, query_records);

	return nq;

end;


--- @function has_available_technologies
--- @desc Creates a narrative query that queries whether the specified faction currently has technologies available for research and acts on the result.
--- @p @string unique name, Unique name amongst other declared narrative queries.
--- @p @string faction key, Key of the faction to which this narrative query applies, from the <code>factions</code> database table.
--- @p @string trigger message, Message on which this narrative query should trigger. If multiple trigger messages are required a @table containing string message names can be supplied here instead.
--- @p @string positive message, Message to trigger if the faction has technologies available. This can be a single string or a @table of strings if multiple messages are desired.
--- @p [opt=nil] @string negative message, Message to trigger if the faction does not have technologies available. This can be a single string or a @table of strings if multiple messages are desired.
--- @p [opt=nil] @function additional condition, Additional condition function which can force a positive or negative result. If supplied, the function is called with the context and narrative query objects passed in as separate functions. If it returns <code>true</code> then a positive result is forced, if <code>false</code> then a negative result is forced. If it returns any other value then no result is forced.
--- @p_long_desc The condition function may also return a string as a second return value, which will be used for output.
function narrative_queries.has_available_technologies(name, faction_key, trigger_messages, positive_target_messages, negative_target_messages, condition)
	local nq = construct_narrative_query_has_available_technologies(name, faction_key, trigger_messages, positive_target_messages, negative_target_messages, condition);

	if nq then
		nq:start();
	end;
end;













-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Has Income
--	Acts on whether the faction has a net income level above the specified amount
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_query_has_income(name, faction_key, trigger_messages, positive_messages, negative_messages, income, condition)

	local query_records = {
		{
			message = positive_messages,
			fail_message = negative_messages,
			query = function(context, nq)

				if is_function(condition) then
					local result, result_str = condition(context, nq);
					if is_boolean(result) then
						return result, error_str;
					end;
				end;

				local faction = cm:get_faction(faction_key, true);
				if not faction then
					return false, "no faction with key [" .. faction_key .. "] could be found - assuming they have died";
				end;

				local net_income = faction:net_income();
				if net_income > income then
					return true, "faction with key [" .. faction_key .. "] has net income of [" .. net_income .. "] which is equal to or more than threshold value [" .. income .. "]";
				end;

				return false, "faction with key [" .. faction_key .. "] has net income of [" .. net_income .. "] which is less than threshold value [" .. income .. "]";
			end;
		}
	};

	local nq = narrative_query:new(name, faction_key, trigger_messages, query_records);

	return nq;

end;


--- @function has_income
--- @desc Creates a narrative query that queries whether the specified faction currently has an income level above the specified amount and acts on the result.
--- @p @string unique name, Unique name amongst other declared narrative queries.
--- @p @string faction key, Key of the faction to which this narrative query applies, from the <code>factions</code> database table.
--- @p @string trigger message, Message on which this narrative query should trigger. If multiple trigger messages are required a @table containing string message names can be supplied here instead.
--- @p @string positive message, Message to trigger if the faction has the required income. This can be a single string or a @table of strings if multiple messages are desired.
--- @p [opt=nil] @string negative message, Message to trigger if the faction does not have the required income. This can be a single string or a @table of strings if multiple messages are desired.
--- @p @number income, Income amount.
--- @p [opt=nil] @function additional condition, Additional condition function which can force a positive or negative result. If supplied, the function is called with the context and narrative query objects passed in as separate functions. If it returns <code>true</code> then a positive result is forced, if <code>false</code> then a negative result is forced. If it returns any other value then no result is forced.
--- @p_long_desc The condition function may also return a string as a second return value, which will be used for output.
function narrative_queries.has_income(name, faction_key, trigger_messages, positive_messages, negative_messages, income, condition)
	local nq = construct_narrative_query_has_income(name, faction_key, trigger_messages, positive_messages, negative_messages, income, condition);

	if nq then
		nq:start();
	end;
end;













-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Can Capture Territory
--	Acts on whether the faction can capture territory. If they can't, they're presumably a horde faction.
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_query_can_capture_territory(name, faction_key, trigger_messages, positive_messages, negative_messages, condition)

	local query_records = {
		{
			message = positive_messages,
			fail_message = negative_messages,
			query = function(context, nq)

				if is_function(condition) then
					local result, result_str = condition(context, nq);
					if is_boolean(result) then
						return result, error_str;
					end;
				end;

				local faction = cm:get_faction(faction_key, true);
				if not faction then
					return false, "no faction with key [" .. faction_key .. "] could be found - assuming they have died";
				end;

				if faction:is_allowed_to_capture_territory() then
					return true, "faction with key [" .. faction_key .. "] is allowed to capture territory";
				end;

				return false, "faction with key [" .. faction_key .. "] cannot capture territory, presumably they are a horde faction";
			end;
		}
	};

	local nq = narrative_query:new(name, faction_key, trigger_messages, query_records);

	return nq;
end;


--- @function can_capture_territory
--- @desc Creates a narrative query that queries whether the specified faction can capture territory, and acts on the result. If the faction cannot capture territory they are presumably a horde faction. If the faction can capture territory then the positive trigger message(s) are fired, otherwise the negative trigger message(s) are fired.
--- @p @string unique name, Unique name amongst other declared narrative queries.
--- @p @string faction key, Key of the faction to which this narrative query applies, from the <code>factions</code> database table.
--- @p @string trigger message, Message on which this narrative query should trigger. If multiple trigger messages are required a @table containing string message names can be supplied here instead.
--- @p @string positive message, Message to trigger if the faction can capture territory. This can be a single string or a @table of strings if multiple messages are desired.
--- @p [opt=nil] @string negative message, Message to trigger if the faction cannot capture territory. This can be a single string or a @table of strings if multiple messages are desired.
--- @p [opt=nil] @function additional condition, Additional condition function which can force a positive or negative result. If supplied, the function is called with the context and narrative query objects passed in as separate functions. If it returns <code>true</code> then a positive result is forced, if <code>false</code> then a negative result is forced. If it returns any other value then no result is forced.
--- @p_long_desc The condition function may also return a string as a second return value, which will be used for output.
function narrative_queries.can_capture_territory(name, faction_key, trigger_messages, positive_messages, negative_messages, condition)
	local nq = construct_narrative_query_can_capture_territory(name, faction_key, trigger_messages, positive_messages, negative_messages, condition);

	if nq then
		nq:start();
	end;
end;













-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Can Recruit Hero
--	Acts on whether the faction can currently recruit a hero in any of their territories.
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_query_can_recruit_hero(name, faction_key, trigger_messages, positive_messages, negative_messages, hero_types, condition)

	hero_types = hero_types or cm:get_all_agent_types();

	local query_records = {
		{
			message = positive_messages,
			fail_message = negative_messages,
			query = function(context, nq)

				if is_function(condition) then
					local result, result_str = condition(context, nq);
					if is_boolean(result) then
						return result, error_str;
					end;
				end;

				local faction = cm:get_faction(faction_key, true);
				if not faction then
					return false, "no faction with key [" .. faction_key .. "] could be found - assuming they have died";
				end;

				if not faction:is_allowed_to_capture_territory() then
					script_error("WARNING: construct_narrative_query_can_recruit_hero() called but faction with key [" .. tostring(faction_key) .. "] is a horde faction - we can't currently test whether horde factions can recruit heroes. Returning false, which might not be right");
					return false, "faction with key [" .. faction_key .. "] is horde, cannot determine if they can recruit agents";
				end;

				if cm:can_recruit_agent(faction, hero_types) then
					return true, "faction with key [" .. faction_key .. "] can recruit an agent of the following type(s): [" .. table.concat(hero_types, ", ") .. "]";
				end;

				return false, "faction with key [" .. faction_key .. "] cannot recruit any agents of the following type(s): [" .. table.concat(hero_types, ", ") .. "]";
			end;
		}
	};

	local nq = narrative_query:new(name, faction_key, trigger_messages, query_records);

	return nq;
end;


--- @function can_recruit_any_hero
--- @desc Creates a narrative query that queries whether the specified faction can recruit any hero and acts on the result. If the faction can recruit a hero then the positive trigger message(s) are fired, otherwise the negative trigger message(s) are fired.
--- @p @string unique name, Unique name amongst other declared narrative queries.
--- @p @string faction key, Key of the faction to which this narrative query applies, from the <code>factions</code> database table.
--- @p @string trigger message, Message on which this narrative query should trigger. If multiple trigger messages are required a @table containing string message names can be supplied here instead.
--- @p @string positive message, Message to trigger if the faction can recruit a hero. This can be a single string or a @table of strings if multiple messages are desired.
--- @p [opt=nil] @string negative message, Message to trigger if the faction cannot recruit a hero. This can be a single string or a @table of strings if multiple messages are desired.
--- @p [opt=nil] @function additional condition, Additional condition function which can force a positive or negative result. If supplied, the function is called with the context and narrative query objects passed in as separate functions. If it returns <code>true</code> then a positive result is forced, if <code>false</code> then a negative result is forced. If it returns any other value then no result is forced.
--- @p_long_desc The condition function may also return a string as a second return value, which will be used for output.
function narrative_queries.can_recruit_any_hero(name, faction_key, trigger_messages, positive_messages, negative_messages, condition)
	local nq = construct_narrative_query_can_recruit_hero(name, faction_key, trigger_messages, positive_messages, negative_messages, nil, condition);

	if nq then
		nq:start();
	end;
end;


--- @function can_recruit_hero_of_type
--- @desc Creates a narrative query that queries whether the specified faction can recruit a hero of the supplied list of types, and acts on the result. If the faction can recruit a hero then the positive trigger message(s) are fired, otherwise the negative trigger message(s) are fired.
--- @p @string unique name, Unique name amongst other declared narrative queries.
--- @p @string faction key, Key of the faction to which this narrative query applies, from the <code>factions</code> database table.
--- @p @string trigger message, Message on which this narrative query should trigger. If multiple trigger messages are required a @table containing string message names can be supplied here instead.
--- @p @string positive message, Message to trigger if the faction can recruit a hero. This can be a single string or a @table of strings if multiple messages are desired.
--- @p [opt=nil] @string negative message, Message to trigger if the faction cannot recruit a hero. This can be a single string or a @table of strings if multiple messages are desired.
--- @p [opt=nil] @table hero types, Indexed table of string hero types. If no table is supplied then all hero types are matched.
--- @p [opt=nil] @function additional condition, Additional condition function which can force a positive or negative result. If supplied, the function is called with the context and narrative query objects passed in as separate functions. If it returns <code>true</code> then a positive result is forced, if <code>false</code> then a negative result is forced. If it returns any other value then no result is forced.
--- @p_long_desc The condition function may also return a string as a second return value, which will be used for output.
function narrative_queries.can_recruit_hero_of_type(name, faction_key, trigger_messages, positive_messages, negative_messages, hero_types, condition)
	local nq = construct_narrative_query_can_recruit_hero(name, faction_key, trigger_messages, positive_messages, negative_messages, hero_types, condition);

	if nq then
		nq:start();
	end;
end;
















-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Contains Hero
--	Acts on whether the faction currently has any heroes
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_query_contains_hero(name, faction_key, trigger_messages, positive_messages, negative_messages, hero_types, condition)

	hero_types = hero_types or cm:get_all_agent_types();

	local query_records = {
		{
			message = positive_messages,
			fail_message = negative_messages,
			query = function(context, nq)

				if is_function(condition) then
					local result, result_str = condition(context, nq);
					if is_boolean(result) then
						return result, error_str;
					end;
				end;

				local faction = cm:get_faction(faction_key, true);
				if not faction then
					return false, "no faction with key [" .. faction_key .. "] could be found - assuming they have died";
				end;

				if cm:faction_contains_characters_of_type(faction, hero_types) then
					return true, "faction with key [" .. faction_key .. "] contains one or more heroes";
				end;

				return false, "faction with key [" .. faction_key .. "] does not contain any heroes";
			end;
		}
	};

	local nq = narrative_query:new(name, faction_key, trigger_messages, query_records);

	return nq;
end;


--- @function contains_any_hero
--- @desc Creates a narrative query that queries whether the specified faction contains any hero, and acts on the result. If the faction contains any heroes then the positive trigger message(s) are fired, otherwise the negative trigger message(s) are fired.
--- @p @string unique name, Unique name amongst other declared narrative queries.
--- @p @string faction key, Key of the faction to which this narrative query applies, from the <code>factions</code> database table.
--- @p @string trigger message, Message on which this narrative query should trigger. If multiple trigger messages are required a @table containing string message names can be supplied here instead.
--- @p @string positive message, Message to trigger if the faction can recruit a hero. This can be a single string or a @table of strings if multiple messages are desired.
--- @p [opt=nil] @string negative message, Message to trigger if the faction cannot recruit a hero. This can be a single string or a @table of strings if multiple messages are desired.
--- @p [opt=nil] @function additional condition, Additional condition function which can force a positive or negative result. If supplied, the function is called with the context and narrative query objects passed in as separate functions. If it returns <code>true</code> then a positive result is forced, if <code>false</code> then a negative result is forced. If it returns any other value then no result is forced.
--- @p_long_desc The condition function may also return a string as a second return value, which will be used for output.
function narrative_queries.contains_any_hero(name, faction_key, trigger_messages, positive_messages, negative_messages, condition)
	local nq = construct_narrative_query_contains_hero(name, faction_key, trigger_messages, positive_messages, negative_messages, nil, condition);

	if nq then
		nq:start();
	end;
end;


--- @function contains_any_hero_of_type
--- @desc Creates a narrative query that queries whether the specified faction contains heroes of the specified type(s), and acts on the result. If the faction contains any matching heroes then the positive trigger message(s) are fired, otherwise the negative trigger message(s) are fired.
--- @p @string unique name, Unique name amongst other declared narrative queries.
--- @p @string faction key, Key of the faction to which this narrative query applies, from the <code>factions</code> database table.
--- @p @string trigger message, Message on which this narrative query should trigger. If multiple trigger messages are required a @table containing string message names can be supplied here instead.
--- @p @string positive message, Message to trigger if the faction can recruit a hero. This can be a single string or a @table of strings if multiple messages are desired.
--- @p [opt=nil] @string negative message, Message to trigger if the faction cannot recruit a hero. This can be a single string or a @table of strings if multiple messages are desired.
--- @p [opt=nil] @table hero types, Indexed table of string character types to test against. If the specified faction contains any heroes matching any of the supplied types then a positive result is returned.
--- @p [opt=nil] @function additional condition, Additional condition function which can force a positive or negative result. If supplied, the function is called with the context and narrative query objects passed in as separate functions. If it returns <code>true</code> then a positive result is forced, if <code>false</code> then a negative result is forced. If it returns any other value then no result is forced.
--- @p_long_desc The condition function may also return a string as a second return value, which will be used for output.
function narrative_queries.contains_any_hero_of_type(name, faction_key, trigger_messages, positive_messages, negative_messages, hero_types, condition)
	local nq = construct_narrative_query_contains_hero(name, faction_key, trigger_messages, positive_messages, negative_messages, hero_types, condition);

	if nq then
		nq:start();
	end;
end;













-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Corruption In Adjacent Region
--	Acts on whether any region adjacent to the faction has a level of a specified
--	corruption type equal to or exceeding a specified threshold
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_query_corruption_in_adjacent_region(name, faction_key, trigger_messages, positive_messages, negative_messages, corruption_key, threshold_value, culture_to_exclude, condition)

	if not validate.is_string(corruption_key) then
		return false;
	end;

	if not validate.is_positive_number(threshold_value) then
		return false;
	end;

	local culture_condition;
	if culture_to_exclude then
		if not validate.is_string(culture_to_exclude) then
			return false;
		else
			function culture_condition(region)
				return region:is_abandoned() or region:owning_faction():culture() ~= culture_to_exclude;
			end;
		end;
	end;

	local query_records = {
		{
			message = positive_messages,
			fail_message = negative_messages,
			query = function(context, nq)

				if is_function(condition) then
					local result, result_str = condition(context, nq);
					if is_boolean(result) then
						return result, error_str;
					end;
				end;

				local faction = cm:get_faction(faction_key, true);
				if not faction then
					return false, "no faction with key [" .. faction_key .. "] could be found - assuming they have died";
				end;

				local region_list_table = cm:get_regions_adjacent_to_faction(faction);

				for i = 1, #region_list_table do
					local resource = region_list_table[i]:province():pooled_resource_manager():resource(corruption_key, culture_condition);

					if not resource:is_null_interface() then 
						local resource_value = resource:value();
						if resource_value >= threshold_value then
							return true, "faction with key [" .. faction_key .. "] has adjacent region [" .. region_list_table[i]:name() .. "] containing corruption of type [" .. corruption_key .. "] with value [" .. resource_value .. "] which meets threshold value [" .. threshold_value .. "]";
						end;
					end;
				end;

				return false, "faction with key [" .. faction_key .. "] has no adjacent regions containing corruption of type [" .. corruption_key .. "] that meets threshold value [" .. threshold_value .. "]";
			end;
		}
	};

	local nq = narrative_query:new(name, faction_key, trigger_messages, query_records);

	return nq;
end;


--- @function corruption_in_adjacent_region
--- @desc Creates a narrative query that queries whether any regions adjacent to the specified faction contain corruption of the specified type equal to or above the supplied threshold, and acts on the result. If any adjacent region meets the corruption threshold then the positive trigger message(s) are fired, otherwise the negative trigger message(s) are fired.
--- @p @string unique name, Unique name amongst other declared narrative queries.
--- @p @string faction key, Key of the faction to which this narrative query applies, from the <code>factions</code> database table.
--- @p @string trigger message, Message on which this narrative query should trigger. If multiple trigger messages are required a @table containing string message names can be supplied here instead.
--- @p @string positive message, Message to trigger if the faction can recruit a hero. This can be a single string or a @table of strings if multiple messages are desired.
--- @p [opt=nil] @string negative message, Message to trigger if the faction cannot recruit a hero. This can be a single string or a @table of strings if multiple messages are desired.
--- @p [opt=nil] @string corruption key, Message to trigger if the faction cannot recruit a hero. This can be a single string or a @table of strings if multiple messages are desired.
--- @p [opt=nil] @string culture key, Culture key of region owner to exclude. If an eligible region has a faction owner with this culture, the region will not be included.
--- @p @string corruption type, Corruption type, from the <code>pooled_resources</code> database table.
--- @p @number threshold value, Threshold value which the corruption must meet or exceed in an adjacent region for the query to pass.
--- @p [opt=nil] @function additional condition, Additional condition function which can force a positive or negative result. If supplied, the function is called with the context and narrative query objects passed in as separate functions. If it returns <code>true</code> then a positive result is forced, if <code>false</code> then a negative result is forced. If it returns any other value then no result is forced.
--- @p_long_desc The condition function may also return a string as a second return value, which will be used for output.
function narrative_queries.corruption_in_adjacent_region(name, faction_key, trigger_messages, positive_messages, negative_messages, corruption_key, threshold_value, culture_to_exclude, condition)
	local nq = construct_narrative_query_corruption_in_adjacent_region(name, faction_key, trigger_messages, positive_messages, negative_messages, corruption_key, threshold_value, culture_to_exclude, condition);

	if nq then
		nq:start();
	end;
end;













-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Has Concocted Plague
--	Acts on whether the faction has concocted a plague in the past.
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_query_has_concocted_plagues(name, faction_key, trigger_messages, positive_messages, negative_messages, plagues_threshold, condition)

	plagues_threshold = plagues_threshold or 1;

	local query_records = {
		{
			message = positive_messages,
			fail_message = negative_messages,
			query = function(context, nq)

				if is_function(condition) then
					local result, result_str = condition(context, nq);
					if is_boolean(result) then
						return result, error_str;
					end;
				end;

				local num_plagues_started = cm:get_saved_value("plagues_started_" .. faction_key) or 0;

				if num_plagues_started >= plagues_threshold then
					return true, "faction with key [" .. faction_key .. "] has concocted " .. num_plagues_started .. (num_plagues_started == 1 and "s" or "") .. " plagues which is greater than or equal to the threshold value " .. plagues_threshold;
				end;

				return false, "faction with key [" .. faction_key .. "] has concocted " .. num_plagues_started .. (num_plagues_started == 1 and "s" or "") .. " plagues which is less than the threshold value " .. plagues_threshold;
			end;
		}
	};

	local nq = narrative_query:new(name, faction_key, trigger_messages, query_records);

	return nq;
end;


--- @function has_concocted_plagues
--- @desc Creates a narrative query that queries whether the specified faction has concocted a threshold number of Nurgle plagues, and acts on the result.
--- @p @string unique name, Unique name amongst other declared narrative queries.
--- @p @string faction key, Key of the faction to which this narrative query applies, from the <code>factions</code> database table.
--- @p @string trigger message, Message on which this narrative query should trigger. If multiple trigger messages are required a @table containing string message names can be supplied here instead.
--- @p @string positive message, Message to trigger if the faction can capture territory. This can be a single string or a @table of strings if multiple messages are desired.
--- @p [opt=nil] @string negative message, Message to trigger if the faction cannot capture territory. This can be a single string or a @table of strings if multiple messages are desired.
--- @p [opt=1] @number plagues, THreshold number of plagues.
--- @p [opt=nil] @function additional condition, Additional condition function which can force a positive or negative result. If supplied, the function is called with the context and narrative query objects passed in as separate functions. If it returns <code>true</code> then a positive result is forced, if <code>false</code> then a negative result is forced. If it returns any other value then no result is forced.
--- @p_long_desc The condition function may also return a string as a second return value, which will be used for output.
function narrative_queries.has_concocted_plagues(name, faction_key, trigger_messages, positive_messages, negative_messages, plagues_threshold, condition)
	local nq = construct_narrative_query_has_concocted_plagues(name, faction_key, trigger_messages, positive_messages, negative_messages, plagues_threshold, condition);

	if nq then
		nq:start();
	end;
end;






















local function faction_list_contains_factions_cultures_subcultures_for_diplomacy_query(faction_list, target_factions, target_cultures, target_subcultures)
	
	if faction_list:num_items() == 0 then
		return false;
	end;

	local no_filter_has_failed = true;

	if target_factions then
		for i, list_faction in model_pairs(faction_list) do
			local list_faction_name = list_faction:name();

			for j = 1, #target_factions do
				if target_factions[j] == list_faction_name then
					return true, "faction with name [" .. list_faction_name .. "]";
				end;
			end;
		end;
		no_filter_has_failed = false;
	end;

	if target_cultures then
		for i, list_faction in model_pairs(faction_list) do
			local list_faction_culture = list_faction:culture();

			for j = 1, #target_cultures do
				if target_cultures[j] == list_faction_culture then
					return true, "faction [" .. list_faction:name() .. "] with culture [" .. list_faction_culture .. "]";
				end;
			end;
		end;
		no_filter_has_failed = false;
	end;

	if target_subcultures then
		for i, list_faction in model_pairs(faction_list) do
			local list_faction_subculture = list_faction:subculture();

			for j = 1, #target_subcultures do
				if target_subcultures[j] == list_faction_subculture then
					return true, "faction [" .. list_faction:name() .. "] with subculture [" .. list_faction_subculture .. "]";
				end;
			end;
		end;
		no_filter_has_failed = false;
	end;

	if no_filter_has_failed then
		return true, "faction with name [" .. faction_list:item_at(0):name() .. "]";
	end;

	return false;
end;




-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Has Non-Aggression Pact
--	Acts on whether the faction has a non-aggression pact, optionally with any of
--	a list of factions or subcultures
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_query_has_non_aggression_pact(name, faction_key, trigger_messages, positive_messages, negative_messages, target_factions, target_cultures, target_subcultures, condition)

	if target_factions then
		if is_string(target_factions) then
			target_factions = {target_factions};
		elseif not validate.is_table_of_strings(target_factions) then
			return false;
		end;
	end;

	if target_cultures then
		if is_string(target_cultures) then
			target_cultures = {target_cultures};
		elseif not validate.is_table_of_strings(target_cultures) then
			return false;
		end;
	end;

	if target_subcultures then
		if is_string(target_subcultures) then
			target_subcultures = {target_subcultures};
		elseif not validate.is_table_of_strings(target_subcultures) then
			return false;
		end;
	end;

	local query_records = {
		{
			message = positive_messages,
			fail_message = negative_messages,
			query = function(context, nq)

				if is_function(condition) then
					local result, result_str = condition(context, nq);
					if is_boolean(result) then
						return result, error_str;
					end;
				end;

				local faction = cm:get_faction(faction_key);
				local faction_list = faction:factions_non_aggression_pact_with();
				
				local query_passes, reason_str = faction_list_contains_factions_cultures_subcultures_for_diplomacy_query(faction_list, target_factions, target_cultures, target_subcultures);

				if query_passes then
					return true, "faction with key [" .. faction_key .. "] has a non-aggression pact with " .. reason_str;
				end;

				if target_factions or target_cultures or target_subcultures then
					return false, "faction with key [" .. faction_key .. "] has no non-aggression pact with any specified faction";
				end;

				return false, "faction with key [" .. faction_key .. "] has no non-aggression pact with any faction";
			end;
		}
	};

	local nq = narrative_query:new(name, faction_key, trigger_messages, query_records);

	return nq;
end;


--- @function has_non_aggression_pact
--- @desc Creates a narrative query that queries whether the specified faction has a non-aggression pact. Zero or more faction keys, faction culture keys or faction subculture keys may be specified. Should the subject faction have a non-aggression pact with any of the specified factions/cultures/subcultures, or should they have a non-aggression pact with any faction if no filters are specified, then the query will return a positive result.
--- @p @string unique name, Unique name amongst other declared narrative queries.
--- @p @string faction key, Key of the faction to which this narrative query applies, from the <code>factions</code> database table.
--- @p @string trigger message, Message on which this narrative query should trigger. If multiple trigger messages are required a @table containing string message names can be supplied here instead.
--- @p @string positive message, Message to trigger if the faction can capture territory. This can be a single string or a @table of strings if multiple messages are desired.
--- @p [opt=nil] @string negative message, Message to trigger if the faction cannot capture territory. This can be a single string or a @table of strings if multiple messages are desired.
--- @p [opt=nil] @string target faction, Faction key of a target faction which the subject should have an agreement with, from the <code>factions</code> database table. A @table of string faction keys may be specified if more than one target faction is desired. In this case, the query passes if an agreement exists with any of the target factions in the list.
--- @p [opt=nil] @string target culture, Culture key of a target faction which the subject should have an agreement with, from the <code>cultures</code> database table. A @table of string culture keys may be specified if more than one target culture is desired. In this case, the query passes if an agreement exists with a faction of any of the target cultures in the list.
--- @p [opt=nil] @string target subculture, Subculture key of a target faction which the subject should have an agreement with, from the <code>cultures_subcultures</code> database table. A @table of string subculture keys may be specified if more than one target subculture is desired. In this case, the query passes if an agreement exists with a faction of any of the target subcultures in the list.
--- @p [opt=nil] @function additional condition, Additional condition function which can force a positive or negative result. If supplied, the function is called with the context and narrative query objects passed in as separate functions. If it returns <code>true</code> then a positive result is forced, if <code>false</code> then a negative result is forced. If it returns any other value then no result is forced.
--- @p_long_desc The condition function may also return a string as a second return value, which will be used for output.
function narrative_queries.has_non_aggression_pact(name, faction_key, trigger_messages, positive_messages, negative_messages, target_factions, target_cultures, target_subcultures, condition)
	local nq = construct_narrative_query_has_non_aggression_pact(name, faction_key, trigger_messages, positive_messages, negative_messages, target_factions, target_cultures, target_subcultures, condition);

	if nq then
		nq:start();
	end;
end;

















-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Has Trade Agreement
--	Acts on whether the faction has a trade agreement, optionally with any of
--	a list of factions or subcultures
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_query_has_trade_agreement(name, faction_key, trigger_messages, positive_messages, negative_messages, target_factions, target_cultures, target_subcultures, condition)

	if target_factions then
		if is_string(target_factions) then
			target_factions = {target_factions};
		elseif not validate.is_table_of_strings(target_factions) then
			return false;
		end;
	end;

	if target_cultures then
		if is_string(target_cultures) then
			target_cultures = {target_cultures};
		elseif not validate.is_table_of_strings(target_cultures) then
			return false;
		end;
	end;

	if target_subcultures then
		if is_string(target_subcultures) then
			target_subcultures = {target_subcultures};
		elseif not validate.is_table_of_strings(target_subcultures) then
			return false;
		end;
	end;

	local query_records = {
		{
			message = positive_messages,
			fail_message = negative_messages,
			query = function(context, nq)

				if is_function(condition) then
					local result, result_str = condition(context, nq);
					if is_boolean(result) then
						return result, error_str;
					end;
				end;

				local faction = cm:get_faction(faction_key);
				local faction_list = faction:factions_trading_with();
				
				local query_passes, reason_str = faction_list_contains_factions_cultures_subcultures_for_diplomacy_query(faction_list, target_factions, target_cultures, target_subcultures);

				if query_passes then
					return true, "faction with key [" .. faction_key .. "] has a trade agreement with " .. reason_str;
				end;

				if target_factions or target_cultures or target_subcultures then
					return false, "faction with key [" .. faction_key .. "] has no trade agreement with any specified faction";
				end;

				return false, "faction with key [" .. faction_key .. "] has no trade agreement with any faction";
			end;
		}
	};

	local nq = narrative_query:new(name, faction_key, trigger_messages, query_records);

	return nq;
end;


--- @function has_trade_agreement
--- @desc Creates a narrative query that queries whether the specified faction has a trade agreement. Zero or more faction keys, faction culture keys or faction subculture keys may be specified. Should the subject faction have a trade agreement with any of the specified factions/cultures/subcultures, or should they have a trade agreement with any faction if no filters are specified, then the query will return a positive result.
--- @p @string unique name, Unique name amongst other declared narrative queries.
--- @p @string faction key, Key of the faction to which this narrative query applies, from the <code>factions</code> database table.
--- @p @string trigger message, Message on which this narrative query should trigger. If multiple trigger messages are required a @table containing string message names can be supplied here instead.
--- @p @string positive message, Message to trigger if the faction can capture territory. This can be a single string or a @table of strings if multiple messages are desired.
--- @p [opt=nil] @string negative message, Message to trigger if the faction cannot capture territory. This can be a single string or a @table of strings if multiple messages are desired.
--- @p [opt=nil] @string target faction, Faction key of a target faction which the subject should have an agreement with, from the <code>factions</code> database table. A @table of string faction keys may be specified if more than one target faction is desired. In this case, the query passes if an agreement exists with any of the target factions in the list.
--- @p [opt=nil] @string target culture, Culture key of a target faction which the subject should have an agreement with, from the <code>cultures</code> database table. A @table of string culture keys may be specified if more than one target culture is desired. In this case, the query passes if an agreement exists with a faction of any of the target cultures in the list.
--- @p [opt=nil] @string target subculture, Subculture key of a target faction which the subject should have an agreement with, from the <code>cultures_subcultures</code> database table. A @table of string subculture keys may be specified if more than one target subculture is desired. In this case, the query passes if an agreement exists with a faction of any of the target subcultures in the list.
--- @p [opt=nil] @function additional condition, Additional condition function which can force a positive or negative result. If supplied, the function is called with the context and narrative query objects passed in as separate functions. If it returns <code>true</code> then a positive result is forced, if <code>false</code> then a negative result is forced. If it returns any other value then no result is forced.
--- @p_long_desc The condition function may also return a string as a second return value, which will be used for output.
function narrative_queries.has_trade_agreement(name, faction_key, trigger_messages, positive_messages, negative_messages, target_factions, target_cultures, target_subcultures, condition)
	local nq = construct_narrative_query_has_trade_agreement(name, faction_key, trigger_messages, positive_messages, negative_messages, target_factions, target_cultures, target_subcultures, condition);

	if nq then
		nq:start();
	end;
end;

















-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Has Defensive Alliance
--	Acts on whether the faction has a defensive alliance, optionally with any of
--	a list of factions or subcultures
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_query_has_defensive_alliance(name, faction_key, trigger_messages, positive_messages, negative_messages, target_factions, target_cultures, target_subcultures, condition)

	if target_factions then
		if is_string(target_factions) then
			target_factions = {target_factions};
		elseif not validate.is_table_of_strings(target_factions) then
			return false;
		end;
	end;

	if target_cultures then
		if is_string(target_cultures) then
			target_cultures = {target_cultures};
		elseif not validate.is_table_of_strings(target_cultures) then
			return false;
		end;
	end;

	if target_subcultures then
		if is_string(target_subcultures) then
			target_subcultures = {target_subcultures};
		elseif not validate.is_table_of_strings(target_subcultures) then
			return false;
		end;
	end;

	local query_records = {
		{
			message = positive_messages,
			fail_message = negative_messages,
			query = function(context, nq)

				if is_function(condition) then
					local result, result_str = condition(context, nq);
					if is_boolean(result) then
						return result, error_str;
					end;
				end;

				local faction = cm:get_faction(faction_key);
				local faction_list = faction:factions_defensive_allies_with();
				
				local query_passes, reason_str = faction_list_contains_factions_cultures_subcultures_for_diplomacy_query(faction_list, target_factions, target_cultures, target_subcultures);

				if query_passes then
					return true, "faction with key [" .. faction_key .. "] has a defensive alliance with " .. reason_str;
				end;

				if target_factions or target_cultures or target_subcultures then
					return false, "faction with key [" .. faction_key .. "] has no defensive alliance with any specified faction";
				end;

				return false, "faction with key [" .. faction_key .. "] has no defensive alliance with any faction";
			end;
		}
	};

	local nq = narrative_query:new(name, faction_key, trigger_messages, query_records);

	return nq;
end;


--- @function has_defensive_alliance
--- @desc Creates a narrative query that queries whether the specified faction has a defensive alliance. Zero or more faction keys, faction culture keys or faction subculture keys may be specified. Should the subject faction have a defensive alliance with any of the specified factions/cultures/subcultures, or should they have a defensive alliance with any faction if no filters are specified, then the query will return a positive result.
--- @p @string unique name, Unique name amongst other declared narrative queries.
--- @p @string faction key, Key of the faction to which this narrative query applies, from the <code>factions</code> database table.
--- @p @string trigger message, Message on which this narrative query should trigger. If multiple trigger messages are required a @table containing string message names can be supplied here instead.
--- @p @string positive message, Message to trigger if the faction can capture territory. This can be a single string or a @table of strings if multiple messages are desired.
--- @p [opt=nil] @string negative message, Message to trigger if the faction cannot capture territory. This can be a single string or a @table of strings if multiple messages are desired.
--- @p [opt=nil] @string target faction, Faction key of a target faction which the subject should have an agreement with, from the <code>factions</code> database table. A @table of string faction keys may be specified if more than one target faction is desired. In this case, the query passes if an agreement exists with any of the target factions in the list.
--- @p [opt=nil] @string target culture, Culture key of a target faction which the subject should have an agreement with, from the <code>cultures</code> database table. A @table of string culture keys may be specified if more than one target culture is desired. In this case, the query passes if an agreement exists with a faction of any of the target cultures in the list.
--- @p [opt=nil] @string target subculture, Subculture key of a target faction which the subject should have an agreement with, from the <code>cultures_subcultures</code> database table. A @table of string subculture keys may be specified if more than one target subculture is desired. In this case, the query passes if an agreement exists with a faction of any of the target subcultures in the list.
--- @p [opt=nil] @function additional condition, Additional condition function which can force a positive or negative result. If supplied, the function is called with the context and narrative query objects passed in as separate functions. If it returns <code>true</code> then a positive result is forced, if <code>false</code> then a negative result is forced. If it returns any other value then no result is forced.
--- @p_long_desc The condition function may also return a string as a second return value, which will be used for output.
function narrative_queries.has_defensive_alliance(name, faction_key, trigger_messages, positive_messages, negative_messages, target_factions, target_cultures, target_subcultures, condition)
	local nq = construct_narrative_query_has_defensive_alliance(name, faction_key, trigger_messages, positive_messages, negative_messages, target_factions, target_cultures, target_subcultures, condition);

	if nq then
		nq:start();
	end;
end;

















-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Has Military Alliance
--	Acts on whether the faction has a military alliance, optionally with any of
--	a list of factions or subcultures
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_query_has_military_alliance(name, faction_key, trigger_messages, positive_messages, negative_messages, target_factions, target_cultures, target_subcultures, condition)

	if target_factions then
		if is_string(target_factions) then
			target_factions = {target_factions};
		elseif not validate.is_table_of_strings(target_factions) then
			return false;
		end;
	end;

	if target_cultures then
		if is_string(target_cultures) then
			target_cultures = {target_cultures};
		elseif not validate.is_table_of_strings(target_cultures) then
			return false;
		end;
	end;

	if target_subcultures then
		if is_string(target_subcultures) then
			target_subcultures = {target_subcultures};
		elseif not validate.is_table_of_strings(target_subcultures) then
			return false;
		end;
	end;

	local query_records = {
		{
			message = positive_messages,
			fail_message = negative_messages,
			query = function(context, nq)

				if is_function(condition) then
					local result, result_str = condition(context, nq);
					if is_boolean(result) then
						return result, error_str;
					end;
				end;

				local faction = cm:get_faction(faction_key);
				local faction_list = faction:factions_military_allies_with();
				
				local query_passes, reason_str = faction_list_contains_factions_cultures_subcultures_for_diplomacy_query(faction_list, target_factions, target_cultures, target_subcultures);

				if query_passes then
					return true, "faction with key [" .. faction_key .. "] has a military alliance with " .. reason_str;
				end;

				if target_factions or target_cultures or target_subcultures then
					return false, "faction with key [" .. faction_key .. "] has no military alliance with any specified faction";
				end;

				return false, "faction with key [" .. faction_key .. "] has no military alliance with any faction";
			end;
		}
	};

	local nq = narrative_query:new(name, faction_key, trigger_messages, query_records);

	return nq;
end;


--- @function has_military_alliance
--- @desc Creates a narrative query that queries whether the specified faction has a military alliance. Zero or more faction keys, faction culture keys or faction subculture keys may be specified. Should the subject faction have a military alliance with any of the specified factions/cultures/subcultures, or should they have a military alliance with any faction if no filters are specified, then the query will return a positive result.
--- @p @string unique name, Unique name amongst other declared narrative queries.
--- @p @string faction key, Key of the faction to which this narrative query applies, from the <code>factions</code> database table.
--- @p @string trigger message, Message on which this narrative query should trigger. If multiple trigger messages are required a @table containing string message names can be supplied here instead.
--- @p @string positive message, Message to trigger if the faction can capture territory. This can be a single string or a @table of strings if multiple messages are desired.
--- @p [opt=nil] @string negative message, Message to trigger if the faction cannot capture territory. This can be a single string or a @table of strings if multiple messages are desired.
--- @p [opt=nil] @string target faction, Faction key of a target faction which the subject should have an agreement with, from the <code>factions</code> database table. A @table of string faction keys may be specified if more than one target faction is desired. In this case, the query passes if an agreement exists with any of the target factions in the list.
--- @p [opt=nil] @string target culture, Culture key of a target faction which the subject should have an agreement with, from the <code>cultures</code> database table. A @table of string culture keys may be specified if more than one target culture is desired. In this case, the query passes if an agreement exists with a faction of any of the target cultures in the list.
--- @p [opt=nil] @string target subculture, Subculture key of a target faction which the subject should have an agreement with, from the <code>cultures_subcultures</code> database table. A @table of string subculture keys may be specified if more than one target subculture is desired. In this case, the query passes if an agreement exists with a faction of any of the target subcultures in the list.
--- @p [opt=nil] @function additional condition, Additional condition function which can force a positive or negative result. If supplied, the function is called with the context and narrative query objects passed in as separate functions. If it returns <code>true</code> then a positive result is forced, if <code>false</code> then a negative result is forced. If it returns any other value then no result is forced.
--- @p_long_desc The condition function may also return a string as a second return value, which will be used for output.
function narrative_queries.has_military_alliance(name, faction_key, trigger_messages, positive_messages, negative_messages, target_factions, target_cultures, target_subcultures, condition)
	local nq = construct_narrative_query_has_military_alliance(name, faction_key, trigger_messages, positive_messages, negative_messages, target_factions, target_cultures, target_subcultures, condition);

	if nq then
		nq:start();
	end;
end;


















-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Has Pooled Resource
--	Acts on whether the faction's currently-held quantity of a specified pooled
--	resource or pooled resources is above a specified threshold
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local function construct_narrative_query_has_pooled_resource(name, faction_key, trigger_messages, positive_messages, negative_messages, pooled_resources, threshold_value, condition)

	if is_string(pooled_resources) then
		pooled_resources = {pooled_resources};
	elseif not validate.is_table_of_strings(pooled_resources) then
		return false;
	end;

	if not validate.is_number(threshold_value) then
		return false;
	end;

	local query_records = {
		{
			message = positive_messages,
			fail_message = negative_messages,
			query = function(context, nq)

				if is_function(condition) then
					local result, result_str = condition(context, nq);
					if is_boolean(result) then
						return result, error_str;
					end;
				end;

				local faction = cm:get_faction(faction_key);
				if not faction then
					return false, "faction [" .. faction_key .. "] could not be found";
				end;
				
				for i = 1, #pooled_resources do
					local resource_key = pooled_resources[i];
					local resource = faction:pooled_resource_manager():resource(resource_key);

					if not resource:is_null_interface() then
						if resource:value() >= threshold_value then
							return true, "faction [" .. faction_key .. "] has pooled resource [" .. resource_key .. "] with value [" .. resource:value() .. "] which is greater than or equal to threshold [" .. threshold_value .. "]";
						end;
					end;
				end;

				if #pooled_resources == 1 then
					return false, "pooled resource [" .. pooled_resources[1] .. "] for faction [" .. faction_key .. "] is less than threshold [" .. threshold_value .. "]";
				end;
				
				return false, "none of pooled resources [" .. table.concat(pooled_resources, ", ") .. "] for faction [" .. faction_key .. "] have a value greater than or equal to threshold [" .. threshold_value .. "]";
			end;
		}
	};

	local nq = narrative_query:new(name, faction_key, trigger_messages, query_records);

	return nq;
end;


--- @function has_pooled_resource
--- @desc Creates a narrative query that queries whether the value of one or more pooled resources for a specified faction is equal to or greater than a specified value. If more than one pooled resource is specified, then the query triggers its positive message if any of the pooled resources meet or exceed the threshold.
--- @p @string unique name, Unique name amongst other declared narrative queries.
--- @p @string faction key, Key of the faction to which this narrative query applies, from the <code>factions</code> database table.
--- @p @string trigger message, Message on which this narrative query should trigger. If multiple trigger messages are required a @table containing string message names can be supplied here instead.
--- @p @string positive message, Message to trigger if the faction can capture territory. This can be a single string or a @table of strings if multiple messages are desired.
--- @p [opt=nil] @string negative message, Message to trigger if the faction cannot capture territory. This can be a single string or a @table of strings if multiple messages are desired.
--- @p @string pooled resource key, Pooled resource key, from the <code>pooled resources</code> database table. If more than one pooled resource is to be queried then a @table of strings may be specified here.
--- @p @number threshold value, Threshold value, which the pooled resource should meet or exceed for the positive message to be triggered.
--- @p [opt=nil] @function additional condition, Additional condition function which can force a positive or negative result. If supplied, the function is called with the context and narrative query objects passed in as separate functions. If it returns <code>true</code> then a positive result is forced, if <code>false</code> then a negative result is forced. If it returns any other value then no result is forced.
--- @p_long_desc The condition function may also return a string as a second return value, which will be used for output.
function narrative_queries.has_pooled_resource(name, faction_key, trigger_messages, positive_messages, negative_messages, pooled_resources, threshold_value, condition)
	local nq = construct_narrative_query_has_pooled_resource(name, faction_key, trigger_messages, positive_messages, negative_messages, pooled_resources, threshold_value, condition);

	if nq then
		nq:start();
	end;
end;