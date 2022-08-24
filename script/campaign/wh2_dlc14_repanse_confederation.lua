local repanse_faction = "wh2_dlc14_brt_chevaliers_de_lyonesse";
local knights_flame = "wh2_main_brt_knights_of_the_flame";
local knights_origo = "wh2_main_brt_knights_of_origo";

function add_repanse_confederation_listeners()
	out("#### Adding Repanse Confederation Listerners ####");
	local repanse_interface = cm:model():world():faction_by_key(repanse_faction); 
	--check if Repanse is human
	if repanse_interface:is_null_interface() == false and repanse_interface:is_human() == true then			
		core:add_listener(
			"repanse_trigger_dilemma",
			"MissionSucceeded",
			function(context)
				local mission = context:mission():mission_record_key();
				return mission == "wh2_dlc14_brt_repanse_capture_arkhan" or mission == "wh2_dlc14_repanse_mission_own_province"
			end,
			function(context)
				local mission = context:mission():mission_record_key();
				if mission == "wh2_dlc14_repanse_mission_own_province" then 
					local origo_interface = cm:model():world():faction_by_key(knights_origo); 
					if origo_interface:is_null_interface() == false and origo_interface:is_dead() == false then
						cm:trigger_dilemma(repanse_faction, "wh2_dlc14_brt_confederation_knights_of_origo");
					end	
				elseif mission == "wh2_dlc14_brt_repanse_capture_arkhan" then
					local flame_interface = cm:model():world():faction_by_key(knights_flame); 
					if flame_interface:is_null_interface() == false and flame_interface:is_dead() == false then				
						cm:trigger_dilemma(repanse_faction, "wh2_dlc14_brt_confederation_knights_of_the_flame");
					end
				end
			end,
			true
		);
		core:add_listener(
			"repanse_trigger_dilemma",
			"DilemmaChoiceMadeEvent",
			function(context)
				local dilemma = context:dilemma();
				return dilemma == "wh2_dlc14_brt_confederation_knights_of_origo" or dilemma == "wh2_dlc14_brt_confederation_knights_of_the_flame";
			end,
			function(context)
				local dilemma = context:dilemma();
				local choice = context:choice();
				if dilemma == "wh2_dlc14_brt_confederation_knights_of_origo" then 
					if choice == 0 then
						cm:force_confederation(repanse_faction, knights_origo);
					end
				elseif dilemma == "wh2_dlc14_brt_confederation_knights_of_the_flame" then 						
					if choice == 0 then					
						cm:force_confederation(repanse_faction, knights_flame);
					end
				end
			end,
			true
		);
	end
end
