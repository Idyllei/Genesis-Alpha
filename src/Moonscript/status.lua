local API = require("API")
local create = (assert(LoadLibrary("RbxUtil"))).Create
local enum
enum = function(names)
  local __enumId = 0
  local t = { }
  for i, k in pairs(names) do
    if (type(k)) == "table" then
      t[i] = enums(k)
    end
    t[k] = __enumId
    __enumId = __enumId + 1
  end
  return t
end
local BASE_STATS = enum({
  "error",
  "speed",
  "poison",
  "fatigue",
  "confusion",
  "sticky",
  "slippery"
})
local status = {
  StructureGenerated = false,
  statuses = { }
}
status.setup = function(player)
  player = API.getPlayer(player)
  if not self.StructureGenerated then
    self:createStatus("speed", {
      length = 10,
      callback = function(player)
        local originalSpeed = originalSpeed or plr.Character.Status.BaseStats.WalkSpeed
        local cb
        cb = function(plr)
          do
            local _with_0 = plr.Character.Humanoid
            if _with_0.WalkSpeed <= originalWalkSpeed then
              _with_0.WalkSpeed = _with_0.WalkSpeed + (5 * _with_0.WalkSpeedMultiplier.Value)
            end
          end
          return cb
        end
      end
    })
    self:createStatus("poison", {
      length = 10,
      callback = function(player)
        do
          local _with_0 = player.Character
          _with_0.Humanoid.Health = _with_0.Humanoid.Health - math.max(0, (5 - _with_0.Humanoid.BaseDefense.Value * (1 + _with_0.Humanoid.DefenseMultiplier.Value)))
          return _with_0
        end
      end
    })
    self:createStatus("fatigue", {
      length = 20,
      callback = function(player)
        local originalSpeed = originalSpeed or plr.Character.Humanoid.WalkSpeed
        local cb
        cb = function(plr)
          local destructor
          destructor = function(p)
            p.Character.Humanoid.WalkSpeed = originalWalkSpeed
          end
          do
            local _with_0 = plr.Character.Humanoid
            if _with_0.WalkSpeed > originalWalkSpeed then
              _with_0.WalkSpeed = _with_0.WalkSpeed - (5 * _with_0.WalkSpeedMultiplier.Value)
            end
          end
          return cb, 0xBAD, destructor
        end
      end
    })
    self:createStatus("confusion", {
      length = 30,
      callback = function(player)
        local call_count = 1
        game.ReplicatedStorage.GUI_Storage.Confusion:Clone().Parent = player.PlayerGui
        local cb
        cb = function(plr)
          local destructor
          destructor = function(p)
            if p.PlayerGui.Confusion then
              return p.PlayerGui.Confusion:Destroy()
            end
          end
          if call_count <= 150 then
            plr.PlayerGui.Confusion.Image.Transparency = math.random((1 - 1 / call_count))
          elseif call_count > 150 then
            plr.PlayerGui.Confusion.Image.Transparency = math.random((1 / call_count))
          end
          if call_count ~= 300 then
            call_count = call_count + 1
            return cb, 0xBAD, destructor
          end
        end
      end
    })
    self:createStatus("sticky", {
      length = 20,
      callback = function(player)
        local runOnce = false
        local originalFriction = player.Character.LeftLeg.Friction
        local originalWalkSpeed = player.Character.Humanoid.WalkSpeed
        local cb
        cb = function(plr)
          local destructor
          destructor = function(p)
            do
              local _with_0 = p.Character
              _with_0.Humanoid.WalkSpeed = _with_0.Humanoid.WalkSpeed * (_with_0.Humanoid.WalkSpeedMultiplier or 2)
              _with_0.LeftLeg.Friction = originalFriction
              _with_0.RightLeg.Friction = originalFriction
              return _with_0
            end
          end
          if not runOnce and not (self:getStatuses(plr))["slippery"] then
            runOnce = true
            do
              local _with_0 = plr.Character
              _with_0.Humanoid.WalkSpeed = _with_0.Humanoid.WalkSpeed / (_with_0.Humanoid.WalkSpeedMultiplier.Value or 2)
              _with_0.LeftLeg.Friction = originalFriction
              _with_0.RightLeg.Friction = originalFriction
            end
            return cb, 0xBAD, destructor
          end
        end
      end
    })
    self:createStatus("slippery", {
      length = 20,
      callback = function(player)
        local runOnce = false
        local originalFriction = player.Character.LeftLeg.Friction
        local originalWalkSpeed = player.Character.Humanoid.WalkSpeed
        local cb
        cb = function(plr)
          local destructor
          destructor = function(p)
            do
              local _with_0 = p.Character
              _with_0.Humanoid.WalkSpeed = _with_0.Humanoid.WalkSpeed / (_with_0.Humanoid.WalkSpeedMultiplier or 2)
              _with_0.LeftLeg.Friction = originalFriction
              _with_0.RightLeg.Friction = originalFriction
              return _with_0
            end
          end
          if not runOnce and not (self:getStatuses(plr))["sticky"] then
            runOnce = true
            do
              local _with_0 = plr.Character
              _with_0.Humanoid.WalkSpeed = _with_0.Humanoid.WalkSpeed * (_with_0.Humanoid.WalkSpeedMultiplier.Value or 2)
              _with_0.LeftLeg.Friction = originalFriction
              _with_0.RightLeg.Friction = originalFriction
            end
            return cb, 0xBAD, destructor
          end
        end
      end
    })
  end
  if not player then
    local _ = error(""), 2
    _ = false
  end
  (player.Character.Humanoid:FindFirstChild("Status")):Destroy()
  return (create("Configuration"))({
    Parent = player.Character,
    Name = "Status"
  })
