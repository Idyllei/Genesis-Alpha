local S_PLAYERS = game.Players
local EVENT
do
  local _with_0 = Instance.new("BindableEvent")
  _with_0.Name = "GuiOpen_OnTouchedEvent"
  do
    local _with_1 = Instance.new("Configuration")
    _with_1.Name = "BindableEvents"
    do
      local _with_2 = Instance.new("Configuration")
      _with_2.Name = "Client_Server_Communication"
      _with_2.Parent = game.Workspace
      _with_2.Parent = _with_2
    end
    _with_1.Parent = _with_1
  end
  EVENT = _with_0
end
local players = game.Players:GetPlayers()
local brickSignal = game.Workspace.OnTouch_Gui_Brick
local guiName = "PUT GUI NAME HERE"
brickSignal.Touched:connect(function(toucher)
  local char = toucher.Parent
  local plr = S_PLAYERS:GetPlayerFromCharacter(char)
  if plr then
    return EVENT:FireClient(plr, guiName)
  end
end)
S_PLAYERS.PlayerAdded:connect(function()
  players = S_PLAYERS:GetPlayers()
end)
return S_PLAYERS.PlayerRemoving:connect(function()
  players = S_PLAYERS:GetPlayers()
end)
