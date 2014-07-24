local par = script.Parent
for v in par:GetChildren() do
  if v:IsA("BasePart") then
    loadstring(v:GetFullName() .. ".Clicked:connect(function(plr)\n\tgame.Workspace.FilterEvent:FireClient(plr.Name,\"NPCTalk\",par.NPCId.Value);\nend)")()
  end
end
