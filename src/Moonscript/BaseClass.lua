local BaseClass
do
  local _base_0 = {
    __extends__ = (require("__Extends__")).__extends__,
    __is__ = (require("__Is__")).__is__,
    crypter = (require("hashids")).new((require("HIDDEN_CONFIG")).dbg_hash_salt),
    __inherited = function(child)
      return LOG:logDebug("Class " .. tostring(self.__name) .. " inherited by " .. tostring(child.__name), tick(), "BaseClass")
    end,
    identity = function()
      return print(self.__name)
    end,
    hash = function()
      return self.crypter.encrypt(_G.prettyTable(self))
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function()
      return self
    end,
    __base = _base_0,
    __name = "BaseClass"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  BaseClass = _class_0
  return _class_0
end
