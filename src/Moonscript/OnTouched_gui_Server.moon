-- OnTouched_Gui_Server.moon

-- What it does:
-- This script sends a signal to the player when they touch a specified brick.
-- The relative script on the Cleint's machine will recieve the signal and
-- open the GUI specified with the signal.

-- Signal: Server->signal(Player toPlayer, String guiName)
-- Received: Client->signal(String guiName)

-- SETUP:
S_PLAYERS = game.Players

EVENT = with Instance.new "BindableEvent" -- game.Workspace.Client_Server_Communication.BindableEvents.GuiOpen_OnTouchedEvent
	.Name = "GuiOpen_OnTouchedEvent"
	.Parent = with Instance.new "Configuration" -- game.Workspace.Client_Server_Communication.BindableEvents
		.Name = "BindableEvents"
		.Parent = with Instance.new "Configuration" -- game.Workspace.Client_Server_Communication
			.Name = "Client_Server_Communication"
			.Parent = game.Workspace

players = game.Players\GetPlayers! -- Players to keep track of...

-- SETTINGS:

brickSignal = game.Workspace.OnTouch_Gui_Brick -- Put the path to the brick here that you want to open the GUI
guiName = "PUT GUI NAME HERE"
-- CORE:
-- Brick touched, open gui
brickSignal.Touched\connect (toucher) ->
	char = toucher.Parent
	plr = S_PLAYERS\GetPlayerFromCharacter char
	if  plr -- Character is child of Player
		EVENT\FireClient plr, guiName -- Tell client to open gui

-- Update on player added
S_PLAYERS.PlayerAdded\connect ->
	players = S_PLAYERS\GetPlayers!

-- Update on player removed
S_PLAYERS.PlayerRemoving\connect ->
	players = S_PLAYERS\GetPlayers!