local distance = 30
game.Players.CharacterAutoLoads = false
local EventHolder
do
  local _with_0 = (game.Workspace.EventHolder or (Instance.new("Configuration", game.Workspace)))
  if not _with_0.Name == "EventHolder" then
    _with_0.Name = "EventHolder"
  end
  EventHolder = _with_0
end
local FieldOfViewUpdateEvent
do
  local _with_0 = (EventHolder.FieldOfViewUpdateEvent or (Instance.new("BindableEvent", game.Workspace)))
  if not _with_0.Name == "FieldOfViewUpdateEvent" then
    _with_0.Name = "FieldOfViewUpdateEvent"
  end
  FieldOfViewUpdateEvent = _with_0
end
local CameraCFrameUpdateEvent
do
  local _with_0 = (EventHolder.CameraCFrameUpdateEvent or (Instance.new("BindableEvent", game.Workspace)))
  if not _with_0.Name == "CameraCFrameUpdateEvent" then
    _with_0.Name = "CameraCFrameUpdateEvent"
  end
  CameraCFrameUpdateEvent = _with_0
end
local ArenaRemovingEvent
do
  local _with_0 = (EventHolder.ArenaRemovingEvent or (Instance.new("BindableEvent", game.Workspace)))
  if not _with_0.Name == "ArenaRemovingEvent" then
    _with_0.Name = "ArenaRemovingEvent"
  end
  ArenaRemovingEvent = _with_0
end
local ArenaAddingEvent
do
  local _with_0 = (EventHolder.ArenaAddingEvent or (Instance.new("BindableEvent", game.Workspace)))
  if not _with_0.Name == "ArenaAddingEvent" then
    _with_0.Name = "ArenaAddingEvent"
  end
  ArenaAddingEvent = _with_0
end
local pairsByKeys
pairsByKeys = function(t, f)
  local a = { }
  for n in pairs(t) do
    table.insert(a, n)
  end
  table.sort(a, f)
  local i = 0
  local iter
  iter = function()
    i = i + 1
    if a[i] == nil then
      return nil
    else
      return a[i], t[a[i]]
    end
  end
  return iter
end
local removeByKey
removeByKey = function(t, k, f)
  local NIL = {
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0
  }
  local a = { }
  if (type(k)) == "table" then
    for _k in pairs(k) do
      for n in pairs(t) do
        if n ~= _k then
          table.insert(a, n)
        end
      end
    end
  else
    for n in pairs(t) do
      if n ~= k then
        table.insert(a, n)
      end
    end
  end
  table.sort(a, f)
  local _tbl_0 = { }
  for _, n in pairs(a) do
    local _key_0, _val_0 = {
      n,
      t[a[n]]
    }
    _tbl_0[_key_0] = _val_0
  end
  return _tbl_0
end
local CenterPointOfArena = (game.Workspace.CurrentArena:FindFirstChild("CenterPoint")).Position
local charDists = { }
local center
do
  local _with_0 = (Instance.new("Part", game.Workspace))
  _with_0.Name = "CenterPoint"
  _with_0.Size = Vector3.new(1, 1, 1)
  _with_0.Transparency = 1
  _with_0.Anchored = true
  _with_0.CanCollide = false
  center = _with_0
end
local cameraOffset
do
  local lookVec = center.CFrame.lookVector
  local v = Vector3.new(0, 0, 0)
  if (lookVec.x > 0) then
    v = v + Vector3.new(lookVec.x, 0, 0)
  end
  if (lookVec.z > 0) then
    v = v + Vector3.new(0, 0, lookVec.z)
  end
  v = v * distance
  cameraOffset = v
end
ArenaRemovingEvent.OnServerEvent:connect(function()
  for _, plr in pairs(game.Players:GetPlayers()) do
    plr.Character:BreakJoints()
  end
  local spawnCharacterAllowed = false
  return ArenaAddingEvent.OnServerEvent:connect(function(newArena)
    CenterPointOfArena = (game.Workspace.CurrentArena:FindFirstChild("CenterPoint")).Position
    local spawnCharactersAllowed = true
    for _, plr in pairs(game.Players:GetPlayers()) do
      plr:LoadCharacter()
    end
  end)
end)
game.Players.PlayerAdded:connect(function(player)
  player.CharacterAdded:connect(function(char)
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
      humanoid.Died:connect(function()
        wait(respawnTime)
        if spawnCharactersAllowed then
          return player:LoadCharacter()
        else
          while not spawnCharactersAllowed do
            wait()
          end
          return player:loadCharacter()
        end
      end)
    end
    while wait(.25) do
      charDists[player.Name] = (CenterPointOfArena - char.Torso.Position).magnitude
    end
  end)
  player.CharacterRemoving:connect(function()
    return removeByKey(charDists, player.Name)
  end)
  return player:LoadCharacter()
end)
while true do
  local highestDist = 0
  local highestPlayer = ""
  local secHighestDist = 0
  local secHighestPlayer = ""
  for plr, dist in pairsByKeys(charDists) do
    if dist > highestDist then
      secHighestDist = highestDist
      secHighestPlayer = highestPlayer
      highestDist = dist
      highestPlayer = plr
    end
  end
  local mLineView = (Vector3.new(game.Players[highestPlayer].Character.Torso.Position.x, 0, game.Players[highestPlayer].Character.Torso.Position.z)) - (Vector3.new(game.Players[secHighestPlayer].Character.Torso.Position.x, 0, game.Players[secHighestPlayer].Character.Torso.Position.z)).magnitude
  center.Position = Vector3.new((game.Players[highestPlayer].Character.Torso.Position.x + game.Players[secHighestPlayer].Character.Torso.Position.x) / 2, (game.Players[HighestPlayer].Character.Torso.Position.y + game.Players[secHighestPlayer].Character.Torso.Position.y) / 2, (game.Players[highestPlayer].Character.Torso.Position.z + game.Players[secHighestPlayer].Character.Torso.Position.z) / 2)
  local FoV = math.deg(2 * math.atan(.5 * (mLineOfView / 30)))
  local camFrame = CFrame.new(((Vector3.new(center.Position.x, center.Position.y, center.Position.z)) + cameraOffset))
  for delta = .01, 1, .01 do
    FieldOfViewUpdateEvent:FireClient(FoV * delta)
    delay(1 / 30, function()
      return CameraCFrameUpdateEvent:FireAllClients(camFrame * delta)
    end)
    wait(.0025)
  end
end
