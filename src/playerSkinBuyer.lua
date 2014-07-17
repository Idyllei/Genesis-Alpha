-- LocalScript: playerSkinBuyer.lua
require("boost").setup();

local pairs=pairs;

local PurchaseHistory = game:GetService("DataStoreService"):GetDataStore("PurchaseHistory");

local char=game.Players.LocalPlayer.Character;
local gui=script.Parent;
local defaultShirtTemplate=game:GetService("DataStoreService"):GetDataStore("playerSkins"):GetAsync(game.Players.LocalPlayer.Name.."$shirtTemplate") or game:GetService("ReplicatedStorage").DefaultShirtTemplate.Value;
local defaultPantsTemplate=game:GetService("DataStoreService"):GetDataStore("playerSkins"):GetAsync(game.Players.LocalPlayer.Name.."$pantsTemplate") or game:GetService("ReplicatedStorage").DefaultPantsTemplate.Value;
local buttonImageUnchecked=gui.ButtonImageUnchecked.Value;
local buttonImageChecked=gui.ButtonImageChecked.Value;
local checkedButton=nil;
local buttons={};
local skins={["shirts"]={},["pants"]={}};



for _,v in pairs(gui:GetChildren()) do
  if (v.Name:sub():gsub("button")) then
    buttons[#buttons+1]=v;
    skins["shirt_pants"][v.ShirtTemplate.Value]=v.PantsTemplate.Value;
    skins["pants_shirt"][v.pantsTemplate.Value]=v.ShirtTemplate.Value;
    
  end
end
  

for v in buttons do
  v.Button1Click:connect(function()
    v.Image=buttonImageChecked;
    for v2 in buttons do
      if (v2~=v) then
        v2.Image=buttonImageUnchecked;
      end
    end
    checkedButton=v;
  end)
end

game:GetService("MarketplaceService").ProcessReceipt = function(receiptInfo) 
  local playerProductKey = receiptInfo.PlayerId .. ":" .. receiptInfo.PurchaseId;
  if PurchaseHistory:GetAsync(playerProductKey) then
    return Enum.ProductPurchaseDecision.PurchaseGranted; --We already granted it.
  end --endif
  -- find the player based on the PlayerId in receiptInfo
  for _,player in ipairs(game.Players:GetPlayers()) do
    if player.userId == receiptInfo.PlayerId then
      -- check which product was purchased (required, otherwise you'll award the wrong items if you're using more than one developer product)
      if skins["shirt_pants"][receiptInfo.ProductId] or skins["pants_shirt"][receiptInfo.ProductId] then
        -- record the transaction in a Data Store
        PurchaseHistory:SetAsync(playerProductKey, true); 
        -- tell ROBLOX that we have successfully handled the transaction (required)
        return Enum.ProductPurchaseDecision.PurchaseGranted;  
      end --endif
    end --endif
  end --endfor
end --endcallback_function ProcessReceipt()

gui:FindFirstChild("BuyBtn").Button1Click:connect(function() 
  if (not checkedButton) then 
    die("[DEBUG][ERROR][playerSkinBuyer].BuyBtn|checkedButton is nil.",2); 
  end 
  game:GetService("MarketplaceService"):PromptProductPurchase(char:GetPlayerFromcharacter().userId,checkedButton.productId);
  game:GetService("MarketplaceService").PromptPurchaseFinished:connect(function(player,assetId,isPurchased)
    if (isPurchased) then
      game:GetService("DataStoreService"):GetDataStore("playerSkins"):SetAsync(player.Name.."$shirtTemplate","http://www.roblox.com/asset/?id="..(skins["shirt_pants"][assetId] and assetId or skins["pants_shirt"][assetId]))
      game:GetService("DataStoreService"):GetDataStore("playerSkins"):SetAsync(player.Name.."$pantsTemplate","http://www.roblox.com/asset/?id="..(skins["pants_shirt"][assetId] and assetId or skins["shirtPants"][assetId]))
      defaultShirtTemplate=game:GetService("DataStoreService"):GetDataStore("playerSkins"):GetAsync(player.Name.."$shirtTemplate") or game:GetService("ReplicatedStorage").DefaultShirtTemplate.Value;
      defaultPantsTemplate=game:GetService("DataStoreService"):GetDataStore("playerSkins"):GetAsync(player.Name.."$pantsTemplate") or game:GetService("ReplicatedStorage").DefaultPantsTemplate.Value;
      player.CharacterAdded:connect(function(char) 
        local shirt;
        local pants;
        -- Remove the old Shirt andPants from the character's Avatar.
        char:FindFirstChild("PantsTemplate"):Destroy();
        char:FindFirstChild("ShirtTemplate"):Destroy();
        -- Make the new Shirt and Pants for the character's Avatar.
        shirt=Instance.new("Shirt");
        pants=Instance.new("Pants");
        shirt.ShirtTemplate=defaultShirtTemplate;
        pants.PantsTemplate=defaultPantsTemplate;
        shirt.Parent=char;
        pants.Parent=char;
      end)
    end
  end)
end)