-- Items.moon
_E = {
	TABLET_TYPE:
		IGNIS: 		 1 -- FIRE
		AQUAM: 		 2 -- WATER
		TERRA: 		 3 -- EARTH
		AERIS: 		 4 -- AIR
		NIHIL: 		 5 -- VOID
		AETHERE: 	 6 -- AETHER     HEAVENS/SKY
		NITE: 		 7 -- LIFE
		OBITUS: 	 8 -- DEATH      SETTING/LAST DAY
		AES: 		 9 -- METAL
		GLACIEM: 	10 -- ICE
		VAPOS: 		11 -- STEAM
		FUMUS: 		12 -- SMOKE
		ANIMA: 		13 -- BREATH     LIFE/MOVEMENT
		ORIENS: 	14 -- Most powerful @ dawn
		UMBRA: 		15 -- Most powerful @ dusk
		MERIDIES: 	16 -- Most powerful when sun @ Zenith
		IVORTO: 	17 -- INVERT     OVERTHROW/OPPOSITE
		ROBORO: 	18 -- STRENGTHEN
		SALUS: 		19 -- HEALTH
		DEFAECO: 	20 -- PURIFY
		POLLUO: 	21 -- TAINT      OBSCURE/CLOUD
		SPIRITUS: 	22 -- Having to do with the SPIRIT world
		CHAUS: 		23 -- CHAOS      UNDERWORLD
}
{:thread,:pack} = require "Sys" -- coroutine.resume coroutine.create `func`, pack (opposite of unpack)
math = require "Math"
NotImplemented = require "NotImplemented"
S_DATA_STORE = game\GetService "DataStoreService"
INVENTORY = require "Inventory"
class Item
	new: =>
		setmetatable {
			Name: ""
			Id: Items.Id["<<<ROOT>>>"]
			Owner: nil
			callback: =>
				return
			use: =>
				@callback!
		},{
			__call: =>
				@use!
		}

