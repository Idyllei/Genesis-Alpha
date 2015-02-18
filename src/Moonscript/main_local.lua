local CONFIG = require("towns.config")
local API = require("API")
local PLAYERS = game.Players
local HEARTBEAT = (game:GetService("RunService")).Heartbeat
local DATA_STORE = game:GetService("DataStoreService")
return PLAYERS.PlayerAdded:connect(function(plr)
  if (DATA_STORE:GetDataStore("Bank")):GetAsync(plr.Name) then
    local playerData = (DATA_Store:GetAsync("Stats")):GetAsync(plr.Name)
    plr:LoadCharacter()
    plr.Character.Humanoid.Torso.CFrame = playerData.StandingPositionCFrame
    do
      local _with_0 = plr.PlayerGui:FindFirstChild("Loading")
      for i = 0, 1, wait() do
        _with_0.Transparency = i
      end
      return _with_0
    end
  end
end)
