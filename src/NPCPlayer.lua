--- @module

--[[
  NPCPCharacterModel:
  Model Character:
  +Model Character
    +intValue NPCId
      +Int Value
    +Part Head
      +Decal Face
      +ClickDetector ClickDetector
    +Part HumanoidRootPart
      +Humanoid Humanoid
        +Model Status
    +Part LeftArm
      +ClickDetector ClickDetector
    +Part RightArm
      +ClickDetector ClickDetector
    +Part LeftLeg
      +ClickDetector ClickDetector
    +Part RightLeg
      +ClickDetector ClickDetector
    +Shirt Shirt
    +Pants Pants
    +RemoteEvent Clicked
  
--]]
local nullptr;
require("nullptr").setup();
require("boost").setup();
local die;
local wait,Spawn=wait,Spawn;
local math,collectgarbage=math,collectgarbage;
local getmetatable,setmetatable,table=getmetatable,setmetatable,table;
local print=print;

local Create=assert(LoadLibrary("RbxUtil")).Create;


local Shop = require("Shop");
local tab=require("TabOp");
-- towns[name][1->N]=Vector3
local towns={["volcano"]={},["void"]={},["aether"]={},["chthonic"]={},["palace"]={}};
local chatBubbleImages={};
local populateTownPoints; -- function() ...; end
local NPCPlayer={
  Name="NPC",
  userId=-1,
  NPCId=-1,
  Character=nullptr,
  ShirtTemplateURL="",
  PantsTemplateURL="",
  SpawnTown="",
  Shop=nil,
  IsTalking=false,
  TalkingTo=nil, -- Character
  Talk=function(self,other)
    if (not other) then
      return die("[DEBUG][ERROR][NPCPlayer]::Talk|Attempt to call `Talk' with `other' parameter as nil.",2);
    end
    if (self.IsTalking and self.TalkingTo:sub(1,3) ~= "NPC" and other.Name=="NPC") then
      -- An NPc is trying to take the conversation away from a player.
      return;
    end
    if (self.Character.HumanoidRootPart.Position-other.Character.HumanoidRootPart.Position).magnitude<10 then
      self.IsTalking = true;
      self.TalkingTo=other;
    end
    while (self.IsTalking) do
      local chatBubble = Create"BillboardGui"{
        Parent=self.Character.Head,
        Offset=Vector3.new(math.random(0,.5),1.5,math.random(0,.5)),
        Create"Image"{
          Image=tab.trand(chatBubbleImages)
        }
      };
      wait(math.random(7.5,10));
      chatBubble:Destroy();
      if (self.Character.HumanoidRootPart.Position-other.Character.HumanoidRootPart.Position).magnitude>=10 then
        self.IsTalking = false;
        break;
      end
    end
  end,
  StopTalking=function(self)
    print("[DEBUG][NPCPlayer]::StopTalking|Setting `IsTalking' to false.");
    self.IsTalking = false;
    return;
  end,
  DistanceFromCharacter=function(self,point)
    return math.sqrt((self.Character.HumanoidRootPart.Position.x^2-point.x^2)+(self.Character.HumanoidRootPart.Position.y^2-point.y^2)+(self.Character.HumanoidRootPart.Position.z^2-point.z^2))
  end,
  LoadCharacterAppearance=function(self)
    (self.Character:FindFirstChild("Shirt") or Instance.new("Shirt",self.Character)).ShirtTemplate=self.ShirtTemplateURL;
    (self.Character:FindFirstChild("Pants") or Instance.new("Pants",self.Character)).ShirtTemplate=self.PantsTemplateURL;
    return;
  end,
  RemoveCharacter=function(self)
    self=nil;
    collectgarbage("collect"); -- TRY to remove this object.
  end,
  MoveToPosition=function(self, point)
    if (self.IsTalking) then
      return die("[DEBUG][INFO][NPCPlayer]::MoveToPosition|Attempt to call `MoveToPosition' while NPc `IsTalking' is true.",2);
    end
    local pfs=game:GetService("PathfindingService");
    local path = pfs:ComputeRawPathAsync(self.Character.HumanoidRootPart.Positon,point,2048); -- Why would we want to move it further than that?
    if (path.Status == Enum.PathStatus.Success) then
      local coords=path:GetPointCoordinates();
      local function Traverse()
      for v in coords do -- iterate through each coordinate in the path
        -- Move the character
        Spawn(function() 
          print("[DEBUG][NPCPlayer]::MoveToPosition|Moving NPC to position: Vector3.new("..v.x..","..v.y..","..v.z..").");
          self.Character:FindFirstChild("Humanoid"):MoveTo(v); 
        end);
        -- Wait until they are near it.
        local distance;
        repeat
          distance = (point - self.Character.HumanoidRootPart.Position).magnitude;
          wait();
        until distance < 2 or self.IsTalking;
        --- TODO: Replace 'IsIntersected()" with true method implementation.
        if (self.IsTalking) then
          -- We don't want to continue walking if we are talking to someone.
          break;
          -- Get out of the loop we are in.
        elseif (path:IsIntersected()) then
          -- Recompute coordinates
          coords=pfs:ComputeRawPathAsync(self.character.HumanoidRootPart.Position,point,2048):GetPointCoordinates();
          -- Start again
          Traverse();
          -- And get out of our loop we are in.
          break;
        end
      end
    end
  end
  return;
  end,
  WalkToRandom=function(self)
    self:MoveToPosition(tab.trand(towns[self.SpawnTown]));
    return;
  end,
  Spawn = function(self, townName)
    local NPCChar=game:GetService("ServerStorage"):FindFirstChild("NPCChar"):Clone();
    local spawnTown=tab.trand(towns[townName] and townName or tab.trand(towns));
    NPCChar.NPCId.Value=_G.CurNPCId;
    NPCChar.HumanoidRootPart.Position=tab.trand(towns[townName]);
    NPCChar.Parent=game.Workspace;
    return self:new(NPCChar,spawnTown);
  end,
  new=function(self,char,spawnTown)
    _G.CurNPCId=_G.CurNPCId+1;
    local o = getmetatable(self).__index;
    o.Character=char;
    o.SpawnTown=spawnTown;
    o.NPCId=_G.CurNPCId;
    o.Shop=Shop.new(spawnTown);
    return setmetatable(o,{__index=o,__gc=function(self) self.Character=nil; collectgarbage("collect"); end});
  end
};

function towns.populateTownPoints() 
  for v in game.Workspace.Towns:GetChildren() do
    if (v.Name:sub(1,4)=="town") then
      for p in v:GetChildren() do
        if (p.Name:sub(1,5)=="point") then
          table.insert(towns[v.Name:sub(5)],p.Value);
        end
      end
    end
  end
  return nil;
end


return {NPCPlayer,towns};