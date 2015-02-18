local log
do
  local _obj_0 = require("stdlog")
  log = _obj_0.log
end
local lowestFallHeight = 16
local maxFallHeight = 64
local humanoid = script.Parent
local character = humanoid.Parent
local torso = character.Torso
local isFalling = false
local deb = false
return humanoid.FreeFalling:connect(function(falling)
  isFalling = falling
  if (INVENTORY.getInventory(API.getPlayer(humanoid.Parent.Name))).hasItem("Djed_Charm") then
    LOG:logDebug("Fall-damage cancelled for owner of Djed_Charm " .. tostring(humanoid.Parent.Name), nil, "Impact->Charms")
    return 
  elseif (INVENTORY.getInventory(API.getPlayer(humanoid.Parent.Name))).hasItem("Plummet_Amulet") then
    LOG:logDebug("Fall-damage reduced for owner of Plummet_Amulet " .. tostring(humnaoid.Parent.Name), nil, "Impact->Charms")
    if isFalling and not deb then
      deb = true
      local maxHeight = 0
      while isFalling do
        local height = math.abs(torso.Position.y)
        if height > maxHeight then
          maxHeight = height
        end
        wait()
      end
      local fallHeight = maxHeight - torso.Position.y
      local impactHeight = fallHeight - lowestFallHeight
      if impactHeight > 0 then
        local damage = impactHeight * (humanoid.MaxHealth / maxFallHeight)
        humanoid:TakeDamage(damage * .75)
      end
      deb = false
    end
  elseif isFalling and not deb then
    deb = true
    local maxHeight = 0
    while isFalling do
      local height = math.abs(torso.Position.y)
      if height > maxHeight then
        maxHeight = height
      end
      wait()
    end
    local fallHeight = maxHeight - torso.Position.y
    local impactHeight = fallHeight - lowestFallHeight
    if impactHeight > 0 then
      local damage = impactHeight * (humanoid.MaxHealth / maxFallHeight)
      humanoid:TakeDamage(damage)
    end
    deb = false
  end
end)
