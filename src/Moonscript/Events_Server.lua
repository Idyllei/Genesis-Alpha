local xassert
do
  local _obj_0 = require("Xassert")
  xassert = _obj_0.xassert
end
local type_and, type_and_f
do
  local _obj_0 = require("Type_ext")
  type_and, type_and_f = _obj_0.type_and, _obj_0.type_and_f
end
(game:GetService("TeleportService")).CustomizedTeleportUI = true
local INVENTORY = require("Inventory")
local teleportBricks = {
  volcano = (function()
    local _tbl_0 = { }
    for _, v in pairs(game.Workspace.Teleports:GetChildren()) do
      if v.Name:sub():find("volcano%d*$") then
        local _key_0, _val_0 = v
        _tbl_0[_key_0] = _val_0
      end
    end
    return _tbl_0
  end)(),
  aether = (function()
    local _tbl_0 = { }
    for _, v in pairs(game.Workspace.Teleports:GetChildren()) do
      if v.Name:sub():find("aether%d*$") then
        local _key_0, _val_0 = v
        _tbl_0[_key_0] = _val_0
      end
    end
    return _tbl_0
  end)(),
  chthonic = (function()
    local _tbl_0 = { }
    for _, v in pairs(game.Workspace.Teleports:GetChildren()) do
      if v.Name:sub():find("chthonic%d*$") then
        local _key_0, _val_0 = v
        _tbl_0[_key_0] = _val_0
      end
    end
    return _tbl_0
  end)(),
  labrynth = (function()
    local _tbl_0 = { }
    for _, v in pairs(game.Workspace.Teleports:GetChildren()) do
      if v.Name:sub():find("labrynth%d*$") then
        local _key_0, _val_0 = v
        _tbl_0[_key_0] = _val_0
      end
    end
    return _tbl_0
  end)(),
  void = (function()
    local _tbl_0 = { }
    for _, v in pairs(game.Workspace.Teleports:GetChildren()) do
      if v.Name:sub():find("void%d*$") then
        local _key_0, _val_0 = v
        _tbl_0[_key_0] = _val_0
      end
    end
    return _tbl_0
  end)(),
  spawnpoint = (function()
    local _tbl_0 = { }
    for _, v in pairs(game.Workspace.Teleports:GetChildren()) do
      if v.Name:sub():find("spawnpoint%d*$") then
        local _key_0, _val_0 = v
        _tbl_0[_key_0] = _val_0
      end
    end
    return _tbl_0
  end)()
}
local teleportIds = {
  volcano = nil,
  aether = nil,
  chthonic = nil,
  labrynth = nil,
  void = nil,
  spawnpoint = nil
}
local isValidCharacter
isValidCharacter = function(char)
  return (char.ClassName == "Model") and (char.Head.ClassName == "Part")
end
Spawn(function()
  for _, v in pairs(teleportBricks) do
    v["Touched"]:connect(function(char)
      if isValidCharacter(char) then
        return game.ReplicatedStorage.TeleportRequestEvent:FireServer(teleportIds[(v.Name:sub():find("%a%d*$")):find("%a")])
      end
    end)
  end
end)
CoreMaids["PlayerAdded"]["Impact"] = S_PLAYERS.PlayerAdded:connect(function(plr)
  return plr.CharacterAdded:connect(function(chr)
    do
      local _with_0 = script.Impact:Clone()
      _with_0.Parent = chr.Humanoid
      _with_0.Disabled = false
      return _with_0
    end
  end)
end)
game.ReplicatedStorage.TeleportRequestEvent.OnServerEvent:connect(function(plr, placeId)
  local character = plr.Character
  local forceField = Instance.new("ForceField", characters)
  player.OnTeleport:connect(function(tpState)
    if tpState == Enum.TeleportState.Failed then
      game.ReplicatedStorage.TeleportRequestEvent:FireClient(plr)
      return forceField:Destroy()
    end
  end)
  return TeleportService:Teleport(placeId, plr)
end)
return game.ReplicatedStorage.ItemPickupRequestEvent.OnServerEvent:connect(function(plr, itemRef)
  xassert(plr, itemRef, "Invalid call to 'game.ReplicatedStorage.ItemPickupRequestEvent:OnServerEvent(Item)'")
  return (INVENTORY.getInventory(plr)).addItem(itemRef)
end)
