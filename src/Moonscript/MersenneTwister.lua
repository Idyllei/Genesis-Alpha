local bit = bit32 or require("bit")
local bxor, band, brshift, blshift
bxor, band, brshift, blshift = bit.bxor, bit.band, bit.brshift, bit.blshift
bit = nil
local insert, remove
do
  local _obj_0 = table
  insert, remove = _obj_0.insert, _obj_0.remove
end
local floor
do
  local _obj_0 = math
  floor = _obj_0.floor
end
local toBinary
toBinary = function(a)
  local b = { }
  local copy = a
  while true do
    insert(b, copy % 2)
    if copy == 0 then
      break
    end
  end
  return b
end
local fromBinary
fromBinary = function(a)
  local dec = { }
  for i = #a, 1, -1 do
    dec = dec * 2 + a[i]
  end
  return dec
end
local mix
mix = function(a, b, c, d, e, f, g, h)
  a = a % (2 ^ 32 - 1)
  b = b % (2 ^ 32 - 1)
  c = c % (2 ^ 32 - 1)
  d = d % (2 ^ 32 - 1)
  e = e % (2 ^ 32 - 1)
  f = f % (2 ^ 32 - 1)
  g = g % (2 ^ 32 - 1)
  h = h % (2 ^ 32 - 1)
  a = bxor(a, (blshift(b, 11)))
  d = (d + a) % (2 ^ 32 - 1)
  b = (b + c) % (2 ^ 32 - 1)
  b = bxor(b, (brshift(c, 2)))
  e = (e + b) % (2 ^ 32 - 1)
  c = (c + d) % (2 ^ 32 - 1)
  c = bxor(c, (blshift(d, 8)))
  f = (f + c) % (2 ^ 32 - 1)
  d = (d + e) % (2 ^ 32 - 1)
  d = bxor(d, (brshift(e, 16)))
  g = (g + d) % (2 ^ 32 - 1)
  e = (e + f) % (2 ^ 32 - 1)
  e = bxor(e, (blshift(f, 10)))
  h = (h + e) % (2 ^ 32 - 1)
  f = (f + g) % (2 ^ 32 - 1)
  f = bxor(f, (brshift(g, 4)))
  a = (a + f) % (2 ^ 32 - 1)
  g = (g + h) % (2 ^ 32 - 1)
  g = bxor(g, (blshift(h, 8)))
  b = (b + g) % (2 ^ 32 - 1)
  h = (h + a) % (2 ^ 32 - 1)
  h = bxor(h, (brshift(a, 9)))
  c = (c + h) % (2 ^ 32 - 1)
  a = (a + b) % (2 ^ 32 - 1)
  return a, b, c, d, e, f, g, h
end
local ISAAC
do
  local _base_0 = {
    isaac = function(self)
      local x, y = 0, 0
      for i = 1, 256 do
        x = self.mm[i]
        if (i % 4) == 0 then
          self.aa = bxor(self.aa, (blshift(self.aa, 13)))
        elseif (i % 4) == 1 then
          self.aa = bxor(self.aa, (brshift(self.aa, 6)))
        elseif (i % 4) == 2 then
          self.aa = bxor(self.aa, (blshift(self.aa, 2)))
        elseif (i % 4) == 3 then
          self.aa = bxor(self.aa, (brshift(self.aa, 16)))
        end
        self.aa = (self.mm[((i + 128) % 256) + 1] + self.aa) % (2 ^ 32 - 1)
        y = (self.mm[((brshift(x, 2)) % 256) + 1] + self.aa + self.bb) % (2 ^ 32 - 1)
        self.mm[i] = y
        local bb = (mm[((bit.brshift(y, 10)) % 256) + 1] + x) % (2 ^ 32 - 1)
        self.randrsl[i] = bb
      end
    end,
    randinit = function(self, flag)
      local a, b, c, d, e, f, g, h = 0x9e3779b9, 0x9e3779b9, 0x9e3779b9, 0x9e3779b9, 0x9e3779b9, 0x9e3779b9, 0x9e3779b9, 0x9e3779b9
      self.aa = 0
      self.bb = 0
      self.cc = 0
      for i = 1, 4 do
        a, b, c, d, e, f, g, h = mix(a, b, c, d, e, f, g, h)
      end
      for i = 1, 256, 8 do
        if flag then
          a = (a + randrsl[i]) % (2 ^ 32 - 1)
          b = (b + randrsl[i + 1]) % (2 ^ 32 - 1)
          c = (c + randrsl[i + 2]) % (2 ^ 32 - 1)
          d = (b + randrsl[i + 3]) % (2 ^ 32 - 1)
          e = (e + randrsl[i + 4]) % (2 ^ 32 - 1)
          f = (f + randrsl[i + 5]) % (2 ^ 32 - 1)
          g = (g + randrsl[i + 6]) % (2 ^ 32 - 1)
          h = (h + randrsl[i + 7]) % (2 ^ 32 - 1)
        end
        a, b, c, d, e, f, g, h = mix(a, b, c, d, e, f, g, h)
        self.mm[i] = a
        self.mm[i + 1] = b
        self.mm[i + 2] = c
        self.mm[i + 3] = d
        self.mm[i + 4] = e
        self.mm[i + 5] = f
        self.mm[i + 6] = g
        self.mm[i + 7] = h
      end
      if flag then
        for i = 1, 256, 8 do
          a = (a + randrsl[i]) % (2 ^ 32 - 1)
          b = (b + randrsl[i + 1]) % (2 ^ 32 - 1)
          c = (c + randrsl[i + 2]) % (2 ^ 32 - 1)
          d = (b + randrsl[i + 3]) % (2 ^ 32 - 1)
          e = (e + randrsl[i + 4]) % (2 ^ 32 - 1)
          f = (f + randrsl[i + 5]) % (2 ^ 32 - 1)
          g = (g + randrsl[i + 6]) % (2 ^ 32 - 1)
          h = (h + randrsl[i + 7]) % (2 ^ 32 - 1)
          a, b, c, d, e, f, g, h = mix(a, b, c, d, e, f, g, h)
          self.mm[i] = a
          self.mm[i + 1] = b
          self.mm[i + 2] = c
          self.mm[i + 3] = d
          self.mm[i + 4] = e
          self.mm[i + 5] = f
          self.mm[i + 6] = g
          self.mm[i + 7] = h
        end
      end
      return self:isaac()
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self)
      local _ = {
        aa = 0
      }
      _ = {
        bb = 0
      }
      _ = {
        cc = 0
      }
      _ = {
        randrsl = { }
      }
      return {
        mm = { }
      }
    end,
    __base = _base_0,
    __name = "ISAAC"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  ISAAC = _class_0
