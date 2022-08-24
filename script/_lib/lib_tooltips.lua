


----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--
--	TOOLTIP LISTENER
--	Listens for the appearance/disappearance of a tooltip and cals 
--	we're interested it replaces the contents of the tooltip with info from the db
--
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------


tooltip_listener = {
	hpm = nil,
	is_active = false,
	link = "",
	mouseon_callback = false,
	mouseoff_callback = false
};


set_class_custom_type(tooltip_listener, TYPE_TOOLTIP_LISTENER);
set_class_tostring(
	tooltip_listener, 
	function(obj)
		return TYPE_TOOLTIP_LISTENER .. "_" .. obj.link
	end
);


function tooltip_listener:new(link, mouseon_callback, mouseoff_callback)

	if not is_string(link) then
		script_error("ERROR: tooltip_listener:new() called but supplied link [" .. tostring(link) .. "] is not a string");
		return false;
	end;
	
	if not is_function(mouseon_callback) then
		script_error("ERROR: tooltip_listener:new() called but supplied mouseon callback [" .. tostring(mouseon_callback) .. "] is not a function");
		return false;
	end;
	
	if not is_function(mouseoff_callback) then
		script_error("ERROR: tooltip_listener:new() called but supplied mouseoff callback [" .. tostring(mouseoff_callback) .. "] is not a function");
		return false;
	end;

	local hpm = get_help_page_manager();
	local tl = {};
	
	tl.link = "tooltip:{{tt:" .. link .. "}}";

	set_object_class(tl, self);

	tl.mouseon_callback = mouseon_callback;
	tl.mouseoff_callback = mouseoff_callback;
	
	hpm:register_tooltip_listener(tl);
	
	return tl;
end;


function tooltip_listener:link_mouseon()
	if not self.is_active then
		self.is_active = true;
		self:mouseon_callback();
	end;
end;



function tooltip_listener:link_mouseoff()
	if self.is_active then
		self.is_active = false;
		self:mouseoff_callback();
	end;
end;

















----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--
--	LINK PARSER
--
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------


----------------------------------------------------------------------------
--	Definition
----------------------------------------------------------------------------


link_parser = {
	links = {},
	
	-- link and visited_link colours are now handled in UI
	-- link_colour_str = "col:help_page_link",
	-- visited_link_colour_str = "col:help_page_link_visited",
	tooltip_colour_str = "col:help_page_link_inactive",
	colour_str_terminator = "col"
};


set_class_custom_type_and_tostring(link_parser, TYPE_LINK_PARSER);


----------------------------------------------------------------------------
--	Declaration
----------------------------------------------------------------------------

function link_parser:new()

	local lp = core:get_static_object("link_parser");
	if lp then
		return lp;
	end;
	
	local lp = {};

	set_object_class(lp, self);
	
	lp.links = {};
	
	lp.parse_for_links_func = function(key, text)
		local link_record = lp.links[key];
		
		if not link_record then
			script_error("ERROR: couldn't find a link record for supplied key [" .. tostring(key) .. "] - one needs to be added with link_parser:add_record(), or this key is a typo");
			return text;
		end;
		
		local script_link = link_record.script_link;
		
		if not link_record then
			script_error("record " .. key .. " doesn't exist !");
			return text;
		end;
		
		-- if this record has no tooltip key then don't include a tooltip tag
		if link_record.tooltip_key == "" then
			script_error("record " .. key .. " has no tooltip tag");
			return "[[url:" .. link_record.script_link .. "]]" .. text .. "[[/url]]";
		end;
		
		
		if common.get_advice_history_string_seen(script_link) then
			-- player has seen this link before
			return "[[url_visited:" .. link_record.script_link .. "]][[tooltip:{{tt:" .. link_record.tooltip_key .. "}}]]" .. text .. "[[/tooltip]][[/url_visited]]";
		else
			-- player has not seen this link before
			return "[[url:" .. link_record.script_link .. "]][[tooltip:{{tt:" .. link_record.tooltip_key .. "}}]]" .. text .. "[[/tooltip]][[/url]]";
		end;
	end;
	
	lp.parse_for_tooltips_func = function(key, text)
		local link_record = lp.links[key];
		
		if not link_record then
			script_error("ERROR: couldn't find a link record for supplied key [" .. tostring(key) .. "] - one needs to be added with link_parser:add_record(), or this key is a typo");
			return "";
		end;
		
		-- if this record has no tooltip key then don't include any tags at all
		if not link_record or link_record.tooltip_key == "" then
			return text;
		end;
		
		return "[[tooltip:{{tt:" .. link_record.tooltip_key .. "}}]][[" .. lp.tooltip_colour_str .. "]]" .. text .. "[[/" .. lp.colour_str_terminator .. "]][[/tooltip]]";
	end;
	
	lp.parse_for_no_links_func = function(key, text)
		-- don't tag the text at all
		return text;
	end;

	core:add_static_object("link_parser", lp);
	
	return lp;
