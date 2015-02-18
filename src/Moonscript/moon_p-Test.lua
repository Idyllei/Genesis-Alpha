local moonscript = require("moon.all")
local Clazz
do
  local _base_0 = {
    printValues = function(self)
      return print(tostring(self.mInt1) .. ", " .. tostring(self.mInt2) .. ", " .. tostring(self.mTab1) .. ", " .. tostring(self.mTab2) .. ", " .. tostring(self.mstr1) .. ", " .. tostring(self.mStr2))
    end,
    getReturn = function()
      return 1
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, mInt1, mInt1, mStr1)
      if mInt1 == nil then
        mInt1 = 0
      end
      if mInt1 == nil then
        mInt1 = {
          "abc"
        }
      end
      if mStr1 == nil then
        mStr1 = ""
      end
      self.mInt1 = mInt1
      self.mTab1 = mTab1
      self.mStr1 = mStr1
    end,
    __base = _base_0,
    __name = "Clazz"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Clazz = _class_0
end
return moonscript.p(Clazz())
