weighted_list = {};
weighted_list.__index = weighted_list;

function weighted_list:__tostring()
	return TYPE_WEIGHTED_LIST;
end

function weighted_list:new(o)
	o = o or {};
	setmetatable(o, self);
	o.items = {};
	o.max_weight = 0;
	return o;
end

function weighted_list:add_item(item, weight)
	if item == nil then
		script_error("Weighted List: Tried to add invalid item to weighted list ("..tostring(item)..")")
	end
	if weight == nil or is_number(weight) == false then
		script_error("Weighted List: Tried to add item to weighted list with invalid weight ("..tostring(weight)..")")
	end

	local list_entry = {};
	list_entry.item = item;
	list_entry.weight = weight;
	table.insert(self.items, list_entry);
	self.max_weight = self.max_weight + weight;
end

function weighted_list:remove_item(i)
	self.max_weight = self.max_weight - self.items[i].weight;
	table.remove(self.items, i);
end

function weighted_list:weighted_select(remove_selected_item)
	if self.max_weight <= 0 then
		return nil, nil;
	end

	remove_selected_item = remove_selected_item or false;
	local rand = cm:random_number(self.max_weight);
	local selected_item = nil;
	local selected_index = nil;

	for i = 1, self:num_items() do
		rand = rand - self.items[i].weight;

		if rand <= 0 then
			selected_item = self.items[i].item;
			selected_index = i;
			break;
		end
	end

	if remove_selected_item == true then
		self.max_weight = self.max_weight - self.items[selected_index].weight;
		table.remove(self.items, selected_index);
	end
	return selected_item, selected_index;
end

function weighted_list:random_select()
	if self:is_empty() then
		return nil, nil
	end
	
	local rand = cm:random_number(self:num_items());
	return self.items[rand].item, rand;
end

function weighted_list:num_items()
	return #self.items
end

function weighted_list:is_empty()
	return self:num_items() == 0
end