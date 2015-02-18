-- Events_Server.lua

import xassert from require "Xassert"
import type_and, type_and_f from require "Type_ext"

(game\GetService "TeleportService").CustomizedTeleportUI = true

INVENTORY = require "Inventory"

teleportBricks = {
	volcano:   {v for _,v in pairs game.Workspace.Teleports\GetChildren! when v.Name\sub!\find "volcano%d*$"}
	aether:    {v for _,v in pairs game.Workspace.Teleports\GetChildren! when v.Name\sub!\find "aether%d*$"}
	chthonic:  {v for _,v in pairs game.Workspace.Teleports\GetChildren! when v.Name\sub!\find "chthonic%d*$"}
	labrynth:  {v for _,v in pairs game.Workspace.Teleports\GetChildren! when v.Name\sub!\find "labrynth%d*$"}
	void:      {v for _,v in pairs game.Workspace.Teleports\GetChildren! when v.Name\sub!\find "void%d*$"}
	spawnpoint:{v for _,v in pairs game.Workspace.Teleports\GetChildren! when v.Name\sub!\find "spawnpoint%d*$"}
}

teleportIds = {
	volcano: nil
	aether: nil
	chthonic: nil
	labrynth: nil
	void: nil
	spawnpoint: nil
}

isValidCharacter = (char) ->
	-- Use the traditional method to check for a Head (Part) in a Model
	(char.ClassName == "Model") and (char.Head.ClassName == "Part")

-- Set up the main control
Spawn ->
	-- use a Direct-Reference instead of look-up for `Touched` event.
	-- (which Maximizes efficiency)
	for _,v in pairs teleportBricks
		v["Touched"]\connect (char) ->
			if isValidCharacter char
				game.ReplicatedStorage.TeleportRequestEvent\FireServer teleportIds[(v.Name\sub!\find "%a%d*$")\find "%a"]

-- Fall-Damage Setup
CoreMaids["PlayerAdded"]["Impact"] = S_PLAYERS.PlayerAdded\connect (plr) ->
			plr.CharacterAdded\connect (chr) ->
				with script.Impact\Clone!
					.Parent = chr.Humanoid
					.Disabled = false

-- Main Teleport Structure:
game.ReplicatedStorage.TeleportRequestEvent.OnServerEvent\connect (plr,placeId) ->
	-- Give char FF for protection
	character = plr.Character
	forceField = Instance.new "ForceField", characters
	-- Handle rare cases where TP fails
	player.OnTeleport\connect (tpState) ->
		if tpState == Enum.TeleportState.Failed
			game.ReplicatedStorage.TeleportRequestEvent\FireClient plr
			forceField\Destroy!
	-- TP player to the other place
	TeleportService\Teleport placeId, plr

-- Main Item Pickup Structure:
game.ReplicatedStorage.ItemPickupRequestEvent.OnServerEvent\connect (plr, itemRef) ->
	-- Check to make sure 'plr' and 'itemRef' are valid
	xassert plr, itemRef, "Invalid call to 'game.ReplicatedStorage.ItemPickupRequestEvent:OnServerEvent(Item)'"
	(INVENTORY.getInventory plr).addItem itemRef