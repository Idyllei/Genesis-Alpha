-- OnTouched_Gui_Client.moon

EVENT = game.Workspace.Client_Server_Communication.BindableEvents.GuiOpen_OnTouchedEvent

char  = game.Players.LocalPlayer.Character

endSize = UDim2.new 1,0,1,0


EVENT.OnClientEvent\connect (guiName) ->
	gui = script.Parent\FindFirstChild guiName
	if not gui
		error "Invalid Gui name fired from GuiOpen_OnTouchedEvent: #{guiName}", 2
	gui\TweenSize endSize