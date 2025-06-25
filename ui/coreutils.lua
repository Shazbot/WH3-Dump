--[[
This file is intended to provide a core set of functions useable in any lua environment
As such it should only use functions provided by the core lua libraries and not any provided
by our own scripted environments (i.e. no Component, UIComponent etc)
--]]

module (..., package.seeall)

function TruncToInt( number )
	return number - ( number % 1 )
end

function RoundToInt( number )
	number = number + .5
	return number - ( number % 1 )
end

function RupToInt( number )

	if ( number % 1 ) >  0 then 
		return number - ( number % 1 ) + 1
	else
		return number
	end
end

function Clamp( number, min, max )
	if number > max then
		return max
	elseif number < min then
		return min
	end
	return number
end

function Max(a, ...)
	local max = a
	for i,v in ipairs{...} do
		if v > max then
			max = v
		end
	end
	
	return max
end

function Min(a, ...)
	local min = a
	for i,v in ipairs{...} do
		if v < min then
			min = v
		end
	end
	
	return min
end

function outputbitfield(b)

	local s = ""
	for i = 0, 7 do
		if bit.band(bit.lshift(1, 7 - i), b) > 0 then
			s = s.."1"
		else
			s = s.."0"
		end
	end

	return s

end


function Require(pack)
	-- Convert module name to all upper case to avoid the situation where 'require "huds"' and 'require "Huds"' results in two seperate tables	
	pack = string.lower(pack)
	
	if package.loaded[pack] == nil then
		require(pack)
	end
--	local t = {}
--	local mt = { __index = function(t,k) return package.loaded[pack][k] end }
--	setmetatable(t, mt)
	
	return package.loaded[pack]
end

function UnRequire(pack)
	pack = string.lower(pack)

	package.loaded[pack] = nil
	_G[pack] = nil
end

function UnRequireAll()
	for k,v in ipairs(package.loaded) do
		package.loaded[k] = nil
		_G[k] = nil
	end
end

--[[
Loads the specified file as a namespace.  I.e. all functions and variables are loaded into a table.  This is similar to "require" only subsequent calls
will create new tables so no data is shared
--]]
function NamespaceFile(pack)
	
	local f  = nil

	-- Look through the same path that "package" uses for the file specified and try to load it
	for c in string.gmatch(package.path, "[^;]+") do
		local fname = string.gsub(c, "?", pack)
		f = loadfile(fname)
		if f ~= nil then
			break
		end
	end
		
	if f == nil then
		error("Unable to create namespace from file "..pack)
	end

	-- Create a new table to be the environment of the function that loadfile returns
	t = {}

	-- Set it's __index metamethod so that any references to global variables will use the environment of the object using this file
	setmetatable(t, { __index = getfenv(1) })

	-- Set the function environment of the loaded file to be the table we create so that all globals are put into the table, thus creating our "namespace"
	setfenv(f, t)
	
	-- Call the function so that the script is actually run
	f()
	
	--  Return our new namespaced table
	return t
end

function PrintTable(t, printf, prefix)
	if t ~= nil then
		if prefix == nil then
			prefix = ""
		end
		
		for k, v in pairs(t) do
			if type(v) == "table" then
				printf(prefix..tostring(k).."...")
				PrintTable(v, printf, prefix.."..")	
			else
				printf(prefix.." "..k..", "..tostring(v))
			end
		end
	end
end

function CopyTable(src)

	local dest = {}

	if src ~= nil then
		for i,v in ipairs(src) do
			if type(v) == "table" then
				dest[i] = CopyTable(v)
			else
				dest[i] = v
			end
		end
		for k,v in pairs(src) do
			if type(v) == "table" then
				dest[k] = CopyTable(v)
			else
				dest[k] = v
			end
		end
	end
	
	setmetatable(dest, getmetatable(src))
	
	return dest
end

function CopyIntoTable(src, dest, ignore_field)
	if src ~= nil then
		for i,v in ipairs(src) do
			if type(ignore_field) == "number" and i == ignore_field then
			else
				if type(v) == "table" then
					if dest[i] == nil then
						dest[i] = {}
					end
					CopyIntoTable(v, dest[i], ignore_field)
				else
					dest[i] = v
				end
			end
		end
		for k,v in pairs(src) do
			if type(ignore_field) == "string" and k == ignore_field then
			else
				if type(v) == "table" then
					if dest[k] == nil then
						dest[k] = {}
					end
					CopyIntoTable(v, dest[k], ignore_field)
				else
					dest[k] = v
				end
			end
		end
	end
	
end

function CompareByValue( value1, value2 )

	if ( type( value1 ) == "table" ) then
		if ( type( value2 ) ~= "table" ) then
			return false
		end
		
		-- Handling recursion
		if ( value1.CoreUtils_CompareByValue_TemporaryMarker ~= nil or value2.CoreUtils_CompareByValue_TemporaryMarker ~= nil ) then
			return value1.CoreUtils_CompareByValue_TemporaryMarker == value2 and value2.CoreUtils_CompareByValue_TemporaryMarker == value1
		end
		
		value1.CoreUtils_CompareByValue_TemporaryMarker = value2
		value2.CoreUtils_CompareByValue_TemporaryMarker = value1

		local equals = true
				
		for k,v in pairs(value1) do
			if ( CompareByValue( v, value2[k] ) ~= true ) then
				equals = false
				break
			end
		end
		if ( equals == true ) then
			for k,v in pairs(value2) do
				if ( value1[k] == nil ) then
					equals = false
					break
				end
			end
		end

		value1.CoreUtils_CompareByValue_TemporaryMarker = nil
		value2.CoreUtils_CompareByValue_TemporaryMarker = nil
		
		return equals
	else
		return value1 == value2
	end
	
