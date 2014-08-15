-- Items.moon

from sys import thread,pack -- coroutine.resume coroutine.create `func`, pack (opposite of unpack)
Math = require "Math"
NotImplemented = require "NotImplemented"
S_DATA_STORE = game\GetService "DataStoreService"

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
		["<<<ROOT>>>"]= 0x4df8f86e536372ef7074 -- MøønScrïpt
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
		}
		class Scarab_Charm
			new: (plrName) =>
				setmetatable {
					Name: "Scarab_Charm"
					Id: Items.Charms.Id["Scarab_Charm"]
					Owner: API.getPlayer plrName
					callback: =>
						(S_DATA_STORE\GetDataStore "Inventory")\SetAsync (@Owner.Name),API.GetInventory (@Owner.Name)
					use: => @callback!
				},{
					__call: =>
						@callback!
				}
		class Djed_Charm
			new: (plrName) =>
				setmetatable {
					Name: "Djed_Charm"
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
		class Isis_Curse_Charm
			new: (plrName) =>
				setmetatable {
					Name: "Isis_Curse_Charm"
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
		class Amethyst_Luck_Amulet
			new: (plrName)=>
				setmetatable {
					Name: "Amethyst_Luck_Amulet"
					Id: Items.Charms.Id["Amethyst_Luck_Amulet"]
					Owner: API.getPlayer plrName
					callback: =>
						if not not @Owner
							(S_DATA_STORE\GetDataStore "Bounty_Luck")\UpdateAsync @Owner.Name, (val) ->
								val * (Math.random 1.25,1.625)
							(S_DATA_STORE\GetDataStore "Bounty_Luck")\GetAsync @Owner.Name
					use: =>
						@callback!
				},{
					__call: =>
						print "[DEBUG][CHARMS]|Amethyst_Luck_Amulet called on player ".. @Owner.Name
						@use!
				}
		class Sun_Stone_Utere_Fexix_Luck_Charm
			new: (plrName) =>
				setmetatable {
					Name: "Sun_Stone_Utere_Fexix_Luck_Charm"
					Id: Items.Charms.Id["Sun_Stone_Utere_Fexix_Luck_Charm"]
					Owner: API.getPlayer plrName
					callback: =>
						if not not @Owner
							(S_DATA_STORE\GetDataStore "Bounty_Luck")\UpdateAsync @Owner.Name, (val) ->
								val * (Math.random 1.5,1.875)
							(S_DATA_STORE\GetDataStore "Bounty_Luck")\GetAsync @Owner.Name
					use: =>
						@callback!
				},{
					__call: =>
						print "[DEBUG][CHARMS]|Sun_Stone_Utere_Fexix_Luck_Charm called on player ".. @Owner.Name
						@use!
				}
		class Wedjat_Eye_Amulet -- Provides a health buff and higher health
			new: (plrName) =>
				setmetatable {
					Name: "Wedjat_Eye_Amulet"
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
		class Evil_Eye_Amulet
			new: (plrName) =>
				setmetatable {
					Name: "Evil_Eye_Amulet"
					Id: Items.Charms.Id["Evil_Eye_Amulet"]
					Owner: API.getPlayer plrName
					callback: =>
						if not not @Owner
							thread ->
								(game.ReplicatedStorage\FindFirstChild "AttackedEvent").OnServerEvent\connect (attacker,recipient,damage) ->
									if not not recipient
										attacker.Character.Humanoid\TakeDamage damage*.1 -- give them 10% of the damage they delt to us
										(S_DATA_STORE\GetDataStore "Bounty_Luck")\UpdateAsync attacker.Name, (val) ->
											val * (Math.random .7,.85)
										(S_DATA_STORE\GetDataStore "Bounty_Luck")\GetAsync attacker.Name
					use: =>
						@callback!
				},{
					__call: =>
						NotImplemented "Evil_Eye_Amulet", "!", ->
							error "Not NotImplemented",2
				}
		class Lapis_Lazuli_Amulet
			new: (plrName) =>
				setmetatable {
					Name: "Lapis_Lazuli_Amulet"
					Id: Items.Charms.Id["Lapis_Lazuli_Amulet"]
					Owner: API.getPlayer plrName
					maxUses: 5
					nUses: 0
					callback: =>
						if not not @Owner
							(S_DATA_STORE\GetDataStore "Bounty_Luck")\UpdataAsync @Owner.Name, (val) ->
								val * (Math.random 1.2,1.51)
							(S_DATA_STORE\GetDataStore "Bounty_Luck")\GetAsync @Owner.Name
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
		class Isis_Knot
			new: (plrName) =>
				setmetatable {
					Name: "Isis_Knot"
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
		class Plummet_Amulet
			new: (plrName) =>
				setmetatable {
					Name: "Plummet_Amulet"
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
		class Sesen_Charm
			new: (plrName) =>
				setmetatable {
					Name: "Sesen_Charm"
					Id: Items.Charms.Id["Sesen_Charm"]
					Owner: API.getPlayer plrName
					maxUses: 10
					nUses: 0
					callback: =>
						(S_DATA_STORE\GetDataStore "Inventory")\SetAsync (@Owner.Name),API.GetInventory (@Owner.Name)
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
		class Double_Plume_Feathers_Amulet
			new: (plrName) =>
				setmetatable {
					Name: "Double_Plume_Feathers_Amulet"
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
					Create "BodyForce" {
						force: (Vector3.new 0,192.6,0) * (GetMass (API.getPlayer plrName).Character)
						Parent: (API.getPlayer plrName).Character.Humanoid.Torso
					}
					thread ->
						game.player.PlayerAdded\connect (plr) ->
							plr.CharacterAdded\connect (chr) ->
								Create "BodyForce" {
									force: (Vector3.new 0,192.6,0) * (GetMass chr)
									Parent: chr.Character.Humanoid.Torso
								}
		class Shen_Amulet
			new: (plrName) =>
				setmetatable {
					Name: "Shen_Amulet"
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
						if plr.Name == @Owner.Name
							plr.CharacterAdded\connect (chr) ->
								with chr
									.MaxHealth *= 2.5
									.Health = .MaxHealth
		class Ieb_Charm
			new: (plrName) =>
				setmetatable {
					Name: "Ieb_Charm"
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
					chr = API.getPlayer plrName
					if not not chr
						while chr and wait 1.25
							chr.Humanoid.Health = Math.min chr.Humanoid.MaxHealth,(chr.Humanoid.Health + chr.Humanoid.Health * Math.random .1,.5525)
				thread ->
					game.Players.PlayerAdded\connect (plr) ->
						if plr.Name == plrName
							plr.CharacterAdded\connect ->
								thread (chr) ->
									if not not chr
										while chr and wait 1.25
											chr.Humanoid.Health = Math.min chr.Humanoid.MaxHealth,(chr.Humanoid.Health + chr.Humanoid.Health * Math.random .1,.5525)
		class Imenet_charm
			
	}
}