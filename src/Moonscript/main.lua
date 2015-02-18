local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Nevermore = require(ReplicatedStorage:WaitForChild("NevermoreEngine"))
local LoadCustomLibrary = NevermoreEngine.LoadLibrary
local qSystems = LoadCustomLibrary("qSystems")
qSystems:Import(getfenv(0))
local qPlayer = LoadCustomLibrary("qPlayer")
local Type = LoadCustomLibrary("Type")
local RawCharacter = LoadCustomLibrary("RawCharacter")
local Character = LoadCustomLibrary("Character")
local PlayerTagTracker = LoadCustomLibrary("PlayerTagTracker")
local EventMaid = LoadCustomLibrary("Maid")
local ExperienceCalculator = LoadCustomLibrary("ExperienceCalculator")
qPlayer:Import(getfenv(0))
Type:Import(getfenv(0))
RawCharacter:Import((getfenv(0)), "Raw")
Character:Import((getfenv(0)), "Safe")
EventMaid:Import(getfenv(0))
ExperienceCalculator:Import(getfenv(0));
(require("bank")).setup()
local math = require("Math")
local NPCPlayer = require("NPCPlayer")
local mana = require("objMana")
local status = require("status")
local pathfinder = require("pathfinder")
local townConfig = require("townConfig")
local API = require("API")
local INVENTORY = require("Inventory")
local Logger = require("stdlog")
local RunTests = require("runTests")
local S_RUN = game:GetService("RunService")
local S_DEBRIS = game:GetService("DebrisService")
local S_SCRIPT_CONTEXT = game:GetService("ScriptContext")
local S_SCRIPT_DEBUGGER = game:GetService("ScriptDebugger")
local S_DATA_STORE = game:GetService("DataStoreService")
local S_PLAYERS = game.Players
local CoreMaids = {
  PlayerAdded = EventMaid.makeMaid(),
  PlayerRemoving = EventMaid.makeMaid(),
  CharacterAdded = EventMaid.makeMaid(),
  Died = EventMaid.makeMaid(),
  WatchAdded = EventMaid.makeMaid(),
  WatchRemoved = EventMaid.makeMaid(),
  Resuming = EventMaid.makeMaid(),
  BreakpointAdded = EventMaid.makeMaid(),
  BreakpointRemoved = EventMaid.makeMaid(),
  EncounteredBreak = EventMaid.makeMaid(),
  Changed = EventMaid.makeMaid(),
  Error = EventMaid.makeMaid(),
  Custom = {
    Attack = EventMaid.makeMaid()
  }
}
local log2
log2 = function(n)
  local _n = 2
  local x = 1
  if (_n < n) then
    x = x + 1
    _n = _n + _n
    while not (_n >= n) do
      x = x + 1
      _n = _n + _n
    end
  elseif (_n >= n) then
    if (n == 1) then
      local _ = 0
    else
      local _ = nil
    end
  end
  if (_n > n) then
    return x - 1
  else
    return x
  end
end
local round
round = function(number, places)
  local mult = 10 ^ (point or 0)
  return (math.floor(number * mult + 0.5)) / mult
end
RUNTEST((getfenv(0)), "round", {
  ARG = {
    {
      100.255,
      2
    },
    {
      0.0625,
      6
    },
    {
      math.pi,
      3
    },
    {
      math.huge,
      1
    },
    {
      -math.huge,
      1
    },
    {
      1 / 3,
      3
    }
  },
  EXPECTED = {
    100.26,
    0.062500,
    3.15,
    math.huge,
    -math.huge,
    0.333
  }
})
local xround
xround = function(number, places)
  local x
  if (number * places < 0) then
    x = -0.5
  else
    x = 0.5
  end
  return (math.modf(number * places + x))[1] / places
