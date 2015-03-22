local bit = (require("bit")) or (require("bit.numberlua"))
local f
f = function(x)
  return x ^ math.abs((math.sin(x + 1 / x)) * (math.cos(1 / x)))
end
local g
g = function(x)
  if (x >= 1) and (x <= 2) then
    return math.sin(2.718281828 ^ (x / 1.618335))
  else
    return f((f(x)) + (f(math.cos(x / (x - 1)))))
  end
end
local H
H = function(x, y)
  if (x == 1) and (y == 1) then
    return 0.97978047694786
  else
    return g((math.sin(x ^ -y + 1 / y)) * (math.cos(y ^ -x + 1 / x)))
  end
end
local J
J = function(x, y)
  return math.sin((x + 1 / y) % (y + 1 / x + 1))
end
local curry
curry = function(f, nArgs)
  nArgs = nArgs or 2
  if nArgs <= 1 then
    local _ = f
  end
  local curry_h
  curry_h = function(argtrace, n)
    if n == 0 then
      return f(reverse(argtrace()))
    else
      return function()
        return (curry_h(function()
          return onearg, argtrace
        end)), n - 1
      end
    end
  end
  return (curry_h((function() end), num_args))
end
local reverse
reverse = function(...)
  local reverse_h
  reverse_h = function(acc, v, ...)
    if (select('#', ...)) == 0 then
      return v, acc()
    else
      return (reverse_h((function()
        return v, acc
      end), ...))
    end
  end
  return (reverse_h((function() end), ...))
end
for x = 1, 20 do
  print("f(" .. tostring(x) .. "): " .. (f(x)))
end
print("\n\n")
for x = 1, 20 do
  print("g(" .. tostring(x) .. "): " .. (g(x)))
end
print("\n\n")
for x = 1, 10 do
  for y = 1, 10 do
    print("H(" .. tostring(x) .. "," .. tostring(y) .. "): " .. (H(x, y)))
  end
end
print("\n\n")
for x = 1, 10 do
  for y = 1, 10 do
    print("J(" .. tostring(x) .. "," .. tostring(y) .. "): " .. (J(x, y)))
  end
end
local TypicTwister
do
  local M
  local _base_0 = {
    random = function(self, min, max)
      M[1] = MersenneTwister(a)
      M[2] = MersenneTwister(b)
      local A = f(M[1].random(1, 1024))
      local B = f(M[2].random(1, 1024))
      local C = math.abs(A - B)
      local H1 = (curry(H))(C)
      local D = g(C)
      M[3] = MersenneTwister(f(C))
      local M3_out = m[3].random()
      if self.run_once then
        M[4] = MersenneTwister(M[4].random())
        M[5] = MersenneTwister(M[5].random())
      else
        M[4] = MersenneTwister(M3_out)
        M[5] = MersenneTwister(M3_out)
      end
      local H2 = (curry(H))(M3_out)
      M[6] = MersenneTwister(H2(((curry(J))(D))(M[5].random())))
      return M[6].random(min, max)
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, a, b)
      a = bit.bxor((bit.rrotate(a, 3)), 255)
      b = bit.bxor((bit.lrotate(b, 3)), 255)
    end,
    __base = _base_0,
    __name = "TypicTwister"
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
  M = { }
  TypicTwister = _class_0
end
return function()
  return {
    TypicTwister = TypicTwister,
    curry = curry,
    reverse = reverse,
    f = f,
    g = g,
    H = H,
    J = J
  }
end
