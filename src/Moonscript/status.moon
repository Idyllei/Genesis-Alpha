-- 0xBAD : DO NOT TERM DIRECTLY
-- 0xDEAD : Something went wrong and should be checked.
-- 0xDEFACE : Run DESTRUCTOR provided by generator when the call must be stopped in order to term properly



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


BASE_STATS = enum{"error","speed","poison","fatigue","confusion","sticky","slippery"}

status = {
	StructureGenerated: false
	statuses: {}
}

status.setup = (player) ->
	player = API.getPlayer player
	if not @StructureGenerated
		@createStatus "speed", {
			length: 10
			callback: (player) ->
				-- set state
				originalSpeed or= plr.Character.Status.BaseStats.WalkSpeed
				-- generator callback
				cb = (plr) ->
					with plr.Character.Humanoid
						if .WalkSpeed <= originalWalkSpeed
							.WalkSpeed += 5*.WalkSpeedMultiplier.Value
					-- return the generator
					cb
		}
		@createStatus "poison", {
			length: 10
			callback: (player) ->
				with player.Character
					-- Make sure that we don't go lower than 0 with the multiple.
					.Humanoid.Health -= math.max 0,(5-.Humanoid.BaseDefense.Value*(1+.Humanoid.DefenseMultiplier.Value))
		}
		@createStatus "fatigue", {
			length: 20
			callback: (player) ->
				-- set state
				originalSpeed or= plr.Character.Humanoid.WalkSpeed
				-- generator callback
				cb = (plr) ->
					destructor = (p) ->
						p.Character.Humanoid.WalkSpeed = originalWalkSpeed
					with plr.Character.Humanoid
						if .WalkSpeed > originalWalkSpeed
							.WalkSpeed -= 5*.WalkSpeedMultiplier.Value
					-- return the generator
					cb, 0xBAD, destructor
		}
		@createStatus "confusion", {
			length: 30
			callback: (player) ->
				call_count = 1 -- will be called 100 times
				game.ReplicatedStorage.GUI_Storage.Confusion\Clone!.Parent = player.PlayerGui
				cb = (plr) ->
					destructor = (p) ->
						if p.PlayerGui.Confusion
							p.PlayerGui.Confusion\Destroy!
					if call_count <= 150
						-- get progressively darker as we get closer to 150
						plr.PlayerGui.Confusion.Image.Transparency = math.random (1-1/call_count)
					elseif call_count > 150
						-- get progressively lighter as we get farther from 150
						plr.PlayerGui.Confusion.Image.Transparency = math.random (1/call_count)
					-- only return the callback generator if we HAVE NOT finished the running
					if call_count ~= 300
						call_count += 1
						-- cb: callback; 0xBAD "DO NOT TERM"; destructor: clean up fro term
						cb, 0xBAD, destructor -- 0xBAD tells 'run'er not to terminate this call
		}
		@createStatus "sticky", {
			length: 20
			callback: (player) ->
				runOnce = false
				originalFriction = player.Character.LeftLeg.Friction
				originalWalkSpeed = player.Character.Humanoid.WalkSpeed
				cb = (plr) ->
					destructor = (p) ->
						with p.Character
							.Humanoid.WalkSpeed *= .Humanoid.WalkSpeedMultiplier or 2
							.LeftLeg.Friction = originalFriction
							.RightLeg.Friction = originalFriction
					if not runOnce and not (@getStatuses plr)["slippery"]
						runOnce = true
						with plr.Character
							.Humanoid.WalkSpeed /= .Humanoid.WalkSpeedMultiplier.Value or 2
							.LeftLeg.Friction = originalFriction
							.RightLeg.Friction = originalFriction
						cb, 0xBAD, destructor
		}
		@createStatus "slippery", {
			length: 20
			callback: (player) ->
				runOnce = false
				originalFriction = player.Character.LeftLeg.Friction
				originalWalkSpeed = player.Character.Humanoid.WalkSpeed
				cb = (plr) ->
					destructor = (p) ->
						with p.Character
							.Humanoid.WalkSpeed /= .Humanoid.WalkSpeedMultiplier or 2
							.LeftLeg.Friction = originalFriction
							.RightLeg.Friction = originalFriction
					if not runOnce and not (@getStatuses plr)["sticky"]
						runOnce = true
						with plr.Character
							.Humanoid.WalkSpeed *= .Humanoid.WalkSpeedMultiplier.Value or 2
							.LeftLeg.Friction = originalFriction
							.RightLeg.Friction = originalFriction
						cb, 0xBAD, destructor

		}
	if not player
		error"",2
		false
	(player.Character.Humanoid\FindFirstChild "Status")\Destroy!
	(create "Configuration") {Parent: player.Character, Name: "Status"}

		


