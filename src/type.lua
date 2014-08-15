--- A ROBLOX library that contains functions related to data types
-- @author Mark Otaris
-- @release 1.1.1
-- @copyright 2013 Mark Otaris

-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

local library = {}

--- Changes the value of a property of an object
-- This is used with pcall to avoid creating more function closures
-- @param object The object of which a property's value should be changed
-- @param property The name of the property of the object that should be changed
-- @param value The value to which the value of the property of the object should be changed
local function set(object, property, value)
  object[property] = value
end

--- Returns whether the value is an instance
-- @param value The value
-- @return True if the value is an instance, false otherwise
function library.is_an_instance(value)
	local _, result = pcall(Game.IsA, value, 'Instance')
	return result == true
end

--- Returns whether the value is a ROBLOX library
-- Finds its result by checking whether the value's GetApi method (if it has one) can be dumped (and therefore is a non-Lua function).
-- @param value The value
-- @return True if the value is a ROBLOX library, false otherwise
function library.is_a_library(value)
	if pcall(function() assert(type(value.GetApi) == 'function') end) then -- Check if the value has a GetApi function.
		local success, result = pcall(string.dump, value.GetApi) -- Try to dump the GetApi function.
		return result == "unable to dump given function" -- Return whether the GetApi function could be dumped.
	end
	return false
end

--- Returns whether the value is an enum
-- @param value The value
-- @return True if the value is an enum, false otherwise
function library.is_an_enum(value)
	return pcall(Enum.Material.GetEnumItems, value) == true
end

--- Coerces a value into an enum item, if possible, raises an error otherwise.
-- @param value The value to coerce into an enum item
-- @param enum The enum type into an enum item of which the value should be coerced
function library.coerce_into_enum(value, enum)
	if library.is_an_enum(enum) then
		for _, enum_item in next, enum:GetEnumItems() do
			if value == enum_item or value == enum_item.Name or value == enum_item.Value then return enum_item end
		end
	else
		error("The 'enum' argument must be an enum.", 2)
	end
	error("The value cannot be coerced into a enum item of the specified type.", 2)
end

--- Returns whether the value is coercible into an enum item of a certain type
-- @param value The value
-- @return True if the value is coercible into an enum item of a certain type, false otherwise
function library.is_of_enum_type(value, enum)
	if library.is_an_enum(enum) then
		return pcall(library.coerce_into_enum, value, enum) == true
	else
		error("The 'enum' argument must be an enum.", 2)
	end
end

--- Returns whether the value is a Color3 value
-- @param value The value
-- @return True if the value is a Color3 value, false otherwise
function library.is_a_color3(value)
	return pcall(set, Instance.new('Color3Value'), 'Value', value) == true
end

--- Returns whether the value is a CFrame value
-- @param value The value
-- @return True if the value is a CFrame value, false otherwise
function library.is_a_coordinate_frame(value)
	return pcall(set, Instance.new('CFrameValue'), 'Value', value) == true
end

--- Returns whether the value is a brick color value
-- @param value The value
-- @return True if the value is a brick color value, false otherwise
function library.is_a_brick_color(value)
	return pcall(set, Instance.new('BrickColorValue'), 'Value', value) == true
end

--- Returns whether the value is a ray
-- @param value The value
-- @return True if the value is a ray, false otherwise
function library.is_a_ray(value)
	return pcall(set, Instance.new('RayValue'), 'Value', value) == true
end

--- Returns whether the value is a Vector3 value
-- @param value The value
-- @return True if the value is a Vector3 value, false otherwise
function library.is_a_vector3(value)
	return pcall(set, Instance.new('Vector3Value'), 'Value', value) == true
end

--- Returns whether the value is a Vector2 value
-- @param value The value
-- @return True if the value is a Vector2 value, false otherwise
function library.is_a_vector2(value)
	return pcall(function() return Vector2.new() + value end) == true
end

--- Returns whether the value is a UDim2 value
-- @param value The value
-- @return True if the value is a UDim2 value, false otherwise
function library.is_a_udim2(value)
	return pcall(set, Instance.new('Frame'), 'Position', value) == true
