API={
	_Inventory: require "Inventory"
	_PlayerSettings: require "PlayerSettings"
	config: require "towns.config"
	_GlobalSettings: {
		ops: {}
		banned: {}
		priveledged: {}
		punished: {}
		locked: {}
		commands: {}
	}
}

API.shorter = (a, b) ->
    if a and b 
    	(#a <= #b) and a or b  
    else 
    	a or b
    

API.getPlayers = ->
	{v,v.Name for v in game.Players\GetPlayers!}

API.getPlayerHealth = (...) =>
	return {i,(@getPlayer v).Character.Humanoid.Health for i,v in pairs {...}} if ...
	error "",2
	{}

API.getPlayerStatus = (...) =>
	if #{...} >= 1
		{i,(@getPlayer v).Character.Humanoid.Status.Value for i,v in pairs {...}} 
	else
		error "",2
		{}

API.setPlayerStatus = (stat, ...) =>
	for i,v in pairs {...}
		((@getPlayer v).Character\FindFirstChild "Humanoid").Status.Value = stat
	if #{...} > 0
		true
	else 
		error "", 2
		false


API.animateDeath = (player) =>
	for v in (@getPlayer player).Character\GetChildren!
		pcall ->
			v.Transparency = 1
	if @_PlayerSettings[(@getPlayer player).Name].SaveInventory
		@_Inventory.savePlayerInventory (@getPlayer player).Name
	((@getPlayer player).playerGui\FindFirstChild "RespawnButton").MouseButton1Click\connect ->
		@respawnPlayer @getPlayer player

API.loadPlayerSkin = (player) =>
	if player
		((@getPlayer player).Character\FindFirstChild "Shirt").ShirtTemplate = "http://www.roblox.com/asset/?id=" .. (((game\GetService "DataStoreService")\GetGlobalDataStore!)\GetAsync (@getPlayer player).Name).."$shirtTemplate"
		((@getPlayer player).Character\FindFirstChild "Pants").PantsTemplate = "http://www.roblox.com/asset/?id=".. (((game\GetService "DataStoreService")\GetGlobalDataStore!)\GetAsync (@getPlayer player).Name).."$pantsTemplate"
		true
	else
		error "",2
		false

API._GlobalSettings.commands.reloadSkins = (user) =>
	for _,plr in pairs @getPlayers!
		@loadPlayerSkin plr

API._GlobalSettings.commands.op = (user, player) =>
	if player
		table.insert @_GlobalSettings.ops, (@getPlayer player).Name
		true
	else
		error "",2
		false

API._GlobalSettings.commands.deOp = (user, player) =>
	if player
		playerName = (@getPlayer player).Name
		pos = nil
		for i,v in pairs @getPlayers!
			if v == playerName
				pos = i
				break
		table.remove @_GlobalSettings.ops, pos
		true
	else
		error "",2
		false

API._GlobalSettings.commands.kick = (user, player) =>
	if player
		playerName = (@getPlayer player).Name
		if (@config.gentleKick == 1)
			@saveCheckpoint @player
		(@getPlayer player)\Kick!
		coroutine.resume coroutine.create ->
			now = tick!
			while tick! > (now + 30)
				coroutine.yield!
			game.Players.PlayerAdded\connect (p) ->
				if (@getPlayer p).Name == PlayerName
					p\Kick!
		true
	else
		error "",2
		false

API._GlobalSettings.commands.ban = (user, player) =>
	if player
		(@getPlayer player)\Kick!
		table.insert @_GlobalSettings.banned, (@getPlayer player).Name
		true
	else
		error "",2
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
	else
		error "",2
		false

API.getPlayerPosition = (player) =>
	if player
		((@getPlayer player).Character\findFirstChild "HumanoidRootPart").Position
	else
		error "",2
		false

API.setCameraNormal = (player) =>
	LFPLocal = ((game\GetService "ReplicatedStorage")\FindFirstChild "LFPLocal")\Clone!
	LFPLocal.Parent = (@getPlayer player).Character
	LFPLocal.Disabled = false
	if player
		true
	else
		error "",2
		false

API.setCameraFixed = (player) =>
	CFixedLocal = ((game\GetService "ReplicatedStorage")\FindFirstChild "CameraFixedLocal")\Clone!
	CfixedLocal.Parent = (@getPlayer player).Character
	CFixedLocal.Disabled = false
	if player
		true
	else
		error "",2
		false

API.setCameraFollow = (player) =>
	CFollowLocal = ((game\GetService "ReplicatedStorage")\FindFirstChild "CameraFollowLocal")\Clone!
	CFollowLocal.Parent = (@getPlayer player).Character
	CFollowLocal.Disabled = false
	if player
		true
	else
		error "",2
		false

API.setCameraPosition = (player, vec3) =>
	if player and vec3
		CSetPosLocal = ((game\GetService "ReplicatedStorage")\FindFirstChild "CSetPosLocal")\Clone!
		CSetPosLocal.Position.Value = vec3
		CSetPosLocal.Parent = (@getPlayer player).Character
		CSetPosLocal.Disabled = false
		true
	else
		error "",2
		false

API.getPlayerIds = ->
	{v.userId for v in game.Players\GetPlayers!}

API.postToChat = (player, msg) =>
	print "[DEBUG][API] postToChat = (player,msg) Is still in ALPHA-dev."