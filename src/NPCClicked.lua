local par=script.Parent;
-- local plrs=game.Players:GetPlayers();
for v in par:GetChildren() do
  if (v:IsA("Part")) then
    loadstring(v:GetFullName()..
    [[.ClickDetector.MouseClick:connect(function(plr)
      game.Workspace.FilterEvent:FireClient(plr.Name,"NPCTalk",par.NPCId.Value);
    end]])();
  end
end
--[[
local function getNearestPlayer()
  local nearestPlayers={};
  local indexes={};
  for p in game.Players:GetPlayers() do
    nearestPlayers[math.floor((p.Character.HumanoidRootPart.Position-par.HumanoidRootPart.Position).magnitude)]=p.Name;
  end
  for i,_  in pairs(nearestPlayers) do
    table.insert(indexes,i);
  end
  tables.sort(indexes);
  return nearestPlayers[indexes[1] ];
end
--]]