end

--- Returns whether the value is a UDim value
-- @param value The value
-- @return True if the value is a UDim value, false otherwise
function library.is_a_udim(value)
	return pcall(function() return UDim.new() + value end) == true
end

--- Returns whether the value is an Axes value
-- @param value The value
-- @return True if the value is an Axes value, false otherwise
function library.is_a_axes(value)
	return pcall(set, Instance.new('ArcHandles'), 'Axes', value) == true
end

--- Returns whether the value is a Faces value
-- @param value The value
-- @return True if the value is a Faces value, false otherwise
function library.is_a_faces(value)
	return pcall(set, Instance.new('Handles'), 'Faces', value) == true
end

--- Returns whether the value is a RBXScriptSignal
-- @param value The value
-- @return True if the value is a RBXScriptSignal, false otherwise
function library.is_a_signal(value)
	-- Returns whether 'value' is a RBXScriptSignal.
	local success, connection = pcall(function() return Game.AllowedGearTypeChanged.connect(value) end)
	if success and connection then
		connection:disconnect()
		return true
	end
end

--- Returns whether the value is an array
-- @param value The value
-- @return True if the value is an array, false otherwise
function library.is_an_array(value)
	if type(value) == 'table' then
		local num_values = 0

		for index in next, value do
			if not (type(index) == 'number' and index > 0 and index % 1 == 0) then return false end
			num_values = num_values + 1
		end

		return num_values == table.maxn(value)
	end
end

--- Returns whether the value is an integer
-- @param value The value
-- @return True if the value is an integer, false otherwise
function library.is_an_integer(value)
	return type(value) == 'number' and math.ceil(value) == value
end


-- The three following functions demonstrate some interesting properties of strange numbers in Lua.
-- See also http://lua-users.org/wiki/InfAndNanComparisons

-- May vary depending on the implementation
-- print(1/0) --> inf
-- print(math.huge) --> inf
-- print(-math.huge) --> -inf
-- print(-math.sqrt(-1)) --> nan
-- print(math.sqrt(-1)) --> -nan
-- print((-1)^.5) --> -nan
-- print(0/0) --> -nan

--- Returns whether a value is infinite
-- @param value The value
-- @return true if the value is finite, false otherwise
-- @return 1 if the value is +∞, -1 if the value is -∞, 0 if the value is neither
function library.is_infinite(value)
	if value == math.huge then
		return true, 1
	elseif value == -math.huge then
		return true, -1
	else
		return false, 0
	end
end

--- Returns whether the value is NaN (not a number)
-- The value nan, because of IEEE 754, will give false in all comparisons.
-- @param value The value
-- @return true if the value is NaN, false otherwise
function library.is_nan(value)
	return value ~= value
end

--- Returns whether the value is finite
-- @param value The value
-- @return true if the value is finite, false otherwise
function library.is_finite(value)
	return type(value) == 'number' and value < math.huge and value > -math.huge
end

--- Returns a string that represents the type of the value
-- Useful for error messages or anything that is meant to be shown to the user
-- @param value The value
-- @return A string that represents the type of the value
function library.get_type(value)
	if type(value) == 'userdata' then
		if library.is_an_instance(value) then return value.ClassName
		elseif library.is_a_color3(value) then return 'Color3'
		elseif library.is_a_coordinate_frame(value) then return 'CFrame'
		elseif library.is_a_brick_color(value) then return 'BrickColor'
		elseif library.is_a_udim2(value) then return 'UDim2'
		elseif library.is_a_udim(value) then return 'UDim'
		elseif library.is_a_vector3(value) then return 'Vector3'
		elseif library.is_a_vector2(value) then return 'Vector2'
		elseif library.is_a_ray(value) then return 'Ray'
		elseif library.is_an_enum(value) then return 'Enum'
		elseif library.is_a_signal(value) then return 'RBXScriptSignal'
		elseif library.is_a_libraryrary(value) then return 'Rbxlibraryrary'
		elseif library.is_a_axes(value) then return 'Axes'
		elseif library.is_a_faces(value) then return 'Faces'
		end
	else
		return type(value)
	end