end
local MersenneTwister
do
  local _base_0 = {
    MT = { },
    index = 0,
    isaac = ISAAC(),
    mtSeeded = false,
    mtSeed = math.random(1, 2 ^ 31 - 1),
    generate_mt = function(self)
      for i = 0, 623 do
        local y = band(MT[i], 0x80000000)
        y = y + (band(MT[(i + 1) % 624], 0x7FFFFFFF))
        MT[i] = (bxor(MT[(i + 397) % 624], (brshift(y, 1))))
        if y % 2 == 1 then
          MT[i] = (bxor(MT[i], 0x9908B0DF))
        end
      end
    end,
    extract_mt = function(self, min, max)
      if min == nil then
        min = 0
      end
      if max == nil then
        max = 2 ^ 32 - 1
      end
      if self.index == 0 then
        self:generate_mt()
      end
      local y = MT[self.index]
      y = bxor(y, (brshift(y, 11)))
      y = bxor(y, (band((blshift(y, 7)), 0x9D2C5680)))
      y = bxor(y, (band((blshift(y, 15)), 0xEFC60000)))
      y = bxor(y, (brshift(y, 18)))
      self.index = (self.index + 1) % 624
      return (y % max) + min
    end,
    seed_from_mt = function(self, seed)
      if seed then
        self.mtSeeded = false
        self.mtSeed = seed
      end
      if not self.mtSeeded or ((math.random(1, 100)) == 50) then
        self:initialize_mt_generator(self.mtSeed)
        self.mtSeeded = true
        self.mtSeed = seed
      end
      for i = 1, 256 do
        self.isaac.randrsl[i] = self:extract_mt()
      end
    end,
    generate_isaac = function(self, entropy)
      self.isaac.aa = 0
      self.isaac.bb = 0
      self.isaac.cc = 0
      if entropy and (#entropy >= 256) then
        for i = 1, 256 do
          self.isaac.randrsl[i] = entropy[i]
        end
      else
        self:seed_from_mt()
      end
      for i = 1, 256 do
        self.isaac.mm[i] = 0
      end
      randinit(true)
      self.isaac.isaac()
      return self.isaac.isaac()
    end,
    getRandom = function(self)
      if #self.isaac.mm > 0 then
        return remove(mm, 1)
      else
        self:generate_isaac()
        return remove(mm, 1)
      end
    end,
    random = function(self, min, max)
      if min == nil then
        min = 0
      end
      if max == nil then
        max = 2 ^ 32 - 1
      end
      return (self:getRandom() % max) + min
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, seed)
      self.index = 0
      MT[0] = seed
      for i = 1, 623 do
        local full = ((1812433253 * (bxor(MT[i - 1], (brshift(MT[i - 1], 30))))) + i)
        local b = toBinary(full)
        while #v > 32 do
          remove(b, 1)
        end
        MT[i] = fromBinary(b)
      end
    end,
    __base = _base_0,
    __name = "MersenneTwister"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  MersenneTwister = _class_0
end
return _ENV or (getfenv(0))