end;


function get_link_parser()
	return link_parser:new();
end;


----------------------------------------------------------------------------
--	Adding link records
----------------------------------------------------------------------------

function link_parser:add_record(key, script_link, tooltip_key)
	if not is_string(key) then
		script_error("ERROR: add_record() called but supplied key [" .. tostring(key) .. "] is not a string");
		return false;
	end;
	
	if not is_string(script_link) then
		script_error("ERROR: add_record() called but supplied script link [" .. tostring(script_link) .. "] is not a string");
		return false;
	end;
	
	if not tooltip_key then
		tooltip_key = "";
	end;
	
	if not is_string(tooltip_key) then
		script_error("ERROR: add_record() called but supplied tooltip key [" .. tostring(tooltip_key) .. "] is not a string or nil");
		return false;
	end;
	
	local record = {};
	record.script_link = script_link;
	record.tooltip_key = tooltip_key;
	
	self.links[key] = record;
end;


----------------------------------------------------------------------------
--	Parse functions
----------------------------------------------------------------------------

function link_parser:parse_component_for_links(uic)
	if not is_uicomponent(uic) then
		script_error("ERROR: parse_component_for_links() called but supplied object [" .. tostring(uic) .. "] is not a uicomponent");
		return false;
	end;
	
	local unparsed_text, source = uic:GetStateText();
	local parsed_text = self:parse(unparsed_text, self.parse_for_links_func);
	
	if parsed_text then
		uic:SetStateText(parsed_text, source);
	end;
end;


function link_parser:parse_for_links(str)
	if not is_string(str) then
		script_error("ERROR: parse_for_links() called but supplied object [" .. tostring(str) .. "] is not a string");
		return false;
	end;
	
	return self:parse(str, self.parse_for_links_func);
end;


function link_parser:parse_component_for_tooltips(uic)
	if not is_uicomponent(uic) then
		script_error("ERROR: parse_component_for_links() called but supplied object [" .. tostring(uic) .. "] is not a uicomponent");
		return false;
	end;
	
	local unparsed_text, source = uic:GetStateText();
	local parsed_text = self:parse(unparsed_text, self.parse_for_tooltips_func);
	
	if parsed_text then
		uic:SetStateText(parsed_text, source);
	end;
end;


function link_parser:parse_for_tooltips(str)
	if not is_string(str) then
		script_error("ERROR: parse_for_tooltips() called but supplied object [" .. tostring(str) .. "] is not a string");
		return false;
	end;
	
	return self:parse(str, self.parse_for_tooltips_func);
end;


function link_parser:parse_for_no_links(str)
	if not is_string(str) then
		script_error("ERROR: parse_for_no_links() called but supplied object [" .. tostring(str) .. "] is not a string");
		return false;
	end;
	
	return self:parse(str, self.parse_for_no_links_func);
end;