end
RUNTEST((getfenv(0)), "xround", {
  ARG = {
    {
      100.255,
      2
    },
    {
      12345.678,
      -2
    },
    {
      0.0625,
      6
    },
    {
      math.pi,
      3
    },
    {
      math.pi,
      -3
    },
    {
      math.huge,
      1
    },
    {
      math.huge,
      -1
    },
    {
      -math.huge,
      1
    },
    {
      1 / 3,
      3
    }
  },
  EXPECTED = {
    100.26,
    12345.68,
    0.062500,
    3.15,
    3.15,
    math.huge,
    math.huge,
    -math.huge,
    0.333
  }
})
local hwait
hwait = function(nS)
  if nS == nil then
    nS = 1 / 30
  end
  local nT = tick()
  local nDGT = Workspace.DistributedGameTime
  while (tick() - nT) < nS do
    S_RUN.Heartbeat:wait()
  end
  return tick() - nT, Workspace.DistributedGameTime, Workspace.DistributedGameTime - nDGT
end
local rwait
rwait = function(nS)
  if nS == nil then
    nS = 1 / 60
  end
  local nT = tick()
  local nDGT = Workspace.DistributedGameTime
  while (tick() - nT) < nS do
    S_RUN.RenderStepped:wait()
  end
  return tick() - nT, Workspace.DistributedGameTime, Workspace.DistributedGameTime - nDGT
end
local swait
swait = function(nS)
  if nS == nil then
    nS = 1
  end
  local nT = tick()
  local nDGT = Workspace.DistributedGameTime
  local nW = nil
  while (tick() - nT) < nS do
    S_RUN.Stepped:wait()
  end
  return tick() - nt, Workspace.DistributedGameTime, Workspace.DistributedGameTime - nDGT
end
local waitms
waitms = function(nM)
  if nM == nil then
    nM = 33
  end
  local nT = tick()
  local nDGT = Workspace.DistributedGameTime
  while (tick() - nT) < (nMs * 1000) do
    S_RUN.RenderStepped:wait()
  end
  return tick() - nT, Workspace.DistributedGameTime, Workspace.DistributedGameTime - nDGT
