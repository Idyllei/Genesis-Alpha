wait = wait
Spawn=Spawn
math=require "Math"
collectgarbage=collectgarbage
getmetatable,setmetatable,table=getmetatable,setmetatable,table
print = print
import die from require "Sys"

Shop=require "Shop"
tab = require "TabOp"

towns = {volcano:{}, void:{}, aether:{},chthonic:{},palace:{}}
towns.populateTownPoints= ->
	for town in game.Workspace.Towns\GetChildren!
		if town.Name\sub 1,4 == "town" -- Python: Name = r"town_NAME"
			for p in town\GetChildren!
				if p.Name\sub 1,5 == "point" -- TOWN.point (Name = r"point.*")
					table.insert towns[town.Name\sub 5], p.Value -- `p' is an ObjectValue
	return nil



chatBubbleImages = {}

create_=(assert LoadLibrary "RbxUtil").Create
Create = (cName,properties) -> 
	-- Lua: create_ "Part" {Size=Vector3.new(3,3,3), Parent = Workspace}
	-- Moonscript: (create "Part") {Size: (Vector3.new 3,3,3), Parent = Workspace}
	(create_ cName) properties
	--// REPLACES THE `Create` FUNCTION PROVIDED THROUGH RbxUtil LIBRARY
	-- cName obj = new cName(properties)
	--// Create a new object of class `cName`
	-- obj = Instance.new cName
	--// Set all ofits properties in a loop
	--  for i,v in properties
	-- 	obj[i] = v
	-- return obj

-- NPC_TYPE:
-- 0: {0:Debug}
-- 1: {0: Debug, 1: Player}
-- 2: {
-- 	  0: Debug
-- 	  1: Vendor_Generic
-- 	  2: Blacksmith
-- 	  3: Cattle Herder
-- 	  4: Bibliophile
-- 	  5: Mage
--    6: Soothsayer
--    7: Necromancer
--    8: Healer
--    9: Judge
-- }
-- 3: {
--    0: Debug_Animal
--    1: Swine
--    2: Ovine (sheep)
--    3: Cattle
--    4: Goose
--    5: Chicken
--    6: Wolf
--    7: Bat
--    8: Alligator
--    8: Elephant
--    9: Crane
--    10: Butterfly
-- }

class NPC
	new: (characterModel = (game.ServerStorage\FindFirstChild "NPCCharacterModel"), spawnTown = tab.trand towns) =>
		-- Get a copy of the CharacterModel
		@Character = characterModel\Clone!
		-- Assign a NPC ID
		@Character.NPCId = _G.NPCId_Counter
		-- Update the counter
		_G.NPCId_Counter += 1
		-- Set it's base stats
		@Character.Humanoid.MaxHealth = @MAX_HEALTH[@Character.NPC_TYPE.Value][@Character.NPC_TYPE.Clarifier.Value]
		@Character.Humanoid.Health = @Character.Humanoid.MaxHealth
		@Character.Humanoid.WalkSpeed = @WALKSPEED[@Character.NPC_TYPE.Value][@Character.NPC_TYPE.Clarifier.Value]
		-- Set its spawn town
		-- `SpawnTown' is an ObjectValue
		@Character.SpawnTown.Value = spawnTown.Name
		-- Set it's shop if it is a Vendor NPC (2)
		@setShop tab.trand @SHOPS[@Character.NPC_TYPE.Value][@Character.NPC_TYPE.Clarifier.Value]
		--Set the Skin of the mob [0][0] is the Default character skin
		@setSkin @SKINS[@Character.NPC_TYPE.Value][@Character.NPC_TYPE.Clarifier.Value]

	setSkin: (skin) =>
		--- @TODO Implement NPC.SKINS[][].Shirt and NPC.SKINS[][].Pants
		shirt = @Character.Skin or ((create "Shirt") {Parent: @Character})
		shirt.ShirtTemplateUrl = @SKINS[0][0].Shirt,
		pants = @Character.Skin or ((create "Pants") {Parent: @Character})
		pants.PantsTemplateUrl = @SKINS[0][0].Pants
	setShop: (shop) =>
		--- @TODO Implement NPC.SHOPS[][] = {{},{},{}}
		shop or= tab.trand @SHOPS[0][0]
		shop = tab.shuffle shop
		-- `Shop' is a TableValue
		@Character.Shop.Value = shop
	Spawn: (spawnTown = tab.trand towns) =>
		spawnPoint = tab.trand spawnTown.spawnPoints
		-- `SpawnPoint' is an ObjectValue
		@Character.SpawnPoint.Value = spawnPoint
		with @Character
			.HumanoidRootPart.CFrame = spawnPoint.CFrame + Vector3.new 0, .HumanoidRootPart.Position.Y, 0
			.Parent = game.Workspace