end
status.run = function(player)
  player = API.getPlayer(player)
  if not player then
    error("", 2)
    local _ = false
  end
  for _, v in pairs(player.Character.Status) do
    if not v.running.Value and not v.forceStop then
      Spawn(function()
        local state_callback_layer, SIGNAL, DESTRUCTOR, dbg = v.callback(player)
        local calls_count = 0
        local call_end = v.length
        local call_inc = 1
        while (wait(1)) do
          if SIGNAL == 0xBAD then
            state_callback_layer, SIGNAL, DESTRUCTOR, dbg = state_callback_layer(player)
          elseif SIGNAL == 0xDEFACE then
            state_callback_layer, SIGNAL, DESTRUCTOR, dbg = state_callback_layer(player)
            if v.forceStop then
              v.running = false
              DESTRUCTOR(player)
              break
            end
          elseif SIGNAL == 0xDEAD then
            LOG:logError(dbg, os.time(), "Status")
            if DESTRUCTOR then
              DESTRUCTOR(player)
            end
          else
            v.callback(player)
            if v.forceStop then
              v.running = false
              break
            end
          end
          if call_count == call_end then
            break
          end
          local call_count = call_count + call_inc
        end
      end)
    end
  end
end
status.stop = function(player, s)
  player = API.getPlayer(player)
  if not player then
    error("", 2)
  end
  if (type(s)) == "string" and self.statuses[s] then
    player.Character.Status.v.forceStop = true
  elseif not self.statuses[s] then
    return LOG:logError(debug.traceback(), os.time(), "Status")
  else
    for _, v in pairs(player.Character.Status) do
      v.forceStop = true
    end
  end
end
status.setStatus = function(player, s, len)
  if len == nil then
    len = math.huge
  end
  player = API.getPlayer(player)
  local tbk = debug.traceback()
  if not (s and player) then
    LOG:logError(tbk, nil, "Status")
    local _ = false
  end
  if self.statuses[s] then
    len = self.statuses[s].length
    if not player.Character.Status[s] then
      (create("StringValue"))({
        Parent = player.Character.Status,
        Name = "status",
        (create("IntValue"))({
          Name = "length",
          Value = len
        }),
        (create("BoolValue"))({
          Name = "forceStop"
        }),
        (create("BoolValue"))({
          Name = "running"
        }),
        (create("BindableFunction"))({
          Name = "callback",
          Value = self.statuses[s].callback
        })
      })
      self:run(player)
    else
      player.Character.Status[s].forceStop = false
      self:run(player)
    end
  else
    LOG:logError("Attempt to set undefined status " .. tostring(s) .. " on player " .. tostring(player.Name), os.time(), "Status")
  end
  return (coroutine.wrap(status.run))(player)
end
status.getStatuses = function(player)
  player = API.getPlayer(player)
  if not player then
    error("", 2)
    local _ = false
  end
  local _tbl_0 = { }
  for _, v in pairs(player.Character.Status) do
    local _key_0, _val_0 = {
      v.status.Value,
      {
        length = v.length.Value,
        forceStop = v.forceStop.Value,
        running = v.running.Value,
        callback = v.callback.Value
      }
    }
    _tbl_0[_key_0] = _val_0
  end
  return _tbl_0
end
status.createStatus = function(self, statusName, properties)
  if not self.statuses[statusName] then
    do
      local _with_0 = self.statuses[statusName]
      _with_0.length = properties.length or math.huge
      _with_0.callback = properties.callback
      return _with_0
    end
  end
end
return status