end

--- Verifies that the value given to it is valid.
-- @param value The value of the parameter.
-- @param verify A function that returns true when given a value as an argument if the value is valid. Can also be a string that represents a type. Can also be an enum, in which case the value will be considered valid if it is an enum item that belongs to that enum. Can also be a table, in which case all values will be considered as if they were a value given to the parameter, and all corresponding types will be considered as valid.
-- @param nil_is_valid If true, the value nil will be considered as valid.
-- @return True if the value is valid, false otherwise
function library.is_valid(value, verify, nil_is_valid)
	verify = type(verify) == 'table' and verify or {verify}
	for _, verify in next, verify do
		if not (
			type(value) == verify
			or nil_is_valid and value == nil
			or type(verify) == 'function' and verify(value)
			or type(verify) == 'string' and (
				verify == 'Color3' and library.is_a_color3(value)
				or verify == 'CFrame' and library.is_a_coordinate_frame(value)
				or verify == 'BrickColor' and library.is_a_brick_color(value)
				or verify == 'UDim2' and library.is_a_udim2(value)
				or verify == 'UDim' and library.is_a_udim(value)
				or verify == 'Vector3' and library.is_a_vector3(value)
				or verify == 'Vector2' and library.is_a_vector2(value)
				or verify == 'Ray' and library.is_a_ray(value)
				or verify == 'Enum' and library.is_an_enum(value)
				or verify == 'RBXScriptSignal' and library.is_a_signal(value)
				or verify == 'Rbxlibraryrary' and library.is_a_libraryrary(value)
				or verify == 'Axes' and library.is_a_axes(value)
				or verify == 'Faces' and library.is_a_faces(value)
				-- Custom types
				or verify == 'integer' and library.is_an_integer(value)
				or verify == 'array' and library.is_an_array(value)
				or verify == 'finite' and library.is_finite(value)
				or verify == 'infinite' and library.is_infinite(value)
				or verify == 'nan' and library.is_nan(value)

				or library.is_an_instance(value) and value:IsA(verify)
			)
			or library.is_an_enum(verify) and library.is_of_enum_type(value, verify)
		)
		then return false
		end
	end
	return true
end

--- Verifies that the value given to it is valid. If it is not, displays an error message.
-- @param identifier The name to give to the argument in the error message. If a number, the number of the parameter in the parameter list. If a string, the name of the parameter.
-- @param value The value of the parameter.
-- @param verify A function that returns true when given a value as an argument if the value is valid. Can also be a string that represents a type. Can also be an enum, in which case the value will be considered valid if it is an enum item that belongs to that enum. Can also be a table, in which case all values will be considered as if they were a value given to the parameter, and all corresponding types will be considered as valid.
-- @param optional If true, the value nil will be considered as valid.
-- @param level The level in the stack at which the error should be thrown. Is relative the assert_parameter function (1 is the function that called assert_parameter). If not specified, will be 2.
-- @param custom_error_function If present, this function will be used instead of the default error function. It is sent a string message and an integer representing the stack level at which the error occured.
function library.assert_parameter(identifier, value, verify, optional, level, custom_error_function)
	level = level and level + 1 or 3
	local error = custom_error_function or error

	if not library.is_valid(value, verify, optional) then
		if type(identifier) == 'number' and type(verify) == 'string' then
			error(("invalid value for parameter #%d (%s expected, got %s)"):format(identifier, verify, library.get_type(value)), level)
		elseif type(identifier) == 'string' and type(verify) == 'string' then
			error(("invalid value for '%s' (%s expected, got %s)"):format(identifier, verify, library.get_type(value)), level)
		elseif type(identifier) == 'number' and type(verify) == 'function' then
			error(("invalid value for parameter #%d"):format(identifier), level)
		elseif type(identifier) == 'string' and type(verify) == 'function' then
			error(("invalid value for '%s'"):format(identifier), level)
		end
	end
end

return library