local wait = wait
local Spawn = Spawn
local math = math
local collectgarbage = collectgarbage
local getmetatable, setmetatable, table = getmetatable, setmetatable, table
local print = print
local Create = assert(LoadLibrary("RbxUtil")).Create
local Shop = require("Shop")
local tab = require("TabOp")
local towns = {
  volcano = { },
  void = { },
  aether = { },
  chthonic = { },
  palace = { }
}
towns.populateTownPoints = function()
  for v in game.Workspace.Towns:GetChildren() do
    if v.Name:sub(1, 4 == "town") then
      for p in v:GetChildren() do
        if p.Name:sub(1, 5 == "point") then
          towns[v.Name:sub(5)][#towns[v.Name:sub(5)]] = p.Value
        end
      end
    end
  end
  return nil
end
local chatBubbleImages = { }
local NPCPlayer
do
  local _base_0 = {
    Spawn = function(self, townName)
      local NPCChar = game:GetService("ServerStorage"):FindFirstChild("NPCChar"):Clone()
      local spawnTown = tab.trand(towns[townName] and townName or tab.trand(towns))
      NPCChar.NPCId.Value = _G.CurNPCId
      NPCChar.HumanoidRootPart.Position = tab.trand(towns[townName])
      NPCChar.Parent = game.Workspace
      return self:new(NPCChar, spawnTown)
    end,
    WalkToRandom = function(self)
      return self:MoveToPosition(tab.trand(towns[self.SpawnTown]))
    end,
    MoveToPosition = function(self, point)
      if self.IsTalking then
        die("[DEBUG][INFO][NPCPlayer]::MoveToPosition|Attempt to call `MoveToPosition` with invalid parameters.", 2)
      end
      local pfs = game:GetService("PathfindingService")
      local path = pfs:ComputeRawPathAsync(self.Character.HumanoidRootPart.Position, point, 2048)
      if path.Status == Enum.PathStatus.Success then
        local coords = path:GetPointCoords()
        local Traverse
        Traverse = function()
          for v in coords do
            Spawn(function()
              print("[DEBUG][NPCPlayer]::MoveToPosition|Moving NPC to position: Vector3.new(" .. tostring(v.x) .. "," .. tostring(v.y) .. "," .. tostring(v.z) .. ").")
              return self.Character:FindFirstChild("Humanoid"):MoveTo(v)
            end)
            local distance = (point - self.Character.HumanoidRootPart.Position).magnitude
            while distance > 2 or self.IsTalking do
              distance = (point - self.Character.HumanoidRootPart.Position).magnitude
              wait()
            end
            if self.IsTalking then
              break
            elseif path:IsIntersected() then
              coords = pfs:ComputeRawPathAsync(self.Character.HumanoidRootPart.Position, point, 2048)
              Traverse()
              break
            end
          end
        end
      end
      return Traverse()
    end,
    RemoveCharacter = function(self)
      setmetatable(self, {
        ["__mode"] = "kv"
      })
      return collectgarbage("collect")
    end,
    LoadCharacterAppearance = function(self)
      (self.Character:FindFirstChild("Shirts" or Instance.new("Shirt", self.Character))).ShirtTemplate = self.ShirtsTemplateURL
      (self.Character:FindFirstChild("Pants" or Instance.new("Pants", self.Character))).PantsTemplate = self.PantsTemplateURL
    end,
    DistanceFromCharacter = function(self, point)
      return math.sqrt((self.Character.HumanoidRootPart.Position.x ^ 2 - point.x ^ 2) + (self.Character.HumanoidRootPart.Position.y ^ 2 - point.y ^ 2) + (self.Character.HumanoidRootPart.Position.z ^ 2 - point.z ^ 2))
    end,
    StopTalking = function(self)
      self.IsTalking = false
    end,
    Talk = function(self, other)
      if not other then
        return 
      end
      if self.IsTalking and (self.TalkingTo:sub(1, 3) ~= "NPC") then
        return 
      end
      if (self.Character.HumanoidRootPart.Position - other.Character.HumanoidRootPart.Position).magnitude < 10 then
        self.IsTalking = true
        self.TalkingTo = other
      end
      while self.IsTalking do
        local chatbubble = Create("billboardGui")({
          Parent = self.Character.Head,
          Offset = Vector3.new(math.random(0, .5), 1.5, math.random(0, .5)),
          Create("Image")({
            Image = tab.trand(chatBubbleImages)
          })
        })
        wait(math.random(7.5, 10))
        chatBubble:Destroy()
        if (self.Character.HumanoidRootPart.Position - other.Character.HumanoidRootPart.Position) > 10 then
          self.IsTalking = false
        end
      end
    end,
    Name = "NPC",
    userId = -1,
    NPCId = -1,
    Character = "",
    ShirtTemplateURL = "",
    PantsTemplateURL = "",
    SpawnTown = "",
    Shop = "",
    IsTalking = false,
    TalkingTo = ""
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, char, spawnTown)
      _G.CurNPCId = _G.CurNPCId + 1
      local o = getmetatable()
      o.Character = char
      o.SpawnTown = spawnTown
      o.NPCId = _G.CurNPCId
      o.Shop = Shop.new(spawnTown)
      return setmetatable(o, {
        ["__index"] = o,
        ["__gc"] = function()
          self.Character = nil
          return collectgarbage("collect")
        end
      })
    end,
    __base = _base_0,
    __name = "NPCPlayer"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  NPCPlayer = _class_0
  return _class_0
end
