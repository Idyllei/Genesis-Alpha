-- Genesis/src/status.lua

--- @author Spencer Tupis
-- @copyright 2014-2015 Spencer Tupis,branefreez
-- @release Module$Core$Module$status$ModuleScript
-- @class module

local API=require("API");
local create=assert(LoadLibrary("RbxUtil")).Create;
function enum( names )
  local __enumID=0; 
  local t={};
  for i,k in ipairs(names) do
    if (type(k)=="table") then
      t[i]=enum{k};
    end --endif
    t[k]=__enumID;
    __enumID = __enumID+1;
  end --endfor
  return t;
end --endfunction enum

local E={stat=enum{"error","speed","poison","fatigue","confusion","hallucinate"}};



local status={};

function status.setup(player)
  player = API.getPlayer(player);
  if (not player) then
    error("[DEBUG][ERROR][status]::setup|Attempt to call `setup' without player parameter.",2);
    return;
  end
  player.Character.Humanoid:FindFirstChild("Status"):Destroy();
  create"Configuration"{
    Parent=player.Character.Humanoid,
    Name="Status",
    create"StringValue"{Name="status"},
    create"IntValue"{Name="length"},
    create"BoolValue"{Name="forceStop"},
    create"BindableFunction"{Name="callback"}
  };
end

function status.run(player)
  player=Api.getPlayer(player);
  if (not player) then
    error("");
    return;
  end
  print("[DEBUG][status]::run|Running status.");
  for i = 0,1,player.Character.Humanoid.Status.length do
    if (player.Character.Humanoid.Status.forceStop) then
      break;
    else
      player.Character.Humanoid.Status.callback();
      wait(1);
    end
  end
  print("[DEBUG][status]::run|Status execution complete. Ending status.");
  return;
end

function status.stop(player)
  player=API.getPlayer(player);
  if (not player) then
    error("");
  end
  print("[DEBUg][status]::stop|Stopping status.");
  player.Character.Humanoid.Status.forceStop=true;
  wait(1);
  player.Character.Humanoid.Status.forceStop=false;
end

function status.setStatus(player,s,len)
  if (not (s and player)) then
    error("[DEBUG][ERROR][status]::setStatus|Attempt to call `setStatus' with invalid parameters (nil param)",2);
    return nil;
  end
  player.Character.Humanoid.Status.status=s;
  player.Character.Humanoid.Status.length=len;
  print("[DEBUG][status]::setStatus|Returning wrapped coroutine. Call returned value to run new status.");
  return coroutine.wrap(status.run)(player);
end

function status.getStatus(player)
  player=API.getPlayer(player);
  if (not player) then
    error("");
    return;
  end
  return player.Character.Humanoid.Status.status;
end

return status;