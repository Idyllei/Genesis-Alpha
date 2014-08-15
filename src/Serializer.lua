Serializer = {}
Serializer.NAN = math.abs(0 / 0)
 
function Serializer.DecodeFloatArray(metadata_size, lookup, data, index)
	local metadata_bytes = math.ceil(metadata_size * 0.25)
	local metadata = {string.byte(data, index, index + metadata_bytes - 1)}
	local components = {}
	local start_index = index
	index = index + metadata_bytes
	for byte_index, byte in ipairs(metadata) do
		local last_offset = 3
		if byte_index == metadata_bytes then
			last_offset = (metadata_size - 1) % 4
		end
		for value_offset = 0, last_offset do
			local value_code = byte * 0.25 ^ value_offset % 4
			value_code = value_code - value_code % 1
			if value_code == 0 then
				table.insert(components, Serializer.DecodeFloat32(string.byte(data, index, index + 3)))
				index = index + 4
			else
				table.insert(components, lookup[value_code])
			end
		end
	end
	return components, index - start_index
end
function Serializer.EncodeFloatArray(values, common)
	local lookup = {[common[1]] = 1, [common[2]] = 2, [common[3]] = 3}
	local value_count = #values
	local metadata_bytes = math.ceil(value_count * 0.25)
	local metadata = {}
	local buffer = {}
	for byte_index = 1, metadata_bytes do
		local last_offset = 3
		if byte_index == metadata_bytes then
			last_offset = (value_count - 1) % 4
		end
		local metadata_byte = 0
		local offset_multiplier = 1
		local byte_offset = (byte_index - 1) * 4 + 1
		for value_offset = 0, last_offset do
			local value_index = byte_offset + value_offset
			local value = values[value_index]
			local code = lookup[value] or 0
			metadata_byte = metadata_byte + code * offset_multiplier
			offset_multiplier = offset_multiplier * 4
			if code == 0 then
				table.insert(buffer, Serializer.EncodeFloat32(value))
			end
		end
		metadata[byte_index] = string.char(metadata_byte)
	end
	return table.concat(metadata) .. table.concat(buffer)
end
 
function Serializer.DecodeBrickColor(b0, b1)
	return BrickColor.new(Serializer.DecodeUnsignedInt16(b0, b1))
end
function Serializer.DecodeCFrame(data, index)
	local components, size = Serializer.DecodeFloatArray(12, {0, 1, -1}, data, index)
	return CFrame.new(unpack(components)), size
end
function Serializer.DecodeColor3(data, index)
	local components, size = Serializer.DecodeFloatArray(3, {0, 0.5, 1}, data, index)
	return Color3.new(unpack(components)), size
end
function Serializer.DecodeFaces(b0)
	local faces = {}
	if b0 >= 32 then
		table.insert(faces, Enum.NormalId.Left)
		b0 = b0 - 32
	end
	if b0 >= 16 then
		table.insert(faces, Enum.NormalId.Right)
		b0 = b0 - 16
	end
	if b0 >= 8 then
		table.insert(faces, Enum.NormalId.Front)
		b0 = b0 - 8
	end
	if b0 >= 4 then
		table.insert(faces, Enum.NormalId.Back)
		b0 = b0 - 4
	end
	if b0 >= 2 then
		table.insert(faces, Enum.NormalId.Bottom)
		b0 = b0 - 2
	end
	if b0 >= 1 then
		table.insert(faces, Enum.NormalId.Top)
	end
	return Faces.new(unpack(faces))
end
function Serializer.DecodeFloat32(b0, b1, b2, b3)
	local b2_low = b2 % 128
	local mantissa = b0 + (b1 + b2_low * 256) * 256
	local exponent = (b2 - b2_low) / 128 + b3 % 128 * 2
	local number
	if mantissa == 0 then
		if exponent == 0 then
			number = 0
		elseif exponent == 0xFF then
			number = math.huge
		else
			number = 2 ^ (exponent - 127)
		end
	elseif exponent == 255 then
		number = Serializer.NAN
	else
		number = (1 + mantissa / 8388608) * 2 ^ (exponent - 127)
	end
	if b3 >= 128 then
		return -number
	else
		return number
	end 
