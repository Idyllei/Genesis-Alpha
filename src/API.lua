-- Genesis/src/API.lua
--- @author Spencer Tupis
-- @copyright 2014-2015 Spencer Tupis,branefreez
-- @release Module$Core$Module$API$ModuleScript
-- @class module

local API={};
API._PlayerSettings=require("PlayerSettings");
API._Inventory=require("Inventory");
API.config=require("genesis.config");
function API.getPlayer(Player) --Player instance
  return type(Player) == "string" and game.Players:FindFirstChild(Player) or type(Player) == "userdata" and (pcall( function() return Player.Character ~= nil end) and Player) or (type(Player)=="number") and (function() for _,v in pairs(game.Players:GetPlayers()) do if (v.userId==Player) then return v; end end end)() or Player:GetPlayerFromCharacter();
end

function API.getPlayers() --table; player instances
  local Players = {};
  for _,v in pairs(game.Players:GetPlayers()) do
      Players[v.Name] = v;
  end
  return Players;
end

function API.getPlayerHealth(...) --table, players' health
  if (#{...}) then
    local PlayersHealth = {};
    for i,v in pairs({...}) do
      PlayersHealth[i] = API.getPlayer(v)
    end;
    return PlayersHealth;
  else
    error("[DEBUG][ERROR][API]::getPlayerHealth | Attempt to call `API:getPlayerHealth(...)' with no arguments\t", 3);
  end
  return {};
end

function API.getPlayerStatus(...) --boolean, success
  if (#{...} > 1) then
    local Statuses = {};
    for i,v in pairs({...}) do
      Statuses[i] = type(v) == "string" and game.Players:FindFirstChild(v):FindFirstChild("Humanoid").Status.Value or type(v) == "userdata" and v:FindFirstChild("Humanoid") ~= nil and v:FindFirstChild("Humanoid").Status.Value or v.Character:FindFirstChild("Humanoid").Status.Value;
    end 
    return Statuses;
  elseif (#{...} == 1) then
    for i,v in pairs({...}) do
      return type(v) == "string" and game.Players:FindFirstChild(v):FindFirstChild("Humanoid").Health or type(v) == "userdata" and v:FindFirstChild("Humanoid") ~= nil and v:FindFirstChild("Humanoid").Health or v.Character:FindFirstChild("Humanoid").Health;
    end
  else
    error("[DEBUG][ERROR][API]::getPlayerStatus | Attempt to call `API:getPlayerStatus(...)' with no arguments\t", 3);
  end
  return {};
end

function API.setPlayerStatus(Stat, ...) --boolean, success
  if (#{...} > 1) then
    for i,v in pairs({...}) do
      API.getPlayer(v).Character:FindFirstChild("Humanoid").Status.Value = Stat;
    end 
    return true;
  elseif (#{...} == 1) then
    API.getPlayer(unpack({...})[1]).Character:FindFirstChild("Humanoid").Status.Value = Stat;
    return true;
  else
    error("[DEBUG][ERROR][API]::setPlayerStatus | Attempt to call `API:getPlayerStatus(...)' with no arguments\t", 3);
  end
  return false;
end

function API.animateThrow(Speed, Start, Target)
  print("[DEBUG][ALPHA][API]::animateThrow|Still in ALPHA dev.");
end

function API.animateSneak(Player)
  print("[DEBUG][ALPHA][API]::animateSneak|Still in ALPHA dev.");
end

function API.animateDeath(Player) --player dies when Health <= 10, as MaxHealth is 110
  for _,v in pairs(Player.Character:GetChildren()) do
    pcall( function() v.Transparency = 1; end );
  end
  if (API._PlayerSettings[API.getPlayer(Player).Name].SaveInventory) then
    --- TODO: Implement Inventory.savePlayerInventory(Player)
    API._Inventory.savePlayerInventory(API.getPlayer(Player).Name);
  end
  API.getPlayer(Player).PlayerGui:FindFirstChild("RespawnButton").MouseButton1Click:connect(function()
    API.respawnPlayer(API.getPlayer(Player));
  end);
end

function API.loadPlayerSkin(Player) --bool, success
  if (Player) then
    API.getPlayer(Player).Character:FindFirstChild("Shirt").ShirtTemplate = "http://www.roblox.com/asset/?id="..game:GetService("DataStoreService"):GetGlobalDataStore():GetAsync(API.getPlayer(Player).Name .. "$shirtTemplate");
    API.getPlayer(Player).Character:FindFirstChild("Pants").PantsTemplate = "http://www.roblox.com/asset/?id="..game:GetService("DataStoreService"):GetGlobalDataStore():GetAsync(API.getPlayer(Player).Name .. "$pantsTemplate");
    return true;
  end
  error("[DEBUG][ERROR][API]::loadPlayerSkin|Attempt to call `loadPlayerSkin' with invalid parameters (nil param).",2);
  return false;
end

function API.op(Player) --bool, success
  if (Player) then
    table.insert(API._GlobalSettings.ops, API.getPlayer(Player).Name);
    return true;
  end
  error("[DEBUG][ERROR][API]::op|Attempt to call `op' with invalid paramters (nil param).",2);
  return false;
end

function API.deOp(Player) --bool, success
  if (Player) then
    local PlayerName = API.getPlayer(Player).Name;
    local Pos;
    for i,v in pairs(API.getPlayers()) do
      if (v == PlayerName) then
        Pos = i;
        break;
      end
    end
    table.remove(API._GlobalSettings.ops, Pos);
    return true;
  end
  error("[DEBUG][ARROR][API]::deOp|Attempt to call `deOp' with invalid parameters (nil param).",2);
  return false;
end

function API.kick(Player) --`plr' is banned for 30 seconds
  if (Player) then
    local PlayerName = API:getPlayer(Player).Name;
    print("[DEBUG][API]::kick|Kicking player '"..API.getPlayer(Player).Name.."' from game.");
    if (API.config.gentleKick==1 or not not API.config.gentleKick) then
      API.saveCheckpoint(Player);
    end
    API.getPlayer(PlayerName):Kick();
    coroutine.resume(coroutine.create(function()
      local now = tick();
      while (tick() > now + 30) do
        coroutine.yield();
      end
      game.Players.PlayerAdded:connect(function(P)
        if (API.getPlayer(P).Name == PlayerName) then
          P:Kick();
        end
      end)
    end))
    return true;
  end
  error("[DEBUG][ERROR][API]::kick|Attempt to call `kick' with invalid parameters (nil param).",2);
  return false;
end

function API.ban(Player) --bool, success
  if (Player) then
    print("[DEBUG][API]::ban|Kicking and banning player '"..API.getPlayer(Player).Name.."' from game.");
    API.getPlayer(Player):Kick();
    table.insert(API._GlobalSettings.banned, API.getPlayer(Player).Name);
    return true;
  end
  error("[DEBUG][ERROR][API]::ban|Attempt to call `ban' with invalid parameters (nil param).",2);
  return false;
end

function API.getNPCHealth(Mouse) --float, NPE health
  return Mouse.Target.Humanoid.Health;
end

function API.getNPCMaxHealth(Mouse) --float
  return Mouse.Target.Humanoid.MaxHealth;
end
--[[
function API:getNPEGender(Mouse) --int, 1: Male, 0: Female, -1: Neutral [Players]
  return Mouse.Target.Humanoid.Gender; -- Humanoid is `Wrap()'-ed
end
--]]
--[[
function API:getNPEBreedable(Mouse) --bool
  return (API.getNPEHealth(Mouse) / API.getNPEMaxHealth(Mouse) >= .74) and API.getNPEGender(Mouse) ~= -1;
end
--]]
--[[
function API:getNPEType(Mouse)
  
end
--]]
--[[
function API:getNPEGear(Mouse)
  return Mouse.Target.Humanoid.EquippedGear;
end
--]]

function API.saveCheckpoint(Player) -- Will save to DataStore when in RBX_Dev
  print("[DEBUG][ALPHA][API]::saveCheckpoint|Still in ALPHA dev.");
end

function API.changeSetting(Setting, Value) -- Boolean
  if (not (Setting and Value)) then 
    error("[DEBUG][ERROR][API]::changeSetting|Attempt to call `changeSetting' with invalid parameters (nil param).",2);
    return false;
  end
  if ((type(Value) == type(API._GlobalSettings[Setting])) or (_GlobalSettings[Setting] == nil)) then
    print("[DEBUG][API]::changeSetting Setting _GlobalSettings["..Setting.."] to `"..tostring(Value).."'.");
    API._GlobalSettings[Setting] = Value;
    return true;
  end
  error("[DEBUG][ERROR][API]::changeSetting|Unspecified Error.",2);
  return false;
end

function API.getPlayerPosition(Player) -- Vector3;
  if (Player) then 
    return API.getPlayer(Player).Character:FindFirstChild("HumanoidRootPart").Position;
  end
  error("[DEBUG][ERROR][API]::getPlayerPosition|Attempt to call `getPlayerPosition' with invalid parameters (nil param.)",2);
end

function API.setPlayerPosition(Player, Vector3) -- Boolean
  if (Player and Vector3) then 
    API.getPlayer(Player).Character:MoveTo(Vector3);
    return true;
  end
  error("[DEBUG][ERROR][API]::setPlayerPosition|Attempt to call `setPlayerPosition' with invalid parameters (nil param).",2);
  return false;
end

function API.setCameraNormal(Player) -- Boolean
  if (Player) then 
    local LFPLocal = game:GetService("ReplicatedStorage"):FindFirstChild("LFPLocal"):Clone();
    LFPLocal.Parent = API.getPlayer(Player).Character;
    LFPLocal.Disabled = false;
  end
  error("[DEBUG][ERROR][API]::setCameraNormal|Attempt to call `setCameraNormal' with invalid parameters (nil param).",2);
  return false;
end

function API.setCameraFixed(Player) -- Boolean success
  if (Player) then 
   local CFixedLocal = game:GetService("ReplicatedStorage"):FindFirstChild("CameraFixedLocal"):Clone();
    CFixedLocal.Parent = API.getPlayer(Player).Character;
    CFixedLocal.Disabled = false;
  end
  error("[DEBUG][ERROR][API]::setCameraFixed|Attempt to call `setCameraFixed' with invalid parameters (nil param).",2);
  return false;
end

function API.setCameraFollow(Player) -- Boolean success
  if (Player) then 
    local CFollowLocal = game:GetService("ReplicatedStorage"):FindFirstChild("CameraFollowLocal"):Clone();
    CFollowLocal.Parent = API.getPlayer(Player).Character;
    CFollowLocal.Disabled = false;
    return true;
  end
  error("[DEBUG][ERROR][API]::setCameraFollow|Attempt to call `setCameraFollow' with invalid parameters (nil param).",2);
end

function API.setCameraPosition(Player, Vector3) -- Boolean Success
  if (Player and Vector3) then 
     local CSetPositionLocal = game:GetService("ReplicatedStorage"):FindFirstChild("CSetPositionLocal"):Clone();
    CSetPositionLocal.Position.Value = Vector3;
   CSetPositionLocal.Parent = API.getPlayer(Player).Character;
    CSetPositionLocal.Disabled = false;
    return true;
  end
  error("[DEBUG][ERROR][API]::setCameraPosition|Attempt to call `setCameraPosition' with invalid parameters (nil param).",2);
  return false;
end

function API.getPlayerIds() -- Table, Integers [userId's of Players connected to game];
  local Ids = {};
  for _,v in pairs(game.Players:GetPlayers()) do
    table.insert(Ids, v.userId);
  end
  return Ids;
end

function API.postToChat(Player, Msg)
  print("[DEBUG][ALPHA][API]::postToChat|Still in ALPHA dev.");
end