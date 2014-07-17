-- Genesis/src/FilteringEnabledServ.lua
--- @author Spencer T****/branefreez
-- @copyright 2014-2015 Spencer T****/branefreez
-- @release LocalScript$Core$Core1$FilteringEnabledServ$LocalScript


local event = Instance.new("RemoteEvent");
event.Parent = game.Workspace;
event.Name = "FilterEvent";
event.OnServerEvent:connect(function(player, arguments)
  game.Workspace.ColorBrick.BrickColor = BrickColor.Red();
end);