-- for internal use only
function link_parser:parse(str, default_parse_func)
	local modified_str = str;
	local pointer = 1;
	local next_separator = 1;
	
	-- [[sl:key]]text[[/sl]]
	-- handle localised text lookup
	local start_tag = "[[sl_lookup]]";
	local end_tag = "[[/sl_lookup]]";
	
	while true do
		pointer = 1;
		next_separator = string.find(modified_str, start_tag, pointer);
		
		if not next_separator then
			break;
		end;
		
		local pre_text = string.sub(modified_str, pointer, next_separator - 1);
		
		pointer = next_separator + string.len(start_tag);
				
		next_separator = string.find(modified_str, end_tag, pointer);
		
		if not next_separator then
			script_error("ERROR: link parser did not find a correctly-formed closing script-lookup tag. Script lookup tags are closed with [[/sl_lookup]]. The string in question follows on the next line:\n" .. modified_str);
			return false;
		end;
		
		local lookup_text = string.sub(modified_str, pointer, next_separator - 1);
		
		pointer = next_separator + string.len(end_tag);
		
		local post_text = string.sub(modified_str, pointer);
		
		modified_str = pre_text .. common.get_localised_string(lookup_text) .. post_text;
	end;
			
	-- [[sl:key]]text[[/sl]]
	-- default tag interpreter
	local start_tag_open = "[[sl:";
	local start_tag_close = "]]";
	end_tag = "[[/sl]]";
	
	while true do
		pointer = 1;
		next_separator = string.find(modified_str, start_tag_open, pointer);
		
		if not next_separator then
			break;
		end;
		
		local pre_text = string.sub(modified_str, pointer, next_separator - 1);
		
		pointer = next_separator + string.len(start_tag_open);
		
		next_separator = string.find(modified_str, start_tag_close, pointer);
		
		if not next_separator then
			script_error("ERROR: link parser did not find a correctly-formed opening script-link tag. Script link tags are opened as follows: [[sl:link_name]]. The string in question follows on the next line:\n" .. modified_str);
			return false;
		end;
		
		local link_key = string.sub(modified_str, pointer, next_separator - 1);
		
		pointer = next_separator + string.len(start_tag_close);
		
		next_separator = string.find(modified_str, end_tag, pointer);
		
		if not next_separator then
			script_error("ERROR: link parser did not find a correctly-formed closing script-link tag. Script link tags are closed with [[/sl]]. The string in question follows on the next line:\n" .. modified_str);
			return false;
		end;
		
		local link_text = string.sub(modified_str, pointer, next_separator - 1);
		
		pointer = next_separator + string.len(end_tag);
		
		local post_text = string.sub(modified_str, pointer);
		
		modified_str = pre_text .. default_parse_func(link_key, link_text) .. post_text;
	end;
	
	-- [[sl_link:key]]text[[/sl_link]]
	-- this tag forces the text to be interpreted as a link
	start_tag_open = "[[sl_link:";
	start_tag_close = "]]";
	end_tag = "[[/sl_link]]";
	
	while true do
		pointer = 1;
		next_separator = string.find(modified_str, start_tag_open, pointer);
		
		if not next_separator then
			break;
		end;
		
		local pre_text = string.sub(modified_str, pointer, next_separator - 1);
		
		pointer = next_separator + string.len(start_tag_open);
		
		next_separator = string.find(modified_str, start_tag_close, pointer);
		
		if not next_separator then
			script_error("ERROR: link parser did not find a correctly-formed opening script-link tag (forcing link). Script link tags are opened as follows: [[sl_link:<link_name>]]. The string in question follows on the next line:\n" .. modified_str);
			return false;
		end;
		
		local link_key = string.sub(modified_str, pointer, next_separator - 1);
		
		pointer = next_separator + string.len(start_tag_close);
		
		next_separator = string.find(modified_str, end_tag, pointer);
		
		if not next_separator then
			script_error("ERROR: link parser did not find a correctly-formed closing script-link tag (forcing link). Script link tags are closed with [[/sl_link]]. The string in question follows on the next line:\n " .. modified_str);
			return false;
		end;
		
		local link_text = string.sub(modified_str, pointer, next_separator - 1);
		
		pointer = next_separator + string.len(end_tag);
		
		local post_text = string.sub(modified_str, pointer);
				
		modified_str = pre_text .. self.parse_for_links_func(link_key, link_text) .. post_text;
	end;
	
	-- [[sl_tooltip:key]]text[[/sl_tooltip]]
	-- this tag forces the text to be interpreted as a tooltip
	start_tag_open = "[[sl_tooltip:";
	start_tag_close = "]]";
	end_tag = "[[/sl_tooltip]]";

	while true do
		pointer = 1;
		next_separator = string.find(modified_str, start_tag_open, pointer);
		
		if not next_separator then
			break;
		end;
		
		local pre_text = string.sub(modified_str, pointer, next_separator - 1);
		
		pointer = next_separator + string.len(start_tag_open);
		
		next_separator = string.find(modified_str, start_tag_close, pointer);
		
		if not next_separator then
			script_error("ERROR: link parser did not find a correctly-formed opening script-link tag (forcing tooltip). Script link tags are opened as follows: [[sl_tooltip:<link_name>]]. The string in question follows on the next line:\n" .. modified_str);
			return false;
		end;
		
		local link_key = string.sub(modified_str, pointer, next_separator - 1);
		
		pointer = next_separator + string.len(start_tag_close);
		
		next_separator = string.find(modified_str, end_tag, pointer);
		
		if not next_separator then
			script_error("ERROR: link parser did not find a correctly-formed closing script-link tag (forcing tooltip). Script link tags are closed with [[/sl_tooltip]]. The string in question follows on the next line:\n" .. modified_str);
			return false;
		end;
		
		local link_text = string.sub(modified_str, pointer, next_separator - 1);
		
		pointer = next_separator + string.len(end_tag);
		
		local post_text = string.sub(modified_str, pointer);
		
		modified_str = pre_text .. self.parse_for_tooltips_func(link_key, link_text) .. post_text;
	end;
		
	return modified_str;