-- NPCMobile is a Server-Rendered mobile NPC
class NPCMobile extends NPC
	new: (cModel, sTown) =>
		super cModel, sTown
	WalkToRandom: =>
		@MoveToPosition tab.trand towns[@SpawnTown.Value]
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
						Traverse!
						break
		Traverse!
	RemoveCharacter: =>
		@Character\Destroy!
	LoadCharacterAppearance: =>
		(@Character\FindFirstChild "Shirt" or Instance.new "Shirt", @Character).ShirtTemplate=@SKINS[@Character.NPC_TYPE.Value][@Character.NPC_TYPE.Clarifier.Value].Shirt
		(@Character\FindFirstChild "Pants" or Instance.new "Pants", @Character).PantsTemplate=@SKINS[@Character.NPC_TYPE.Value][@Character.NPC_TYPE.Clarifier.Value].Pants
	DistanceFromCharacter: (point) =>
		math.sqrt (@Character.HumanoidRootPart.Position.x^2-point.x^2)+(@Character.HumanoidRootPart.Position.y^2-point.y^2)+(@Character.HumanoidRootPart.Position.z^2-point.z^2)
	StopTalking: =>
		@IsTalking=false
	Talk: (other) =>
		unless other
			return
		-- Don't interrupt the conversation with the other player
		if @IsTalking and (@TalkingTo\sub(1,3) ~= "NPC")
			return
		if (@Character.HumanoidRootPart.Position-other.Character.HumanoidRootPart.Position).magnitude < 10
			@IsTalking=true
			@TalkingTo=other
		while @IsTalking
			chatbubble = (create "BillboardGui") {
				Parent:@Character.Head,
				Offset:Vector3.new math.random(0,.5),1.5,math.random(0,.5)
				(create "Image") {
					Image:tab.trand chatBubbleImages
				}
			}
			wait math.random 7.5,10
			chatBubble\Destroy!
			if (@Character.HumanoidRootPart.Position-other.Character.HumanoidRootPart.Position)>10
				@IsTalking=false
	Name:"NPC"
	userId:-1
	NPCId:-1
	Character:"" -- nil
	ShirtTemplateURL:""
	PantsTemplateURL:""
	SpawnTown:"" -- // "volcano","void","aether","chthonic","palace"
	Shop:"" -- nil
	IsTalking:false
	TalkingTo:"" -- nil

class Player
	new: (plr, plrId, skin) =>
		-- Get character
		with plr.Character
			-- Set character Skin
			(\FindFirstChild "Shirt" or (Create "Shirt" {Parent = .})).ShirtTemplateUrl = (DS_PLAYER_SKIN\GetAsync plrId).Shirt
			(\FindFirstChild "Pants" or (Create "Pants" {Parent = .})).PantsTemplateUrl = (DS_PLAYER_SKIN\GetAsync plrId).Pants
			-- Set the character's name by fetching from the DataStore
			.Name = (((game\GetService "DataStoreService")\GetDataStore "InGameNames")\GetAsync plrId) or plr.Name
			-- Set their properties from the DataStore Storage medium
			stats = (S_DATA_STORE\GetDataStore "Stats")\GetAsync plr.Name
			.Humanoid.WalkSpeed = stats.Humanoid.WalkSpeed
			.Humanoid.Health = stats.Humanoid.Health
			.Humanoid.MaxHealth = stats.Humanoid.MaxHealth

return NPCPlayer