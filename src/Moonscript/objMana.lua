local API = require("API")
local Mana
do
  local _base_0 = {
    addExperience = function(self, amt)
      if amt == nil then
        amt = 0
      end
      self.experience.amt = self.experience.amt + amt
      return self
    end,
    calcXpForLvlUp = function(self)
      return 100 * 1.25 ^ (self.experience.level + 1)
    end,
    recalculateLevel = function(self)
      if self.experience.amt >= self:calcXpForLvlUp() then
        self.experience.level = self.experience.level + 1
        return self:recalculateLevel()
      end
    end,
    useMana = function(self, amt)
      if amt == nil then
        amt = 0
      end
      if amt < 0 then
        error("", 2)
      end
      self.experience.amt = self.experience.amt + ((math.floor(amt)) / 100)
      self.remaining = self.remaining - math.ceil(amt)
      self:recalculateLevel()
      return self.remaining, self.experience.amt
    end,
    replenishMana = function(self, amt)
      if amt == nil then
        amt = 0
      end
      if amt < 0 then
        error("", 2)
      end
      self.remaining = math.min(self.remaining + amt, self.absMax)
      return self
    end,
    __unm = function(self)
      local newMana
      do
        local _with_0 = Mana(self.player)
        _with_0.baseMax = 0
        _with_0.absMax = 0
        _with_0.remaining = 0
        _with_0.experience.level = 0
        _with_0.experience.amt = 0
        newMana = _with_0
      end
      return newMana
    end,
    __add = function(self, other)
      if other.__class == self.__class then
        local newMana
        do
          local _with_0 = Mana(self.player)
          _with_0.baseMax = _with_0.baseMax + other.baseMax
          _with_0.remaining = _with_0.remaining + other.remaining
          _with_0.experience.level = _with_0.experience.level + other.experience.level
          _with_0.experience.amt = _with_0.experience.amt + other.experience.amt
          newMana = _with_0
        end
        for i, v in pairs(self) do
          if v < 0 then
            self[i] = 0
          end
        end
        newMana.baseMax = math.min(newMana.baseMax, newMana.absMax)
        return newMana
      else
        do
          other = tonumber(other)
          if other then
            local newMana
            do
              local _with_0 = Mana(self.player)
              _with_0.baseMax = _with_0.baseMax + other
              _with_0.remaining = _with_0.remaining + other
              _with_0.experience.level = _with_0.experience.level + other
              _with_0.experience.amt = _with_0.experience.amt + other
              newMana = _with_0
            end
            for i, v in pairs(self) do
              if v < 0 then
                self[i] = 0
              end
            end
            newMana.baseMax = math.min(newMana.baseMax, newMana.absMax)
            return newMana
          elseif (type(other)) == "table" then
            local newMana
            do
              local _with_0 = Mana(self.player)
              _with_0.baseMax = _with_0.baseMax + other[1]
              _with_0.remaining = _with_0.remaining + other[2]
              _with_0.experience.level = _with_0.experience.level + other[3][1]
              _with_0.experience.amt = _with_0.experience.amt + other[3][2]
              newMana = _with_0
            end
            for i, v in pairs(self) do
              if v < 0 then
                self[i] = 0
              end
            end
            newMana.baseMax = math.min(newMana.baseMax, newMana.absMax)
            return newMana
          end
        end
      end
    end,
    __sub = function(self, other)
      if other.__class == self.__class then
        local newMana
        do
          local _with_0 = Mana(self.player)
          _with_0.baseMax = _with_0.baseMax - other.baseMax
          _with_0.remaining = _with_0.remaining - other.remaining
          _with_0.experience.level = _with_0.experience.level - other.experience.level
          _with_0.experience.amt = _with_0.experience.amt - other.experience.amt
          newMana = _with_0
        end
        for i, v in pairs(self) do
          if v < 0 then
            self[i] = 0
          end
        end
        newMana.baseMax = math.min(newMana.baseMax, newMana.absMax)
        return newMana
      else
        do
          other = tonumber(other)
          if other then
            local newMana
            do
              local _with_0 = Mana(self.player)
              _with_0.baseMax = _with_0.baseMax - other
              _with_0.remaining = _with_0.remaining - other
              _with_0.experience.level = _with_0.experience.level - other
              _with_0.experience.amt = _with_0.experience.amt - other
              newMana = _with_0
            end
            for i, v in pairs(self) do
              if v < 0 then
                self[i] = 0
              end
            end
            newMana.baseMax = math.min(newMana.baseMax, newMana.absMax)
            return newMana
          elseif (type(other)) == "table" then
            local newMana
            do
              local _with_0 = Mana(self.player)
              _with_0.baseMax = _with_0.baseMax - other[1]
              _with_0.remaining = _with_0.remaining - other[2]
              _with_0.experience.level = _with_0.experience.level - other[3][1]
              _with_0.experience.amt = _with_0.experience.amt - other[3][2]
              newMana = _with_0
            end
            for i, v in pairs(self) do
              if v < 0 then
                self[i] = 0
              end
            end
            newMana.baseMax = math.min(newMana.baseMax, newMana.absMax)
            return newMana
          end
        end
      end
    end,
    __mul = function(self, other)
      if other.__class == self.__class then
        local newMana
        do
          local _with_0 = Mana(self.player)
          _with_0.baseMax = _with_0.baseMax * other.baseMax
          _with_0.remaining = _with_0.remaining * other.remaining
          _with_0.experience.level = _with_0.experience.level * other.experience.level
          _with_0.experience.amt = _with_0.experience.amt * other.experience.amt
          newMana = _with_0
        end
        newMana.baseMax = math.min(newMana.baseMax, newMana.absMax)
        return newMana
      else
        do
          other = tonumber(other)
          if other then
            local newMana
            do
              local _with_0 = Mana(self.player)
              _with_0.baseMax = _with_0.baseMax * other
              _with_0.remaining = _with_0.remaining * other
              _with_0.experience.level = _with_0.experience.level * other
              _with_0.experience.amt = _with_0.experience.amt * other
              newMana = _with_0
            end
            newMana.baseMax = math.min(newMana.baseMax, newMana.absMax)
            return newMana
          elseif (type(other)) == "table" then
            local newMana
            do
              local _with_0 = Mana(self.player)
              _with_0.baseMax = _with_0.baseMax * other[1]
              _with_0.remaining = _with_0.remaining * other[2]
              _with_0.experience.level = _with_0.experience.level * other[3][1]
              _with_0.experience.amt = _with_0.experience.amt * other[3][2]
              newMana = _with_0
            end
            newMana.baseMax = math.min(newMana.baseMax, newMana.absMax)
            return newMana
          end
        end
      end
    end,
    __div = function(self, other)
      if other.__class == self.__class then
        local newMana
        do
          local _with_0 = Mana(self.player)
          _with_0.baseMax = _with_0.baseMax / other.baseMax
          _with_0.remaining = _with_0.remaining / other.remaining
          _with_0.experience.level = _with_0.experience.level / other.experience.level
          _with_0.experience.amt = _with_0.experience.amt / other.experience.amt
          newMana = _with_0
        end
        newMana.baseMax = math.min(newMana.baseMax, newMana.absMax)
        return newMana
      elseif tonumber(other) then
        local newMana
        do
          local _with_0 = Mana(self.player)
          _with_0.baseMax = _with_0.baseMax / other
          _with_0.remaining = _with_0.remaining / other
          _with_0.experience.level = _with_0.experience.level / other
          _with_0.experience.amt = _with_0.experience.amt / other
          newMana = _with_0
        end
        newMana.baseMax = math.min(newMana.baseMax, newMana.absMax)
        return newMana
      elseif (type(other)) == "table" then
        local newMana
        do
          local _with_0 = Mana(self.player)
          _with_0.baseMax = _with_0.baseMax / other[1]
          _with_0.remaining = _with_0.remaining / other[2]
          _with_0.experience.level = _with_0.experience.level / other[3][1]
          _with_0.experience.amt = _with_0.experience.amt / other[3][2]
          newMana = _with_0
        end
        newMana.baseMax = math.min(newMana.baseMax, newMana.absMax)
        return newMana
      end
    end,
    __mod = function(self, other)
      if other.__class == self.__class then
        local newMana
        do
          local _with_0 = Mana(self.player)
          _with_0.baseMax = _with_0.baseMax % other.baseMax
          _with_0.remaining = _with_0.remaining % other.remaining
          _with_0.experience.level = _with_0.experience.levle % other.experience.level
          _with_0.experience.amt = _with_0.experience.amt % other.experience.amt
          newMana = _with_0
        end
        newMana.baseMax = math.min(newMana.baseMax, newMana.absMax)
        return newMana
      elseif tonumber(other) then
        local newMana
        do
          local _with_0 = Mana(self.player)
          _with_0.baseMax = _with_0.baseMax % other
          _with_0.remaining = _with_0.remaining % other
          _with_0.experience.level = _with_0.experience.level % other
          _with_0.experience.amt = _with_0.experience.amt % other
          newMana = _with_0
        end
        newMana.baseMax = math.min(newMana.baseMax, newMana.absMax)
        return newMana
      elseif (type(other)) == "table" then
        local newMana
        do
          local _with_0 = Mana(self.player)
          _with_0.baseMax = _with_0.baseMax % other[1]
          _with_0.remaining = _with_0.remaining % other[2]
          _with_0.experience.level = _with_0.experience.levle % other[3][1]
          _with_0.experience.amt = _with_0.experience.amt % other[3][2]
          newMana = _with_0
        end
        newMana.baseMax = math.min(newMana.baseMax, newMana.absMax)
        return newMana
      end
    end,
    __pow = function(self, other)
      if other.__class == self.__class then
        local newMana
        do
          local _with_0 = Mana(self.player)
          _with_0.baseMax = _with_0.baseMax ^ other.baseMax
          _with_0.remaining = _with_0.remaining ^ other.remaining
          _with_0.experience.level = _with_0.experience.level ^ other.experience.level
          _with_0.experience.amt = _with_0.experience.amt ^ other.experience.amt
          newMana = _with_0
        end
        newMana.baseMax = math.min(newMana.baseMax, newMana.absMax)
        return newMana
      elseif tonumber(other) then
        local newMana
        do
          local _with_0 = Mana(self.player)
          _with_0.baseMax = _with_0.baseMax ^ other
          _with_0.remaining = _with_0.remaining ^ other
          _with_0.experience.level = _with_0.experience.level ^ other
          _with_0.experience.amt = _with_0.experience.amt ^ other
          newMana = _with_0
        end
        newMana.baseMax = math.min(newMana.baseMax, newMana.absMax)
        return newMana
      elseif (type(other)) == "table" then
        local newMana
        do
          local _with_0 = Mana(self.player)
          _with_0.baseMax = _with_0.baseMax ^ other[1]
          _with_0.remaining = _with_0.remaining ^ other[2]
          _with_0.experience.level = _with_0.experience.level ^ other[3][1]
          _with_0.experience.amt = _with_0.experience.amt ^ other[3][2]
          newMana = _with_0
        end
        newMana.baseMax = math.min(newMana.baseMax, newMana.absMax)
        return newMana
      end
    end,
    __idiv = function(self, other)
      if other.__class == self.__class then
        local newMana
        do
          local _with_0 = Mana(self.player)
          _with_0.baseMax = math.floor((math.floor(_with_0.baseMax)) / (math.floor(other.baseMax)))
          _with_0.remaining = math.floor((math.floor(_with_0.remaining)) / (math.floor(other.remaining)))
          _with_0.experience.level = math.floor((math.floor(_with_0.remaining)) / (math.floor(other.experience.level)))
          _with_0.experience.amt = math.floor((math.floor(_with_0.experience.amt)) / (math.floor(other.experience.amt)))
          newMana = _with_0
        end
        return newMana
      else
        do
          other = tonumber(other)
          if other then
            local newMana
            do
              local _with_0 = Mana(self.player)
              _with_0.baseMax = math.floor((math.floor(_with_0.baseMax)) / (math.floor(other)))
              _with_0.remaining = math.floor((math.floor(_with_0.remaining)) / (math.floor(other)))
              _with_0.experience.level = math.floor((math.floor(_with_0.remaining)) / (math.floor(other)))
              _with_0.experience.amt = math.floor((math.floor(_with_0.experience.amt)) / (math.floor(other)))
              newMana = _with_0
            end
            return newMana
          elseif (type(other)) == "table" then
            local newMana
            do
              local _with_0 = Mana(self.player)
              _with_0.baseMax = math.floor((math.floor(_with_0.baseMax)) / (math.floor(other[1])))
              _with_0.remaining = math.floor((math.floor(_with_0.remaining)) / (math.floor(other[2])))
              _with_0.experience.level = math.floor((math.floor(_with_0.experience.level)) / (math.floor(other[3][1])))
              _with_0.experience.amt = math.floor((math.floor(_with_0.experience.amt)) / (math.floor(other[3][2])))
              newMana = _with_0
            end
            return newMana
          end
        end
      end
    end,
    __tostring = function(self)
      return (assert(LoadLibrary("RbxUtil"))).JSONEncode(self)
    end,
    __eq = function(self, other)
      return (other.__class == self.__class) and (self.baseMax == other.baseMax) and (self.remaining == other.remaining) and (self.experience.level == other.experience.level) and (self.experience.amt == other.experience.amt)
    end,
    __lt = function(self, other)
      return (other.__class < self.__class) and (self.baseMax < other.baseMax) and (self.remaining < other.remaining) and (self.experience.level < other.experience.level) and (self.experience.amt < other.experience.amt)
    end,
    __le = function(self, other)
      return (self < other) or (self == other)
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, player, baseMx, r, xpl, xpa)
      if baseMx == nil then
        baseMx = 100
      end
      if r == nil then
        r = 100
      end
      if xpl == nil then
        xpl = 0
      end
      if xpa == nil then
        xpa = 0
      end
      local _ = {
        [self.absMax] = 10000
      }
      self.player = API.getPlayer(player)
      self.baseMax = baseMx
      self.remaining = r
      self.experience = { }
      self.experience.level = xpl
      self.experience.amt = xpa
      return self
    end,
    __base = _base_0,
    __name = "Mana"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Mana = _class_0
end
return Mana
