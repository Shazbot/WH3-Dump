----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--
--	UNIQUE_TABLE
--
--- @set_environment campaign
--- @c unique_table Unique Table
--- @desc A unique table is an expanded table object allowing for easy management of a table where the desired usage of the table is to only store unique items.
--- @desc Also allows easy addition, subtraction and various other functionality to manage the tables via multiple operators implemented through metamethods.
--
--- @section Metamethods - Usable Operators
--- @desc <strong>Addition Operator (+)</strong>
--- @desc <li>Creates a new unique table adding the two unique tables together, the resulting unique table contains only unique items</li>
--- @desc <strong>Subtraction Operator (-)</strong>
--- @desc <li>Creates a new unique table removing all of the items from the second unique table from the first unique table</li>
--- @desc <strong>Multiplication Operator (*)</strong>
--- @desc <li>Creates a new unique table containing only items that exist in both tables</li>
--- @desc <strong>Division Operator (/)</strong>
--- @desc <li>Creates a new unique table containing only items that only exist in one of the two tables</li>
--
--- @section Example Usages
--- @new_example Creating and Inserting
--- @desc Only unique entires are added to the table, hence in the example below the second attempt to add "first_string" does not work
--- @example local ut1 = unique_table:new();
--- @example ut1:insert("first_string");
--- @example ut1:insert("first_string");
--- @example ut1:insert("second_string");
--- @example  
--- @example -- ut1 Contents: "first_string", "second_string"

--- @new_example Adding two unique tables together
--- @desc Only unique entires are added to both tables, and upon adding both tables again only unique entires remain in the final table
--- @example local ut1 = unique_table:new();
--- @example ut1:insert("first_string");
--- @example ut1:insert("first_string");
--- @example ut1:insert("second_string");
--- @example  
--- @example local ut2 = unique_table:new();
--- @example ut2:insert("second_string");
--- @example ut2:insert("third_string");
--- @example  
--- @example local ut3 = ut1 + ut2;
--- @example  
--- @example -- ut3 Contents: "first_string", "second_string", "third_string"

--- @new_example Subracting one unique table from another
--- @desc The entries from the second table are removed from the first and the result is a new unique table
--- @example local ut1 = unique_table:new();
--- @example ut1:insert("first_string");
--- @example ut1:insert("second_string");
--- @example  
--- @example local ut2 = unique_table:new();
--- @example ut2:insert("second_string");
--- @example  
--- @example local ut3 = ut1 - ut2;
--- @example  
--- @example -- ut3 Contents: "first_string"

--- @new_example Extracting matching items
--- @desc The resulting unique table from the multiplication operator only contains items that are in <strong>both</strong> of the unique tables supplied
--- @example local ut1 = unique_table:new();
--- @example ut1:insert("first_string");
--- @example ut1:insert("second_string");
--- @example  
--- @example local ut2 = unique_table:new();
--- @example ut2:insert("second_string");
--- @example ut2:insert("third_string");
--- @example  
--- @example local ut3 = ut1 * ut2;
--- @example  
--- @example -- ut3 Contents: "second_string"

--- @new_example Extracting unique items amongst multiple unique tables
--- @desc The resulting unique table from the division operator only contains items that are <strong>not</strong> in both of the unique tables supplied
--- @example local ut1 = unique_table:new();
--- @example ut1:insert("first_string");
--- @example ut1:insert("second_string");
--- @example  
--- @example local ut2 = unique_table:new();
--- @example ut2:insert("second_string");
--- @example ut2:insert("third_string");
--- @example  
--- @example local ut3 = ut1 / ut2;
--- @example  
--- @example -- ut3 Contents: "first_string", "third_string"

--- @new_example Creating a unique table from existing data
--- @desc Here two list interfaces are taken from the model, turned into unique tables and multiplied to get only the items in both lists
--- @example local faction_obj = cm:model():world():faction_by_key(faction_key);
--- @example local non_aggression_pacts = unique_table:faction_list_to_unique_table(faction_obj:factions_non_aggression_pact_with());
--- @example local trading_partners = unique_table:faction_list_to_unique_table(faction_obj:factions_trading_with());
--- @example  
--- @example local trading_partners_with_nap_pacts = non_aggression_pacts * trading_partners;
--- @example  
--- @example -- Result: The final unique table contains only factions with whom the player has both a non-aggression pact and a trade treaty


----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--- @section Creation
unique_table = {};

function unique_table:__tostring()
	return TYPE_UNIQUE_TABLE;
end

function unique_table:__type()
	return TYPE_UNIQUE_TABLE;
end

