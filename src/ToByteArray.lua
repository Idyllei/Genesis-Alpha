-- StringToByteArray.lua

local function ToByteArray(str)
	t = {}
	str = "local bytes = { "
	for v in str:gmatch(".") do
		if v ~= str:sub(str:len()-1) then
			str = str .. "\"\\\\"..tostring(v:byte()).."\", "
		else
			str = str .. "\\\\"..tostring(v:byte()) .. "\""
		end
	end
	str = str .. " }"
	print(str)
end

ToByteArray("Z4xX173r1Ng")