end;











----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--
--	COMPONENT VISIBILITY MONITOR
--	This system listens for script events from the context system which are triggered when
--	a component's visibility status changes (A ContextCommandGiverOnVisibilityChanged callback 
--	has to be set up on the UI item in question for this to work). Each visibility-changed
--	callback is set up with an ID in the UI editor. It can then parse one or more components that 
--	have been registered against that ID using the link_parser. Using this mechanism, random
--	panels/bits of UI can be set up so that [[sl]] tags are parsed correctly, allowing many
--	topical words like army, faction and unit to be highlighted across the UI.
--
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

context_visibility_monitor = {
	-- parse_for_tooltips_map = {}
	-- parse_for_links_map = {}
}

set_class_custom_type_and_tostring(context_visibility_monitor, TYPE_CONTEXT_VISIBILITY_MONITOR);


function get_context_visibility_monitor()
	return context_visibility_monitor:new();
end;


function context_visibility_monitor:new()

	local cvm = core:get_static_object("context_visibility_monitor");
	if cvm then
		return cvm;
	end;

	cvm = {};

	cvm.parse_for_tooltips_map = {};
	cvm.parse_for_links_map = {};
	cvm.link_parser = get_link_parser();

	set_object_class(cvm, self);

	core:add_listener(
		"context_visibility_monitor",
		"ContextTriggerEvent",
		true,
		function(context)
			cvm:event_triggered(context.string);
		end,
		true
	);

	core:add_static_object("context_visibility_monitor", cvm);

	cvm.tm = core:get_tm();

	return cvm;
end;


-- The context event has been triggered
function context_visibility_monitor:event_triggered(key)

	self.tm:remove_real_callback("context_visibility_monitor_check_map_poll_" .. key);

	-- Check mapping for tooltips and then links
	self:check_map(
		key,
		self.parse_for_tooltips_map,
		function(uic)
			self.link_parser:parse_component_for_tooltips(uic)
		end
	);

	self:check_map(
		key,
		self.parse_for_links_map,
		function(uic)
			self.link_parser:parse_component_for_links(uic)
		end
	);
end;


-- The context event has been triggered, check a particular map
function context_visibility_monitor:check_map(key, map, parse_callback, repeat_count)
	repeat_count = repeat_count or 0;

	local component_paths = map[key];
	if component_paths then
		for i = 1, #component_paths do
			local path = component_paths[i];
			local uic = find_uicomponent_from_table(core:get_ui_root(), component_paths[i]);
			if uic then
				parse_callback(uic);
				-- out.ui("context_visibility_monitor has parsed the following uicomponent after key " .. key .. " received:");
				-- output_uicomponent(uic);
				
				-- try again next few frames - remove this hack
				if repeat_count <= 5 then
					self.tm:real_callback(
						function() 
							self:check_map(key, map, parse_callback, repeat_count + 1);
						end, 
						10,
						"context_visibility_monitor_check_map_poll_" .. key
					);
				end;
			end;
		end;
	end;
end;


-- Add a mapping for a particular context event key to parse a particular component for tooltips.
-- When the parsing occurs, any [[sl]] tags will be interpreted as non-clickable links, shown in light yellow.
function context_visibility_monitor:add_map_parse_for_tooltips(key, path_to_component)
	if not validate.is_string(key) then
		return false;
	end;

	if not validate.is_table_of_strings(path_to_component) then
		return false;
	end;

	if not self.parse_for_tooltips_map[key] then
		self.parse_for_tooltips_map[key] = {};
	end;

	table.insert(self.parse_for_tooltips_map[key], path_to_component);
end;


-- Add a mapping for a particular context event key to parse a particular component for links.
-- When the parsing occurs, any [[sl]] tags will be interpreted as clickable links, shown in dark orange.
function context_visibility_monitor:add_parse_for_links_map(key, path_to_component)
	if not validate.is_string(key) then
		return false;
	end;

	if not validate.is_table_of_strings(path_to_component) then
		return false;
	end;

	if not self.parse_for_links_map[key] then
		self.parse_for_links_map[key] = {};
	end;

	table.insert(self.parse_for_links_map[key], path_to_component);