end
function Serializer.DecodeFloat64(b0, b1, b2, b3, b4, b5, b6, b7)
	local b6_low = b6 % 0x10
	local mantissa = b0 + (b1 + (b2 + (b3 + (b4 + (b5 + b6_low * 256) * 256) * 256) * 256) * 256) * 256
	local exponent = (b6 - b6_low) / 16 + b7 % 128 * 16
	local number
	if mantissa == 0 then
		if exponent == 0 then
			number = 0
		elseif exponent == 0x7FF then
			number = math.huge
		else
			number = 2 ^ (exponent - 1074)
		end
	elseif exponent == 0x7FF then
		number = Serializer.NAN
	else
		number = (1 + mantissa / 4503599627370496) * 2 ^ (exponent - 1074)
	end
	if b7 >= 128 then
		return -number
	else
		return number
	end 
end
function Serializer.DecodeInt8(b0)
	return b0 - 128
end
function Serializer.DecodeInt16(b0, b1)
	return b0 + b1 * 256 - 32768
end
function Serializer.DecodeInt32(b0, b1, b2, b3)
	return b0 + (b1 + (b2 + b3 * 256) * 256) * 256 - 2147483648
end
function Serializer.DecodeNil()
	return nil
end
function Serializer.DecodeRay(
		b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11,
		b12, b13, b14, b15, b16, b17, b18, b19, b20, b21, b22, b23)
	return Ray.new(
		Serializer.DecodeVector3(b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11),
		Serializer.DecodeVector3(b12, b13, b14, b15, b16, b17, b18, b19, b20, b21, b22, b23)
	)
end
function Serializer.DecodeRegion3
	return Region3.new (Serializer.DecodeVector3b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11), (Serializer.DecodeVector3b12, b13, b14, b15, b16, b17, b18, b19, b20, b21, b22, b23)
end
function Serializer.DecodeString(data, index)
	local size = Serializer.DecodeUnsignedInt32(string.byte(data, index, index + 3))
	return string.sub(data, index + 4, index + size + 3), size + 4
end
function Serializer.DecodeUDim(b0, b1, b2, b3, b4, b5)
	return UDim.new(
		Serializer.DecodeFloat32(b0, b1, b2, b3),
		Serializer.DecodeInt16(b4, b5)
	)
end
function Serializer.DecodeUDim2(b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11)
	return 
end
function Serializer.DecodeUnsignedInt8(b0)
	return b0
end
function Serializer.DecodeUnsignedInt16(b0, b1)
	return b0 + b1 * 256
end
function Serializer.DecodeUnsignedInt32(b0, b1, b2, b3)
	return b0 + (b1 + (b2 + b3 * 256) * 256) * 256
end
function Serializer.DecodeVector2(b0, b1, b2, b3, b4, b5, b6, b7)
	return Vector2.new (Serializer.DecodeFloat32 b0, b1, b2, b3), (Serializer.DecodeFloat32 b4, b5, b6, b7)
end
function Serializer.DecodeVector3(b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11)
	return Vector3.new (Serializer.DecodeFloat32 b0, b1, b2, b3), (Serializer.DecodeFloat32 b4, b5, b6, b7), (Serializer.DecodeFloat32 b8, b9, b10, b11)
end
 
function Serializer.EncodeBrickColor(brick_color)
	return Serializer.EncodeUnsignedInt16(brick_color.Number)
end
function Serializer.EncodeCFrame(cframe)
	return Serializer.EncodeFloatArray({cframe:components()}, {0, 1, -1})
end
function Serializer.EncodeColor3(color3)
	return Serializer.EncodeFloatArray({color3.r, color3.g, color3.b}, {0, 0.5, 1})
end
function Serializer.EncodeFaces(faces)
	local b0 = 0
	if faces.Top then
		b0 = b0 + 1
	end
	if faces.Bottom then
		b0 = b0 + 2
	end
	if faces.Back then
		b0 = b0 + 4
	end
	if faces.Front then
		b0 = b0 + 8
	end
	if faces.Right then
		b0 = b0 + 16
	end
	if faces.Left then
		b0 = b0 + 32
	end
	return string.char(b0)
end
function Serializer.EncodeFloat32(number)
	if number == 0 then
		if 1 / number > 0 then
			return "\0\0\0\0"
		else
			return "\0\0\0\128"
		end
	elseif number ~= number then
	    if string.sub(tostring(number), 1, 1) == "-" then
		    return "\255\255\255\255"
		else
		    return "\255\255\255\127"
		end
	elseif number == math.huge then
		return "\0\0\128\127"
	elseif number == -math.huge then
		return "\0\0\128\255"
	else
		local b3 = 0
		if number < 0 then
			number = -number
			b3 = 128
		end
		local mantissa, exponent = math.frexp(number)
		exponent = exponent + 126
		if exponent < 0 then
			return "\0\0\0" .. string.char(b3)
		elseif exponent >= 255 then
			return "\0\0\128" .. string.char(b3 + 0x7F)
		else
			local fraction = mantissa * 16777216 - 8388608 + 0.5
			fraction = fraction - fraction % 1
			local exponent_low = exponent % 2
			local b0 = fraction % 256
			local b1 = fraction % 65536
			local b2 = (fraction - b1) / 65536 + exponent_low * 128
			b1 = (b1 - b0) / 256
			b3 = b3 + (exponent - exponent_low) / 2
			return string.char(b0, b1, b2, b3)
		end
	end
