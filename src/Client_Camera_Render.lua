-- Client_Camera_Render.lua

local EventHolder = game.Workspace.EventHolder

-- `OnClientEvent` is the RAW event, not an object, but a ROBLOX back-end userdata value
local FieldOfViewUpdateEventRAW = EventHolder.FieldOfViewUpdateEvent.OnClientEvent
local CameraCFrameUpdateEventRAW = EventHolder.CameraCFrameUpdateEvent.OnClientEvent

local cam = game.Workspace.CurrentCamera

while cam do
	local FoV = FieldOfViewUpdateEventRAW:wait()
	local CamFrame = CameraCFrameUpdateEventRAW:wait()
	for delta = .01, 1, .01 do
		cam.FieldOfView = FoV * delta
		cam.CoordinateFrame = CamFrame * delta
		-- LOOK! HERE'S THE PART THAT THE PLAYERS SHOULD UPDATE THEIR SETTINGS FOR!
		wait(.0025)
		-- This allows us to do this entire update loop in 1/4 of a second, and then start the next.
	end
end