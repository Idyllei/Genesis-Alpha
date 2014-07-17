-- Genesis/src/FilteringEnabledLocal.lua
--- @author Spencer T****/branefreez
-- @copyright 2014-2015 Spencer T****/branefreez
-- @release LocalScript$Core$Core1$FilteringEnabledLocal$LocalScript
local type,pcall,error=type,pcall,error;
local event=game.Workspace:WaitForChild("FilterEvent");
local clickDetector = Instance.new("ClickDetector");
clickDetector.Parent = game.Workspace.ColorBrick;
clickDetector.MouseClick:connect(function(hit)
  game.Workspace.FilterEvent:FireServer("test");
end);

event.FireClient:connect(function(...)
  if (arg) then -- `arg' is a hidden variable that contains the arguments passed through with the variadic argument operator `...'
    if (arg.n == 3) then
      if (type(arg[1])=="string") then -- Its a Player's Name
        if (arg[1]==game.Players.LocalPlayer.Name) then -- Affects this player
          if (type(arg[2])=="string") then -- It tells the type of command
            if (arg[2]=="NPCTalk") then -- We are talking to an NPC
              if (type(arg[3])=="number") then -- This is the NPCId of whom we are talking to.
                openShop(arg[3]); -- Open the shop for the NPC whom we are talking to.
              end
            end
          end
        end
      end
    end
  else
    pcall(error,"[DEBUG][ERROR][FilteringEnabledLocal] `event.fireClient:connect()| No arguements passed to FilterEvent.",0);
  end
end);