end
function Serializer.EncodeFloat64(number)
	if number == 0 then
		if 1 / number > 0 then
			return "\0\0\0\0\0\0\0\0"
		else
			return "\0\0\0\0\0\0\0\128"
		end
	elseif number ~= number then
	    if string.sub(tostring(number), 1, 1) == "-" then
		    return "\255\255\255\255\255\255\255\255"
		else
		    return "\255\255\255\255\255\255\255\127"
		end
	elseif number == math.huge then
		return "\0\0\0\0\0\0\240\127"
	elseif number == -math.huge then
		return "\0\0\0\0\0\0\240\255"
	else
		local b7 = 0
		if number < 0 then
			number = -number
			b7 = 128
		end
		local mantissa, exponent = math.frexp(number)
		local fraction = mantissa * 9007199254740992 - 4503599627370496
		exponent = exponent + 1073
		local exponent_low = exponent % 16
		local b0 = fraction % 256
		local b1 = fraction % 65536
		local b2 = fraction % 16777216
		local b3 = fraction % 4294967296
		local b4 = fraction % 1099511627776
		local b5 = fraction % 281474976710656
		local b6 = (fraction - b5) / 281474976710656 + exponent_low * 16
		b5 = (b5 - b4) / 1099511627776
		b4 = (b4 - b3) / 4294967296
		b3 = (b3 - b2) / 16777216
		b2 = (b2 - b1) / 65536
		b1 = (b1 - b0) / 256
		b7 = b7 + (exponent - exponent_low) / 16
		return string.char(b0, b1, b2, b3, b4, b5, b6, b7)
	end
end
function Serializer.EncodeInt8(number)
	return string.char((number - number % 1 + 128) % 256)
end
function Serializer.EncodeInt16(number)
	number = ((number - number % 1) + 32768) % 65536
	local b0 = number % 256
	local b1 = (number - b0) / 256
	return string.char(b0, b1)
end
function Serializer.EncodeInt32(number)
	number = ((number - number % 1) + 2147483648) % 4294967296
	local b0 = number % 256
	local b1 = number % 65536
	local b2 = number % 16777216
	local b3 = (number - b2) / 16777216
	b2 = (b2 - b1) / 65536
	b1 = (b1 - b0) / 256
	return string.char(b0, b1, b2, b3)
end
function Serializer.EncodeNil()
	return ""
end
function Serializer.EncodeRay(ray)
	return Serializer.EncodeVector3(ray.Origin) .. Serializer.EncodeVector3(ray.Direction)
end
function Serializer.EncodeRegion3(region3)
	local size = region3.Size
	local min_position = region3.CFrame.p - (size * 0.5)
	return Serializer.EncodeVector3(min_position) .. Serializer.EncodeVector3(min_position + size)
