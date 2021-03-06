local API = {
  _Inventory = require("Inventory"),
  _PlayerSettings = require("PlayerSettings"),
  config = require("towns.config"),
  _GlobalSettings = {
    ops = { },
    banned = { },
    priveledged = { },
    punished = { },
    locked = { },
    commands = { }
  }
}
API.shorter = function(a, b)
  if a and b then
    return (#a <= #b) and a or b
  else
    return a or b
  end
end
API.getPlayers = function()
  local _tbl_0 = { }
  for v in game.Players:GetPlayers() do
    _tbl_0[v] = v.Name
  end
  return _tbl_0
end
API.getPlayerHealth = function(self, ...)
  if ... then
    local _tbl_0 = { }
    for i, v in pairs({
      ...
    }) do
      _tbl_0[i] = (self:getPlayer(v)).Character.Humanoid.Health
    end
    return _tbl_0
  end
  error("", 2)
  return { }
end
API.getPlayerStatus = function(self, ...)
  if #{
    ...
  } >= 1 then
    local _tbl_0 = { }
    for i, v in pairs({
      ...
    }) do
      _tbl_0[i] = (self:getPlayer(v)).Character.Humanoid.Status.Value
    end
    return _tbl_0
  else
    error("", 2)
    return { }
  end
end
API.setPlayerStatus = function(self, stat, ...)
  for i, v in pairs({
    ...
  }) do
    ((self:getPlayer(v)).Character:FindFirstChild("Humanoid")).Status.Value = stat
  end
  if #{
    ...
  } > 0 then
    return true
  else
    error("", 2)
    return false
  end
end
API.animateDeath = function(self, player)
  for v in (self:getPlayer(player)).Character:GetChildren() do
    pcall(function()
      v.Transparency = 1
    end)
  end
  if self._PlayerSettings[(self:getPlayer(player)).Name].SaveInventory then
    self._Inventory.savePlayerInventory((self:getPlayer(player)).Name)
  end
  return ((self:getPlayer(player)).playerGui:FindFirstChild("RespawnButton")).MouseButton1Click:connect(function()
    return self:respawnPlayer(self:getPlayer(player))
  end)
end
API.loadPlayerSkin = function(self, player)
  if player then
    ((self:getPlayer(player)).Character:FindFirstChild("Shirt")).ShirtTemplate = "http://www.roblox.com/asset/?id=" .. (((game:GetService("DataStoreService")):GetGlobalDataStore()):GetAsync((self:getPlayer(player)).Name)) .. "$shirtTemplate"
    ((self:getPlayer(player)).Character:FindFirstChild("Pants")).PantsTemplate = "http://www.roblox.com/asset/?id=" .. (((game:GetService("DataStoreService")):GetGlobalDataStore()):GetAsync((self:getPlayer(player)).Name)) .. "$pantsTemplate"
    return true
  else
    error("", 2)
    return false
  end
end
API._GlobalSettings.commands.reloadSkins = function(self, user)
  for _, plr in pairs(self:getPlayers()) do
    self:loadPlayerSkin(plr)
  end
end
API._GlobalSettings.commands.op = function(self, user, player)
  if player then
    table.insert(self._GlobalSettings.ops, (self:getPlayer(player)).Name)
    return true
  else
    error("", 2)
    return false
  end
end
API._GlobalSettings.commands.deOp = function(self, user, player)
  if player then
    local playerName = (self:getPlayer(player)).Name
    local pos = nil
    for i, v in pairs(self:getPlayers()) do
      if v == playerName then
        pos = i
        break
      end
    end
    table.remove(self._GlobalSettings.ops, pos)
    return true
  else
    error("", 2)
    return false
  end
end
API._GlobalSettings.commands.kick = function(self, user, player)
  if player then
    local playerName = (self:getPlayer(player)).Name
    if (self.config.gentleKick == 1) then
      self:saveCheckpoint(self.player)
    end
    (self:getPlayer(player)):Kick()
    coroutine.resume(coroutine.create(function()
      local now = tick()
      while tick() > (now + 30) do
        coroutine.yield()
      end
      return game.Players.PlayerAdded:connect(function(p)
        if (self:getPlayer(p)).Name == PlayerName then
          return p:Kick()
        end
      end)
    end))
    return true
  else
    error("", 2)
    return false
  end
end
API._GlobalSettings.commands.ban = function(self, user, player)
  if player then
    (self:getPlayer(player)):Kick()
    table.insert(self._GlobalSettings.banned, (self:getPlayer(player)).Name)
    return true
  else
    error("", 2)
    return false
  end
end
API.getNPCHealth = function(mouse)
  return mouse.Target.Humanoid.Health
end
API.getNPCMaxHealth = function(mouse)
  return mouse.Target.Humanoid.MaxHealth
end
API.saveCheckpoint = function(self, player)
  return print("[DEBUG][API] saveCheckpoint = (player) Still in ALPHA-dev.")
end
API.changeSetting = function(self, setting, value)
  if not (setting and value) then
    error("", 2)
    local _ = false
  end
  if (((type(Value)) == (type(self._GlobalSettings[setting]))) or (self._GlobalSettings[setting] == nil)) then
    self._GlobalSettings[setting] = value
    return true
  else
    error("", 2)
    return false
  end
end
API.getPlayerPosition = function(self, player)
  if player then
    return ((self:getPlayer(player)).Character:findFirstChild("HumanoidRootPart")).Position
  else
    error("", 2)
    return false
  end
end
API.setCameraNormal = function(self, player)
  local LFPLocal = ((game:GetService("ReplicatedStorage")):FindFirstChild("LFPLocal")):Clone()
  LFPLocal.Parent = (self:getPlayer(player)).Character
  LFPLocal.Disabled = false
  if player then
    return true
  else
    error("", 2)
    return false
  end
end
API.setCameraFixed = function(self, player)
  local CFixedLocal = ((game:GetService("ReplicatedStorage")):FindFirstChild("CameraFixedLocal")):Clone()
  CfixedLocal.Parent = (self:getPlayer(player)).Character
  CFixedLocal.Disabled = false
  if player then
    return true
  else
    error("", 2)
    return false
  end
end
API.setCameraFollow = function(self, player)
  local CFollowLocal = ((game:GetService("ReplicatedStorage")):FindFirstChild("CameraFollowLocal")):Clone()
  CFollowLocal.Parent = (self:getPlayer(player)).Character
  CFollowLocal.Disabled = false
  if player then
    return true
  else
    error("", 2)
    return false
  end
end
API.setCameraPosition = function(self, player, vec3)
  if player and vec3 then
    local CSetPosLocal = ((game:GetService("ReplicatedStorage")):FindFirstChild("CSetPosLocal")):Clone()
    CSetPosLocal.Position.Value = vec3
    CSetPosLocal.Parent = (self:getPlayer(player)).Character
    CSetPosLocal.Disabled = false
    return true
  else
    error("", 2)
    return false
  end
end
API.getPlayerIds = function()
  local _tbl_0 = { }
  for v in game.Players:GetPlayers() do
    local _key_0, _val_0 = v.userId
    _tbl_0[_key_0] = _val_0
  end
  return _tbl_0
end
API.postToChat = function(self, player, msg)
  return print("[DEBUG][API] postToChat = (player,msg) Is still in ALPHA-dev.")
end
