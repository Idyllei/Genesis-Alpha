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
local E = {
  stat = {
    enum({
      "error",
      "speed",
      "poison",
      "fatigue",
      "confusion",
      "hallucinate"
    })
  }
}
local status = { }
status.setup = function(player)
  player = API.getPlayer(player)
  if not player then
    local _ = error(""), 2
    _ = false
  end
  (player.Character.Humanoid:findFirstChild("Status")):Destroy()
  return (create("Configuration"))({
    Parent = player.Character.Humanoid,
    Name = "Status",
    (create("StringValue"))({
      Name = "status"
    }),
    (create("IntValue"))({
      Name = "length"
    }),
    (create("BoolValue"))({
      Name = "forceStop"
    }),
    (create("BindableFunction"))({
      Name = "callback"
    })
  })
end
status.run = function(player)
  player = API.getPlayer(player)
  if not player then
    error("", 2)
    local _ = false
  end
  for i = 0, 1, player.Character.Status.length do
    if player.Character.Humanoid.Status.forceStop.IntValue then
      break
    end
    player.character.Humanoid.Status.callback()
    wait(1)
  end
end
status.stop = function(player)
  player = API.getPlayer(player)
  if not player then
    error("", 2)
  end
  player.character.Humanoid.Status.forceStop = true
  wait(1)
  player.Character.Humanoid.Status.forceStop = false
end
status.setStatus = function(player, s, len)
  player = API.getPlayer(player)
  if not (s and player) then
    error("", 2)
    local _ = false
  end
  player.Charcter.Humanoid.Status.status.Value = s
  player.Character.Humanoid.Status.length.Value = len or math.huge
  return (coroutine.wrap(status.run))(player)
end
status.getStatus = function(player)
  player = API.getPlayer(player)
  if not player then
    error("", 2)
    local _ = false
  end
  return player.Character.Humanoid.Status.status.Value
end
return status
