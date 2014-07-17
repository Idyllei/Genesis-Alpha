-- Genesis/src/main.lua
--- @author Spencer Tupis
-- @copyright 2014-2015 Spencer Tupis,branefreez
-- @release Script$Core$main$main$Script
-- @class module
local bank;
require("Bank"):setup();

local ipairs,pairs=ipairs,pairs;
local wait,type,Spawn=wait,type,Spawn;
local print,error=print,error;
require("Bank").setup(); -- Set up the Bank API (bapi) and environment
local tab=require("TableOp");
local API=require("API");
local NPCPlayer,towns=require("NPCPlayer")[1],require("NPCPlayer")[2];
local config=require("towns.config");
local status=require("status");
local townNames={"volcano","aether","palace","void","chthonic"};
local PurchaseHistory = game:GetService("DataStoreService"):GetDataStore("PurchaseHistory");
-- NPCList["volcano"][1->N]=NPCPlayer.new(...);
_G.NPCList={};

local upgrades = {
  speedBoost=0,
  healthBoost=1,
  regenBoost=2,
  manaBoost=3
};

local function populateTowns()
  print("[DEBUG][local][main]| Start `populateTowns()'", populateTowns);
  for i,_ in pairs(config) do
    if (math.random(10) < config[i].SpawnDelta) then
      -- NPCList[townName][1->N]=NPCPlayer.Spawn(townName);
      local NPC=NPCPlayer.Spawn(i);
      _G.NPCList[i][NPC.NPCId]=NPC;
    end
  end
  print("[DEBUG][local][main]| End `populateTowns()'", populateTowns);
end

local function rndNPCTalk(townName)
  print("[DEBUG][local][main]| Start `rndNPCTalk(townName="..townName..")'",rndNPCTalk);
  local townName=townName or tab.trand(townNames);
  local point=tab.trand(towns[townName]);
  local npcs={tab.trand(_G.NPCList[townName]),tab.trand(_G.NPCList[townName])};
  npcs[1]:MoveToPosition(point);
  npcs[2]:MoveToPosition(point);
  npcs[1]:Talk(npcs[2]);
  npcs[2]:Talk(npcs[1]);
  wait(math.random(10,17.5));
  npcs[1]:StopTalking();
  npcs[2]:StopTalking();
  print("[DEBUG][local][main]| End `rndNPCTalk(townName)'", rndNPCTalk);
end

local function promptProductPurchase(player,id)
  print("[DEBUG][local][main]| Start `promptProductPurchase(player,id)'",promptProductPurchase);
  if (not (player and id)) then
    error("[DEBUG][UpgradesCore]::promptPurchase|Attempt to call `promptPurchase' with invalid parameters (nil param)",2);
  end
  game:GetService("MarketplaceService"):PromptProductPurchase(player,id);
  print("[DEBUG][local][main]| end `promptProductPurchase()'",promptProductPurchase);
end
-- ------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------Enumerations:-------------------------------------------------------
-- ------------------------------------------------------------------------------------------------------------------------
local function enum( names )
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

local E={};
E.status=enum{"speed","poison","stamina","fatigue","confusion","hallucinate"};
E.upgrade=enum{"speed","health","regen","mana"};
-- ----------------------------------------------------Documentation:------------------------------------------------------
-- local enumList = enum{'EnumName1',['EnumList2']={'EnumName1A','EnumName2A'}};
-- enumList.EnumList2.EnumName1A
-- ------------------------------------------------------------------------------------------------------------------------

-- -----------------------------------------Receipt Processing Mechanism:--------------------------------------------------
-- ------------------------------------------------------------------------------------------------------------------------
game:GetService("MarketplaceService").ProcessReceipt = function(receiptInfo) 
  print("[DEBUG][main][game.MarketplaceService].ProcessReceipt| Start");
  local playerProductKey = receiptInfo.PlayerId .. ":" .. receiptInfo.PurchaseId;
  if PurchaseHistory:GetAsync(playerProductKey) then
    return Enum.ProductPurchaseDecision.PurchaseGranted; --We already granted it.
  end --endif
  -- find the player based on the PlayerId in receiptInfo
  for _,player in ipairs(game.Players:GetPlayers()) do
    if player.userId == receiptInfo.PlayerId then
      -- check which product was purchased (required, otherwise you'll award the wrong items if you're using more than one developer product)
      if receiptInfo.ProductId == upgrades.speedBoost then
        -- handle purchase. In this case we are giving the player a +12.5% WalkSpeed boost.
        player.Character.Humanoid.WalkSpeed = player.Character.Humanoid.WalkSpeed * 1.125;
      elseif receiptInfo.ProductId == upgrades.healthBoost then
        -- handle purchase. In this case we are giving the player a +12.5% Health boost.
        player.Character.Humanoid.MaxHealth = player.lCharacter.Humanoid.MaxHealth  * 1.125;
        player.Character.Humanoid.Health = player.Character.Humanoid.MaxHealth;
      elseif receiptInfo.ProductId == upgrades.regenBoost then
        -- handle purchase. In this case we are giving the player a +12.5% Health Regeneration Speed boost.
        player.Upgrades.RegenSpeed.Value = player.Upgrades.RegenSpeed.Value * 1.125;
      elseif receiptInfo.ProductId == upgrades.manaBoost then
        -- handle purchase. In this case we are giving the player a +12.5% MaxManaLevel boost.
        player.Upgrades.MaxManaLevel.Value = player.Upgrades.MaxManaLevel.Value * 1.125;
      end --endif
    end --endif
  end --endfor
  -- record the transaction in a Data Store
  PurchaseHistory:SetAsync(playerProductKey, true); 
  -- tell ROBLOX that we have successfully handled the transaction (required)
  print("[DEBUG][main][game.MarketplaceService].ProcessReceipt| End");
  return Enum.ProductPurchaseDecision.PurchaseGranted;  
end --endcallback_function ProcessReceipt()

game.Players.PlayerAdded:connect(function(player) 
  local function f(player)
    print("[DEBUG][local][game.Players.PlayerAdded]->Start ",f);
    player = API.getPlayer(player);
    if (not player) then
      error("[DEBUG][ERROR][main]::anonymous_PlayerAdded|unknown exception. (Did player disconect before event could fire?)",2);
    end
    print("[DEBUG][main]::anonymous_playerAdded|Setting up Status of player "..API.getPlayer(player).Name..".");
    status.setup(player);
    print("[DEBUG][main]::anonymous_PlayerAdded|Setting up [Bank]::_account of player"..API.getPlayer(player).Name..".");
    bank.setAccount(player);
    print("[DEBUG][main]::anonymous_PlayerAdded|Completed.");
    (function(plr)
    if (plr==nil) then return; end
    local upgrade=tab.trand(upgrades);
    if (not game:GetSevice("MarketplaceService"):PlayerOwnsAsset(upgrade)) then
      promptProductPurchase(plr,upgrade);
    end
    end)(player)
    print("[DEBUG][local][game.Players.PlayerAdded]->End ",f);
  end
  f(player);
end);



local function main()
  print("[DEBUG][local][main]::f()|Start ",main);
  
  print("[DEBUG][local][main]::f()|End ",main);
end --endfunction main
main()
