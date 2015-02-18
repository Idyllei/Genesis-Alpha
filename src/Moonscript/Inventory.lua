local __extends__
do
  local _obj_0 = require("__Extends__")
  __extends__ = _obj_0.__extends__
end
local Item
do
  local _obj_0 = (require("Items"))
  Item = _obj_0.Item
end
local hashids = require("hashids")
local hashAlphabet = "ABCDEF1234567890"
local Inventory
do
  local _base_0 = {
    getInventory = function(self, plrName)
      return self.__PLAYER_INVENTORIES[plrName]
    end,
    loadInventory = function(self, plrName)
      self.__PLAYER_INVENTORIES[plrName] = ((S_DATA_STORE:GetDataStore("Inventories")):GetAsync(plrName)) or self:new(plrName)
      return self.__PLAYER_INVENTORIES
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(plrName)
      self.__PLAYER_INVENTORIES[plrName] = setmetatable({ }, {
        __index = {
          Owner = plrName,
          INVENTORY = { },
          getHash = function(item)
            local nameHash = hashids.new(nil, 8, hashAlphabet)
            local nHash = nameHash:encrypt(unpack(item.Name:byte()))
            local idHash = hashids.new(nil, 8, hashAlphabet)
            local iHash = idHash:encrypt(item.Id)
            local ownerHash = hashIds.new(nil, 8, hashAlphabet)
            local oHash = wnerHash:encrypt(unpack(item.OwnerName:byte()))
            return nHash .. "-" .. iHash .. "$" .. oHash, nameHash, idHash, ownerHash
          end,
          decodeHash = function(hash, a, b, c)
            local name = hash:match("^%a-")
            name = name:sub(1, name:len() - 1)
            name = {
              a:decode(name)
            }
            local id = id:match("-%a%$")
            id = id:sub(2, id:len() - 1)
            id = b:decode(id)
            local owner = owner:match("%$%a$")
            owner = owner:sub(2, owner:len())
            owner = {
              c:decode(owner)
            }
            local itemName = ""
            for _index_0 = 1, #name do
              local _, byte = name[_index_0]
              itemName = itemName .. string.char(byte)
            end
            local ownerName = ""
            for _index_0 = 1, #owner do
              local _, byte = owner[_index_0]
              ownerName = ownerName .. string.char(byte)
            end
            return itemName, id, ownerName
          end,
          contains = function(self, itemName)
            for _, v in pairs(self.INVENTORY) do
              if (v.Name == itemName) or (v.Id == itemName) then
                return true
              end
            end
            return false
          end,
          containsItem = function(self, itemName)
            return self:contains(itemName)
          end,
          hasItem = function(self, itemName)
            return self:contains(itemName)
          end,
          add = function(self, x, itemY, item)
            if item then
              self[{
                x,
                itemY
              }] = item
            elseif itemY then
              self[x] = itemY
            else
              return pcall(error, "[DEBUG][ERROR][Inventory]|Attempt to call `add` with insufficient parameters.", 2)
            end
          end,
          addItem = function(self, x, itemY, item)
            return self:add(x, itemY, item)
          end,
          remove = function(self, x, y)
            if y then
              local ret = rawget(self, {
                x,
                y
              })
              rawset(self, {
                x,
                y
              }, nil)
              return ret
            elseif x then
              if (type(x)) == "table" then
                local ret = rawget(self, x)
                rawset(self, x, nil)
                return ret
              else
                pcall(error, "[DEBUG][ERROR][Inventory]|Attempt to call `remove` with invalid `x` parameter.", 2)
                return Item()
              end
            else
              return pcall(error, "[DEBUG][ERROR][Inventory]|Attempt to call `remove` with insufficient parameters.", 2)
            end
          end,
          removeItem = function(self, x, y)
            return self:remove(x, y)
          end,
          clear = function(self, id)
            if id then
              for i, v in pairs(self.INVENTORY) do
                if v.Id == id then
                  self:remove(i)
                end
              end
            else
              for i, v in pairs(self.INVENTORY) do
                self:remove(i)
              end
            end
          end,
          clean = function(self, id)
            return self:clear(id)
          end
        },
        __newindex = function(self, i, v)
          if (v.__extends__(Item)) then
            self.Inventory[i] = v
          else
            return pcall(error, "[DEBUG][ERROR][INVENTORY]|Attempt to set invalid value (non-Item) to index: `" .. tostring(i) .. "`", 2)
          end
        end,
        __metatable = function(self)
          return (getmetatable(self)).__index
        end
      })
    end,
    __base = _base_0,
    __name = "Inventory"
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
  self.__PLAYER_INVENTORIES = { }
  Inventory = _class_0
end
return Inventory