end
function Serializer.EncodeString(value)
	return Serializer.EncodeUnsignedInt32(#value) .. value
end
function Serializer.EncodeUDim(udim)
	return Serializer.EncodeFloat32(udim.Scale) .. Serializer.EncodeInt16(udim.Offset)
end
function Serializer.EncodeUDim2(udim2)
	return Serializer.EncodeUDim(udim2.X) .. Serializer.EncodeUDim(udim2.Y)
end
function Serializer.EncodeUnsignedInt8(number)
	return string.char((number - number % 1) % 256)
end
function Serializer.EncodeUnsignedInt16(number)
	number = (number - number % 1) % 65536
	local b0 = number % 256
	local b1 = (number - b0) / 256
	return string.char(b0, b1)
end
function Serializer.EncodeUnsignedInt32(number)
	number = (number - number % 1) % 4294967296
	local b0 = number % 256
	local b1 = number % 65536
	local b2 = number % 16777216
	local b3 = (number - b2) / 16777216
	b2 = (b2 - b1) / 65536
	b1 = (b1 - b0) / 256
	return string.char(b0, b1, b2, b3)
end
function Serializer.EncodeVector2(vector2)
	return Serializer.EncodeFloat32(vector2.X) .. Serializer.EncodeFloat32(vector2.Y)
end
function Serializer.EncodeVector3(vector3)
	return Serializer.EncodeFloat32(vector3.X) .. Serializer.EncodeFloat32(vector3.Y) .. Serializer.EncodeFloat32(vector3.Z)
end
 
Serializer.Format = {
	Int16 = 1,
	Int32 = 2,
	UnsignedInt16 = 3,
	UnsignedInt32 = 4,
	Float32 = 5,
	Float64 = 6,
	String = 7,
	Vector3 = 8,
	CFrame = 9,
	BrickColor = 10,
	Color3 = 11,
	Vector2 = 12,
	Ray = 13,
	UDim = 14,
	UDim2 = 15,
	Faces = 16,
	Int8 = 17,
	UnsignedInt8 = 18,
	Region3 = 19,
	Nil = 20
}
Serializer.Decoders = {
	Serializer.DecodeInt16,
	Serializer.DecodeInt32,
	Serializer.DecodeUnsignedInt16,
	Serializer.DecodeUnsignedInt32,
	Serializer.DecodeFloat32,
	Serializer.DecodeFloat64,
	Serializer.DecodeString,
	Serializer.DecodeVector3,
	Serializer.DecodeCFrame,
	Serializer.DecodeBrickColor,
	Serializer.DecodeColor3,
	Serializer.DecodeVector2,
	Serializer.DecodeRay,
	Serializer.DecodeUDim,
	Serializer.DecodeUDim2,
	Serializer.DecodeFaces,
	Serializer.DecodeInt8,
	Serializer.DecodeUnsignedInt8,
	Serializer.DecodeRegion3,
	Serializer.DecodeNil
}
Serializer.Encoders = {
	Serializer.EncodeInt16,
	Serializer.EncodeInt32,
	Serializer.EncodeUnsignedInt16,
	Serializer.EncodeUnsignedInt32,
	Serializer.EncodeFloat32,
	Serializer.EncodeFloat64,
	Serializer.EncodeString,
	Serializer.EncodeVector3,
	Serializer.EncodeCFrame,
	Serializer.EncodeBrickColor,
	Serializer.EncodeColor3,
	Serializer.EncodeVector2,
	Serializer.EncodeRay,
	Serializer.EncodeUDim,
	Serializer.EncodeUDim2,
	Serializer.EncodeFaces,
	Serializer.EncodeInt8,
	Serializer.EncodeUnsignedInt8,
	Serializer.EncodeRegion3,
	Serializer.EncodeNil
}
Serializer.Sizes = {2, 4, 2, 4, 4, 8, -1, 12, -1, 2, -1, 8, 24, 6, 12, 1, 1, 1, 24, 0}
 
function Serializer.DecodeStruct(data, structure)
	local values = {}
	local index = 1
	local length = #data
	local value_index = 1
	while index < length do
		local format
		if structure then
			format = structure[value_index]
		else
			format = string.byte(data, index)
			index = index + 1
		end
		local value
		local size = Serializer.Sizes[format]
		if not size then
			print("Serializer.DecodeStruct: bad format")
			break
		end
		local decoder = Serializer.Decoders[format]
		if size < 0 then
			value, size = decoder(data, index)
		else
			value = decoder(string.byte(data, index, index + size - 1))
		end
		index = index + size
		values[value_index] = value
		value_index = value_index + 1
	end
	return values
end
function Serializer.EncodeStruct(structure, values, dynamic)
	local buffer = {}
	for index, format in ipairs(structure) do
		local value = values[index]
		local encoded = Serializer.Encoders[format](value)
		if dynamic then
			encoded = string.char(format) .. encoded
		end
		buffer[index] = encoded
	end
	return table.concat(buffer)
end
 
Serializer.DEFAULT_CHUNK_SIZE = 32
function Serializer.ByteBufferToString(buffer)
    local size = #buffer
    local string_buffer = {}
    local string_buffer_index = 0
    for index = 1, size, 1024 do
        string_buffer_index = string_buffer_index + 1
        string_buffer[string_buffer_index] = string.char(unpack(buffer, index, math.min(index + 1023, size)))
    end
    return table.concat(string_buffer)
end
function Serializer.RemoveNullCharacters(data, chunk_size)
    if not chunk_size then
        chunk_size = Serializer.DEFAULT_CHUNK_SIZE
    end
    local size = #data
    if size == 0 then
        return ""
    else
        local buffer = {}
        local buffer_index = 0
        local bytes = {}
        for index = 1, size do
            bytes[index] = string.byte(data, index)
        end
        for chunk_index = 1, math.ceil(size / chunk_size) do
            local chunk_offset = (chunk_index - 1) * chunk_size
            local chunk_remainder = math.min(chunk_size, size - chunk_offset)
            local chunk_start = chunk_offset + 1
            buffer_index = buffer_index + 1
            local contains_null = false
            local removing_zeros = true
            for index = chunk_offset + chunk_remainder, chunk_start, -1 do
                if bytes[index] == 0 then
                    if removing_zeros then
                        chunk_remainder = chunk_remainder - 1
                    else
                        contains_null = true
                    end
                else
                    removing_zeros = false
                end
            end
            if contains_null then
                local chunk_bytes = 0
                while chunk_remainder > 0 do
                    local remainder = 0
                    local chunk_end = chunk_offset + chunk_remainder
                    for index = chunk_end, chunk_start, -1 do
                        local numerator = remainder * 256 + bytes[index]
                        remainder = numerator % 255
                        bytes[index] = (numerator - remainder) * 0.00392156862745098
                    end
                    chunk_bytes = chunk_bytes + 1
                    buffer[buffer_index + chunk_bytes] = remainder + 1
                    for index = chunk_end, chunk_start, -1 do
                        if bytes[index] == 0 then
                            chunk_remainder = chunk_remainder - 1
                        else
                            break
                        end
                    end
                end
                buffer[buffer_index] = chunk_bytes + 1
                buffer_index = buffer_index + chunk_bytes
            else
                if chunk_remainder == chunk_size then
                    buffer[buffer_index] = 254
                else
                    buffer[buffer_index] = 255
                    buffer_index = buffer_index + 1
                    buffer[buffer_index] = chunk_remainder + 1
                end
                for index = chunk_start, chunk_offset + chunk_remainder do
                    buffer_index = buffer_index + 1
                    buffer[buffer_index] = bytes[index]
                end
            end
        end
        buffer[buffer_index + 1] = (size - 1) % chunk_size + 1
        return Serializer.ByteBufferToString(buffer)
    end
end
function Serializer.RestoreNullCharacters(data, chunk_size)
    local size = #data
    if size == 0 then
        return ""
    else
        if not chunk_size then
            chunk_size = Serializer.DEFAULT_CHUNK_SIZE
        end
        local last_chunk_size = string.byte(data, size, size)
        local last_chunk_start = size - last_chunk_size
        size = size - 1
        local buffer = {}
        local buffer_index = 0
        local bytes = {}
        for index = 1, size do
            bytes[index] = string.byte(data, index) - 1
        end
        local chunk_start = 1
        repeat
            local chunk_remainder = bytes[chunk_start]
            local is_encoded = chunk_remainder < 253
            if not is_encoded then
                if chunk_remainder == 253 then
                    chunk_remainder = chunk_size
                else
                    chunk_start = chunk_start + 1
                    chunk_remainder = bytes[chunk_start]
                end
            end
            chunk_start = chunk_start + 1
            local next_chunk_start = chunk_start + chunk_remainder
            local result_chunk_size
            if chunk_start == last_chunk_start then
                result_chunk_size = last_chunk_size
            else
                result_chunk_size = chunk_size
            end
            if is_encoded then
                for index = 1, result_chunk_size do
                    local chunk_end = chunk_start + chunk_remainder - 1
                    local remainder = 0
                    for index = chunk_end, chunk_start, -1 do
                        local numerator = remainder * 255 + bytes[index]
                        remainder = numerator % 256
                        bytes[index] = (numerator - remainder) * 0.00390625
                    end
                    buffer_index = buffer_index + 1
                    buffer[buffer_index] = remainder
                    for index = chunk_end, chunk_start, -1 do
                        if bytes[index] == 0 then
                            chunk_remainder = chunk_remainder - 1
                        else
                            break
                        end
                    end
                end
            else
                for index = chunk_start, chunk_start + chunk_remainder - 1 do
                    buffer_index = buffer_index + 1
                    buffer[buffer_index] = bytes[index] + 1
                end
                for index = chunk_start + chunk_remainder, chunk_start + result_chunk_size - 1 do
                    buffer_index = buffer_index + 1
                    buffer[buffer_index] = 0
                end
            end
            chunk_start = next_chunk_start
        until chunk_start > size
        return Serializer.ByteBufferToString(buffer)
    end
end