end

function PickFGColour(rgb)
	if (rgb.R + rgb.G + rgb.B) / 3 > 140 then
		return { ["r"] = 0, ["g"] = 0, ["b"] = 0, ["a"] = 255 }
	else
		return { ["r"] = 255, ["g"] = 255, ["b"] = 255, ["a"] = 255  }
	end
end

function OffsetFrom(a, b)
	local a_x, a_y = a:Position()
	local b_x, b_y = b:Position()
	
	return b_x - a_x, b_y - a_y
end


-- Table IO Functions ripped mercelesly from the lua wiki (http://lua-users.org/wiki/SaveTableToFile)
local function exportstring( s )
  s = string.format( "%q",s )
  -- to replace
  s = string.gsub( s,"\\\n","\\n" )
  s = string.gsub( s,"\r","\\r" )
  s = string.gsub( s,string.char(26),"\"..string.char(26)..\"" )
  return s
end
  
-- The Save Function
function SaveTable(  tbl, filename )
   local charS,charE = "   ","\n"
   local file,err
   -- create a pseudo file that writes to a string and return the string
   if not filename then
      file =  { write = function( self,newstr ) self.str = self.str..newstr end, str = "" }
      charS,charE = "",""
   -- write table to tmpfile
   elseif filename == true or filename == 1 then
      charS,charE,file = "","",io.tmpfile()
   -- write table to file
   -- use io.open here rather than io.output, since in windows when clicking on a file opened with io.output will create an error
   else
      file,err = io.open( filename, "w" )
      if err then return _,err end
   end
   -- initiate variables for save procedure
   local tables,lookup = { tbl },{ [tbl] = 1 }
   file:write( "return {"..charE )
   for idx,t in ipairs( tables ) do
      if filename and filename ~= true and filename ~= 1 then
         file:write( "-- Table: {"..idx.."}"..charE )
      end
      file:write( "{"..charE )
      local thandled = {}
      for i,v in ipairs( t ) do
         thandled[i] = true
         -- escape functions and userdata
         if type( v ) ~= "userdata" then
            -- only handle value
            if type( v ) == "table" then
               if not lookup[v] then
                  table.insert( tables, v )
                  lookup[v] = #tables
               end
               file:write( charS.."{"..lookup[v].."},"..charE )
            elseif type( v ) == "function" then
               file:write( charS.."loadstring("..exportstring(string.dump( v )).."),"..charE )
            else
               local value =  ( type( v ) == "string" and exportstring( v ) ) or tostring( v )
               file:write(  charS..value..","..charE )
            end
         end
      end
      for i,v in pairs( t ) do
         -- escape functions and userdata
         if (not thandled[i]) and type( v ) ~= "userdata" then
            -- handle index
            if type( i ) == "table" then
               if not lookup[i] then
                  table.insert( tables,i )
                  lookup[i] = #tables
               end
               file:write( charS.."[{"..lookup[i].."}]=" )
            else
               local index = ( type( i ) == "string" and "["..exportstring( i ).."]" ) or string.format( "[%d]",i )
               file:write( charS..index.."=" )
            end
            -- handle value
            if type( v ) == "table" then
               if not lookup[v] then
                  table.insert( tables,v )
                  lookup[v] = #tables
               end
               file:write( "{"..lookup[v].."},"..charE )
            elseif type( v ) == "function" then
               file:write( "loadstring("..exportstring(string.dump( v )).."),"..charE )
            else
               local value =  ( type( v ) == "string" and exportstring( v ) ) or tostring( v )
               file:write( value..","..charE )
            end
         end
      end
      file:write( "},"..charE )
   end
   file:write( "}" )
   -- Return Values
   -- return stringtable from string
   if not filename then
      -- set marker for stringtable
      return file.str.."--|"
   -- return stringttable from file
   elseif filename == true or filename == 1 then
      file:seek ( "set" )
      -- no need to close file, it gets closed and removed automatically
      -- set marker for stringtable
      return file:read( "*a" ).."--|"
   -- close file and return 1
   else
      file:close()
      return 1
   end
end

--// The Load Function
function LoadTable( sfile )
   -- catch marker for stringtable
   if string.sub( sfile,-3,-1 ) == "--|" then
      tables,err = loadstring( sfile )
   else
      tables,err = loadfile( sfile )
   end
   if err then return _,err
   end
   tables = tables()
   for idx = 1,#tables do
      local tolinkv,tolinki = {},{}
      for i,v in pairs( tables[idx] ) do
         if type( v ) == "table" and tables[v[1]] then
            table.insert( tolinkv,{ i,tables[v[1]] } )
         end
         if type( i ) == "table" and tables[i[1]] then
            table.insert( tolinki,{ i,tables[i[1]] } )
         end
      end
      -- link values, first due to possible changes of indices
      for _,v in ipairs( tolinkv ) do
         tables[idx][v[1]] = v[2]
      end
      -- link indices
      for _,v in ipairs( tolinki ) do
         tables[idx][v[2]],tables[idx][v[1]] =  tables[idx][v[1]],nil
      end
   end
   return tables[1]
end

function TimeString(time)
	local minutes = TruncToInt(time/60)
	local seconds = TruncToInt(time%60)
	return string.format("%02d:%02d", minutes, seconds)
end

table.load = LoadTable
table.save = SaveTable