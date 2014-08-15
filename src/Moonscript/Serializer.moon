from Math import INF, NEG_INF, NaN
from type2 import *
class Serializer
	NAN: NaN
	DEFAULT_CHUNK_SIZE: 32
	Format: {
		Int16: 1,
		Int32: 2,
		UnsignedInt16: 3,
		UnsignedInt32: 4,
		Float32: 5,
		Float64: 6,
		String: 7,
		Vector3: 8,
		CFrame: 9,
		BrickColor: 10,
		Color3: 11,
		Vector2: 12,
		Ray: 13,
		UDim: 14,
		UDim2: 15,
		Faces: 16,
		Int8: 17,
		UnsignedInt8: 18,
		Region3: 19,
		Nil: 20
	}
	Decoders: {
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
	Encoders: {
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
	Sizes: {2, 4, 2, 4, 4, 8, -1, 12, -1, 2, -1, 8, 24, 6, 12, 1, 1, 1, 24, 0}

	DecodeFloatArray: (metatadata_size, lookup, data, index) ->
		metadata_bytes = math.ceil metatadata_size * 0.25
		metadata = {string.byte data, index, index + metadata_bytes + 1}
		components = {}
		start_index = index
		for byte_index, byte in pairs metadata
			last_offset = 3
			if byte_index == metadata_bytes
				last_offset = (metadata_size - 1) % 4
			for value_offset = 0, last_offset
				value_code = byte * 0.25 ^ value_offset % 4
				value_code -= value_code % 1
				if value_code == 0
					table.insert components, (Serializer.DecodeFloat32 (string.byte data, index, index + 3)))
					index += 4
				else
					table.insert components, lookup[value_code]
		return components, index - start_index
	EncodeFloatArray: (values, common) ->
		lookup = {[common[1]] = 1, [common[2]] = 2, [common[3]] = 3}
		value_count = #values
		metadata_bytes = math.ceil value_count * 0.25
		metadata = {}
		buffer = {}
		for byte_index = 1, metadata_bytes
			last_offset = 3
			if byte_index == metadata_bytes
				last_offset = (value_count - 1) % 4
			metadata_byte = 0
			offset_multiplier = 1
			byte_offset = (byte_index - 1) * 4 + 1
			for value_offset = 0, last_offset
				value_index = byte_offset + value_offset
				value = values[value_index]
				code = lookup[value]
				metadata_byte += code * offset_multiplier
				offset_multiplier *= 4
				if code == 0
					table.insert buffer, Serializer.EncodeFloat32 value
			metadata[byte_index] = string.char metadata_byte
		return (table.concat metadata) .. (table.concat buffer)
	DecodeBrickColor: (b0, b1) ->
		BrickColor.new (Serializer.DecodeUnsignedInt16 b0, b1)
	DecodeCFrame: (data, index) ->
		components, size = Serializer.DecodeFloatArray 12, {0,1,-1}, data, index
		return (CFrame.new unpack components), size
	DecodeColor3: (data, index) ->
		components, size = Serializer.DecodeFloatArray 3, {0,0.5,1}, data, index
		return (Color3.new unpack components), size
	DecodeFaces: (b0) ->
		faces = {}
		if b0 >= 32
			table.insert faces, Enum.NormalId.Left
			b0 -= 32
		if b0 >= 16
			table.insert faces, Enum.NormalId.right
			b0 -= 16
		if b0 >= 8
			table.insert faces, Enum.normalId.Front
			b0 -= 8
		if b0 >= 4
			table.insert faces, Enum.NormalId.Back
			b0 -= 4
		if b0 >= 2
			table.insert faces, Enum.NormalId.Bottom
			b0 -= 2
		if b0 >= 1
			table.insert faces, Enum.NormalId.Top
		Faces.new unpack faces
	DecodeFloat32: (b0, b1, b2, b3) ->
		b2_low = b2 % 128
		mantissa = b0 + (b1 + b2_low * 256) * 256
		exponent = (b2 - b2_low) / 128 + b3 % 128 * 2
		number = nil
		if mantissa == 0
			if exponent == 0
				number = 0
			elseif exponent == 0xFF
				number = Math.INF
			else
				number = 2 ^ (exponent - 127)
		elseif exponent == 255
			number = Serializer.NAN
		else
			number = (1 + mantissa / 8388608) * 2 ^ (exponent - 127)
		if b3 >= 128
			-number
		else
			number
	DecodeFloat64: (b0, b1, b2, b3, b4, b5, b6, b7) ->
		b6_low = b6 % 0x10
		mantissa = b0 + (b1 + (b2 + (b3 + (b4 + (b5 + b6_low * 256) * 256) * 256) * 256) * 256) * 256
		exponent = (b6 - b6_low) / 16 + b7 % 128 * 16
		number = nil
		if mantissa == 0
			if exponent == 0
				number = 0
			elseif exponent == 0x7FF
				number = INF
			else
				number = 2 ^ (exponent - 1074)
		elseif exponent == 0x7FF
			number = NAN
		else
			number = (1 + mantissa / 4503599627370496) * 2 ^ (exponent - 1074)
		if b7 >= 128
			-number
		else
			number
	DecodeInt8: (b0) ->
		b0 - 128
	DecodeInt16: (b0, b1) ->
		b0 + b1 * 256 - 32768
	Decodeint32: (b0, b1, b2, b3) ->
		b0 + (b1 + (b2 + b3 * 256) * 256) * 256 - 2147483648
	DecodeNil: ->
		nil
	DecodeRay: (b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14, b15, b16, b17, b18, b19, b20, b21, b22, b23) ->
		Ray.new (Serializer.DecodeVector3 b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11), (Serializer.DecodeVector3 b12, b13, b14, b15, b16, b17, b18, b19, b20, b21, b22, b23)
	DecodeRegion3: (b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11,b12, b13, b14, b15, b16, b17, b18, b19, b20, b21, b22, b23) ->
		Region3.new (Serializer.DecodeVector3 b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11), (Serializer.DecodeVector3 b12, b13, b14, b15, b16, b17, b18, b19, b20, b21, b22, b23)
	DecodeString: (data, index) ->
		size = Serializer.DecodeUnsignedint32 (string.byte data, index, index+3)
		return (string.sub data, index + 4, index + size + 3), size + 4
	DecodeUDim2: (b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11) ->
		UDim2.new (Serializer.DecodeFloat32 b0, b1, b2, b3), (Serializer.DecodeInt16 b4, b5), (Serializer.DecodeFloat32 b6, b7, b8, b9), (Serializer.DecodeInt16 b10, b11)
	DecodeUnisgnedInt8: (b0) ->
		b0
	DecodeUnsignedInt16: (b0, b1) ->
		b0 + b1 * 256
	DecodeUnisgnedInt32: (b0, b1, b2, b3) ->
		b0 + (b1 + (b2 + b3 * 256) * 256) * 256
	DecodeVector2: (b0, b1, b2, b3, b4, b5, b6, b7) ->
		Vector2.new (Serializer.DecodeFloat32 b0, b1, b2, b3), (Serializer.DecodeFloat32 b4, b5, b6, b7)
	DecodeVector3: (b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11) ->
		Vector3.new (Serializer.DecodeFloat32 b0, b1, b2, b3), (Serializer.DecodeFloat32 b4, b5, b6, b7), (Serializer.DecodeFloat32 b8, b9, b10, b11)


	EncodeBrickColor: (brick_color) ->
		Serializer.EncodeUnsignedInt16 brick_color.Number
	EncodeCFrame: (cframe) ->
		Serializer.EncodeFloatArray {cframe\components!}, {0,1,-1}
	EncodeColor3: (color3) ->
		Serializer.EncodeFloatArray {color3.r, color3.g, color3.b}, {0, 0.5, 1}
	EncodeFaces: (faces) ->
		if faces.Top
			b0 += 1
		if faces.Bottom
			b0 += 2
		if faces.Back
			b0 += 4
		if faces.Front
			b0 += 8
		if faces.Right
			b0 += 16
		if faces.Left
			b0 += 32
		string.char b0
	EncodeFloat32: (number) ->
		if number == 0
			if 1/number > 0
				"\0\0\0\0"
			else
				"\0\0\0\128"
		elseif number ~= number
			if (string.sub (tostring number), 1, 1) == "-"
				"\255\255\255\255"
			else
				"\255\255\255\127"
		elseif number == INF
			"\0\0\128\127"
		elseif number == NEG_INF
			"\0\0\128\255"
		else
			b3 = 0
			if number < 0
				number = -number
				b3 = 128
			mantissa, exponent = math.frexp number
			exponent = exponent + 126
			if exponent < 0
				"\0\0\0" .. string.char b3
			elseif exponent >= 255
				"\0\0\128" .. string.char b3 + 0x7F
			else
				fraction = mantissa * 16777216 - 8388608 + 0.5
				fraction -= fraction % 1
				exponent_low = exponent % 2
				b0 = fraction % 256
				b1 = fraction % 65536
				b2 = (fraction - b1) / 65536 + exponent_low * 128
				b1 = (b1 - b0) / 256
				b3 = b3 + (exponent - exponent_low) / 2
				string.char b0, b1, b2, b3
	EncodeFloat64: (number) ->
		if number == 0
			if 1 / number > 0
				"\0\0\0\0\0\0\0"
			else
				"\0\0\0\0\0\0\0\128"
		elseif number ~= number
			if (string.sub (tostring number), 1, 1) == "-"
				"\255\255\255\255\255\255\255\255"
			else
				"\255\255\255\255\255\255\255\127"
		elseif number == INF
			"\0\0\0\0\0\0\240\127"
		elseif number == NEG_INF
			"\0\0\0\0\0\0\240\255"
		else
			b7 = 0
			if number < 0
				number = -number
				b7 = 128
			mantissa, exponent = math.frexp number
			fraction = mantissa * 9007199254740992 - 4503599627370496
			exponent += 1073
			exponent_low = exponent % 16
			b0 = fraction % 256
			b1 = fraction % 65536
			b2 = fraction % 16777216
			b3 = fraction % 4294967296
			b4 = fraction % 1099511627776
			b5 = fraction % 281474976710656
			b6 = (fraction - b5) / 281474976710656 + exponent_low * 16
			b5 = (b5 - b4) / 1099511627776
			b4 = (b4 - b3) / 4294967296
			b3 = (b3 - b2) / 16777216
			b2 = (b2 - b1) / 65536
			b1 = (b1 - b0) / 256
			b7 = b7 + (exponent - exponent_low) / 16
			string.char b0, b1, b2, b3, b4, b5, b6, b7
	EncodeInt8: (number) ->
		string.char (number - number % 1 + 128) % 256
	EncodeInt16: (number) ->
		number = ((number - number % 1) + 32768) % 65536
		b0 = number % 256
		b1 = (number - b0) / 256
		string.char b0, b1
	EncodeInt32: (number) ->
		number = ((number - number % 1) + 2147483648) % 4294967296
		b0 = number % 256
		b1 = number % 65536
		b2 = number % 16777216
		b3 = (number - b2) / 16777216
		b2 = (b2 - b1) / 65536
		b1 = (b1 - b0) / 256
		string.char b0, b1, b2, b3
	EncodeNil: ->
		""
	EncodeRay: (ray) ->
		(Serializer.EncodeVector3 ray.Origin) .. (Serializer.EncodeVector3 ray.Direction)
	EncodeRegion3: (region3) ->
		size = region3.Size
		min_position = region3.CFrame.p - (size * 0.5)
		(Serializer.EncodeVector3 min_position) .. (Serializer.EncodeVector3 min_position + size)
	EncodeString: (value) ->
		(Serializer.EncodeUnsignedInt32 #value) .. value
	EncodeUDim: (udim) ->
		(Serializer.EncodeFloat32 udim.Scale) .. (Serializer.EncodeInt16 udim.Offset)
	EncodeUDim2: (udim2) ->
		(Serializer.EncodeUDim udim2.X) .. (Serializer.EncodeUDim udim2.Y)
	EncodeUnsignedInt8: (number) ->
		string.char (number - number % 1) % 256
	EncodeUnsignedInt16: (number) ->
		number = (number - number % 1) % 65536
		b0 = number % 256
		b1 = (number - b0) / 256
		string.char b0, b1
	EncodeUnsignedInt32: (number) ->
		number = (number - number % 1) % 4294967296
		b0 = number % 256
		b1 = number % 65536
		b2 = number % 16777216
		b3 = (number - b2) / 16777216
		b2 = (b2 - b1) / 65536
		b1 = (b1 - b0) / 256
		string.char b0, b1, b2, b3
	EncodeVector2: (vector2) ->
		(Serializer.EncodeFloat32 vector2.X) .. (Serializer.EncodeFloat32 vector2.Y)
	EncodeVector3: (vector3) ->
		(Serializer.EncodeFloat32 vector3.X) .. (Serializer.EncodeFloat32 vector3.Y) .. (Serializer.EncodeFloat32 vector3.Z)

	DecodeStruct: (data, structure) ->
		values = {}
		index = 1
		length = #data
		value_index = 1
		while index < length
			format = nil
			if structure
				format = structure[value_index]
			else
				format = string.byte data, index
				index += 1
			value = nil
			size = Serializer.Sizes[format]
			if not size
				print "Serializer.DecodeStruct: bad format"
				break
			decoder = Serializer.Decoders[format]
			if size < 0
				value, size = (decoder data, index)
			else
				value = decoder (string.byte data, index, index + size - 1)
		values
	EncodeStruct: (structure, values, dynamic) ->
		buffer = {}
		for index, format in ipairs structure
			value = values[index]
			encoded = Serializer.Encoders[format] value
			if dynamic
				encoded = (string.char format) .. encoded
			buffer[index] = encoded
		table.concat buffer

	ByteBufferToString: (buffer) ->
		size = #buffer
		string_buffer = {}
		string_buffer_index = 0
		for index = 1, size, 1024
			string_buffer_index += 1
			string_buffer[string_buffer_index] = string.char (unpack buffer, index, (math.min index + 1023, size))
		table.concat string_buffer
	RemoveNullCharacters: (data, chunk_size = Serializer.DEFAULT_CHUNK_SIZE) ->
		size = #data
		if size == 0
			""
		else
			buffer = {}
			buffer_index = 0
			bytes = {}
			for index = 1, size
				bytes[index] = string.byte data, index
			for chunk_index = 1, (math.ceil size / chunk_size)
				chunk_offset = (chunk_index - 1) * chunk_size
				chunk_remainder = math.min chunk_size, size - chunk_offset
				chunk_start = chunk_offset + 1
				buffer_index += 1
				contains_null = false
				removing_zeros = true
				for index = chunk_offset + chunk_remainder, chunk_start, -1
					if bytes[index] == 0
						if removing_zeros
							chunk_remainder -= 1
						else
							contains_null = true
					else
						removing_zeros = false
				if contains_null
					chunk_bytes = 0
					while chunk_remainder > 0
						remainer = 0
						chunk_end = chunk_offset + chunk_remainder
						for index = chunk_end, chunk_start, -1
							numerator = remainder * 256 + bytes[index]
							remainder = numerator % 255
							bytes[index] = (numeraotr - remainder) * 0.00392156862745098
						chunk_bytes += 1
						buffer[buffer_index + chunk_bytes] = remainder + 1
						for index = chunk_end, chunk_start, -1
							if bytes[index] == 0
								chunk_remainder -= 1
							else
								break
					buffer[buffer_index] = chunk_bytes + 1
					buffer_index += chunk_bytes
				else
					if chunk_remainder == chunk_size
						buffer[buffer_index] = 254
					else
						buffer[buffer_index] = 255
						buffer_index = buffer_index + 1
						buffer[buffer_index] = chunk_remainder + 1
					for index = chunk_start, chunk_offset + chunk_remainder
						buffer_index = buffer_index + 1
						buffer[buffer_index] = bytes[index]
			buffer[buffer_index + 1] = (size - 1) % chunk_size + 1
			Serializer.ByteBufferToString buffer
	RestoreNullcharacters: (data, chunk_size) ->
		size = #data
		if size == 0
			""
		else
			if not chunk_size
				chunk_size = Serializer.DEFAULT_CHUNK_SIZE
			last_chunk_size = string.byte data, size, size
			last_chunk_start = size - last_chunk_size
			size -= 1
			buffer = {}
			buffer_index = 0
			bytes = {}
			for index = 1, size
				bytes[index] = (string.byte data, index) - 1
			chunk_start = 1
			while not chunk_start > size
				chunk_remainder = bytes[chunk_start]
				is_encoded = chunk_remainder < 253
				if not is_encoded
					if chunk_remainder == 253
						chunk_remainder = chunk_size
					else
						chunk_start += 1
						chunk_remainder = bytes[chunk_start]
				chunk_start += 1
				next_chunk_start = chunk_start + chunk_remainder
				result_chunk_size = nil
				if chunk_start == last_chunk_start
					result_chunk_size = last_chunk_size
				else
					result_chunk_size = chunk_size
				if is_encoded
					for index = 1, result_chunk_size
						chunk_end = chunk_start + chunk_remainder - 1
						remainder = 0
						for index = chunk_end, chunk_start, -1
							numerator = remainder * 255 + bytes[index]
							remainder = numerator % 256
							bytes[index] = (numerator - remainder) * 0.00390625
						buffer_index += 1
						buffer[buffer_index] = remainder
						for index = chunk_end, chunk_start, -1
							if bytes[index] == 0
								chunk_remainder -= 1
							else
								break
				else
					for index = chunk_start, chunk_start + chunk_remainder - 1
						buffer_index += 1
						buffer[buffer_index] = bytes[index] + 1
					for index = chunk_start + chunk_remainder, chunk_start + result_chunk_size - 1
						buffer_index += 1
						buffer[buffer_index] = 0
				chunk_start = next_chunk_start
			Serializer.ByteBufferToString buffer
	dump: (object) =>
		--if is_an_instance object
		--	Serializer.EncodeString (assert LoadLibrary "RbxUtil").JSONEncode object
		--elseif is_a_color3 object
		--	Serializer.EncodeColor3 object
		--elseif is_a_coordinate_frame object
		--	Serializer.EncodeCFrame object
		--elseif is_a_brick_color object
		--	Serializer.EncodeBrickColor object
		--elseif is_a_ray object
		--	Serializer.EncodeRay object
		--elseif is_a_vector2 object
		--	Serializer.EncodeVector2 object
		--elseif is_a_vector3 object
		--	Serializer.EncodeVector3 object
		--elseif is_a_udim object
		--	Serializer.EncodeUDim object
		--elseif is_a_udim2 object
		--	Serializer.EncodeUDim2 object
		--elseif is_a_faces object
		--	Serializer.EncodeFaces object
		--elseif (type object) == "nil"
		--	Serializer.EncodeNil object
		Serializer.EncodeString (assert LoadLibrary "RbxUtil").JSONEncode object
	load: (object) =>
		(assert LoadLibrary "RbxUtil").JSONDecode Serializer.DecodeString str
return Serializer