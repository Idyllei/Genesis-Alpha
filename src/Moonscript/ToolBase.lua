local xround
do
  local _obj_0 = require("utils")
  xround = _obj_0.xround
end
local ToolBase
do
  local _parent_0 = BaseClass
  local _base_0 = {
    takeDurability = function(self, amount)
      if amount == nil then
        amount = 1
      end
      self.durability = self.durability - xround(amount, 0)
      if self.durability <= 0 then
        return self:destroy()
      end
    end,
    use = function(self, plr, shift, leftClick, rightClick, subject, damageTaken)
      if damageTaken == nil then
        damageTaken = 1
      end
      if shift then
        if leftClick then
          self.callbacks.shiftLeftClick()
          self.durability = self.durability - 1
        elseif rightClick then
          self.callbacks.shiftRightClick()
          self.durability = self.durability - 1
        else
          return LOG:logWarn("Invalid arguements:\n\t" .. tostring(prettyTab({
            ...
          })) .. "\nto " .. tostring(self.__name) .. ".use(...)", nil, "Tool." .. tostring(self.__class.__name))
        end
      else
        if leftClick then
          self.callbacks.leftClick()
          self.durability = self.durability - 1
        elseif rightClick then
          self.callbacks.rightClick()
          self.durability = self.durability - 1
        else
          return LOG:logWarn("Invalid arguements:\n\t" .. tostring(prettyTab({
            ...
          })) .. "\nto " .. tostring(self.__name) .. ".use(...)", nil, "Tool." .. tostring(self.__class.__name))
        end
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, name, durability, maxDurability, callbackLeftClick, callbackRightClick, callbackShiftLeftClick, callbackShiftRightCLick, keybindingCallbacks)
      if name == nil then
        name = "Tool"
      end
      if durability == nil then
        durability = 1
      end
      if maxDurability == nil then
        maxDurability = 1
      end
      if callbackLeftClick == nil then
        callbackLeftClick = (function() end)
      end
      if callbackRightClick == nil then
        callbackRightClick = (function() end)
      end
      if callbackShiftLeftClick == nil then
        callbackShiftLeftClick = (function() end)
      end
      if callbackShiftRightCLick == nil then
        callbackShiftRightCLick = (function() end)
      end
      if keybindingCallbacks == nil then
        keybindingCallbacks = { }
      end
      self.tags = { }
      self.name = name
      self.durability = (durability >= 0) and durability or 0
      self.maxDurability = (maxDurability >= durability) and maxDurability or durability
      self.callbacks = {
        leftClick = callbackLeftClick,
        rightClick = callbackRightClick,
        shiftLeftClick = callbackShiftLeftCLick,
        shiftRightClick = callbackShiftRightClick
      }
      for k, v in pairs(keybindingCallbacks) do
        table.insert(self.callbacks, k, v)
      end
    end,
    __base = _base_0,
    __name = "ToolBase",
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
  ToolBase = _class_0
  return _class_0
end