--- @function new
--- @desc Creates a new unique table object
--- @p [opt=nil] table o, Pass an object to the new function to use that instance of the object as this new one
--- @r unique_table the new unique table object
function unique_table:new()
	local o = o or {};
	setmetatable(o, self);
	self.__index = self;

	self.__add = function(table1, table2)
		local new_table = unique_table:new();
		for i = 1, #table1.items do
			new_table:insert(table1.items[i]);
		end
		for i = 1, #table2.items do
			new_table:insert(table2.items[i]);
		end
		return new_table;
	end

	self.__sub = function(table1, table2)
		local new_table = unique_table:new();
		for i = 1, #table1.items do
			new_table:insert(table1.items[i]);
		end
		for i = 1, #table2.items do
			new_table:remove(table2.items[i]);
		end
		return new_table;
	end

	self.__mul = function(table1, table2)
		local new_table = unique_table:new();

		for i = 1, #table1.items do
			if table2:contains(table1.items[i]) == true then
				new_table:insert(table1.items[i]);
			end
		end
		for i = 1, #table2.items do
			if table1:contains(table2.items[i]) == true then
				new_table:insert(table2.items[i]);
			end
		end
		return new_table;
	end

	self.__div = function(table1, table2)
		local new_table = unique_table:new();

		for i = 1, #table1.items do
			if table2:contains(table1.items[i]) == false then
				new_table:insert(table1.items[i]);
			end
		end
		for i = 1, #table2.items do
			if table1:contains(table2.items[i]) == false then
				new_table:insert(table2.items[i]);
			end
		end
		return new_table;
	end

	o.items = {};
	o.tracker = {};
	return o;
end

--- @section Usage
--- @function insert
--- @desc Adds a new item into the unique table, but only if that item does not already exist
--- @p object item, The item to add to the table
function unique_table:insert(item)
	if self.tracker[item] == nil then
		table.insert(self.items, item);
		self.tracker[item] = #self.items;
	end
end

--- @function remove
--- @desc Removes the given item from the table
--- @p object item, The item to remove from the table
function unique_table:remove(item)
	for i = 1, #self.items do
		if self.items[i] == item then
			table.remove(self.items, i);
			self.tracker[item] = nil;
			break;
		end
	end
end

--- @function contains
--- @desc Returns true if the given item exists in the table
--- @p object item, The item to check
--- @r boolean true if the item exists
function unique_table:contains(item)
	return self.tracker[item] ~= nil;
end

--- @function index_of
--- @desc Returns the index of the given item in the table, or 0 if it doesn't exist
--- @p object item, The item to check
--- @r number index of the given item
function unique_table:index_of(item)
	for i = 1, #self.items do
		if self.items[i] == item then
			return i;
		end
	end
	return 0;
end

--- @function to_table
--- @desc Returns the unique table object as a normal table
--- @r table the unique table as a normal table
function unique_table:to_table()
	return {unpack(self.items)};
end

--- @section Constructing From Existing Data
--- @function table_to_unique_table
--- @desc Returns the table as a new unique table object
--- @r unique_table the table as a new unique table
function unique_table:table_to_unique_table(tab)
	local new_table = unique_table:new();

	if type(tab) == "table" then
		for i = 1, #tab do
			new_table:insert(tab[i]);
		end
	end
	return new_table;
end

--- @function faction_list_to_unique_table
--- @desc Returns a new unique table containing the items from the given faction list
--- @p object faction_list, The faction list to use
--- @p boolean cqi_list, Pass true to make the table use cqi's instead of faction objects
--- @r unique_table the new unique table
function unique_table:faction_list_to_unique_table(faction_list, cqi_list)
	local new_unique_list = unique_table:new();

	for i = 0, faction_list:num_items() - 1 do
		if cqi_list == true then
			local faction_cqi = faction_list:item_at(i):command_queue_index();
			new_unique_list:insert(faction_cqi);
		else
			local faction_key = faction_list:item_at(i):name();
			new_unique_list:insert(faction_key);
		end
	end
	return new_unique_list;
end

--- @function character_list_to_unique_table
--- @desc Returns a new unique table containing the items from the given character list
--- @p object character_list, The character list to use
--- @r unique_table the new unique table
function unique_table:character_list_to_unique_table(character_list)
	local new_unique_list = unique_table:new();

	for i = 0, character_list:num_items() - 1 do
		local character_cqi = character_list:item_at(i):command_queue_index();
		new_unique_list:insert(character_cqi);
	end
	return new_unique_list;
end

--- @function region_list_to_unique_table
--- @desc Returns a new unique table containing the items from the given region list
--- @p object region_list, The region list to use
--- @r unique_table the new unique table
function unique_table:region_list_to_unique_table(region_list, cqi_list)
	local new_unique_list = unique_table:new();

	for i = 0, region_list:num_items() - 1 do
		if cqi_list == true then
			local region_cqi = region_list:item_at(i):cqi();
			new_unique_list:insert(region_cqi);
		else
			local region_key = region_list:item_at(i):name();
			new_unique_list:insert(region_key);
		end
	end
	return new_unique_list;
end