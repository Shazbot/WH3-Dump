

-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	CAMPAIGN SCRIPT
--
--	First file that gets loaded by a scripted campaign. This shouldn't need
--	to be changed per-campaign. It loads the campaign script and a required.lua
--	file which lives in the campaign script folder.
--	
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

-- load lua script libraries
load_script_libraries();

-- change this to false to not load the script
local load_script =  true;

if not load_script then
	out("*** WARNING: Not loading script for campaign as load_script variable is set to false! Edit lua file at " .. get_full_file_path() .. " to change this back ***");
	return;
end;

-- name of the campaign, sourced from the name of the containing folder
cm:set_campaign_name(get_folder_name_and_shortform());

-- include path to scripts in script/campaign/<campaign_name>/* associated with this campaign
cm:require_path_to_campaign_folder();

-------------------------------------------------------
--	additional script files to load - customise this
-------------------------------------------------------

require("required");