end;



















----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--
--	TOOLTIP PATCHER
--	This system kicks in when a custom tooltip is displayed, and if it's a tooltip that
--	we're interested it replaces the contents of the tooltip with info from the db
--
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------


----------------------------------------------------------------------------
--	Definition
----------------------------------------------------------------------------


local MAX_TOOLTIP_IMAGE_WIDTH = 400;

tooltip_patcher = {
	layout_key = "",
	tl = false
};


set_class_custom_type(tooltip_patcher, TYPE_TOOLTIP_PATCHER);
set_class_tostring(
	tooltip_patcher,
	function(obj)
		return TYPE_TOOLTIP_PATCHER .. "_" .. obj.layout_key
	end
);


----------------------------------------------------------------------------
--	Declaration
----------------------------------------------------------------------------




function tooltip_patcher:new(layout_key)
	
	if not is_string(layout_key) then
		script_error("ERROR: add_tooltip_patcher() called but supplied layout key [" .. tostring(key) .. "] is not a string");
		return false;
	end;
	
	local tp = {};

	tp.layout_key = layout_key;
	
	set_object_class(tp, self);
		
	return tp;
end;


function tooltip_patcher:set_layout_data(layout_string, ...)

	if not is_string(layout_string) then
		script_error("ERROR: set_layout_data() called but supplied layout string [" .. tostring(layout_string) .. "] is not a string");
		return false;
	end;
	
	self.layout_string = layout_string;

	if layout_string == "tooltip_title_text_and_image" then
		local title_string_key = arg[1];
		local text_string_key = arg[2];
		local image_path = arg[3];
		
		if not is_string(title_string_key) then
			script_error("ERROR: set_layout_data() called but supplied title key [" .. tostring(title_string_key) .. "] is not a string");
			return false;
		end;
		
		if not is_string(text_string_key) then
			script_error("ERROR: set_layout_data() called but supplied text key [" .. tostring(text_string_key) .. "] is not a string");
			return false;
		end;

		if not is_string(image_path) then
			script_error("ERROR: set_layout_data() called but supplied image path [" .. tostring(image_path) .. "] is not a string");
			return false;
		end;
		
		self.title_string_key = arg[1];
		self.text_string_key = arg[2];
		self.image_path = arg[3];
	
		self.tl = tooltip_listener:new(
			self.layout_key, 
			function() self:tooltip_created_title_text_and_image() end,
			function() self:tooltip_destroyed() end
		);

	elseif layout_string == "tooltip_title_and_text" then
		local title_string_key = arg[1];
		local text_string_key = arg[2];
		
		if not is_string(title_string_key) then
			script_error("ERROR: set_layout_data() called but supplied title key [" .. tostring(title_string_key) .. "] is not a string");
			return false;
		end;
		
		if not is_string(text_string_key) then
			script_error("ERROR: set_layout_data() called but supplied text key [" .. tostring(text_string_key) .. "] is not a string");
			return false;
		end;
		
		self.title_string_key = arg[1];
		self.text_string_key = arg[2];
	
		self.tl = tooltip_listener:new(
			self.layout_key, 
			function() self:tooltip_created_title_and_text() end,
			function() self:tooltip_destroyed() end
		);
	
	
	elseif layout_string == "tooltip_text_only" then
		local text_string_key = arg[1];
				
		if not is_string(text_string_key) then
			script_error("ERROR: set_layout_data() called but supplied text key [" .. tostring(text_string_key) .. "] is not a string");
			return false;
		end;

		self.text_string_key = arg[1];
	
		self.tl = tooltip_listener:new(
			self.layout_key, 
			function() self:tooltip_created_text_only() end,
			function() self:tooltip_destroyed() end
		);
	
	-- add more layouts here if necessary
	else		
		script_error("ERROR: tooltip_patcher:new() called but don't know how to deal with the supplied layout [" .. tostring(layout_string) .. "]. Either add script to cope with it or change the layout");
	end;
end;


