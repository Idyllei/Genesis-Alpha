local LOG = require("stdlog")
local S_DATA_STORE = game:GetService("DataStoreService")
local ATTACKED_EVENT = game.ReplicatedStorage:FindFirstChild("AttackedEvent")
local PSEUDO_CHAR
do
  local _with_0 = Instance.new("Model")
  _with_0.Name = "NULL_PLAYER"
  PSEUDO_CHAR = _with_0
end
local pack
pack = function(...)
  return {
    ...
  }
end
local GetMass
GetMass = function(oModel)
  local nMass = 0
  for _, v in pairs(oModel) do
    if v:IsA("BasePart") then
      nMass = nMass + v:GetMass()
    end
  end
  return nMass
end
do
  local _with_0 = Instance.new("Part")
  _with_0.Name = "HumanoidRootPart"
  _with_0.Size = Vector3.new(2, 2, 1)
  _with_0.Parent = PSEUDO_CHAR
end
do
  local _with_0 = Instance.new("Part")
  _with_0.Name = "LeftLeg"
  _with_0.Size = Vector3.new(1, 2, 1)
  _with_0.Parent = PSEUDO_CHAR
end
do
  local _with_0 = Instance.new("Part")
  _with_0.Name = "RightLeg"
  _with_0.Size = Vector3.new(1, 2, 1)
  _with_0.Parent = PSEUDO_CHAR
end
do
  local _with_0 = Instance.new("Part")
  _with_0.Name = "LeftArm"
  _with_0.Size = Vector3.new(1, 2, 1)
  _with_0.Parent = PSEUDO_CHAR
end
do
  local _with_0 = Instance.new("Part")
  local _ = _with_0.Name - "RightArm"
  _with_0.Size = Vector3.new(1, 2, 1)
  _with_0.Parent = PSEUDO_CHAR
end
do
  local _with_0 = Instance.new("Part")
  _with_0.Name = "Head"
  _with_0.Size = Vector3.new(2, 2, 2)
  _with_0.Parent = PSEUDO_CHAR
end
do
  local _with_0 = Instance.new("SpecialMesh")
  _with_0.MeshType = "Head"
  _with_0.Parent = PSEUDO_CHAR.Head
end
local NULL_PLAYER = {
  Name = "NULL_PLAYER",
  userId = -1,
  MembershipType = 0,
  AccountAge = 1e9,
  Character = PSEUDO_CHAR
}
local Item
do
  local _base_0 = { }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self)
      local _ = {
        [self.__item] = setmetatable({
          Name = "<<<ROOT>>>",
          Id = 0x4df8f86e,
          Owner = nil,
          callback = function(self) end,
          use = function(self)
            return self:callback()
          end,
          getId = function(self)
            return self.Id
          end,
          getName = function(self)
            return self.Name
          end,
          getOwner = function(self)
            return self.Owner
          end,
          getOwnerId = function(self)
            return self.Owner.userId
          end
        }, {
          __call = function(self)
            return self:use()
          end
        })
      }
      return self.__item
    end,
    __base = _base_0,
    __name = "Item"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  local self = _class_0
  self.__inherited = function(self, child)
    return print(tostring(self.__name) .. " was inherited by @{child.__name}")
  end
  Item = _class_0
end
local ItemEntity
do
  local _base_0 = {
    place = function(self, mouse_V3)
      if types.is_a_vector3(mouse_V3) then
        local availableHeight = 0
        for i = 1, 4 do
          if BLOCKS[mouse_V3.x][mouse_V3.y + i][mouse_V3.z] == { } then
            availableHeight = availableHeight + 1
          end
        end
        if self.__item.height and (availableHeight >= self.__item.height) then
          return BLOCKS:setBlock(mouse_V3.x, mouse_V3.y + 1, mouse_V3.z, self.__item)
        end
      end
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, name_ID)
      do
        local _with_0 = Instance.new("Tool")
        _with_0.CanBeDropped = false
        _with_0.ManualActivationOnly = false
        self.itemEntity = _with_0
      end
      if (type(name_ID)) == "string" then
        self.__item = Items[name_ID]()
      elseif (type(name_ID)) == "number" then
        for v in Items do
          if v.__parent == Items.Item.__class then
            if v.Id == name_ID then
              self.__item = v
            end
          end
        end
        return ItemERROR("Unknown item name or ID passed to `ItemEntity`")
      else
        return ItemERROR("Invalid item name or ID passed to `ItemEntity`")
      end
    end,
    __base = _base_0,
    __name = "ItemEntity"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  ItemEntity = _class_0
