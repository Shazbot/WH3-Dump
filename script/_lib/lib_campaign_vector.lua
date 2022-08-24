



----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--
--	CAMPAIGN VECTOR
--	script implementation of vectors for campaign (positions in battle), so that campaign
--	scripts can use convex areas and other positional library support that was originally
--	made for battle
--
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------


----------------------------------------------------------------------------
--	Shorthand method of creating campaign vectors
----------------------------------------------------------------------------

---------------------------------------------------------------
--
--	Shorthand way of creating vectors
--	This is here rather than in lib_convex_area.lua as
--	it's battle-specific
--
---------------------------------------------------------------

function v_dis(obj)
	if not (is_character(obj) or is_settlement(obj)) then
		script_error("ERROR: v_dis() called but supplied object [" .. tostring(obj) .. "] is not a character or settlement");
		return false;
	end;
	
	return campaign_vector:new(obj:display_position_x(), 0, obj:display_position_y());
end;


function v_log(obj)
	if not (is_character(obj) or is_settlement(obj)) then
		script_error("ERROR: v_log() called but supplied object [" .. tostring(obj) .. "] is not a character or settlement");
		return false;
	end;
	
	return campaign_vector:new(obj:logical_position_x(), 0, obj:logical_position_y());
end;

	
function v(x, y, z)
	if (not is_number(x)) or (not is_number(y)) then
		script_error("ERROR: v() called but didn't get at least two numeric parameters: " .. tostring(x) .. " and " .. tostring(y));
		return false;
	end;

	if is_number(z) then
		-- we are creating a 3D vector
		return campaign_vector:new(x, y, z);
	else
		-- we are creating a 2D vector
		return campaign_vector:new(x, 0, y);
	end;
end;




----------------------------------------------------------------------------
--	Definition
----------------------------------------------------------------------------

campaign_vector = {
	x = 0,
	y = 0,
	z = 0
};


set_class_custom_type(campaign_vector, TYPE_CAMPAIGN_VECTOR);
set_class_tostring(
	campaign_vector, 
	function(obj)
		return TYPE_CAMPAIGN_VECTOR .. "_[" .. obj.x .. "," .. obj.y .. "," .. obj.z .. "]";
	end
);




----------------------------------------------------------------------------
--	Declaration
----------------------------------------------------------------------------

function campaign_vector:new(x, y, z)
	if x then
		if not is_number(x) then
			script_error("ERROR: campaign_vector:new() called but supplied co-ordinate x [" .. tostring(x) .. "] is not a number or nil");
			return false;
		end;
	
		if not is_number(y) then
			script_error("ERROR: campaign_vector:new() called but supplied co-ordinate y [" .. tostring(y) .. "] is not a number or nil");
			return false;
		end;
	
		if not is_number(z) then
			script_error("ERROR: campaign_vector:new() called but supplied co-ordinate z [" .. tostring(z) .. "] is not a number or nil");
			return false;
		end;
	end;
			
	local vec = {};
	
	vec.x = x;
	vec.y = y;
	vec.z = z;

	set_object_class(vec, self);
	
	return vec;
end;


function campaign_vector:get_x()
	return self.x;
end;


function campaign_vector:get_y()
	return self.y;
end;


function campaign_vector:get_z()
	return self.z;
end;


function campaign_vector:set_x(value)
	if not is_number(value) then
		script_error("ERROR: campaign_vector:set_x() called but supplied value [" .. tostring(value) .. "] is not a number");
		return false;
	end;
	self.x = value;
end;


function campaign_vector:set_y(value)
	if not is_number(value) then
		script_error("ERROR: campaign_vector:set_y() called but supplied value [" .. tostring(value) .. "] is not a number");
		return false;
	end;
	self.y = value;
end;


function campaign_vector:set_z(value)
	if not is_number(value) then
		script_error("ERROR: campaign_vector:set_z() called but supplied value [" .. tostring(value) .. "] is not a number");
		return false;
	end;
	self.z = value;
end;


function campaign_vector:set(a, b, c)
	if is_vector(a) then
		-- we are setting the position of this vector to the value of another
		self.x = a.x;
		self.y = a.y;
		self.z = a.z;
		
		return;
	end;
	
	-- we are setting the position of this vector using numbers
	if not is_number(a) then
		script_error("ERROR: campaign_vector:set() called but supplied x value [" .. tostring(a) .. "] is not a number");
		return false;
	end;
	
	if not is_number(b) then
		script_error("ERROR: campaign_vector:set() called but supplied y value [" .. tostring(b) .. "] is not a number");
		return false;
	end;
	
	if not is_number(c) then
		script_error("ERROR: campaign_vector:set() called but supplied z value [" .. tostring(c) .. "] is not a number");
		return false;
	end;
	
	self.x = a;
	self.y = b;
	self.z = c;
end;


function campaign_vector:distance(target)
	if not is_vector(target) then
		script_error("ERROR: campaign_vector:distance() called but supplied target [" .. tostring(vector) .. "] is not a vector");
		return false;
	end;
	
	return ((self.x - target.x) ^ 2 + (self.y - target.y) ^ 2 + (self.z - target.z) ^ 2) ^ 0.5;
end;


function campaign_vector:distance_xz(target)
	if not is_vector(target) then
		script_error("ERROR: campaign_vector:distance_xz() called but supplied target [" .. tostring(vector) .. "] is not a vector");
		return false;
	end;
	
	return distance_squared(self.x, self.z, target.x, target.z) ^ 0.5;
end;


function campaign_vector:vector_to_screen_position()
	script_error("ERROR: vector_to_screen_position() is not supported by campaign vectors");
end;


function campaign_vector:length()
	return (self.x ^ 2 + self.y ^ 2 + self.z ^ 2) ^ 0.5;
end;


function campaign_vector:length_xz()
	return (self.x ^ 2 + self.z ^ 2) ^ 0.5;
end;
