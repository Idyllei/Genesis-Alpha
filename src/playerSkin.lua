-- LocalScript: playerSkinLoader.lua

-- TODO: Make so they must buy a pass to do this.

local char=game.Players.LocalPlayer.Character;
local gui=script.Parent;
local shirtURLTextBox=gui.ShirtURLTextBox;
local pantsURLTextBox=gui.PantsURLTextBox;
local shirtTemplate=game:GetService("DataStoreService"):GetDataStore("playerSkins"):GetAsync(game.Players.LocalPlayer.Name.."$shirtTemplate") or shirtURLTextBox.Text or game:GetService("ReplicatedStorage").DefaultShirtTemplate.Value;
local pantsTemplate=game:GetService("DataStoreService"):GetDataStore("playerSkins"):GetAsync(game.Players.LocalPlayer.Name.."$pantsTemplate") or pantsURLTextBox.Text or game:GetService("ReplicatedStorage").DefaultPantsTemplate.Value;
local loadButton=gui.LoadButton;


loadButton.MouseButton1Click:connect(function() 
  local shirt;
  local pants;
  shirt=Instance.new("Shirt");
  pants=Instance.new("Pants");
  shirt.ShirtTemplate=shirtTemplate;
  pants.PantsTemplate=pantsTemplate;
  shirt.Parent=char;
  pants.Parent=char;
end);