end
local ItemERROR
do
  local _parent_0 = Item
  local _base_0 = { }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, message)
      if message == nil then
        message = "Unknown Error"
      end
      return setmetatable({
        Name = "<!>",
        Id = 0x3C213E,
        Owner = nil,
        Message = message,
        what = function(self)
          return self.Message
        end,
        callback = function(self)
          return LOG:logError("Attempt to call `ItemERROR` class", nil, "Items.ItemERROR")
        end,
        use = function(self)
          return self:callback()
        end
      }, {
        __call = function(self)
          return self:use()
        end
      })
    end,
    __base = _base_0,
    __name = "ItemERROR",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        return _parent_0[name]
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  ItemERROR = _class_0
end
local Craftable
do
  local _parent_0 = Item
  local _base_0 = {
    addCraftingRecipe = function(tRecipe, item)
      Items.Recipes[tRecipe[1][1]] = Items.Recipes[tRecipe[1][1]] or { }
      Items.Recipes[tRecipe[1][1]][tRecipe[1][2]] = Items.Recipes[tRecipe[1][1]][tRecipe[1][2]] or { }
      Items.Recipes[tRecipe[1][1]][tRecipe[1][2]][tRecipe[1][3]] = Items.Recipes[tRecipe[1][1]][tRecipe[1][2]][tRecipe[1][3]] or { }
      Items.Recipes[tRecipe[1][1]][tRecipe[1][2]][tRecipe[1][3]][tRecipe[2][1]] = Items.Recipes[tRecipe[1][1]][tRecipe[1][2]][tRecipe[1][3]][tRecipe[2][1]] or { }
      Items.Recipes[tRecipe[1][1]][tRecipe[1][2]][tRecipe[1][3]][tRecipe[2][1]][tRecipe[2][2]] = Items.Recipes[tRecipe[1][1]][tRecipe[1][2]][tRecipe[1][3]][tRecipe[2][1]][tRecipe[2][2]] or { }
      Items.Recipes[tRecipe[1][1]][tRecipe[1][2]][tRecipe[1][3]][tRecipe[2][1]][tRecipe[2][2]][tRecipe[2][3]] = Items.Recipes[tRecipe[1][1]][tRecipe[1][2]][tRecipe[1][3]][tRecipe[2][1]][tRecipe[2][2]][tRecipe[2][3]] or { }
      Items.Recipes[tRecipe[1][1]][tRecipe[1][2]][tRecipe[1][3]][tRecipe[2][1]][tRecipe[2][2]][tRecipe[2][3]][tRecipe[3][1]] = Items.Recipes[tRecipe[1][1]][tRecipe[1][2]][tRecipe[1][3]][tRecipe[2][1]][tRecipe[2][2]][tRecipe[2][3]][tRecipe[3][1]] or { }
      Items.Recipes[tRecipe[1][1]][tRecipe[1][2]][tRecipe[1][3]][tRecipe[2][1]][tRecipe[2][2]][tRecipe[2][3]][tRecipe[3][1]][tRecipe[3][2]] = Items.Recipes[tRecipe[1][1]][tRecipe[1][2]][tRecipe[1][3]][tRecipe[2][1]][tRecipe[2][2]][tRecipe[2][3]][tRecipe[3][1]][tRecipe[3][2]] or { }
      Items.Recipes[tRecipe[1][1]][tRecipe[1][2]][tRecipe[1][3]][tRecipe[2][1]][tRecipe[2][2]][tRecipe[2][3]][tRecipe[3][1]][tRecipe[3][2]][tRecipe[3][3]] = Items.Recipes[tRecipe[1][1]][tRecipe[1][2]][tRecipe[1][3]][tRecipe[2][1]][tRecipe[2][2]][tRecipe[2][3]][tRecipe[3][1]][tRecipe[3][2]][tRecipe[3][3]] or setmetatable(tItem, tMT)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, tRecipe, tProperties, tMT)
      local _ = {
        [self.__item] = _parent_0[self.__item](self)
      }
      for _, v1 in ipairs(tRecipe) do
        if (not Items.Id[v1]) or ((type(v1)) ~= "string") then
          LOG:logError("Encountered item with invalid Recipe", nil, "Items." .. tostring(tProperties.Name))
          break
        end
      end
      for kProp, vVal in pairs(tProperties) do
        pcall(function()
          self[kProp] = vVal
        end)
      end
      return self.__item
    end,
    __base = _base_0,
    __name = "Craftable",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        return _parent_0[name]
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Craftable = _class_0
end
local CraftableItemEntity
do
  local _parent_0 = Item
  local _base_0 = {
    addCraftingRecipe = function(tRecipe, item)
      Items.Recipes[tRecipe[1][1]] = Items.Recipes[tRecipe[1][1]] or { }
      Items.Recipes[tRecipe[1][1]][tRecipe[1][2]] = Items.Recipes[tRecipe[1][1]][tRecipe[1][2]] or { }
      Items.Recipes[tRecipe[1][1]][tRecipe[1][2]][tRecipe[1][3]] = Items.Recipes[tRecipe[1][1]][tRecipe[1][2]][tRecipe[1][3]] or { }
      Items.Recipes[tRecipe[1][1]][tRecipe[1][2]][tRecipe[1][3]][tRecipe[2][1]] = Items.Recipes[tRecipe[1][1]][tRecipe[1][2]][tRecipe[1][3]][tRecipe[2][1]] or { }
      Items.Recipes[tRecipe[1][1]][tRecipe[1][2]][tRecipe[1][3]][tRecipe[2][1]][tRecipe[2][2]] = Items.Recipes[tRecipe[1][1]][tRecipe[1][2]][tRecipe[1][3]][tRecipe[2][1]][tRecipe[2][2]] or { }
      Items.Recipes[tRecipe[1][1]][tRecipe[1][2]][tRecipe[1][3]][tRecipe[2][1]][tRecipe[2][2]][tRecipe[2][3]] = Items.Recipes[tRecipe[1][1]][tRecipe[1][2]][tRecipe[1][3]][tRecipe[2][1]][tRecipe[2][2]][tRecipe[2][3]] or { }
      Items.Recipes[tRecipe[1][1]][tRecipe[1][2]][tRecipe[1][3]][tRecipe[2][1]][tRecipe[2][2]][tRecipe[2][3]][tRecipe[3][1]] = Items.Recipes[tRecipe[1][1]][tRecipe[1][2]][tRecipe[1][3]][tRecipe[2][1]][tRecipe[2][2]][tRecipe[2][3]][tRecipe[3][1]] or { }
      Items.Recipes[tRecipe[1][1]][tRecipe[1][2]][tRecipe[1][3]][tRecipe[2][1]][tRecipe[2][2]][tRecipe[2][3]][tRecipe[3][1]][tRecipe[3][2]] = Items.Recipes[tRecipe[1][1]][tRecipe[1][2]][tRecipe[1][3]][tRecipe[2][1]][tRecipe[2][2]][tRecipe[2][3]][tRecipe[3][1]][tRecipe[3][2]] or { }
      Items.Recipes[tRecipe[1][1]][tRecipe[1][2]][tRecipe[1][3]][tRecipe[2][1]][tRecipe[2][2]][tRecipe[2][3]][tRecipe[3][1]][tRecipe[3][2]][tRecipe[3][3]] = Items.Recipes[tRecipe[1][1]][tRecipe[1][2]][tRecipe[1][3]][tRecipe[2][1]][tRecipe[2][2]][tRecipe[2][3]][tRecipe[3][1]][tRecipe[3][2]][tRecipe[3][3]] or setmetatable(tItem, tMT)
    end,
    place = function(self, mouse_V3)
      if types.is_a_vector3(mouse_V3) then
        local availableHeight = 0
        for i = 1, 4 do
          if BLOCKS[math.floor(mouse_V3.x)][math.floor(mouse_V3.y + i)][math.floor(mouse_V3.z)] == { } then
            availableHeight = availableHeight + 1
          end
        end
        if self.__item.height and (availableHeight >= self.__item.height) then
          return BLOCKS:setBlock((math.floor(mouse_V3.x)), (math.floor(mouse_V3.y + 1)), (math.floor(mouse_V3.z)), self.__item)
        end
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, sItemName, tRecipe, tProperties, tMT)
      do
        local _with_0 = Instance.new("Tool")
        _with_0.CanBeDropped = false
        _with_0.ManualActivationOnly = false
        self.itemEntity = _with_0
      end
      local _ = {
        [self.__item] = _parent_0[self.__item](self)
      }
      for _, v1 in ipairs(tRecipe) do
        if (not Items.Id[v1]) or ((type(v1)) ~= "string") then
          LOG:logError("Encountered item with invalid Recipe", nil, "Items." .. tostring(tProperties.Name))
          break
        end
      end
      for kProp, vVal in pairs(tProperties) do
        pcall(function()
          self[kProp] = vVal
        end)
      end
      return self.__item
    end,
    __base = _base_0,
    __name = "CraftableItemEntity",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        return _parent_0[name]
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  CraftableItemEntity = _class_0
end
local NonCraftable
do
  local _parent_0 = Item
  local _base_0 = { }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, tProperties, tMT)
      self.__ITEM = _parent_0.__init(self)
      for kProp, vVal in pairs(tProperties) do
        pcall(function()
          self.__ITEM[kProp] = vVal
        end)
      end
      return setmetatable(self.__ITEM, tMT)
    end,
    __base = _base_0,
    __name = "NonCraftable",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        return _parent_0[name]
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  NonCraftable = _class_0
end
local Items = {
  Item = Item,
  Craftable = Craftable,
  NonCraftable = NonCraftable,
  Recipes = {
    NONE = {
      NONE = {
        NONE = {
          NONE = {
            NONE = {
              NONE = {
                NONE = {
                  NONE = {
                    NONE = ItemERROR()
                  }
                }
              }
            }
          }
        }
      }
    }
  },
  Id = {
    ROOT = 0x4df8f86e,
    NONE = 0,
    ItemERROR = 0x3C213E,
    Scarab_Charm = 1,
    Djed_Charm = 2,
    Isis_Curse_Charm = 3,
    Amethyst_Luck_Amulet = 4,
    Sun_Stone_Utere_Fexix_Luck_Charm = 5,
    Wedjat_Eye_Amulet = 6,
    Evil_Eye_Amulet = 7,
    Lapis_Lazuli_Amulet = 8,
    Isis_Knot = 9,
    Plummet_amulet = 10,
    Sesen_Charm = 11,
    Double_Plume_Feathers_Amulet = 12,
    Shen_Amulet = 13,
    Ieb_Charm = 14,
    Imenet_Charm = 15,
    Ka_Charm = 16,
    Menhed_Charm = 17,
    Nebu_Charm = 18,
    Pet_Charm = 19,
    Ushabtis_Amulet = 20,
    Was_Amulet = 21,
    Menta_Rune = 22,
    Winged_Solar_Disk = 23,
    Amenta_Rune = 24,
    Maat_Rune = 25,
    Naos_Tablet = 26,
    Palm_Branch_Charm = 27,
    Sa_Amulet = 28,
    Sekhem_Rune = 29,
    Sema_Rune = 30
  },
  Scarab_Charm = (function()
    local Scarab_Charm
    do
      local _parent_0 = Craftable
      local _base_0 = { }
      _base_0.__index = _base_0
      setmetatable(_base_0, _parent_0.__base)
      local _class_0 = setmetatable({
        __init = function(self, plrName)
          return _parent_0.__init(self, {
            [1] = {
              [1] = "Gold_Ingot",
              [2] = "Honey_Pot",
              [3] = "Gold_Ingot"
            },
            [2] = {
              [1] = "Ankh",
              [2] = "Sun_Stone",
              [3] = "Ushabtis_Amulet"
            },
            [3] = {
              [1] = "Gold_Ingot",
              [2] = "Honey_Pot",
              [3] = "Gold_Ingot"
            }
          }, {
            Name = "Scarab_Charm",
            Id = Items.Charms.Id["Scarab_Charm"],
            Owner = API.getPlayer(plrName),
            Used = false,
            callback = function(self)
              if not Used then
                self.Used = true
                return self.Owner.Character.Humanoid.Died:connect(function()
                  self.Used = false
                  return (S_DATA_STORE:GetDataStore("Inventory")):SetAsync((self.Owner.Name), API.GetInventory((self.Owner.Name)))
                end)
              end
            end,
            use = function(self)
              return self:callback()
            end
          }, {
            __call = function(self)
              return self:callback()
            end
          })
        end,
        __base = _base_0,
        __name = "Scarab_Charm",
        __parent = _parent_0
      }, {
        __index = function(cls, name)
          local val = rawget(_base_0, name)
          if val == nil then
            return _parent_0[name]
          else
            return val
          end
        end,
        __call = function(cls, ...)
          local _self_0 = setmetatable({}, _base_0)
          cls.__init(_self_0, ...)
          return _self_0
        end
      })
      _base_0.__class = _class_0
      if _parent_0.__inherited then
        _parent_0.__inherited(_parent_0, _class_0)
      end
      Scarab_Charm = _class_0
      return _class_0
    end
  end)(),
  Djed_Charm = (function()
    local Djed_Charm
    do
      local _parent_0 = Craftable
      local _base_0 = { }
      _base_0.__index = _base_0
      setmetatable(_base_0, _parent_0.__base)
      local _class_0 = setmetatable({
        __init = function(self, plrName)
          return _parent_0.__init(self, {
            [1] = {
              [1] = "Clay_Block",
              [2] = "Slime_Ball",
              [3] = "Clay_Block"
            },
            [2] = {
              [1] = "Soft_Cloud",
              [2] = "Diamond_Boots",
              [3] = "Soft_Cloud"
            },
            [3] = {
              [1] = "Clay_Block",
              [2] = "Slime_Ball",
              [3] = "Clay_Block"
            }
          }, {
            Name = "Djed_Charm",
            Id = Items.Charms.Id["Djed_Charm"],
            Owner = API.getPlayer(plrName),
            callback = function()
              return nil
            end,
            use = function(self)
              return self:callback()
            end
          }, {
            __call = function(self, ...)
              LOG:logInfo("Djed_Charm called with arguements:\t" .. tostring(unpack({
                ...
              })), nil, "Items")
              return ...
            end
          })
        end,
        __base = _base_0,
        __name = "Djed_Charm",
        __parent = _parent_0
      }, {
        __index = function(cls, name)
          local val = rawget(_base_0, name)
          if val == nil then
            return _parent_0[name]
          else
            return val
          end
        end,
        __call = function(cls, ...)
          local _self_0 = setmetatable({}, _base_0)
          cls.__init(_self_0, ...)
          return _self_0
        end
      })
      _base_0.__class = _class_0
      if _parent_0.__inherited then
        _parent_0.__inherited(_parent_0, _class_0)
      end
      Djed_Charm = _class_0
      return _class_0
    end
  end)(),
  Isis_Curse_Charm = (function()
    local Isis_Curse_Charm
    do
      local _parent_0 = NonCraftable
      local _base_0 = { }
      _base_0.__index = _base_0
      setmetatable(_base_0, _parent_0.__base)
      local _class_0 = setmetatable({
        __init = function(self, plrName)
          return _parent_0.__init(self, {
            Name = "Isis_Curse_Charm",
            Id = Items.Charms.Id["Isis_Curse_Charm"],
            Owner = API.getPlayer(plrName),
            callback = function(self, player)
              player = API.getPlayer(player)
              if player then
                do
                  local _with_0 = (script.Parent:FindFirstChild("Isis_Curse")):Clone()
                  _with_0.Parent = player.Character.Humanoid
                  _with_0.Disabled = false
                  return _with_0
                end
              end
            end,
            use = function(self, player)
              return self:callback(player)
            end
          }, {
            __call = function(self, player, ...)
              LOG:logInfo("Isis_Curse_Charm called on player " .. tostring((API.getPlayer(player)).Name))
              return self:use(player)
            end
          })
        end,
        __base = _base_0,
        __name = "Isis_Curse_Charm",
        __parent = _parent_0
      }, {
        __index = function(cls, name)
          local val = rawget(_base_0, name)
          if val == nil then
            return _parent_0[name]
          else
            return val
          end
        end,
        __call = function(cls, ...)
          local _self_0 = setmetatable({}, _base_0)
          cls.__init(_self_0, ...)
          return _self_0
        end
      })
      _base_0.__class = _class_0
      if _parent_0.__inherited then
        _parent_0.__inherited(_parent_0, _class_0)
      end
      Isis_Curse_Charm = _class_0
      return _class_0
    end
  end)(),
  Amethyst_Luck_Amulet = (function()
    local Amethyst_Luck_Amulet
    do
      local _parent_0 = Craftable
      local _base_0 = { }
      _base_0.__index = _base_0
      setmetatable(_base_0, _parent_0.__base)
      local _class_0 = setmetatable({
        __init = function(self, plrName)
          return _parent_0.__init(self, {
            [1] = {
              [1] = "Stick",
              [2] = "String",
              [3] = "Stick"
            },
            [2] = {
              [1] = "Honey_Pot",
              [2] = "Amethyst",
              [3] = "Thyme"
            },
            [3] = {
              [1] = "Stick",
              [2] = "String",
              [3] = "Stick"
            }
          }, {
            Name = "Amethyst_Luck_Amulet",
            Id = Items.Charms.Id["Amethyst_Luck_Amulet"],
            Owner = API.getPlayer(plrName),
            callback = function(self)
              if self.Owner then
                (S_DATA_STORE:GetDataStore("Bounty_Luck")):UpdateAsync(self.Owner.Name, function(val)
                  return val * (math.random(1.25, 1.625))
                end);
                (S_DATA_STORE:GetDataStore("Bounty_Luck")):GetAsync(self.Owner.Name)
                return self:Destroy()
              end
            end,
            use = function(self)
              return self:callback()
            end
          }, {
            __call = function(self)
              LOG:logInfo("Amethyst_Luck_Amulet called on player " .. tostring(self.Owner.Name), nil, "Items")
              return self:use()
            end
          })
        end,
        __base = _base_0,
        __name = "Amethyst_Luck_Amulet",
        __parent = _parent_0
      }, {
        __index = function(cls, name)
          local val = rawget(_base_0, name)
          if val == nil then
            return _parent_0[name]
          else
            return val
          end
        end,
        __call = function(cls, ...)
          local _self_0 = setmetatable({}, _base_0)
          cls.__init(_self_0, ...)
          return _self_0
        end
      })
      _base_0.__class = _class_0
      if _parent_0.__inherited then
        _parent_0.__inherited(_parent_0, _class_0)
      end
      Amethyst_Luck_Amulet = _class_0
      return _class_0
    end
  end)(),
  Sun_Stone_Utere_Fexix_Luck_Charm = (function()
    local Sun_Stone_Utere_Fexix_Luck_Charm
    do
      local _parent_0 = Craftable
      local _base_0 = { }
      _base_0.__index = _base_0
      setmetatable(_base_0, _parent_0.__base)
      local _class_0 = setmetatable({
        __init = function(self, plrName)
          return _parent_0.__init(self, {
            [1] = {
              [1] = "Stick",
              [2] = "String",
              [3] = "Stick"
            },
            [2] = {
              [1] = "Imenet_Charm",
              [2] = "Sun_Stone",
              [3] = "Ka_Charm"
            },
            [3] = {
              [1] = "Stick",
              [2] = "String",
              [3] = "Stick"
            }
          }, {
            Name = "Sun_Stone_Utere_Fexix_Luck_Charm",
            Id = Items.Charms.Id["Sun_Stone_Utere_Fexix_Luck_Charm"],
            Owner = API.getPlayer(plrName),
            callback = function(self)
              if self.Owner then
                (S_DATA_STORE:GetDataStore("Bounty_Luck")):UpdateAsync(self.Owner.Name, function(val)
                  return val * (math.random(1.5, 1.875))
                end)
                return (S_DATA_STORE:GetDataStore("Bounty_Luck")):GetAsync(self.Owner.Name)
              end
            end,
            use = function(self)
              return self:callback()
            end
          }, {
            __call = function(self)
              LOG:logInfo("Sun_Stone_Utere_Fexix_Luck_Charm called on player " .. tostring(self.Owner.Name), nil, "Items")
              return self:use()
            end
          })
        end,
        __base = _base_0,
        __name = "Sun_Stone_Utere_Fexix_Luck_Charm",
        __parent = _parent_0
      }, {
        __index = function(cls, name)
          local val = rawget(_base_0, name)
          if val == nil then
            return _parent_0[name]
          else
            return val
          end
        end,
        __call = function(cls, ...)
          local _self_0 = setmetatable({}, _base_0)
          cls.__init(_self_0, ...)
          return _self_0
        end
      })
      _base_0.__class = _class_0
      if _parent_0.__inherited then
        _parent_0.__inherited(_parent_0, _class_0)
      end
      Sun_Stone_Utere_Fexix_Luck_Charm = _class_0
      return _class_0
    end
  end)(),
  Wedjat_Eye_Amulet = (function()
    local Wedjat_Eye_Amulet
    do
      local _parent_0 = Craftable
      local _base_0 = { }
      _base_0.__index = _base_0
      setmetatable(_base_0, _parent_0.__base)
      local _class_0 = setmetatable({
        __init = function(self, plrName)
          return _parent_0.__init(self, {
            [1] = {
              [1] = "String",
              [2] = "NONE",
              [3] = "String"
            },
            [2] = {
              [1] = "Glowing_Water",
              [2] = "Heart",
              [3] = "Pixie_Dust"
            },
            [3] = {
              [1] = "NONE",
              [2] = "NONE",
              [3] = "NONE"
            }
          }, {
            Name = "Wedjat_Eye_Amulet",
            Id = Items.Charms.Id["Wedjat_Eye_Amulet"],
            Owner = API.getPlayer(plrName),
            callback = function(self)
              if self.Owner then
                Owner.Character.Humanoid.MaxHealth = Owner.Character.Humanoid.MaxHealth * 1.25
                Owner.Character.Humanoid.Health = Owner.Character.Humanoid.MaxHealth
              end
            end,
            use = function(self)
              return self:callback()
            end
          }, {
            __call = function(self)
              LOG:logInfo("Wedjat_Eye_Amulet called on player " .. tostring(self.Owner.Name), nil, "Items.charms.Wedjat_Eye_Amulet")
              return self:use()
            end
          })
        end,
        __base = _base_0,
        __name = "Wedjat_Eye_Amulet",
        __parent = _parent_0
      }, {
        __index = function(cls, name)
          local val = rawget(_base_0, name)
          if val == nil then
            return _parent_0[name]
          else
            return val
          end
        end,
        __call = function(cls, ...)
          local _self_0 = setmetatable({}, _base_0)
          cls.__init(_self_0, ...)
          return _self_0
        end
      })
      _base_0.__class = _class_0
      if _parent_0.__inherited then
        _parent_0.__inherited(_parent_0, _class_0)
      end
      Wedjat_Eye_Amulet = _class_0
      return _class_0
    end
  end)(),
  Evil_Eye_Amule = (function()
    local Evil_Eye_Amulet
    do
      local _parent_0 = Craftable
      local _base_0 = { }
      _base_0.__index = _base_0
      setmetatable(_base_0, _parent_0.__base)
      local _class_0 = setmetatable({
        __init = function(self, plrName)
          return _parent_0.__init(self, {
            [1] = {
              [1] = "Gold_Ingot",
              [2] = "Electrum_Ingot",
              [3] = "Silver_Ingot"
            },
            [2] = {
              [1] = "Sun_Stone",
              [2] = "Wraith_Eye",
              [3] = "Moon_Stone"
            },
            [3] = {
              [1] = "Gold_Ingot",
              [2] = "Electrum_Ingot",
              [3] = "Silver_Ingot"
            }
          }, {
            Name = "Evil_Eye_Amulet",
            Id = Items.Charms.Id["Evil_Eye_Amulet"],
            Owner = API.getPlayer(plrName),
            callback = function(self)
              if self.Owner then
                return thread(function()
                  return (game.ReplicatedStorage:FindFirstChild("AttackedEvent")).OnServerEvent:connect(function(attacker, recipient, damage, weaponType)
                    if recipient then
                      attacker.Character.Humanoid:TakeDamage(damage * .1);
                      (S_DATA_STORE:GetDataStore("Bounty_Luck")):UpdateAsync(attacker.Name, function(val)
                        return val * (math.random(.7, .85))
                      end)
                      return (S_DATA_STORE:GetDataStore("Bounty_Luck")):GetAsync(attacker.Name)
                    end
                  end)
                end)
              end
            end,
            use = function(self)
              return self:callback()
            end
          }, {
            __call = function(self)
              return self:use()
            end
          })
        end,
        __base = _base_0,
        __name = "Evil_Eye_Amulet",
        __parent = _parent_0
      }, {
        __index = function(cls, name)
          local val = rawget(_base_0, name)
          if val == nil then
            return _parent_0[name]
          else
            return val
          end
        end,
        __call = function(cls, ...)
          local _self_0 = setmetatable({}, _base_0)
          cls.__init(_self_0, ...)
          return _self_0
        end
      })
      _base_0.__class = _class_0
      if _parent_0.__inherited then
        _parent_0.__inherited(_parent_0, _class_0)
      end
      Evil_Eye_Amulet = _class_0
      return _class_0
    end
  end)(),
  Lapis_Lazuli_Amulet = (function()
    local Lapis_Lazuli_Amulet
    do
      local _parent_0 = Craftable
      local _base_0 = { }
      _base_0.__index = _base_0
      setmetatable(_base_0, _parent_0.__base)
      local _class_0 = setmetatable({
        __init = function(self, plrName)
          return _parent_0.__init(self, {
            [1] = {
              [1] = "Gold_Dust",
              [2] = "Sun_Stone",
              [3] = "Gold_Dust"
            },
            [2] = {
              [1] = "Blue_Wool",
              [2] = "Lapis_Block",
              [3] = "Blue_Wool"
            },
            [3] = {
              [1] = "Gold_Dust",
              [2] = "Moon_Stone",
              [3] = "Gold_Dust"
            }
          }, {
            Name = "Lapis_Lazuli_Amulet",
            Id = Items.Charms.Id["Lapis_Lazuli_Amulet"],
            Owner = API.getPlayer(plrName),
            maxUses = 5,
            nUses = 0,
            callback = function(self)
              if self.Owner then
                (S_DATA_STORE:GetDataStore("Bounty_Luck")):UpdateAsync(self.Owner.Name, function(val)
                  return val * (math.random(1.2, 1.51))
                end)
                return (S_DATA_STORE:GetDataStore("Bounty_Luck")):GetAsync(self.Owner.Name)
              end
            end,
            use = function(self)
              self.nUses = self.nUses + 1
              self:callback()
              if nUses >= self.maxUses then
                return self:Destroy()
              end
            end
          }, {
            __call = function(self)
              LOG:logInfo("Lapis_Lazuli_Amulet called on player " .. tostring(self.Owner.Name), nil, "Item.Craftable.Lapis_Lazuli_Amulet")
              return self:use()
            end
          })
        end,
        __base = _base_0,
        __name = "Lapis_Lazuli_Amulet",
        __parent = _parent_0
      }, {
        __index = function(cls, name)
          local val = rawget(_base_0, name)
          if val == nil then
            return _parent_0[name]
          else
            return val
          end
        end,
        __call = function(cls, ...)
          local _self_0 = setmetatable({}, _base_0)
          cls.__init(_self_0, ...)
          return _self_0
        end
      })
      _base_0.__class = _class_0
      if _parent_0.__inherited then
        _parent_0.__inherited(_parent_0, _class_0)
      end
      Lapis_Lazuli_Amulet = _class_0
      return _class_0
    end
  end)(),
  Isis_Knot = (function()
    local Isis_Knot
    do
      local _parent_0 = Craftable
      local _base_0 = { }
      _base_0.__index = _base_0
      setmetatable(_base_0, _parent_0.__base)
      local _class_0 = setmetatable({
        __init = function(self, plrName)
          _parent_0.__init(self, {
            [1] = {
              [1] = "NONE",
              [2] = "String",
              [3] = "NONE"
            },
            [2] = {
              [1] = "String",
              [2] = "Clay",
              [3] = "String"
            },
            [3] = {
              [1] = "NONE",
              [2] = "String",
              [3] = "NONE"
            }
          }, {
            Name = "Isis_Knot",
            Id = Items.Charms.Id["Isis_Knot"],
            Owner = API.getPlayer(plrName),
            callback = function(self)
              return (game.ReplicatedStorage:FindFirstChild("AttackedEvent")).OnServerEvent:connect(function(attacker, recipient, damage, weaponType)
                if (attacker ~= self.Owner) and (recipient == self.Owner) then
                  if weaponType ~= 0 then
                    return self.Owner.Character:TakeDamage(damage)
                  else
                    return ATTACKED_EVENT.InvokeServer(NULL_PLAYER, attacker, 1e-9, -1)
                  end
                end
              end)
            end,
            use = function(self)
              return self:callback()
            end
          }, {
            __call = function(self)
              return self:use()
            end
          })
          return thread(function()
            local values = pack((game.ReplicatedStorage:FindFirstChild("AttackedEvent")).OnServerEvent:wait())
            while ((INVENTORY.getInventory(plrName)).hasItem("Isis_Knot")) and values do
              local attacker, recipient, damage, type_ = unpack(values)
              if recipient == API.getPlayer(plrName) then
                if type_ ~= "direct" then
                  recipient.Humanoid:TakeDamage(damage)
                else
                  LOG:logInfo("Isis_Knot Blocked damage from direct attack on " .. tostring(recipient.Name), nil, "Item.NonCraftable.Isis_Knot")
                end
              end
              values = pack((game.ReplicatedStorage:FindFirstChild("AttackedEvent")).OnServerEvent:wait())
            end
          end)
        end,
        __base = _base_0,
        __name = "Isis_Knot",
        __parent = _parent_0
      }, {
        __index = function(cls, name)
          local val = rawget(_base_0, name)
          if val == nil then
            return _parent_0[name]
          else
            return val
          end
        end,
        __call = function(cls, ...)
          local _self_0 = setmetatable({}, _base_0)
          cls.__init(_self_0, ...)
          return _self_0
        end
      })
      _base_0.__class = _class_0
      if _parent_0.__inherited then
        _parent_0.__inherited(_parent_0, _class_0)
      end
      Isis_Knot = _class_0
      return _class_0
    end
  end)(),
  Plummet_Amulet = (function()
    local Plummet_Amulet
    do
      local _parent_0 = Craftable
      local _base_0 = { }
      _base_0.__index = _base_0
      setmetatable(_base_0, _parent_0.__base)
      local _class_0 = setmetatable({
        __init = function(self, plrName)
          return _parent_0.__init(self, {
            [1] = {
              [1] = "Feather",
              [2] = "Soft_Sand",
              [3] = "Feather"
            },
            [2] = {
              [1] = "NONE",
              [2] = "Slime_Block",
              [3] = "NONE"
            },
            [3] = {
              [1] = "Enchanted_Book__Feather_Falling",
              [2] = "Quicksilver",
              [3] = "Diamond_Boots"
            }
          }, {
            Name = "Plummet_Amulet",
            Id = Items.Charms.Id["Plummet_Amulet"],
            Owner = API.getPlayer(plrName),
            callback = function(self)
              if self.Owner.Character:FindFirstChild("Impact") then
                (self.Owner.Character:FindFirstChild("Impact")).Disabled = false
              else
                do
                  local _with_0 = (script:FindFirstChild("Impact")):Clone()
                  _with_0.Parent = self.Owner.Character
                  _with_0.Disabled = false
                  return _with_0
                end
              end
            end,
            use = function(self)
              return self:callback()
            end,
            unequip = function(self)
              (self.Owner.Character:FindFirstChild("Impact")).Disabled = true
            end
          }, {
            __call = function(self)
              return self:use()
            end
          })
        end,
        __base = _base_0,
        __name = "Plummet_Amulet",
        __parent = _parent_0
      }, {
        __index = function(cls, name)
          local val = rawget(_base_0, name)
          if val == nil then
            return _parent_0[name]
          else
            return val
          end
        end,
        __call = function(cls, ...)
          local _self_0 = setmetatable({}, _base_0)
          cls.__init(_self_0, ...)
          return _self_0
        end
      })
      _base_0.__class = _class_0
      if _parent_0.__inherited then
        _parent_0.__inherited(_parent_0, _class_0)
      end
      Plummet_Amulet = _class_0
      return _class_0
    end
  end)(),
  Sesen_Charm = (function()
    local Sesen_Charm
    do
      local _parent_0 = Craftable
      local _base_0 = { }
      _base_0.__index = _base_0
      setmetatable(_base_0, _parent_0.__base)
      local _class_0 = setmetatable({
        __init = function(self, plrName)
          return _parent_0.__init(self, {
            [1] = {
              [1] = "Stick",
              [2] = "Diamond",
              [3] = "Stick"
            },
            [2] = {
              [1] = "Leather",
              [2] = "Diamond",
              [3] = "Leather"
            },
            [3] = {
              [1] = "Stick",
              [2] = "Diamond",
              [3] = "Stick"
            }
          }, {
            Name = "Sesen_Charm",
            Id = Items.Charms.Id["Sesen_Charm"],
            Owner = API.getPlayer(plrName),
            maxUses = 10,
            nUses = 0,
            callback = function(self)
              (S_DATA_STORE:GetDataStore("Inventory")):SetAsync((self.Owner.Name), API.GetInventory((self.Owner.Name)))
              return self.Owner:LoadCharacter()
            end,
            use = function(self)
              local nUses = nUses + 1
              self:callback()
              if self.nUses >= self.maxUses then
                return self:Destroy()
              end
            end,
            Destroy = function(self)
              for v in self do
                v = nil
              end
              self = nil
            end
          }, {
            __call = function(self)
              return self:use()
            end
          })
        end,
        __base = _base_0,
        __name = "Sesen_Charm",
        __parent = _parent_0
      }, {
        __index = function(cls, name)
          local val = rawget(_base_0, name)
          if val == nil then
            return _parent_0[name]
          else
            return val
          end
        end,
        __call = function(cls, ...)
          local _self_0 = setmetatable({}, _base_0)
          cls.__init(_self_0, ...)
          return _self_0
        end
      })
      _base_0.__class = _class_0
      if _parent_0.__inherited then
        _parent_0.__inherited(_parent_0, _class_0)
      end
      Sesen_Charm = _class_0
      return _class_0
    end
  end)(),
  Double_Plume_Feathers_Amulet = (function()
    local Double_Plume_Feathers_Amulet
    do
      local _parent_0 = Craftable
      local _base_0 = { }
      _base_0.__index = _base_0
      setmetatable(_base_0, _parent_0.__base)
      local _class_0 = setmetatable({
        __init = function(self, plrName)
          local _ = {
            super = {
              [1] = {
                [1] = "Feather",
                [2] = "Aer_Essence",
                [3] = "Feather"
              },
              [2] = {
                [1] = "Solid_Aer",
                [2] = "Sapphire",
                [3] = "Solid_Aer"
              },
              [3] = {
                [1] = "Quartz_Block",
                [2] = "Silver_Block",
                [3] = "Quartz_Block"
              }
            }
          }, {
            Name = "Double_Plume_Feathers_Amulet",
            Id = Items.Charms.Id["Double_Plume_Feathers_Amulet"],
            Owner = API.getPlayer(plrName),
            callback = function()
              return nil
            end,
            use = function(self)
              return self:callback()
            end
          }, {
            __call = function(self)
              return self:use()
            end
          }
          if API.getPlayer(plrName) then
            do
              local _with_0 = Instance.new("BodyForce")
              _with_0.force = (Vector3.new(0, 192.6, 0)) * (GetMass((API.getPlayer(plrName)).Character))
              _with_0.Parent = (API.getPlayer(plrName)).Character.Humanoid.Torso
            end
            return thread(function()
              return game.player.PlayerAdded:connect(function(plr)
                return plr.CharacterAdded:connect(function(chr)
                  do
                    local _with_0 = Instance.new("BodyForce")
                    local force = (Vector3.new(0, 192.6, 0)) * (GetMass(chr))
                    local Parent = chr.Character.Humanoid.Torso
                    return _with_0
                  end
                end)
              end)
            end)
          end
        end,
        __base = _base_0,
        __name = "Double_Plume_Feathers_Amulet",
        __parent = _parent_0
      }, {
        __index = function(cls, name)
          local val = rawget(_base_0, name)
          if val == nil then
            return _parent_0[name]
          else
            return val
          end
        end,
        __call = function(cls, ...)
          local _self_0 = setmetatable({}, _base_0)
          cls.__init(_self_0, ...)
          return _self_0
        end
      })
      _base_0.__class = _class_0
      if _parent_0.__inherited then
        _parent_0.__inherited(_parent_0, _class_0)
      end
      Double_Plume_Feathers_Amulet = _class_0
      return _class_0
    end
  end)(),
  Shen_Amulet = (function()
    local Shen_Amulet
    do
      local _parent_0 = Craftable
      local _base_0 = { }
      _base_0.__index = _base_0
      setmetatable(_base_0, _parent_0.__base)
      local _class_0 = setmetatable({
        __init = function(self, plrName)
          _parent_0.__init(self, {
            [1] = {
              [1] = "Blood_Vial",
              [2] = "Copper_Ingot",
              [3] = "Blood_Vial"
            },
            [2] = {
              [1] = "Healing_Tablet",
              [2] = "Herb_Sack",
              [3] = "Healing_Tablet"
            },
            [3] = {
              [1] = "Skull",
              [2] = "Heart",
              [3] = "Skull"
            }
          }, {
            Name = "Shen_Amulet",
            Id = Items.Charms.Id["Shen_Amulet"],
            Owner = API.getPlayer(plrName),
            callback = function()
              return nil
            end,
            use = function(self)
              return self:callback()
            end
          }, {
            __call = function(self)
              return self:use()
            end
          })
          do
            local _with_0 = (self.Owner.Character or (API.getPlayer(plrName)).Character)
            _with_0.MaxHealth = _with_0.MaxHealth * 2.5
            _with_0.Health = _with_0.MaxHealth
          end
          return thread(function()
            return game.Players.PlayerAdded:connect(function(plr)
              if plr.Name == self.Owner.Name then
                return plr.CharacterAdded:connect(function(chr)
                  do
                    local _with_0 = chr
                    _with_0.MaxHealth = _with_0.MaxHealth * 2.5
                    _with_0.Health = _with_0.MaxHealth
                    return _with_0
                  end
                end)
              end
            end)
          end)
        end,
        __base = _base_0,
        __name = "Shen_Amulet",
        __parent = _parent_0
      }, {
        __index = function(cls, name)
          local val = rawget(_base_0, name)
          if val == nil then
            return _parent_0[name]
          else
            return val
          end
        end,
        __call = function(cls, ...)
          local _self_0 = setmetatable({}, _base_0)
          cls.__init(_self_0, ...)
          return _self_0
        end
      })
      _base_0.__class = _class_0
      if _parent_0.__inherited then
        _parent_0.__inherited(_parent_0, _class_0)
      end
      Shen_Amulet = _class_0
      return _class_0
    end
  end)(),
  Ieb_Charm = (function()
    local Ieb_Charm
    do
      local _parent_0 = Item
      local _base_0 = { }
      _base_0.__index = _base_0
      setmetatable(_base_0, _parent_0.__base)
      local _class_0 = setmetatable({
        __init = function(self, plrName)
          setmetatable({
            Name = "Ieb_Charm",
            Id = Items.Charms.Id["Ieb_Charm"],
            Owner = API.getPlayer(plrName),
            callback = function(self)
              return nil
            end,
            use = function(self)
              return self:callback()
            end
          }, {
            __call = function(self)
              return self:use()
            end
          })
          thread(function()
            local chr = API.getPlayer(plrName)
            if chr then
              while chr and wait(1.25) do
                chr.Humanoid.Health = math.min(chr.Humanoid.MaxHealth, (chr.Humanoid.Health + chr.Humanoid.Health * math.random(.1, .5525)))
              end
            end
          end)
          return thread(function()
            return game.Players.PlayerAdded:connect(function(plr)
              if plr.Name == plrName then
                return plr.CharacterAdded:connect(function()
                  return thread(function(chr)
                    if not not chr then
                      while chr and wait(1.25) do
                        chr.Humanoid.Health = math.min(chr.Humanoid.MaxHealth, (chr.Humanoid.Health + chr.Humanoid.Health * math.random(.1, .5525)))
                      end
                    end
                  end)
                end)
              end
            end)
          end)
        end,
        __base = _base_0,
        __name = "Ieb_Charm",
        __parent = _parent_0
      }, {
        __index = function(cls, name)
          local val = rawget(_base_0, name)
          if val == nil then
            return _parent_0[name]
          else
            return val
          end
        end,
        __call = function(cls, ...)
          local _self_0 = setmetatable({}, _base_0)
          cls.__init(_self_0, ...)
          return _self_0
        end
      })
      _base_0.__class = _class_0
      if _parent_0.__inherited then
        _parent_0.__inherited(_parent_0, _class_0)
      end
      Ieb_Charm = _class_0
      return _class_0
    end
  end)(),
  Imenet_Charm = (function()
    local Imenet_Charm
    do
      local _parent_0 = Item
      local _base_0 = { }
      _base_0.__index = _base_0
      setmetatable(_base_0, _parent_0.__base)
      local _class_0 = setmetatable({
        __init = function(self, plrName)
          return setmetatable({
            Name = "Imenet_Charm",
            Id = Items.Charms.Id["Imenet_Charm"],
            Owner = API.getPlayer(plrName),
            callback = function(self)
              if self.Owner then
                return Spawn(function()
                  while LIGHTING:GetMinutesAfterMidnight() < 1140 do
                    wait(20)
                  end
                  while wait(0.125) do
                    do
                      local _with_0 = self.Owner.Character.Humanoid
                      _with_0.Health = _with_0.Health + (_with_0.Health - _with_0.MaxHealth) * math.abs((math.random() - math.random()))
                    end
                  end
                end)
              else
                return LOG:logWarn("@Owner is nil, cannot call `callback` properly.", nil, "Item.NonCraftable.Imenet_Charm")
              end
            end,
            use = function(self)
              return self:callback()
            end
          }, {
            __call = function(self)
              return use()
            end
          })
        end,
        __base = _base_0,
        __name = "Imenet_Charm",
        __parent = _parent_0
      }, {
        __index = function(cls, name)
          local val = rawget(_base_0, name)
          if val == nil then
            return _parent_0[name]
          else
            return val
          end
        end,
        __call = function(cls, ...)
          local _self_0 = setmetatable({}, _base_0)
          cls.__init(_self_0, ...)
          return _self_0
        end
      })
      _base_0.__class = _class_0
      if _parent_0.__inherited then
        _parent_0.__inherited(_parent_0, _class_0)
      end
      Imenet_Charm = _class_0
      return _class_0
    end
  end)(),
  Ka_Charm = (function()
    local Ka_Charm
    do
      local _parent_0 = Craftable
      local _base_0 = { }
      _base_0.__index = _base_0
      setmetatable(_base_0, _parent_0.__base)
      local _class_0 = setmetatable({
        __init = function(self, plrName)
          return _parent_0.__init(self, {
            [1] = {
              [1] = "NONE",
              [2] = "Knowledge_Fragment",
              [3] = "NONE"
            },
            [2] = {
              [1] = "Clay",
              [2] = "Blank_Tablet",
              [3] = "Clay"
            },
            [3] = {
              [1] = "Scribe_Set",
              [2] = "Golden_Ring",
              [3] = "Ink_Vial"
            }
          }, {
            Name = "Ka_Charm",
            Id = Items.Charms.Id["Ka_Charm"],
            Owner = API.getPlayer(plrName),
            callback = function(self)
              if self.Owner then
                return Spawn(function()
                  while LIGHTING:GetMinutesAfterMidnight() < 360 do
                    wait(20)
                  end
                  while wait(0.125) do
                    do
                      local _with_0 = self.Owner.Character.Humanoid
                      _with_0.Health = _with_0.Health + (_with_0.Health - _with_0.MaxHealth) * math.abs((math.random() - math.random()))
                    end
                  end
                end)
              else
                return LOG:logWarn("@Owner is nil, cannot call `callback` properly.", nil, "Item.Craftable.Ka_Charm")
              end
            end,
            use = function(self)
              return self:callback()
            end
          }, {
            __call = function(self)
              return self:use()
            end
          })
        end,
        __base = _base_0,
        __name = "Ka_Charm",
        __parent = _parent_0
      }, {
        __index = function(cls, name)
          local val = rawget(_base_0, name)
          if val == nil then
            return _parent_0[name]
          else
            return val
          end
        end,
        __call = function(cls, ...)
          local _self_0 = setmetatable({}, _base_0)
          cls.__init(_self_0, ...)
          return _self_0
        end
      })
      _base_0.__class = _class_0
      if _parent_0.__inherited then
        _parent_0.__inherited(_parent_0, _class_0)
      end
      Ka_Charm = _class_0
      return _class_0
    end
  end)(),
  Menhed_Charm = (function()
    local Menhed_Charm
    do
      local _parent_0 = Craftable
      local _base_0 = { }
      _base_0.__index = _base_0
      setmetatable(_base_0, _parent_0.__base)
      local _class_0 = setmetatable({
        __init = function(self, plrName)
          self.__ITEM = _parent_0.__init(self, {
            [1] = {
              [1] = "Moonstone_Dust",
              [2] = "Electrum_Ingot",
              [3] = "Sunstone_Dust"
            },
            [2] = {
              [1] = "Blank_Tablet",
              [2] = "Scribe_Set",
              [3] = "Blank_Tablet"
            },
            [3] = {
              [1] = "Gold_Block",
              [2] = "Electrum_Block",
              [3] = "Silver_Block"
            }
          }, {
            Name = "Menhed_Charm",
            Id = Items.charms.Id["Menhed_Charm"],
            Owner = API.getPlayer(plrName),
            callback = function(self)
              return (S_DATA_STORE:GetDataStore("Stats")):UpdateAsync(self.Owner, function(t)
                return {
                  nPlays = t.nPlays,
                  StandingPosition = t.StandingPosition,
                  TabletCostLess = t.TabletCostLess + ((x / 2.718281828) ^ -.6183358898) ^ (0.36787944123356733855191706781332),
                  Humanoid = {
                    MaxHealth = t.Humanoid.MaxHealth,
                    Health = t.Humanoid.Health,
                    WalkSpeed = t.Humanoid.WalkSpeed
                  },
                  Bank = {
                    Interest = t.Bank.Interest
                  },
                  Inventory = {
                    nUsesLess = t.Inventory.nUsesLess
                  }
                }
              end)
            end,
            [self.use] = function(self)
              return self:callback()
            end
          }, {
            __call = function(self)
              return self:use()
            end
          })
        end,
        __base = _base_0,
        __name = "Menhed_Charm",
        __parent = _parent_0
      }, {
        __index = function(cls, name)
          local val = rawget(_base_0, name)
          if val == nil then
            return _parent_0[name]
          else
            return val
          end
        end,
        __call = function(cls, ...)
          local _self_0 = setmetatable({}, _base_0)
          cls.__init(_self_0, ...)
          return _self_0
        end
      })
      _base_0.__class = _class_0
      if _parent_0.__inherited then
        _parent_0.__inherited(_parent_0, _class_0)
      end
      Menhed_Charm = _class_0
      return _class_0
    end
  end)()
}
