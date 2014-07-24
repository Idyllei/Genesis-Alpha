wait = wait
Spawn=Spawn
math=math
collectgarbage=collectgarbage
getmetatable,setmetatable,table=getmetatable,setmetatable,table
print = print

Create=assert(LoadLibrary("RbxUtil")).Create

Shop=require "Shop"
tab = require "TabOp"

towns = {volcano:{}, void:{}, aether:{},chthonic:{},palace:{}}
towns.populateTownPoints=->
	for v in game.Workspace.Towns\GetChildren!
		if v.Name\sub 1,4 == "town"
			for p in v\GetChildren!
				if p.Name\sub 1,5 == "point"
					towns[v.Name\sub 5][#towns[v.Name\sub 5]] = p.Value
	return nil



chatBubbleImages = {}

class NPCPlayer
	new: (char,spawnTown) =>
		_G.CurNPCId+=1
		o = getmetatable()
		o.Character=char
		o.SpawnTown=spawnTown
		o.NPCId=_G.CurNPCId
		o.Shop=Shop.new spawnTown
		setmetatable(o, {
			"__index":o,
			"__gc":->
				@Character=nil
				collectgarbage "collect"
		})
	Spawn: (townName) =>
		NPCChar=game\GetService("ServerStorage")\FindFirstChild("NPCChar")\Clone!
		spawnTown=tab.trand(towns[townName] and townName or tab.trand(towns))
		NPCChar.NPCId.Value=_G.CurNPCId
		NPCChar.HumanoidRootPart.Position=tab.trand towns[townName]
		NPCChar.Parent=game.Workspace
		return self\new NPCChar,spawnTown
	WalkToRandom: =>
		self\MoveToPosition tab.trand towns[self.SpawnTown]
	MoveToPosition: (point) =>
		if @IsTalking
			die "[DEBUG][INFO][NPCPlayer]::MoveToPosition|Attempt to call `MoveToPosition` with invalid parameters.",2
		pfs=game\GetService "PathfindingService"
		path=pfs\ComputeRawPathAsync @Character.HumanoidRootPart.Position,point,2048
		if path.Status == Enum.PathStatus.Success
			coords=path\GetPointCoords!
			Traverse=->
				for v in coords
					Spawn ->
						print "[DEBUG][NPCPlayer]::MoveToPosition|Moving NPC to position: Vector3.new(#{v.x},#{v.y},#{v.z})."
						@Character\FindFirstChild("Humanoid")\MoveTo v
					distance=(point - @Character.HumanoidRootPart.Position).magnitude
					while distance > 2 or @IsTalking
						distance=(point - @Character.HumanoidRootPart.Position).magnitude
						wait!
					if @IsTalking
						break
					elseif path\IsIntersected!
						coords=pfs\ComputeRawPathAsync @Character.HumanoidRootPart.Position,point,2048
						Traverse()
						break
		Traverse!
	RemoveCharacter: =>
		setmetatable self,{"__mode":"kv"}
		collectgarbage "collect"
	LoadCharacterAppearance: =>
		(@Character\FindFirstChild "Shirts" or Instance.new "Shirt", @Character).ShirtTemplate=@ShirtsTemplateURL
		(@Character\FindFirstChild "Pants" or Instance.new "Pants", @Character).PantsTemplate=@PantsTemplateURL
	DistanceFromCharacter: (point) =>
		math.sqrt (@Character.HumanoidRootPart.Position.x^2-point.x^2)+(@Character.HumanoidRootPart.Position.y^2-point.y^2)+(@Character.HumanoidRootPart.Position.z^2-point.z^2)
	StopTalking: =>
		@IsTalking=false
	Talk: (other) =>
		if not other
			return
		if @IsTalking and (@TalkingTo\sub(1,3) ~= "NPC")
			return
		if (@Character.HumanoidRootPart.Position-other.Character.HumanoidRootPart.Position).magnitude < 10
			@IsTalking=true
			@TalkingTo=other
		while @IsTalking
			chatbubble= Create("billboardGui")({
				Parent:@Character.Head,
				Offset:Vector3.new math.random(0,.5),1.5,math.random(0,.5)
				Create("Image")({
					Image:tab.trand chatBubbleImages
				})
			})
			wait math.random(7.5,10)
			chatBubble\Destroy!
			if (@Character.HumanoidRootPart.Position-other.Character.HumanoidRootPart.Position)>10
				@IsTalking=false
	Name:"NPC"
	userId:-1
	NPCId:-1
	Character:"" -- nil
	ShirtTemplateURL:""
	PantsTemplateURL:""
	SpawnTown:""
	Shop:"" -- nil
	IsTalking:false
	TalkingTo:"" -- nil