Items = {
	Id:{
		["<<<ROOT>>>"]= "0x4df8f86e      " -- MøønLua
	}
	Charms:{
		Id:{
			ERROR: 0
			Scarab_Charm: 1
			Djed_Charm: 2
			Isis_Curse_Charm: 3
			Amethyst_Luck_Amulet: 4
			Sun_Stone_Utere_Fexix_Luck_Charm: 5
			Wedjat_Eye_Amulet: 6
			Evil_Eye_Amulet: 7
			Lapis_Lazuli_Amulet: 8
			Isis_Knot: 9
			Plummet_amulet: 10
			Sesen_Charm: 11
			Double_Plume_Feathers_Amulet: 12
			Shen_Amulet: 13
			Ieb_Charm: 14
			Ka_Charm: 15
			Menhed_Charm: 16
		}
		class Scarab_Charm extends Item
			new: (plrName) =>
				setmetatable {
					Name: "Scarab Charm"
					Id: Items.Charms.Id["Scarab_Charm"]
					Owner: API.getPlayer plrName
					callback: =>
						(S_DATA_STORE\GetDataStore "Inventory")\SetAsync (@Owner.userId),INVENTORY.getInventory (@Owner.userId)
					use: => @callback!
				},{
					__call: =>
						@callback!
				}
		class Djed_Charm extends Item
			new: (plrName) =>
				setmetatable {
					Name: "Djed Charm"
					Id: Items.Charms.Id["Djed_Charm"]
					Owner: API.getPlayer plrName
					callback: =>
						NotImplemented "callback","!", -> nil
					use: => @callback!
				},{
					__call: (...) =>
						print "[DEBUG][CHARMS]|Djed_Charm called with arguements:\t#{unpack {...}}"
						return ...
				}
		class Isis_Curse_Charm extends Item
			new: (plrName) =>
				setmetatable {
					Name: "Isis Curse Charm"
					Id: Items.Charms.Id["Isis_Curse_Charm"]
					Owner: API.getPlayer plrName
					callback: (player) =>
						player = API.getPlayer player
						if not not player
							with (script.Parent\FindFirstChild "Isis_Curse")\Clone!
								.Parent = player.character.Humanoid
								.Disabled = false
					use: (player) =>
						@callback player
				},{
					__call: (player,...) =>
						print "[DEBUG][CHARMS]|Isis_Curse_Charm called on player ".. (API.getPlayer player).Name
						@use player
				}
		class Amethyst_Luck_Amulet extends Item
			new: (plrName)=>
				setmetatable {
					Name: "Amethyst Luck Amulet"
					Id: Items.Charms.Id["Amethyst_Luck_Amulet"]
					Owner: API.getPlayer plrName
					callback: =>
						if not not @Owner
							(S_DATA_STORE\GetDataStore "Bounty_Luck")\UpdateAsync @Owner.userId, (val) ->
								val * (math.random 1.25,1.625)
							(S_DATA_STORE\GetDataStore "Bounty_Luck")\GetAsync @Owner.userId
					use: =>
						@callback!
				},{
					__call: =>
						print "[DEBUG][CHARMS]|Amethyst_Luck_Amulet called on player ".. @Owner.Name
						@use!
				}
		class Sun_Stone_Utere_Fexix_Luck_Charm extends Item
			new: (plrName) =>
				setmetatable {
					Name: "Sun Stone 'Utere Fexix' Luck Charm"
					Id: Items.Charms.Id["Sun_Stone_Utere_Fexix_Luck_Charm"]
					Owner: API.getPlayer plrName
					callback: =>
						if not not @Owner
							(S_DATA_STORE\GetDataStore "Bounty_Luck")\UpdateAsync @Owner.userId, (val) ->
								val * (math.random 1.5,1.875)
							(S_DATA_STORE\GetDataStore "Bounty_Luck")\GetAsync @Owner.userId
					use: =>
						@callback!
				},{
					__call: =>
						print "[DEBUG][CHARMS]|Sun_Stone_Utere_Fexix_Luck_Charm called on player ".. @Owner.Name
						@use!
				}
		class Wedjat_Eye_Amulet extends Item -- Provides a health buff and higher health
			new: (plrName) =>
				setmetatable {
					Name: "Wedjat Eye Amulet"
					Id: Items.Charms.Id["Wedjat_Eye_Amulet"]
					Owner: API.getPlayer plrName
					callback: =>
						if not not @Owner
							Owner.Character.Humanoid.MaxHealth *= 1.25
							Owner.Character.Humanoid.Health = Owner.Character.Humanoid.MaxHealth
					use: =>
						@callback!
				},{
					__call: =>
						print "[DEBUG][CHARMS]|Wedjat_Eye_Amulet called on player ".. @Owner.Name
						@use!
				}
		class Evil_Eye_Amulet extends Item
			new: (plrName) =>
				setmetatable {
					Name: "Evil Eye Amulet"
					Id: Items.Charms.Id["Evil_Eye_Amulet"]
					Owner: API.getPlayer plrName
					callback: =>
						if not not @Owner
							thread ->
								(game.ReplicatedStorage\FindFirstChild "AttackedEvent").OnServerEvent\connect (attacker,recipient,damage) ->
									if not not recipient
										attacker.Character.Humanoid\TakeDamage damage*.1 -- give them 10% of the damage they delt to us
										(S_DATA_STORE\GetDataStore "Bounty_Luck")\UpdateAsync attacker.userId, (val) ->
											val * (math.random .7,.85)
										(S_DATA_STORE\GetDataStore "Bounty_Luck")\GetAsync attacker.userId
					use: =>
						@callback!
				},{
					__call: =>
						NotImplemented "Evil_Eye_Amulet", "!", ->
							error "Not NotImplemented",2
				}
		class Lapis_Lazuli_Amulet extends Item
			new: (plrName) =>
				setmetatable {
					Name: "Lapis Lazuli Amulet"
					Id: Items.Charms.Id["Lapis_Lazuli_Amulet"]
					Owner: API.getPlayer plrName
					maxUses: 5
					nUses: 0
					callback: =>
						if not not @Owner
							(S_DATA_STORE\GetDataStore "Bounty_Luck")\UpdatAsync @Owner.userId, (val) ->
								val * (math.random 1.2,1.51)
							(S_DATA_STORE\GetDataStore "Bounty_Luck")\GetAsync @Owner.userId
					use: =>
						-- add to the use counter
						@nUses += 1
						-- call the callback
						@callback!
						-- check to make sure we haven't used it too much
						if nUses >= @maxUses
							@Destroy!
				},{
					__call: =>
						print "[DEBUG][CHARMS]|Lapis_Lazuli_Amulet called on player ".. @Owner.Name
						@use!
				}
		class Isis_Knot extends Item
			new: (plrName) =>
				setmetatable {
					Name: "Isis Knot"
					Id: Items.Charms.Id["Isis_Knot"]
					Owner: API.getPlayer plrName
					callback: =>
						NotImplemented "Isis_Knot","!",->
							error "NotImplemented",2
					use: =>
						@callback!
				},{
					__call: =>
						@use!
				}
				thread ->
					while ((INVENTORY.getInventory plrName).hasItem "Isis_Knot") and values = pack (game.ReplicatedStorage\FindFirstChild "AttackedEvent").OnServerEvent\wait!
						attacker,recipient,damage,type_ = unpack values
						if recipient == API.getPlayer plrName
							if type_ ~= "direct"
								recipient.Humanoid\TakeDamage damage
							else
								print "[DEBUG][CHARMS]|Isis_Knot Blocked damage from direct attack on " .. plrName
		class Plummet_Amulet extends Item
			new: (plrName) =>
				setmetatable {
					Name: "Plummet Amulet"
					Id: Items.Charms.Id["Plummet_Amulet"]
					Owner: API.getPlayer plrName
					callback: =>
						NotImplemented "Plummet_Amulet","!",->
							error "NotImplemented",2
					use: => @callback!
				},{
					__call: =>
						@use!
				}
		class Sesen_Charm extends Item
			new: (plrName) =>
				setmetatable {
					Name: "Sesen Charm"
					Id: Items.Charms.Id["Sesen_Charm"]
					Owner: API.getPlayer plrName
					maxUses: 10
					nUses: 0
					callback: =>
						(S_DATA_STORE\GetDataStore "Inventory")\SetAsync (@Owner.userId),API.getInventory (@Owner.userId)
						@Owner\LoadCharacter!
						-- Loading of the player's Inventory will be handled in the main script
					use: =>
						nUses += 1
						@callback!
						if @nUses >= @maxUses
							@Destroy!
				},{
					__call: =>
						@use!
				}
		class Double_Plume_Feathers_Amulet extends Item
			new: (plrName) =>
				setmetatable {
					Name: "Double Plume Feathers Amulet"
					Id: Items.Charms.Id["Double_Plume_Feathers_Amulet"]
					Owner: API.getPlayer plrName
					callback: =>
						NotImplemented "Double_Plume_Feathers_Amulet","!",->
							error "NotImplemented",2
					use: =>
						@callback!
				},{
					__call: =>
						@use!
				}
				if not not API.getPlayer plrName
					Create "BodyForce", {
						force: (Vector3.new 0,192.6,0) * (GetMass (API.getPlayer plrName).Character)
						Parent: (API.getPlayer plrName).Character.Humanoid.Torso
					}
					thread ->
						game.player.PlayerAdded\connect (plr) ->
							plr.CharacterAdded\connect (chr) ->
								Create "BodyForce", {
									force: (Vector3.new 0,192.6,0) * (GetMass chr)
									Parent: chr.Character.Humanoid.Torso
								}
		class Shen_Amulet extends Item
			new: (plrName) =>
				setmetatable {
					Name: "Shen Amulet"
					Id: Items.Charms.Id["Shen_Amulet"]
					Owner: API.getPlayer plrName
					callback: =>
						NotImplemented "Shen_Amulet","!",->
							error "NotImplemented",2
					use: =>
						@callback!
				},{
					__call: =>
						@use!
				}
				with (API.getPlayer plrName).Character
					.MaxHealth *= 2.5
					.Health = .MaxHealth
				thread ->
					game.Players.PlayerAdded\connect (plr) ->
						if plr.userId == @Owner.userId
							plr.CharacterAdded\connect (chr) ->
								with chr
									.MaxHealth *= 2.5
									.Health = .MaxHealth
		class Ieb_Charm extends Item
			new: (plrName) =>
				setmetatable {
					Name: "Ieb Charm"
					Id: Items.Charms.Id["Ieb_Charm"]
					Owner: API.getPlayer plrName
					callback: =>
						NotImplemented "Ieb_Charm","!",->
							error "NotImplemented",2
					use: => @callback!
				},{
					__call: =>
						@use!
				}
				thread ->
					(chr = API.getPlayer plrName).Character
					if not not chr
						while chr and wait 1.25
							chr.Humanoid.Health = math.min chr.Humanoid.MaxHealth,(chr.Humanoid.Health + chr.Humanoid.Health * math.random .1,.5525)
				thread ->
					game.Players.PlayerAdded\connect (plr) ->
						if plr.Name == plrName
							plr.CharacterAdded\connect ->
								thread (chr) ->
									if not not chr
										while chr and wait 1.25
											chr.Humanoid.Health = math.min chr.Humanoid.MaxHealth,(chr.Humanoid.Health + chr.Humanoid.Health * math.random .1,.5525)
		class Imenet_Charm extends Item
			new: =>
				setmetatable {
					Name: "Imenet Charm"
					Id: Items.Charms.Id["Imenet_Charm"]
					Owner: API.getPlayer plrName
					callback: =>
						if false --- TODO: substitute `false` (in Imenet_Charm::callback) with condition that is true if sun is near dusk
							while Owner.Character.Humanoid.Health < Owner.Character.Humanoid.MaxHealth
								with Owner.Character.Humanoid
									.Health = math.min .MaxHealth,.Health*(.Health/.MaxHealth+.125)

				},{
					__index = 
				}
		class Ka_Charm extends Item
			new: =>
				setmetatable {
					Name: "Ka Charm"
					Id: Items.Charms.Id["Ka_Charm"]
					Owner: API.getPlayer plrName
					coThread: nil
					callback: =>
						if not coThread
							coThread = thread ->
								while wait!
									if (tonumber (game.Workspace.TimeOfDay\sub 1,2)) >= 19
										with Owner.Character
											while wait math.random .5,.75
												.Humanoid.Health = math.min (.Humanoid.Health+.Humanoid.MaxHealth*.5/math.pi),(.Humanoid.MaxHealth)
												if (.Humanoid.Health == .Humanoid.MaxHealth)
													break
					use: =>
						@callback!
				},{
					__call: =>
						@use!
				}
		class Menhed_Charm extends Item
			-- Allows owner to craft tablets for less mana.
			new: (plrName) =>
				setmetatable {
					Name: "Menhed Charm"
					Id: Items.Charms.Id["Menhed_Charm"]
					Owner: API.getPlayer plrName
					callback: (cost)=>
							cost * math.random .675,.9
					use: (cost) =>
						@callback cost
				},{
					__call: (cost) =>
						@use cost
				}
		
	}
}