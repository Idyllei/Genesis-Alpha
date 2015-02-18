-- Serv_Cam_Calc.moon

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
distance = 30 -- Dist of cam from Arena on X-Axis
-- `height` no longer used, cam now centered over point of [most] rendering activity
-- & should provide
-- height = 5

game.Players.CharacterAutoLoads = false

-- Events:
EventHolder = with (game.Workspace.EventHolder or (Instance.new "Configuration", game.Workspace))
	if not .Name == "EventHolder"
		.Name = "EventHolder"

FieldOfViewUpdateEvent = with (EventHolder.FieldOfViewUpdateEvent or (Instance.new "BindableEvent", game.Workspace))
	if not .Name == "FieldOfViewUpdateEvent"
		.Name = "FieldOfViewUpdateEvent"

CameraCFrameUpdateEvent = with (EventHolder.CameraCFrameUpdateEvent or (Instance.new "BindableEvent", game.Workspace))
	if not .Name == "CameraCFrameUpdateEvent"
		.Name = "CameraCFrameUpdateEvent"

ArenaRemovingEvent = with (EventHolder.ArenaRemovingEvent or (Instance.new "BindableEvent", game.Workspace))
	if not .Name == "ArenaRemovingEvent"
		.Name = "ArenaRemovingEvent"

ArenaAddingEvent = with (EventHolder.ArenaAddingEvent or (Instance.new "BindableEvent", game.Workspace))
	if not .Name == "ArenaAddingEvent"
		.Name = "ArenaAddingEvent"

-- Core Function for sorting the players' distances
pairsByKeys = (t, f) ->
	a = {}
	for n in pairs t
		table.insert a, n
	table.sort a, f
	i = 0
	iter = ->
		i += 1
		if a[i] == nil
			nil
		else
			a[i],t[a[i]]
	iter

removeByKey = (t, k, f) ->
	NIL = {0,0,0,0,0,0,0,0}
	a = {}
	-- only add keys to tab if not key to be removed
	if (type k) == "table"
		for _k in pairs k
			for n in pairs t
				if n ~= _k
					table.insert a, n
	else
		for n in pairs t
			if n ~= k
				table.insert a,n
	table.sort a, f
	{{n,t[a[n]]} for _,n in pairs a}

-- Variables & Instances:

CenterPointOfArena = (game.Workspace.CurrentArena\FindFirstChild "CenterPoint").Position
charDists = {}

-- Brick Instance located @ center of map
center = with (Instance.new "Part", game.Workspace)
	.Name = "CenterPoint"
	.Size = Vector3.new 1,1,1
	.Transparency = 1
	.Anchored = true
	.CanCollide = false

-- Lambda functions will run only once.
-- Calculates the Camera's vector offset from the rotation of the 'center' brick.
cameraOffset = do
	lookVec = center.CFrame.lookVector
	v = Vector3.new 0,0,0
	if (lookVec.x > 0)
		v += Vector3.new lookVec.x, 0, 0
	if (lookVec.z > 0)
		v += Vector3.new 0,0,lookVec.z
	v *= distance
	v


ArenaRemovingEvent.OnServerEvent\connect ->
	-- Remove each remaining player from the map
	for _,plr in pairs game.Players\GetPlayers!
		plr.Character\BreakJoints!
	spawnCharacterAllowed = false
	ArenaAddingEvent.OnServerEvent\connect (newArena) ->
		CenterPointOfArena = (game.Workspace.CurrentArena\FindFirstChild "CenterPoint").Position
		spawnCharactersAllowed = true
		-- Spawn each character into the level
		for _,plr in pairs game.Players\GetPlayers!
			plr\LoadCharacter!

game.Players.PlayerAdded\connect (player) ->
	player.CharacterAdded\connect (char) ->
		humanoid = char\FindFirstChild "Humanoid"
		if humanoid
			humanoid.Died\connect ->
				wait respawnTime
				if spawnCharactersAllowed
					player\LoadCharacter!
				else
					while not spawnCharactersAllowed
						wait!
					player\loadCharacter!
		while wait .25
			charDists[player.Name] = (CenterPointOfArena-char.Torso.Position).magnitude
	player.CharacterRemoving\connect ->
		-- cleanly remove the player from the table
		removeByKey charDists, player.Name
	-- Load character for first time
	player\LoadCharacter!

-- Main control loop
while true
	highestDist = 0
	highestPlayer = ""
	secHighestDist = 0
	secHighestPlayer = ""
	for plr, dist in pairsByKeys charDists
		if dist > highestDist
			secHighestDist = highestDist
			secHighestPlayer = highestPlayer
			highestDist = dist
			highestPlayer = plr
	mLineView = (Vector3.new game.Players[highestPlayer].Character.Torso.Position.x, 0, game.Players[highestPlayer].Character.Torso.Position.z) - (Vector3.new game.Players[secHighestPlayer].Character.Torso.Position.x, 0, game.Players[secHighestPlayer].Character.Torso.Position.z).magnitude
	-- get midpoint of the 2 Torso Position Vectors
	center.Position = Vector3.new (game.Players[highestPlayer].Character.Torso.Position.x + game.Players[secHighestPlayer].Character.Torso.Position.x)/2, (game.Players[HighestPlayer].Character.Torso.Position.y +game.Players[secHighestPlayer].Character.Torso.Position.y)/2, (game.Players[highestPlayer].Character.Torso.Position.z + game.Players[secHighestPlayer].Character.Torso.Position.z)/2
	-- Set the FieldOfView property of the Camera instance usting the witchraft known as GEOMETRY
	FoV = math.deg 2*math.atan .5*(mLineOfView/30)
	camFrame = CFrame.new ((Vector3.new center.Position.x, center.Position.y, center.Position.z)+cameraOffset)
	for delta = .01, 1, .01
		FieldOfViewUpdateEvent\FireClient FoV * delta
		-- We must have a default delay before passing the next value due to transfer lag.
		delay 1/30, -> CameraCFrameUpdateEvent\FireAllClients camFrame * delta
		wait .0025
	