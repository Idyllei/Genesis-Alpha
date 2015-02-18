-- Impact.moon

import log from require "stdlog"

lowestFallHeight = 16 --how many studs you must fall before damage is inflicted
maxFallHeight = 64 --if fallen from this many studs, 100% of health will be inflicted

humanoid = script.Parent
character = humanoid.Parent
torso = character.Torso

isFalling = false
deb = false

humanoid.FreeFalling\connect (falling) ->
	isFalling = falling
	-- if the faller owns a `Djed_Charm`, then they don't take fall damage.
	if (INVENTORY.getInventory API.getPlayer humanoid.Parent.Name).hasItem "Djed_Charm"
		LOG\logDebug "Fall-damage cancelled for owner of Djed_Charm #{humanoid.Parent.Name}", nil, "Impact->Charms"
		return
	-- player has Plummet_Amulet, take 25% less damage
	elseif (INVENTORY.getInventory API.getPlayer humanoid.Parent.Name).hasItem "Plummet_Amulet"
		LOG\logDebug "Fall-damage reduced for owner of Plummet_Amulet #{humnaoid.Parent.Name}", nil, "Impact->Charms"
		if isFalling and not deb
			deb = true
			maxHeight = 0
			while isFalling
				height = math.abs torso.Position.y
				if height > maxHeight
					maxHeight = height
				wait!
			fallHeight = maxHeight - torso.Position.y -- studs fallen
			impactHeight = fallHeight - lowestFallHeight
			--print character.Name.. " fell "  .. math.floor(fallHeight + 0.5) .. " studs."
			if impactHeight > 0 then
				damage = impactHeight * (humanoid.MaxHealth / maxFallHeight)
				humanoid\TakeDamage damage*.75
			deb = false
	-- Does not own Djed_Charm or Plummet_Amulet, so take full damage
	elseif isFalling and not deb
		deb = true
		maxHeight = 0
		while isFalling
			height = math.abs torso.Position.y
			if height > maxHeight
				maxHeight = height
			wait!
		fallHeight = maxHeight - torso.Position.y -- studs fallen
		impactHeight = fallHeight - lowestFallHeight
		--print character.Name.. " fell "  .. math.floor(fallHeight + 0.5) .. " studs."
		if impactHeight > 0 then
			damage = impactHeight * (humanoid.MaxHealth / maxFallHeight)
			humanoid\TakeDamage damage
		deb = false