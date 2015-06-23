-- Impact.moon

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
    print "[DEBUG][CHARMS] Fall-damage cancelled for owner of Djed_Charm (" .. humanoid.Parent.Name .. ")"
    return
  elseif (INVENTORY.getInventory API.getPlayer humanoid.Parent.Name).hasItem "Plummet_Amulet"
    print "[DEBUG][CHARMS] Fall-damage reduced for owner of Plummet_Amulet (" .. hmunaoid.Parent.Name .. ")"
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
    -- print "character.Name.. " fell "  .. math.floor(fallHeight + 0.5) .. " studs."
    if impactHeight > 0 then
      damage = impactHeight * (humanoid.MaxHealth / maxFallHeight)
      humanoid\TakeDamage damage*.75
    deb = false
    -- stop here
    return
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
    -- print "character.Name.. " fell "  .. math.floor(fallHeight + 0.5) .. " studs."
    if impactHeight > 0 then
      damage = impactHeight * (humanoid.MaxHealth / maxFallHeight)
      humanoid\TakeDamage damage
    deb = false