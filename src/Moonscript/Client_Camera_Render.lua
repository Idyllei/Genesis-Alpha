local EventHolder = game.Workspace.EventHolder
local FieldOfViewUpdateEventRawRAW = EventHolder.FieldOfViewUpdateEvent.OnClientEvent
local CameraCFrameUpdateEventRAW = EventHolder.CameraCFrameUpdateEvent.OnClientEvent
local cam = game.Workspace.CurrentCamera
while cam do
  local FoV = FieldOfViewUpdateEventRAW:wait()
  local CamFrame = CameraCFrameUpdateEventRAW:wait()
  for delta = .01, 1, .01 do
    cam.FieldOfView = FoV * delta
    cam.CoordinateFrame = CamFrame * delta
    wait(.0025)
  end
end