status.run = (player) ->
	player = API.getPlayer player
	if not player
		error "",2
		false
	for _,v in pairs player.Character.Status
		if not v.running.Value and not v.forceStop
			Spawn () ->
				state_callback_layer, SIGNAL, DESTRUCTOR, dbg = v.callback player
				-- original callback returned a callback generator and SIGNAL message
				calls_count = 0
				call_end = v.length
				call_inc = 1
				while (wait 1) -- modified 'while' loop acts as a for loop
					if SIGNAL == 0xBAD -- DO NOT TERM (DIRECTLY)
						state_callback_layer, SIGNAL, DESTRUCTOR, dbg = state_callback_layer player
					elseif SIGNAL == 0xDEFACE -- Run DESTRUCTOR before exiting call.
						state_callback_layer, SIGNAL, DESTRUCTOR, dbg = state_callback_layer player
						if v.forceStop
							v.running = false
							DESTRUCTOR player
							break
					elseif SIGNAL == 0xDEAD -- Something went wrong
						-- so log the error with debug info 'dbg' as coming from status.
						LOG\logError dbg, os.time!, "Status"
						-- check to make sure that we have received a DESTRUCTOR
						if DESTRUCTOR
							-- clean up
							DESTRUCTOR player
					-- normal callback
					else
						v.callback player
						if v.forceStop
							v.running = false
							break
					-- break out if we have reached the end of the loop
					if call_count == call_end
						break
					call_count += call_inc



status.stop = (player, s) ->
	player = API.getPlayer player
	if not player
		error "",2
	-- check for valid status ID, and make sure we created it
	if (type s) == "string" and @statuses[s]
		player.Character.Status.v.forceStop = true
	elseif not @statuses[s]
		-- log a detailed traceback, including the time and source
		LOG\logError debug.traceback!, os.time!, "Status"
	else
		for _,v in pairs player.Character.Status
			v.forceStop = true

status.setStatus = (player, s, len=math.huge) ->
	player = API.getPlayer player
	tbk = debug.traceback!
	if not (s and player)
		LOG\logError tbk, nil, "Status"
		false
	-- make sure that the status we're trying to set already exists.
	if @statuses[s]
		len = @statuses[s].length
		if not player.Character.Status[s]
			(create "StringValue") {
				Parent: player.Character.Status
				Name: "status"
				(create "IntValue") {
					Name: "length"
					Value: len
				}
				(create "BoolValue") {Name: "forceStop"}
				(create "BoolValue") {Name: "running"}
				(create "BindableFunction") {
					Name: "callback" 
					Value: @statuses[s].callback
				}
			}
			@run player
		else
			player.Character.Status[s].forceStop = false
			@run player
	else
		LOG\logError "Attempt to set undefined status #{s} on player #{player.Name}", os.time!, "Status"

	(coroutine.wrap status.run) player

status.getStatuses = (player) ->
	player = API.getPlayer player
	if not player
		error "",2
		false
	{{v.status.Value,{length: v.length.Value,forceStop: v.forceStop.Value,running: v.running.Value,callback: v.callback.Value}} for _,v in pairs player.Character.Status}


status.createStatus = (statusName, properties) =>
	if not @statuses[statusName]
		with @statuses[statusName]
			.length = properties.length or math.huge
			.callback = properties.callback

return status