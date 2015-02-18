local EVENT = game.Workspace.Client_Server_Communication.BindableEvents.GuiOpen_OnTouchedEvent
local char = game.Players.LocalPlayer.Character
local endSize = UDim2.new(1, 0, 1, 0)
return EVENT.OnClientEvent:connect(function(guiName)
  local gui = script.Parent:FindFirstChild(guiName)
  if not gui then
    error("Invalid Gui name fired from GuiOpen_OnTouchedEvent: " .. tostring(guiName), 2)
  end
  return gui:TweenSize(endSize)
end)
