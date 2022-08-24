-- Reference API: http://totalwar-confluence:8090/pages/viewpage.action?pageId=23268632

require "data.script.autotest.lib.all"


function uicomponent_to_string(uicomponent)
	
	if uicomponent:Id() == "root" then
		return "root";
	else
		local parent = uicomponent:Parent();
		
		if parent then
			return uicomponent_to_string(UIComponent(parent)) .. ">" .. uicomponent:Id();
		else
			return uicomponent:Id();
		end
	end
end


function component_clicked(context)
	local component = UIComponent(context.component)
	Utilities.print("GSAT_Record:ComponentClicked:" .. Functions.find_path_from_component(component))
end

function component_mouseon(context)
	Utilities.print("GSAT_Record:MouseOn:" .. context.string)
end

function key_pressed(context)
	Utilities.print("GSAT_Record:KeyPressed:" .. context.string)
end

function shortcut_triggered(context)
	Utilities.print("GSAT_Record:ShortcutTriggered:" .. context.string)
end

add_event_callback("ComponentLClickUp", 	component_clicked)
add_event_callback("ComponentMouseOn",		component_mouseon)
add_event_callback("ShortcutTriggered", 	shortcut_triggered)