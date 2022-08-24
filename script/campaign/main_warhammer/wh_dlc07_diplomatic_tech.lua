function Add_Bretonnia_Technology_Listeners()
	out("#### Adding Bretonnian Tech Listeners ####");
	core:add_listener(
		"Bret_Tech_FactionTurnStart",
		"ScriptEventHumanFactionTurnStart",
		true,
		function(context) Check_Bretonnia_Technology(context:faction()) end,
		true
	);
	core:add_listener(
		"Bret_Tech_ResearchCompleted",
		"ResearchCompleted",
		true,
		function(context) Bret_ResearchCompleted(context) end,
		true
	);
	core:add_listener(
		"Bret_Tech_ChivalryDilemmaChoiceMadeEvent",
		"DilemmaChoiceMadeEvent",
		true,
		function(context) Bret_Tech_ChivalryDilemmaChoiceMadeEvent(context) end,
		true
	);
	
	if cm:is_new_game() == true then
		local bretonnia = cm:model():world():faction_by_key("wh_main_brt_bretonnia");
		
		if bretonnia:is_null_interface() == false and bretonnia:is_human() then
			Check_Bretonnia_Technology(bretonnia);
		end
		
		local carcassonne = cm:model():world():faction_by_key("wh_main_brt_carcassonne");
		
		if carcassonne:is_null_interface() == false and carcassonne:is_human() then
			Check_Bretonnia_Technology(carcassonne);
		end
		
		local bordeleaux = cm:model():world():faction_by_key("wh_main_brt_bordeleaux");
		
		if bordeleaux:is_null_interface() == false and bordeleaux:is_human() then
			Check_Bretonnia_Technology(bordeleaux);
		end
	end
end

function Check_Bretonnia_Technology(faction)
	local faction_name = faction:name();
	if faction:culture() == "wh_main_brt_bretonnia" and faction_name ~= "wh2_dlc14_brt_chevaliers_de_lyonesse" then
		for i = 1, #bret_confederation_dilemmas do
			local unlock = bret_confederation_dilemmas[i];
			
			if faction_name ~= unlock.faction then
				local has_tech = faction:has_technology(unlock.tech);
				cm:force_diplomacy("faction:" .. faction_name, "faction:" .. unlock.faction, "form confederation", has_tech, has_tech, true);
			end
		end
	end
end

function Bret_ResearchCompleted(context)
	local tech_key = context:technology();
	local faction_key = context:faction():name();
	
	for i = 1, #bret_confederation_dilemmas do
		if bret_confederation_dilemmas[i].tech == tech_key then
			local confed_faction = bret_confederation_dilemmas[i].faction;
			local confed_faction_obj = cm:model():world():faction_by_key(confed_faction);
			
			if confed_faction_obj:is_null_interface() == false and confed_faction_obj:is_dead() == false and confed_faction_obj:is_human() == false then
				local dilemma = bret_confederation_dilemmas[i].dilemma;
				cm:trigger_dilemma(faction_key, dilemma);
			end
		end
	end
end

function Bret_Tech_ChivalryDilemmaChoiceMadeEvent(context)
	local dilemma = context:dilemma();
	local choice = context:choice();
	local faction_key = context:faction():name();
	
	for i = 1, #bret_confederation_dilemmas do
		if bret_confederation_dilemmas[i].dilemma == dilemma then
			if choice == 0 or choice == 1 then
				cm:force_confederation(faction_key, bret_confederation_dilemmas[i].faction);
			end
		end
	end
end

bret_confederation_dilemmas = {
	{tech = "wh_dlc07_tech_brt_heraldry_artois", dilemma = "wh_dlc07_brt_confederation_artois", faction = "wh_main_brt_artois"},
	{tech = "wh_dlc07_tech_brt_heraldry_bastonne", dilemma = "wh_dlc07_brt_confederation_bastonne", faction = "wh_main_brt_bastonne"},
	{tech = "wh_dlc07_tech_brt_heraldry_bordeleaux", dilemma = "wh_dlc07_brt_confederation_bordeleaux", faction = "wh_main_brt_bordeleaux"},
	{tech = "wh_dlc07_tech_brt_heraldry_bretonnia", dilemma = "wh_dlc07_brt_confederation_bretonnia", faction = "wh_main_brt_bretonnia"},
	{tech = "wh_dlc07_tech_brt_heraldry_carcassonne", dilemma = "wh_dlc07_brt_confederation_carcassonne", faction = "wh_main_brt_carcassonne"},
	{tech = "wh_dlc07_tech_brt_heraldry_lyonesse", dilemma = "wh_dlc07_brt_confederation_lyonesse", faction = "wh_main_brt_lyonesse"},
	{tech = "wh_dlc07_tech_brt_heraldry_parravon", dilemma = "wh_dlc07_brt_confederation_parravon", faction = "wh_main_brt_parravon"},
	{tech = "wh3_main_tech_brt_heraldry_aquitaine", dilemma = "wh3_main_brt_confederation_aquitaine", faction = "wh3_main_brt_aquitaine"}
};