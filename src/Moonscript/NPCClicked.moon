par = script.Parent

for v in par\GetChildren!
	if v\IsA "BasePart"
		loadstring(v\GetFullName! .. ".Clicked:connect(function(plr)\n\tgame.Workspace.FilterEvent:FireClient(plr.Name,\"NPCTalk\",par.NPCId.Value);\nend)")!
