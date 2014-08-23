PLAYERS = game.Players

API={
	_Inventory: require "Inventory"
	_PlayerSettings: require "PlayerSettings"
	config: require "towns.config"
}

API.getPlayers = ->
	{v,v.Name for v in game.Players\GetPlayers!}

API.getPlayerHealth = (...) =>
	return {i,(@getPlayer v).Character.Humanoid.Health for i,v in pairs {...}} if ...
	error "",2
	{}

API.getPlayerStatus = (...) =>
	{i,(@getPlayer v).Character.Humanoid.Status.Value for i,v in pairs {...}} if #{...} > 1
	{plr.Character.Humanoid.Status.Value for _,plr in @GetPlayers!} if #{...} == 1
	error "[DEBUG][ERROR][API] Attempt to call API.getPlayerStatus too few arguments",2
	

API.setPlayerStatus = (stat, ...) =>
	for i,v in pairs {...}
		((@getPlayer v).Character\FindFirstChild "Humanoid").Status.Value = stat
	true if #{...} > 0
	error "[DEBUG][ERROR][API] Attempt to call API.setPlayerStatus with too few arguments",2
	false

API.getUserId = (plr) ->
	if (plr.Parent == game.Players)
		--// Is a Player instance
		plr.userId
	elseif (plr.HumanoidRootPart)
		--// Character plr = new Model()
		PLAYERS\GetPlayerFromCharacter plr
	elseif ((type plr) == "string")
		--// String plr;
		(API.getPlayer plr).userId
	elseif ((type plr) == "number")
		--// int plr = (int)userId
		plr
	else
		error "[DEBUG][ERROR][API] Unknown Error.",2

API.animateDeath = (player) =>
	for v in (@getPlayer player).Character\GetChildren!
		pcall ->
			v.Transparency = 1
	if @_PlayerSettings[(@getPlayer player).Name].SaveInventory
		@_Inventory.savePlayerInventory (@getPlayer player).Name
	((@getPlayer player).playerGui\FindFirstChild "RespawnButton").MouseButton1Click\connect ->
		@respawnPlayer @getPlayer player

API.loadPlayerSkin = (player) =>
	player = @getPlayer player
	if player
		(player.Character\FindfirstChild "Shirt").ShirtTemplate = "http://www.roblox.com/asset/?id=" .. (((game\GetService "DataStoreService")\GetGlobalDataStore!)\GetAsync player.Name).."$shirtTemplate"
		(player.Character\FindfirstChild "Pants").PantsTemplate = "http://www.roblox.com/asset/?id=".. (((game\GetService "DataStoreService")\GetGlobalDataStore!)\GetAsync player.Name).."$pantsTemplate"
		true
	error "[DEBUg][ERROR][API] Attempt to call API.loadPlayerSkin with invalid argument(s)",2
	false

API.op = (player) =>
	player = @getPlayer player
	if player
		table.insert @_GlobalSettings.ops, player.Name
		true
	error "[DEBUG][ERROR][API] Attempt to call op with invalid argument(s)",2
	false

API.deOp = (player) =>
	player = @getPlayer player
	if player
		playerName = player.Name
		pos = nil
		for i,v in pairs @getPlayers!
			if v == playerName
				pos = i
				break
		table.remove @_GlobalSettings.ops, pos
		true
	error "[DEBUG][ERROR][API] Attempt to call deOp with invalid argumen(s)",2
	false

API.kick = (player) =>
	player = @getPlayer player
	if player
		playerName = player.Name
		if (@config.gentleKick == 1)
			@saveCheckpoint @player
		player\Kick!
		coroutine.resume coroutine.create ->
			now = tick!
			while tick! > (now + 30)
				coroutine.yield!
			game.Players.PlayerAdded\connect (p) ->
				if (@getPlayer p).Name == PlayerName
					p\Kick!
		true
	error "[DEBUG][ERROR][API] Attempt to call kick with invalid argument(s)",2
	false

API.ban = (player) =>
	player = @getPlayer player
	if player
		player\Kick!
		table.insert @_GlobalSettings.banned, player.Name
		true
	error "[DEBUG][ERROR][API] Attempt to call ban with invalid argument(s)",2
	false

API.getNPCHealth = (mouse) ->
	mouse.Target.Humanoid.Health

API.getNPCMaxHealth = (mouse) ->
	mouse.Target.Humanoid.MaxHealth

API.saveCheckpoint = (player) =>
	print "[DEBUG][API] saveCheckpoint = (player) Still in ALPHA-dev."

API.changeSetting = (setting,value) =>
	if not (setting and value)
		error "",2
		false
	if (((type Value) == (type @_GlobalSettings[setting])) or (@_GlobalSettings[setting] == nil))
		@_GlobalSettings[setting] = value
		true
	error "[DEBUG][ERROR][API] Attempt to call changeSetting with invalid argument(s)",2
	false

API.getPlayerPosition = (player) =>
	player = @getPlayer player
	if player
		(player.Character\FindFirstChild "HumanoidRootPart").Position
	error "",2
	false

API.setCameraNormal = (player) =>
	player = @getPlayer player
	LFPLocal = ((game\GetService "ReplicatedStorage")\FindFirstChild "LFPLocal")\Clone!
	LFPLocal.Parent = player.Character
	LFPLocal.Disabled = false
	return true if player
	error "",2
	false

API.setCameraFixed = (player) =>
	player = @getPlayer player
	CFixedLocal = ((game\GetService "ReplicatedStorage")\FindFirstChild "CameraFixedLocal")\Clone!
	CfixedLocal.Parent = player.Character
	CFixedLocal.Disabled = false
	return true if player
	error "",2
	false

API.setCameraFollow = (player) =>
	player = @getPlayer player
	CFollowLocal = ((game\GetService "ReplicatedStorage")\FindFirstChild "CameraFollowLocal")\Clone!
	CFollowLocal.Parent = player.Character
	CFollowLocal.Disabled = false
	return true if player
	error "",2
	false

API.setCameraPosition = (player, vec3) =>
	player = @getPlayer player
	if player and vec3
		CSetPosLocal = ((game\GetService "ReplicatedStorage")\FindFirstChild "CSetPosLocal")\Clone!
		CSetPosLocal.Position.Value = vec3
		CSetPosLocal.Parent = player.Character
		CSetPosLocal.Disabled = false
		true
	error "",2
	false

API.getPlayerIds = ->
	{v.userId for v in game.Players\GetPlayers!}

API.postToChat = (player, msg) =>
	player = @getPlayer player
	print "[DEBUG][API] postToChat = (player,msg) Is still in ALPHA-dev."