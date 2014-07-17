-- Genesis/src/RemoteEventAPI.lua

-- LuaDoc
--- @author SPencer Tupis,branefreez
-- @copyright Spencer Tupis,branefreez 2014-2015
-- @release Module$Core$Module$RemoteEventAPI$ModuleScript
-- @class module

local REF = {event=Instance.new("RemoteEvent",game.Workspace)};

function REF:sendClient(to,...)
  if (not to) then
    return false,"[DEBUG][ERROR][RemoteEvent]::SendP2P Param `to = nil'";
  end --endif
  print("[DEBUG][RemoteEvent]::sendClient invoked as `sendClient("..tostring(to)..")'");
  if (type(to)=="string" and to:sub()=="all") then
    REF.event:FireAllClients(...);
  elseif (type(to)=="string" and to:sub(1,4)=="not ") then
    if (tonumber(to:sub(5))) then -- "not userId"
      for _,v in pairs(game.Players:GeChildren()) do
        if (v.userId~=tonumber(to:sub(5))) then
          REF.event:FireClient(v,...);
        end --endif
      end --endfor
    else 
      for _,v in pairs(game.Players:GetChildren()) do
        if (v.Name~=to:sub(5)) then -- not playerName
          REF.event:FireClient(v,...);
        end --endif
      end --endfor
    end --endif
  elseif (type(to)=="string") then
    REF.event:FireClient(getPlayer(to),...);
  elseif (type(to)=="number") then
    for _,v in pairs(game.Players:GetChildren()) do
      if (v.userId==to) then -- userId
        REF.event:FireClient(v,...);
      end --endif
    end --endfor
  end --endif
end

function REF:sendServer(...)
  print("[DEBUG][RemoteEvent]::sendServer invoked.");
  REF.event:FireServer(...);
end

function REF:connectOnServerInvoke(lstring)
  if (not not lstring) then
    print("[DEBUG][ERROR][RemoteEvent]::connectOnServerInvoke | `lstring' = nil");
  end --endif
  if (not game.Workspace.LoadstringEnabled) then
    print("[DEBUG][ERROR][RemoteEvent]::connectOnServerInvoke | `game.Workspace.LoadstringEnabled = false'");
  end
end
return REF;