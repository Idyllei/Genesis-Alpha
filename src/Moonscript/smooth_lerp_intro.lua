local pairsByKeys
pairsByKeys = function(t, f)
  if f == nil then
    f = (function(a, b)
      return a < b
    end)
  end
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
local camera = game.Workspace.CurrentCamera
local secondsPerSegment = .2
local waitDelta = 30 / ((secondsPerSegment > 0) and secondsPerSegment or -secondsPerSegment)
local path
do
  local _tbl_0 = { }
  for key, value in pairsByKeys((function()
    local _tbl_1 = { }
    for i, brick in pairs(game.Workspace.CFBricks:GetChildren()) do
      if brick.Name:lower():match("^cfbrick%d+") then
        _tbl_1[i] = brick
      end
    end
    return _tbl_1
  end)()) do
    _tbl_0[key] = value.CFrame
  end
  path = _tbl_0
end
return game.Players.LocalPlayer.CharacterAdded:connect(function(chr)
  return Spawn(function()
    chr.Torso.Transparency = 1
    chr.LeftArm.Transparency = 1
    chr.RightArm.Transparency = 1
    chr.LeftLeg.Transparency = 1
    chr.RightLeg.Transparency = 1
    chr.Head.Transparency = 1
    chr.Torso.Anchored = true
    local nPoints = #path
    for index = 1, nPoints - 1 do
      for delta = 0, 1, 1 / waitDelta do
        local a = Vector3.new(path[index].x, path[index].y, path[index].z)
        local b = Vector3.new(path[index + 1].x, path[index + 1].y, path[index + 1].z)
        local position = a + (a - b) * delta
        if path[index + 2] then
          local nextPos = b + (b - (Vector3.new(path[index + 2].x, path[index + 2].y, path[index + 2].z))) * delta
        else
          local nextPos = b * (1 + 1 / (a - b).magnitude)
        end
        camera.CoordinateFrame = CFrame.new(position, nextPos)
        wait(1 / waitDelta)
      end
    end
    chr.Torso.Transparency = 0
    chr.LeftArm.Transparency = 0
    chr.RightArm.Transparency = 0
    chr.LeftLeg.Transparency = 0
    chr.RightLeg.Transparency = 0
    chr.Head.Transparency = 0
    chr.Torso.Anchored = false
  end)
end)
