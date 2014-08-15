API = require "API"
create = (assert LoadLibrary "RbxUtil").Create

enum = (names) ->
	__enumId=0
	t = {}
	for i,k in pairs names
		if (type k) == "table"
			t[i] = enums k
		t[k] = __enumId
		__enumId += 1
	t


E = {stat: enum{"error","speed","poison","fatigue","confusion","hallucinate"}}

status = {}

status.setup = (player) ->
	player = API.getPlayer player
	if not player
		error"",2
		false
	(player.Character.Humanoid\FindFirstChild "Status")\Destroy!
	(create "Configuration") {
		Parent: player.Character.Humanoid
		Name: "Status"
		(create "StringValue") {Name: "status"}
		(create "IntValue") {Name: "length"}
		(create "BoolValue") {Name: "forceStop"}
		(create "BindableFunction") {Name: "callback"}
	}

status.run = (player) ->
	player = API.getPlayer player
	if not player
		error "",2
		false
	for i = 0,1,player.Character.Status.length
		if player.Character.Humanoid.Status.forceStop.IntValue
			break
		player.character.Humanoid.Status.callback!
		wait 1

status.stop = (player) ->
	player = API.getPlayer player
	if not player
		error "",2
	player.character.Humanoid.Status.forceStop = true
	wait 1
	player.Character.Humanoid.Status.forceStop = false

status.setStatus = (player, s, len) ->
	player = API.getPlayer player
	if not (s and player)
		error "",2
		false
	player.Charcter.Humanoid.Status.status.Value = s
	player.Character.Humanoid.Status.length.Value = len or math.huge
	(coroutine.wrap status.run) player

status.getStatus = (player) ->
	player = API.getPlayer player
	if not player
		error "",2
		false
	player.Character.Humanoid.Status.status.Value

return status