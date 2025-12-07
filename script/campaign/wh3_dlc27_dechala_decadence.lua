dechala_decadence_config = {

	------------------------------------------------------------------------------------
	------                              CONSTANTS                              ---------
	------------------------------------------------------------------------------------
	--these dont need to be saved because these never change and when the script is loaded they will always be set correctly
	--dechala faction key and character name
	dechala_faction_key = "wh3_dlc27_sla_the_tormentors";
	dechala_forename = "names_name_1163393566";
	decadence_resource_key = "wh3_dlc27_sla_decadence";

	------------------------------------------------------------------------------------
	------                              VARIABLES                               ---------
	------------------------------------------------------------------------------------
	-- these will need to be saved and loaded because they may change during the campaign

	--this table keeps track of every value that can affect the momentum value of Dechala's decadence
	decadence_battle_matrix = {
		["pyrrhic_victory"]		= 	{factor = "wh3_dlc27_sla_decadence_battles", 		amount = 100},
		["close_victory"]		= 	{factor = "wh3_dlc27_sla_decadence_battles", 		amount = 200},
		["decisive_victory"]	= 	{factor = "wh3_dlc27_sla_decadence_battles", 		amount = 300},
		["heroic_victory"]		= 	{factor = "wh3_dlc27_sla_decadence_battles", 		amount = 400},
		["valiant_defeat"]		= 	{factor = "wh3_dlc27_sla_decadence_battles",		amount = -50},
		["close_defeat"]		= 	{factor = "wh3_dlc27_sla_decadence_battles",		amount = -100},
		["decisive_defeat"]		= 	{factor = "wh3_dlc27_sla_decadence_battles",		amount = -150},
		["crushing_defeat"]		= 	{factor = "wh3_dlc27_sla_decadence_battles",		amount = -200},

	};
}

dechala_decadence = {}
dechala_decadence.config = dechala_decadence_config

function dechala_decadence:initialize()

	out("#### Adding Dechala Decadence Listeners ####");
	local dechala_interface = cm:get_faction(dechala_decadence.config.dechala_faction_key)

	if dechala_interface then
		-- add listener for start of round incrementations
	
		-- Award decadence based on battle results
		core:add_listener(
			"DechalaDecadence_CharacterCompletedBattle",
			"CharacterCompletedBattle",
			function(context) 
				--Check if battle is over and if Dechala force took part
				return cm:model():pending_battle():has_been_fought() 
					and context:character():faction():name() == dechala_decadence.config.dechala_faction_key;  
			end,
			function(context) 

				dechala_decadence:BattleCompleted(context) 
			end,
			true
		);
	end

end


--Check if Dechala took part in a battle, if he did determine if he won that battle
function dechala_decadence:BattleCompleted(context)

	local battle = context:pending_battle()	
	local battle_result
	
	if battle:attacker():faction():name() == dechala_decadence.config.dechala_faction_key then
		battle_result = battle:attacker_battle_result()
	else 
		battle_result = battle:defender_battle_result()
	end

	dechala_decadence:updateDecadence(dechala_decadence.config.decadence_battle_matrix[battle_result])

end

--Updates the decadence pooled resource amount with the passed integer argument
function dechala_decadence:updateDecadence(decadence_entry)
	if not decadence_entry then return false end
	
	cm:faction_add_pooled_resource(dechala_decadence.config.dechala_faction_key,dechala_decadence.config.decadence_resource_key, decadence_entry.factor, decadence_entry.amount);	
end