end
local main
main = function() end
CoreMaids["PlayerAdded"]["Bank"] = S_PLAYERS.PlayerAdded:connect(function(plr)
  do
    local acc = (S_DATA_STORE:GetDataStore("Bank")):GetAsync(plr.Name)
    if acc then
      accounts[plr.Name] = acc
    else
      return bank.setAccount(plr)
    end
  end
end)
CoreMaids["PlayerAdded"]["Stamina"] = S_PLAYERS.PlayerAdded:connect(function(plr)
  return plr.CharacterAdded:connect(function(chr)
    return Spawn(function()
      local nStamina = 100
      local bRunning = false
      Spawn(function()
        while wait(.5) do
          if nStamina < 10 then
            chr.Humanoid.WalkSpeed = round((chr.Humanoid.WalkSpeed * (nStamina / 100) * (1 - chr.HumanoidWalkSpeedMultiplier.Value)), 2)
          else
            chr.Humanoid.WalkSpeed = round((chr.Humanoid.WalkSpeed * (nStamina / 100) * (1 + chr.HumanoidWalkSpeedMultiplier.Value)), 2)
          end
        end
      end)
      while wait() do
        nStamina = (nStamina >= 1) and nStamina or 1
        if chr.Humanoid.Running:wait() then
          bRunning = not bRunning
        end
        if bRunning and chr.Humanoid.Running:wait() >= 16 then
          while bRunning and wait(1) do
            nStamina = nStamina - 7.5
          end
        elseif chr.Humanoid.Running:wait() < 16 then
          while wait(.5) do
            nStamina = nStamina + 5
          end
        end
      end
    end)
  end)
end)
CoreMaids["PlayerAdded"]["Inventory"] = S_PLAYERS.PlayerAdded:connect(function(plr)
  local plrInventory = INVENTORY.loadInventory(plr.Name)
  for i, v in plrInventory.getItems() do
    if v.nUses then
      plrInventory[i].nUses = plrInventory[i].nUses - math.floor(((S_DATA_STORE:GetDataStore("Stats")):GetAsync(plr.Name)).Inventory.nUsesLess)
    end
  end
end)
CoreMaids["PlayerAdded"]["Death"] = S_PLAYERS.PlayerAdded:connect(function(plr)
  CoreMaids["CharacterAdded"]["Death"] = plr.CharacterAdded:connect(function(chr)
    CoreMaids["Died"]["Death"] = chr.Humanoid.Died:connect(function()
      if (INVENTORY.getInventory(plr)).hasItem("Scarab_Charm") then
        (S_DATA_STORE:GetDataStore("Inventory")):SetAsync(plr.Name, INVENTORY.getInventory(plr))
      end
      (S_DATA_STORE:GetDataStore("KDR")):UpdateAsync(plr.Name, function(kdr)
        return {
          nKills = kdr.kills,
          nDeaths = kdr.deaths + 1,
          kdr = kdr.kills / (kdr.deaths + 1)
        }
      end)
      return (S_DATA_STORE:GetDataStore("KDR")):UpdateAsync((RawCharacter.getKiller(plr.Character.Humanoid)), function(kdr)
        return {
          nKills = kdr.kills + 1,
          nDeaths = kdr.deaths,
          kdr = (kdr.kills + 1) / kdr.deaths
        }
      end)
    end)
  end)
end)
CoreMaids["PlayerRemoving"]["Save"] = S_PLAYERS.PlayerRemoving:connect(function(plr)
  (S_DATA_STORE:GetDataStore("Bank")):SetAsync(plr.Name, accounts[plr.Name]);
  (S_DATA_STORE:GetDataStore("Inventory")):SetAsync(plr.Name, INVENTORY.getInventory(plr))
  return (S_DATA_STORE:GetDataStore("Stats")):SetAsync(plr.Name, {
    nPlays = ((S_DATA_STORE:GetDataStore("Stats")):GetAsync(plr.Name)).nPlays + 1,
    StandingPosition = plr.Character.Humanoid.Torso.Position,
    Humanoid = {
      MaxHealth = plr.Character.Humanoid.MaxHealth,
      Health = plr.Character.Humanoid.Health,
      WalkSpeed = math.max(plr.Character.Humanoid.WalkSpeed, 10)
    },
    Bank = {
      Interest = accounts[plr.Name].JointAccount.Interest + .1
    },
    Inventory = {
      nUsesLess = ((S_DATA_STORE:GetDataStore("Stats")):GetAsync(plr.Name)).Inventory.nUsesLess + .5 + (math.floor(1.61833588985 ^ (((S_DATA_STORE:GetDataStore("Stats")):GetAsync(plr.Name)).nPlays / 1.6183358898))) - 1
    }
  })
end)
CoreMaids["PlayerAdded"]["Luck"] = S_PLAYERS.PlayerAdded:connect(function(plr)
  return (S_DATA_STORE:GetDataStore("Plays")):UpdateAsync("Plays", function(nVal)
    if (math.log10(nVal + 1)) % 1 == 0 then
      local oMsg
      do
        local _with_0 = Instance.new("Message")
        _with_0.Text = "Thank you for being the " .. tostring(nVal + 1) .. " visitor! You have been awarded with more in-game luck than other players! ~branefreez"
        _with_0.Parent = plr.Character
        oMsg = _with_0
      end
      S_DEBRIS:AddItem(oMsg, 5)
      delay(5, function()
        local oWkspcMsg
        do
          local _with_0 = Instance.new("Message")
          _with_0.Text = "Thank you for the " .. tostring(nVal + 1) .. " visits! ~branefreez"
          _with_0.Parent = Workspace
          oWkspcMsg = _with_0
        end
        return S_DEBRIS:Additem(oWkspcMsg, 5)
      end)
    elseif (log2(nVal + 1)) % 1 == 0 then
      local oMsg
      do
        local _with_0 = Instance.new("Message")
        _with_0.Text = "Thank you for being the " .. tostring(nVal + 1) .. " visiotr! You have been rewarded with more in-game luck than other players! ~branefreez"
        _with_0.Parent = plr.Character
        oMsg = _with_0
      end
      S_DEBRIS:AddItem(oMsg, 5)
      delay(5, function()
        local oWkspcMsg
        do
          local _with_0 = Instance.new("Message")
          _with_0.Text = "Thank you for the " .. tostring(nVal + 1) .. " visits! ~branefreez"
          _with_0.Parent = Workspace
          oWkspcMsg = _with_0
        end
        return S_DEBRIS:Additem(oWkspcMsg, 5)
      end)
    elseif ((math.log10(nVal)) / (math.log10(1.5))) % 1 == 0 then
      local oMsg
      do
        local _with_0 = Instance.new("Message")
        _with_0.Text = "Thank you for being the " .. tostring(nVal + 1) .. " visitor! You have been reqarded more in-game luck than other players! ~branefreez"
        _with_0.Parent = plr.Character
        oMsg = _with_0
      end
      S_DEBRIS:AddItem(oMsg, 5)
      delay(5, function()
        local oWkspcMsg
        do
          local _with_0 = Instance.new("Message")
          _with_0.Text = "Thank you for the " .. tostring(nVal + 1) .. " visits! ~branefreez"
          _with_0.Parent = Workspace
          oWkspcMsg = _with_0
        end
        return S_DEBRIS:Additem(oWkspcMsg, 5)
      end)
    end
    return nVal + 1
  end)
end)
CoreMaids["WatchAdded"]["Debugging"] = S_SCRIPT_DEBUGGER.WatchAdded:connect(function(oWatch)
  return Logger:logInfo("Watch Added", nil, oWatch:GetFullName())
end)
CoreMaids["WatchRemoved"]["Debugging"] = S_SCRIPT_DEBUGGER.WatchRemoved:connect(function(oWatch)
  return Logger:logInfo("Watch Removed", nil, oWatch:GetFullName())
end)
CoreMaids["Resuming"]["Debugging"] = S_SCRIPT_DEBUGGER.Resuming:connect(function()
  return Logger:logInfo("ScriptDebugger Resumed", nil, "MAIN")
end)
CoreMaids["BreakpointAdded"]["Debugging"] = S_SCRIPT_DEBUGGER.BreakpointAdded:connect(function(oBreakpoint)
  return Logger:logDebug("Breakpoint Added", nil, oBreakpoint:GetFullName())
end)
CoreMaids["BreakpointRemoved"]["Debugging"] = S_SCRIPT_DEBUGGER.BreakpointRemoved:connect(function(oBreakpoint)
  return Logger:logDebug("Breakpoint Removed", nil, oBreakpoint:GetFullName())
end)
CoreMaids["EncounteredBreak"]["Debugging"] = S_SCRIPT_DEBUGGER.EncounteredBreak:connect(function(line)
  return Logger:logDebug("Encountered Break", nil, tostring(line) .. ":" .. tostring(S_SCRIPT_DEBUGGER.Script) .. ":" .. tostring(S_SCRIPT_DEBUGGER.CurrentLine))
end)
CoreMaids["Changed"]["Debugging"] = S_SCRIPT_DEBUGGER.Changed:connect(function(sProperty)
  return Logger:logDebug("Property `" .. tostring(sProperty) .. "` of ScriptDebugger Changed", nil, "game:GetService(\"ScriptDebugger\")")
end)
CoreMaids["Error"]["Debugging"] = S_SCRIPT_CONTEXT.Error:connect(function(sMsg, sTrace, oOrigin)
  return Logger:logError(sMsg, nil, oOrigin:GetFullName())
end)
