-- A*.lua

math = require "Math"

import is_a_vector3,is_a_cframe from require "type2"
import getCharacter from require "API"

class Pathfinder
	new: (startPath,endPoint,char_) =>
		if (type startPath) == "table"
			if (type endPoint) == "table" 	-- (table, table)
				@path_ = (game\GetService "PathfindingService")\ComputeRawPathAsync startPath[1], endPoint[-1], (startPath[1]-endPoint[-1]).magntiude*(2048%(startPoint[1]-endPoint[-1]).magnitude)
				@path = @path_\GetPointCoordinates!
				@char = getCharacter char_
			else 							-- (table, nil)
				@path = startPath
		elseif (is_a_vector3 startPath)
			-- Vector3
			if (is_a_vector3 endPoint) 		-- (Vector3, Vector3)
				@path_ = (game\GetService "PathfindingService")\ComputeRawPathAsync startPath, endPoint, (startPath-endPoint).magnitude * (2048%(startPath-endPoint).magnitude)
				@path = @path_\GetPointCoordinates!
			elseif (is_a_cframe endPoint) 	-- (Vector3, CFrame)
				endPoint = Vector3.new endPoint.x, endPoint.y, endPoint.z
				@path_ = (game\GetService "PathfindingService")\ComputeRawPathAsync startPath, endPoint, (startPath-endPoint).magnitude * (2048%(startPath-endPoint).magnitude)
				@path = @path_\GetPointCoordinates!
		elseif (is_a_cframe startPath)
			-- CFrame
			if (is_a_cframe endPoint) 		-- (CFrame, CFrame)
				strt = Vector3.new startPath.x, startPath.y, startPath.z
				endP = Vector3.new endPoint.x, endPoint.y, endPoint.z
				@path_ = (game\GetService "PathfindingService")\ComputeRawPathAsync strt, endP, (strt-endP).magnitude*(2048%(strt-endP).magnitude)
				@path = @path_\GetPointCoordinates!
			elseif (is_a_vector3 endPoint)	-- (CFrame, Vector3)
				strtP = Vector3.new startPath.x, startPath.y, startPath.z
				@path_ = (game\GetService "PathfindingService")\ComputeRawPathAsync strtP, endPoint, (strtP-endPoint).magntiude*(2048%(strtP-endPoint).magnitude)
				@path = @path_\GetPointCoordinates!
			elseif (is_a_table endPoint)	-- (CFrame, Table)
				@path_ = (game\GetService "PathfindingService")\ComputeRawPathAsync (Vector3.new startPath.x, startPath.y, startPath.z), endPoint[-1], (startPath-endPoint).magntiude*(2048%(startPath-endPoint).magnitude)
				@path = @path_\GetPointCoordinates!
				for i,v in pairs @path
					if (not is_a_vector3 v)
						@path[i] = pcall toVector3, v
	Traverse: (char_) =>
		if (not @char)
			@char = getCharacter char_
		i = 1
		for _, point in pairs @path
			print "Moving @char to " .. (tostring2 point) .. "."
			char.Humanoid\moveTo point
			while (point - player.Character.Torso.Position).magnitude > 3
				wait!
			i += 1
			if math.random! >= .875 -- A (semi) random check for Path Occlusions
				if (point == @path[@path_\CheckOcclusionAsync!]) and (path_\CheckOcclusionAsync! == i)-- If it IS blocked, then recompute from the blocked point
					@path_ = (game\GetService "PathfindingService")\ComputeRawPathAsync point, @path[-1], (point-@path[-1]).magntiude*(2048%(point-@path[-1]).magnitude)
					@path = @path_\GetPointCoordinates!

return Pathfinder