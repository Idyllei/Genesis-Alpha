-- Server_Camera_Calc.lua

-- Usage: This should be put in a Script in ServerScriptService to protect it and your game.
-- Please notify your players to do the following for optimal performance:
-- 1) Go into ROBLOX Studio
-- 2) Open File > Settings > Lua
-- 3) Change DefaultWaitTime to 0.0025
-- 4) Go to Physics
-- 5) Make sure ParallelPhysics is turned on. (This SOMETIMES allows the clients to render for the server
--    and speeds up the game's physics)


-- ADDED PERKS: This code is FilteringEnabled compatible! You can use it without it breaching 
-- the client-server barrier! 



-- Settings:
local distance = 30 -- Distance of the Camera from the Arena on the x axis
-- `height' No longer used, the camera is now centered over point of [most] rendering activity
-- And should provide 
-- local height = 5 

game.Players.CharacterAutoLoads = false

-- Events

local EventHolder = game.Workspace.EventHolder or Instance.new("Configuration", game.Workspace)
if not EventHolder.Name == "EventHolder" then EventHolder.Name = "EventHolder" end

local FieldOfViewUpdateEvent = EventHolder.FieldOfViewUpdateEvent or Instance.new("BindableEvent",EventHolder)
if not FieldOfViewUpdateEvent.Name == "FieldOfViewUpdateEvent" then FieldOfViewUpdateEvent.Name = "FieldOfViewUpdateEvent" end

local CameraCFrameUpdateEvent = EventHolder.CameraCFrameUpdateEvent or Instance.new("BindableEvent",EventHolder)
if not CameraCFrameUpdateEvent.Name == "CameraCFrameUpdateEvent" then CameraCFrameUpdateEvent.Name = "CameraCFrameUpdateEvent" end

local ArenaRemovingEvent = EventHolder.ArenaRemovingEvent or Instance.new("BindableEvent",EventHolder)
if not ArenaRemovingEvent.Name == "ArenaRemovingEvent" then ArenaRemovingEvent.Name = "ArenaRemovingEvent" end

local ArenaAddingEvent = EventHolder.ArenaAddingEvent or Instance.new("BindableEvent",EventHolder)
if not ArenaAddingEvent.Name == "ArenaAddingEvent" then ArenaAddingEvent.Name = "ArenaAddingEvent" end

-- Core Function for sorting the players' distances
function pairsByKeys (t, f)
	local a = {}
	for n in pairs(t) do table.insert(a, n) end
	table.sort(a, f)
	local i = 0      -- iterator variable
	local iter = function ()   -- iterator function
		i = i + 1
		if a[i] == nil then return nil
		else return a[i], t[a[i]]
        end
	end
	return iter
end
-- Table t: Table to sort
-- Table/Key k: Key(s) to remove
-- function f: Sort function
function removeByKey(t,k,f)
	local NIL = {0,0,0,0,0,0,0,0}
	local a = {}
	-- only add keys to table if they arent't the key to be removed
	if type(k) == "table" then
		for _k in pairs(k) do 
			for n in pairs(t) do if n ~= _k then table.insert(a,n) end end
		end
	else
		for n in pairs(t) do if n ~= k then table.insert(a,n) end end
	end
	table.sort(a,f)
	local ret = {}
	for _,n in pairs(a) do
		ret[n] = t[a[n]]
	end
	return ret
end
-- Variables and Instances

local CenterPointOfArena = game.Workspace.CurrentArena:FindFirstChild("CenterPoint").Position
local charDists = {}

-- Brick Instance located at center of the map
local center = Instance.new("Part")
center.Name = "Camera_Center"
center.Size = Vector3.new(1,1,1)
center.Transparency = 1
center.Anchored = true
center.CanCollide = false 


-- Lambda Expression will run only once.
-- Calculates the Camera's vector offset from the rotation of the 'center' brick
local cameraOffset = (function(lookVec)
	local v = Vector3.new(0,0,0)
	if lookVec.x > 0 then
		v = v + Vector3.new(lookVec.x,0,0)
	end
	if lookVec.z > 0 then
		v = v + Vector3.new(0,0,lookVec.z)
	end
	v = v * distance
	return v
end)(center.CFrame.lookVector)

ArenaRemovingEvent.OnServerEvent:connect(function()
	-- Remove each remaining player from the map
	for _,plr in pairs(game.Players:GetPlayers()) do
		plr.Character:BreakJoints()
	end
	spawnCharactersAllowed = false
	ArenaAddingEvent.OnServerEvent:connect(function(newArena)
		CenterPointOfArena = game.Workspace.CurrentArena:FindFirstChild("CenterPoint").Position
		spawnCharactersAllowed = true
		-- Spawn each character into the level
		for _,plr in pairs(game.Players:GetPlayers()) do
			plr:LoadCharacter()
		end
	end)
end)

-- Event Connection to update the player's 
game.Players.PlayerAdded:connect(function(player)
	player.CharacterAdded:connect(function(char)
		local humanoid = char:FindFirstChild("Humanoid")
		if humanoid then
			hmanoid.Died:connect(function()
				wait(respawnTime)
				if spawnCharactersAllowed then
					player:LoadCharacter()
				else
					repeat wait() until spawnCharactersAllowed
					player:LoadCharacter()
				end
			end)
		while wait(.25) do
			charDists[player.Name] = (CenterPointOfArena-char.Torso.Position).magnitude
		end
	end)
	player.CharacterRemoving:connect(function()
		-- Cleanly remove the player from the table
		removeByKey(charDists, player.Name)
	end)
	-- Load for first time
	player:LoadCharacter()
end)

-- Main control loop
while true do
	local highestDist = 0
	local highestPlayer = ""
	local secHighestDist = 0
	local secHighestPlayer = ""
	for plr, dist in pairsByKeys(charDists) do
		if dist > highestDist then
			secHighestDist = highestDist
			secHighestPlayer = highestPlayer
			highestDist = dist
			highestPlayer = plr
		end
	end
	local mLineView = (Vector3.new(game.Players[highestPlayer].Character.Torso.Position.x, 0, game.Players[highestPlayer].Character.Torso.Position.z) - Vector3.new(game.Players[secHighestPlayer].Character.Torso.Position.x, 0, game.Players[secHighestPlayer].Character.Torso.Position.z)).magnitude
	-- get midpoint of the 2 Torso Position Vectors
	center.Position = Vector3.new(game.Players[highestPlayer].Character.Torso.Position.x + game.Players[secHighestPlayer].Character.Torso.Position.x)/2, (game.Players[HighestPlayer].Character.Torso.Position.y +game.Players[secHighestPlayer].Character.Torso.Position.y)/2, (game.Players[highestPlayer].Character.Torso.Position.z + game.Players[secHighestPlayer].Character.Torso.Position.z)/2
	-- Set the FieldOfView property of the Camera Instance using the witchcraft known as GEOMETRY (and Trigonometry, but I'm not taking that class yet :P).
	FoV = math.deg(2*math.atan(.5*mLineOfView/30))
	camFrame = CFrame.new(Vector3.new(center.Position.x, center.Position.y, center.Position.z)+cameraOffset)
	for delta = .01, 1, .01 do
		FieldOfViewUpdateEvent:FireClient(FoV * delta)
		-- We must have a default delay before passing the next value do to transfer lag.
		delay(1/30, function() CameraCFrameUpdateEvent:FireAllClients(camFrame * delta) end)
		wait(.0025)
	end
end