function tooltip_patcher:tooltip_created_title_text_and_image()

	local uic_tooltip = find_uicomponent(core:get_ui_root(), self.layout_string);
	
	if not uic_tooltip then
		script_error("ERROR: tooltip_created_title_text_and_image() couldn't find tooltip component. Layout key is " .. self.layout_key);
		return false;
	end;
	
	local uic_title = find_uicomponent(uic_tooltip, "title");
	
	if not uic_title then
		script_error("ERROR: tooltip_created_title_text_and_image() couldn't find title component. Layout key is " .. self.layout_key);
		print_all_uicomponent_children(uic_tooltip);
		return false;
	end;
	
	local uic_text = find_uicomponent(uic_tooltip, "text");
	
	if not uic_text then
		script_error("ERROR: tooltip_created_title_text_and_image() couldn't find description component. Layout key is " .. self.layout_key);
		print_all_uicomponent_children(uic_tooltip);
		return false;
	end;

	local uic_image = find_uicomponent(uic_tooltip, "image");
	
	if not uic_image then
		script_error("ERROR: tooltip_created_title_text_and_image() couldn't find description component. Layout key is " .. self.layout_key);
		print_all_uicomponent_children(uic_tooltip);
		return false;
	end;
	
	local localised_title = common.get_localised_string(self.title_string_key);
	
	if localised_title == "" then
		script_error("ERROR: couldn't find localised title corresponding to key " .. self.title_string_key);
		return false;
	end;
	
	local localised_text = common.get_localised_string(self.text_string_key);
	
	if localised_text == "" then
		script_error("ERROR: couldn't find localised description corresponding to key " .. self.text_string_key);
		return false;
	end;
	
	uic_title:SetStateText(localised_title, self.title_string_key);
	uic_text:SetStateText(localised_text, self.text_string_key);
	
	uic_image:SetImagePath(self.image_path, 0, true);

	local img_w, img_h = uic_image:GetImageDimensions(0);

	-- Clamp img width to MAX_TOOLTIP_IMAGE_WIDTH, preserving aspect ratio
	if img_w > MAX_TOOLTIP_IMAGE_WIDTH then
		img_h = img_h * (img_w / MAX_TOOLTIP_IMAGE_WIDTH);
		img_w = MAX_TOOLTIP_IMAGE_WIDTH;
	end;

	uic_image:Resize(img_w, img_h);
	uic_image:ResizeCurrentStateImage(0, img_w, img_h);

	-- This is a hack - if we don't set the image path a second time, for some reason the aspect ratio doesn't behave itself in all cases
	uic_image:SetImagePath(self.image_path, 0, true);
end;


function tooltip_patcher:tooltip_created_title_and_text()

	local uic_tooltip = find_uicomponent(core:get_ui_root(), self.layout_string);
	
	if not uic_tooltip then
		script_error("ERROR: tooltip_created_title_and_text() couldn't find tooltip component. Layout key is " .. self.layout_key);
		return false;
	end;
	
	local uic_title = find_uicomponent(uic_tooltip, "title");
	
	if not uic_title then
		script_error("ERROR: tooltip_created_title_and_text() couldn't find title component. Layout key is " .. self.layout_key);
		return false;
	end;
	
	local uic_text = find_uicomponent(uic_tooltip, "text");
	
	if not uic_text then
		script_error("ERROR: tooltip_created_title_and_text() couldn't find description component. Layout key is " .. self.layout_key);
		return false;
	end;
	
	local localised_title = common.get_localised_string(self.title_string_key);
	
	if localised_title == "" then
		script_error("ERROR: couldn't find localised title corresponding to key " .. self.title_string_key);
		return false;
	end;
	
	local localised_text = common.get_localised_string(self.text_string_key);
	
	if localised_text == "" then
		script_error("ERROR: couldn't find localised description corresponding to key " .. self.text_string_key);
		return false;
	end;
	
	uic_title:SetStateText(localised_title, self.title_string_key);
	uic_text:SetStateText(localised_text, self.text_string_key);
end;


function tooltip_patcher:tooltip_created_text_only()

	local uic_tooltip = find_uicomponent(core:get_ui_root(), self.layout_string);
	
	if not uic_tooltip then
		script_error("ERROR: tooltip_created_title_and_text() couldn't find tooltip component. Layout key is " .. self.layout_key);
		return false;
	end;
		
	local uic_text = find_uicomponent(uic_tooltip, "text");
	
	if not uic_text then
		script_error("ERROR: tooltip_created_title_and_text() couldn't find description component. Layout key is " .. self.layout_key);
		return false;
	end;
	
	local localised_text = common.get_localised_string(self.text_string_key);
	
	if localised_text == "" then
		script_error("ERROR: couldn't find localised description corresponding to key " .. self.text_string_key);
		return false;
	end;
	
	uic_text:SetStateText(localised_text, self.text_string_key);
end;



function tooltip_patcher:tooltip_destroyed()
	-- don't need to do anything here
end;