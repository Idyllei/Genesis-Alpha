-- smooth_lerp_intro.moon
pairsByKeys = (t, f=((a,b)->a<b)) ->
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
			a[i], t[a[i]]
	iter

camera = game.Workspace.CurrentCamera
secondsPerSegment = .2
waitDelta = 30/((secondsPerSegment>0) and secondsPerSegment or -secondsPerSegment)
path = {key, value.CFrame for key, value in pairsByKeys {i,brick for i,brick in pairs game.Workspace.CFBricks\GetChildren! when brick.Name\lower!\match "^cfbrick%d+"}}

game.Players.LocalPlayer.CharacterAdded\connect (chr)->
	
	Spawn ->
		chr.Torso.Transparency = 1
		chr.LeftArm.Transparency = 1
		chr.RightArm.Transparency = 1
		chr.LeftLeg.Transparency = 1
		chr.RightLeg.Transparency = 1
		chr.Head.Transparency = 1
		chr.Torso.Anchored = true
		nPoints = #path
		for index = 1, nPoints-1
			for delta = 0,1,1/waitDelta
				a = Vector3.new path[index].x, path[index].y, path[index].z
				b = Vector3.new path[index+1].x, path[index+1].y, path[index+1].z
				position = a + (a-b) * delta
				if path[index+2]
					nextPos = b + (b-(Vector3.new path[index+2].x, path[index+2].y,path[index+2].z)) * delta
				else
					nextPos = b * (1+1/(a-b).magnitude)
				camera.CoordinateFrame = CFrame.new position, nextPos
				wait 1/waitDelta
		chr.Torso.Transparency = 0
		chr.LeftArm.Transparency = 0
		chr.RightArm.Transparency = 0
		chr.LeftLeg.Transparency = 0
		chr.RightLeg.Transparency = 0
		chr.Head.Transparency = 0
		chr.Torso.Anchored = false