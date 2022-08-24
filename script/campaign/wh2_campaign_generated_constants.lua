---- Script for generating . Called on load. 
GeneratedConstants = {

	provinces_to_regions = {}

}

function GeneratedConstants:generate_constants()
	self:map_provinces_to_regions()
end


function GeneratedConstants:map_provinces_to_regions()
	local all_regions = cm:model():world():region_manager():region_list();

	for i = 0, all_regions:num_items() -1 do
		local region = all_regions:item_at(i)
		local province_key = region:province_name()
		local region_key = region:name()

		if not self.provinces_to_regions[province_key] then
			self.provinces_to_regions[province_key] = {}
		end
		self.provinces_to_regions[province_key][region_key] = true
	end

end


function GeneratedConstants:get_other_regions_in_province(starting_region_key)
	local region_list = {}
	for province, regions in pairs(GeneratedConstants.provinces_to_regions) do
		if regions[starting_region_key] then
			for other_region_key, v in pairs(regions) do
				if other_region_key ~= starting_region_key then
					table.insert(region_list, other_region_key)
				end
			end
		end
	end
	return region_list
end


