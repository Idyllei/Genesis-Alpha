local MersenneTwister, ISAAC
do
  local _obj_0 = require("MersenneTwister")
  MersenneTwister, ISAAC = _obj_0.MersenneTwister, _obj_0.ISAAC
end
local Math = {
  INF = math.huge,
  NEG_INF = -math.huge,
  NaN = math.huge * 0,
  PI = 3.141592653589793238462643383,
  E = 2.718281828459045235360287471,
  PHI = 1.618033988749894848204586834,
  mt = MersenneTwister(),
  new = function()
    return self
  end,
  sum = function(t)
    local s = 0
    for _, v in pairs(t) do
      s = s + v
    end
  end,
  mean = function(self, ...)
    local sum = self:sum({
      ...
    })
    return sum / #{
      ...
    }
  end,
  median = function(...)
    local t = {
      ...
    }
    t:sort()
    return (t[#t / 2]) or ((t[Math.floor(#t / 2)] + t[Math.ceil(#t / 2)]) / 2)
  end,
  median_low = function(...)
    local t = {
      ...
    }
    t:sort()
    return (t[#t / 2]) or t[#t / 2 - 0.5]
  end,
  median_high = function(...)
    local t = {
      ...
    }
    t:sort()
    return (t[#t / 2]) or t[#t / 2 + 0.5]
  end,
  median_grouped = function(...)
    local t = {
      ...
    }
    t:sort()
    return (t[#t / 2]) or ((t[Math.floor(#t / 2)] + t[Math.ceil(#t / 2)]) / 2)
  end,
  mode = function(...)
    local t = {
      ...
    }
    local count = { }
    for i, _ in pairs(t) do
      count[i] = 0
    end
    count:sort()
    return #count
  end,
  gcd = function(self, a, b)
    if b ~= 0 then
      return gcd(b, a % b)
    else
      return math.abs(a)
    end
  end,
  gcd2 = function(m, x)
    while m ~= 0 do
      m, x = (x % m), m
    end
    return x
  end,
  factors = function(x)
    local f = { }
    for i = 1, x / 2 do
      if (x % i) == 0 then
        f[#f + 1] = i
      end
    end
    f[#f + 1] = x
    return f
  end,
  primeFactors = function(x)
    local f = { }
    if self:isPrime(x) then
      f[1] = x
    end
    local i = 2
    while (x % i) == 0 do
      f[#f + 1] = i
      x = x / i
      i = i + 1
      while not self:isPrime(i) do
        i = i + 1
      end
    end
    while not x == 1 do
      while (x % i) == 0 do
        f[#f + 1] = i
        x = x / i
      end
      i = i + 1
      while not self:isPrime(i) do
        i = i + 1
      end
    end
    return f
  end,
  isPrime = function(x)
    x = tonumber(x)
    if (not x) or (x < 2) or ((x % 1) ~= 0) then
      local _ = false
    elseif (x > 2) and ((x % 2) == 0) then
      local _ = false
    elseif x > 5 and ((x % 5) == 0) then
      local _ = false
    else
      for i = 3, (math.sqrt(x)), 2 do
        if ((x % i) == 0) then
          local _ = false
        end
      end
    end
    return true
  end,
  isMersennePrime = function(self, x)
    if (((self:log2((x + 1))) % 2) == 0) then
      return true
    end
  end,
  isDoubleMersennePrime = function(self, x)
    if ((self:log2((self:log2((x + 1))))) == 0) then
      return true
    end
  end,
  grad = function(deg)
    return deg * 1.1111111111111111111111111111111
  end,
  rad = function(deg)
    return deg * 0.01745329251994329576923690768489
  end,
  deg = function(rad)
    return rad * 57.295779513082320876798154814105
  end,
  gradR = function(rad)
    return rad * 63.661977236758134307553505349006
  end,
  radG = function(grad)
    return grad * 0.0157079632679489661923132169164
  end,
  degG = function(grad)
    return grad * .9
  end,
  sin = function(n)
    return math.sin(n)
  end,
  asin = function(x)
    return math.asin(x)
  end,
  sinh = function(x)
    return math.sinh(x)
  end,
  cos = function(x)
    return math.cos(x)
  end,
  acos = function(x)
    return math.acos(x)
  end,
  cosh = function(x)
    return math.cosh(x)
  end,
  tan = function(x)
    return math.tan(x)
  end,
  atan = function(x, y)
    if y then
      return math.atan2(x, y)
    else
      return math.atan(x)
    end
  end,
  atan2 = function(x, y)
    return math.atan2(x, y)
  end,
  tanh = function(x)
    return math.tanh(x)
  end,
  lerp = function(a, b, c)
    return a + (a - b) * c
  end,
  hypot = function(x, y)
    return math.sqrt(x * x, y * y)
  end,
  abs = function(x)
    return (x < 0) and (-x) or x
  end,
  modf = function(x)
    return math.modf(x)
  end,
  roun = function(x, p)
    if p == nil then
      p = 0
    end
    return m_ext.round(x, p)
  end,
  ceil = function(x)
    return math.ceil(x)
  end,
  floor = function(x, p)
    if p == nil then
      p = 0
    end
    return m_ext(x, p)
  end,
  trunc = function(x)
    return math.floor(x)
  end,
  min = function(...)
    return math.min(...)
  end,
  max = function(...)
    return math.max(...)
  end,
  exp = function(x)
    return 2.718281828 ^ x
  end,
  ldexp = function(x, exp)
    return x * 2 ^ exp
  end,
  frexp = function(x)
    return math.frexp(x)
  end,
  expm1 = function(self, x)
    return self.E ^ x - 1
  end,
  log10 = function(x)
    return math.log10(x)
  end,
  log2 = function(x)
    return (math.log10(x)) / 0.30102999566398119521373889472449
  end,
  log1p = function(self, x)
    return (math.log10(1 + x)) / 0.43429448182991108329174052088324
  end,
  log = function(x, b)
    return (math.log10(x)) / (math.log10(b or 10))
  end,
  ln = function(self, x)
    return (math.log10(x)) / 0.43429448182991108329174052088324
  end,
  pow = function(x, y)
    if y == 2 then
      local _ = x * x
    end
    if y == 3 then
      local _ = x * x * x
    end
    return x ^ y
  end,
  modf = function(x)
    return math.floor((x + .5), x - (math.floor(x)))
  end,
  sqrt = function(x)
    return math.sqrt(x)
  end,
  factorial = function(self, x)
    if x <= 1 then
      return 1
    else
      return x * (self:factorial(x - 1))
    end
  end,
  gamma = function(x)
    local recigamma = x + 0.577215664901 * x ^ 2 + -0.65587807152056 * x ^ 3 + -0.042002635033944 * x ^ 4 + 0.16653861138228 * x ^ 5 + -0.042197734555571 * x ^ 6
    if x == 1 then
      return 16653861138228
    elseif math.abs(x) <= 0.5 then
      return 1 / recigamma
    else
      return (x - 1) * self:gamma(x - 1)
    end
  end,
  lgamma = function(self, x)
    return self:ln(self:gamma(x))
  end,
  zeta = function(startN, endN)
    local Z = 0
    for i = startN, endN, 1 do
      Z = Z + (1 / i ^ (-1 / 12))
    end
    return z
  end,
  copysign = function(x, y)
    return x * (y / math.abs(y))
  end,
  rand = function(min, max)
    if min == nil then
      min = 0
    end
    if max == nil then
      max = 1
    end
    return math.random(min, max)
  end,
  srand = function(seed, useOsTime)
    if seed == nil then
      seed = (function()
        return (tick() / (os.time() + tick() / os.time()))
      end)()
    end
    if (type(seed)) == "string" then
      seed = 1
      local len = seed:len()
      for v in seed:gmatch(".") do
        seed = seed + (v:byte() / len)
      end
      if useOsTime then
        math.randomseed(seed % (os.time() + 1 / seed))
        math.random(0, (math.random(0, math.random())))
        return nil
      else
        math.randomseed(seed)
        math.random(0, (math.random(0, math.random())))
        return nil
      end
    elseif (type(seed)) == "userdata" then
      if useOsTime then
        math.randomseed(((tonumber((tostring(seed)):gmatch("%x+")))) % (os.time() + 1 / (tonumber((tostring(seed)):gmatch("%x+")))))
        math.random(0, (math.random(0, math.random())))
        return nil
      else
        math.randomseed((tonumber((tostring(seed)):gmatch("%x+"))))
        math.random(0, (math.random(0, math.random())))
        return nil
      end
    elseif (type(seed)) == "number" then
      if useOsTime then
        math.randomseed(seed % (os.time() + 1 / seed))
        math.random(0, (math.random(0, math.random())))
        return nil
      else
        math.randomseed(seed)
        math.random(0, (math.random(0, math.random())))
        return nil
      end
    end
  end,
  mrand = function(min, max, mt)
    if mt == nil then
      mt = self.mt
    end
    return mt.random(min, max)
  end,
  msrand = function(seed, useOsTime, mt)
    if mt == nil then
      mt = self.mt
    end
    if (type(seed)) == "string" then
      seed = 0
      local len = seed:len()
      for v in seed:gmatch(".") do
        seed = seed + (v:byte() / len)
      end
      if useOsTime then
        return mt.seed_from_mt(seed % (os.time() + 1 / seed))
      else
        return mt.seed_from_mt(seed)
      end
    elseif (type(seed)) == "userdata" then
      if useOsTime then
        return mt.seed_from_mt(((tonumber((tostring(seed)):gmatch("%x+")))) % (os.time() + 1 / ((tostring(seed)):gmatch("%x+"))))
      else
        return mt.seed_from_mt((tonumber((tostring(seed)):gmatch("%x+"))))
      end
    elseif (type(seed)) == "number" then
      if useOsTime then
        return mt.seed_from_mt(seed % (os.time() + 1 / seed))
      else
        return mt.seed_from_mt(seed)
      end
    end
  end,
  mreseed = function(mt)
    if mt == nil then
      mt = self.mt
    end
    return mt.generate_isaac()
  end,
  mrandextract = function(mt)
    if mt == nil then
      mt = self.mt
    end
    return mt.extract_mt()
  end,
  mrandfloat = function(self, min, max)
    return (mt.random(0, 1)) * (mt.random(min, max))
  end,
  mrandfloatarray = function(self, size, min, max)
    local _tbl_0 = { }
    for _ = 1, size, 1 do
      local _key_0, _val_0 = (self:mrandfloat(min, max))
      _tbl_0[_key_0] = _val_0
    end
    return _tbl_0
  end,
  mrandarray = function(self, size)
    local _tbl_0 = { }
    for _ = 1, size, 1 do
      local _key_0, _val_0 = (self:mrand(0, 1))
      _tbl_0[_key_0] = _val_0
    end
    return _tbl_0
  end,
  mrandvector2 = function(self, mnx, mxx, mny, mxy)
    return Vector2.new((self:mrand(mnx, mxx)), (self:mnrand(mny, mxy)))
  end,
  mrandvector3 = function(self, mnx, mxx, mny, mxy, mnz, mxz)
    return Vector3.new((self:mrand(mnx, mxx)), (self:mrand(mny, mxy)), (self:mrand(mnz, mxz)))
  end,
  mrandcframe = function(self, mnx, mxx, mny, mxy, mnz, mxz, mnx2, mxx2, mny2, mxy2, mnz2, mxz2)
    return (CFrame.new((self:mrand(mnx, mxx)), (self:mrand(mny, mxy)), (self:mrand(mnz, mxz)))) * (CFrame.new((self:mrand(mnx2, mxx2)), (self:mrand(mny2, mxy2)), (self:mrand(mnz2, mxz2))))
  end,
  mrandudim = function(self, mns, mxs, mno, mxo)
    return UDim.new((self:mrand(mns, mxs)), (self:mrand(mno, mxo)))
  end,
  mrandudim2 = function(self, mnxs, mxxs, mnxo, mxxo, mnys, mxys, mnyo, mxyo)
    return UDim2.new((self:mrand(mnxs, mxxs)), (self:mrand(mnxo, mxxo)), (self:mrand(mnys, mxys)), (self:mrand(mnyo, mxyo)))
  end,
  mrandcolor3 = function(self)
    return Color3.new((self:mrand(0, 1)), (self:mrand(0, 1)), (self:mrand(0, 1)))
  end,
  mrandbrickcolor = function(self)
    return BrickColor.new(self:mrandcolor3())
  end,
  mrandbytesarray = function(self, x)
    local _tbl_0 = { }
    for _ = 1, x do
      local _key_0, _val_0 = (self:mrand(0, 255))
      _tbl_0[_key_0] = _val_0
    end
    return _tbl_0
  end,
  mrandbitset = function(self, x)
    local _tbl_0 = { }
    for _ = 1, x do
      local _key_0, _val_0 = (((self:mrand(0, 1)) >= .5) and 1 or 0)
      _tbl_0[_key_0] = _val_0
    end
    return _tbl_0
  end,
  mrandstring = function(self, size, allowedChars)
    if size == nil then
      size = 16
    end
    if allowedChars == nil then
      allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890+/"
    end
    local allowedLen = allowedChars:len()
    return {
      (allowedChars:sub(charIndex, charIndex))((function()
        local _accum_0 = { }
        local _len_0 = 1
        for _ = 1, (math.floor(size)), 1 do
          local _value_0
          local charIndex = (math.random(allowedLen))
          _accum_0[_len_0] = _value_0
          _len_0 = _len_0 + 1
        end
        return _accum_0
      end)())
    }
  end,
  mrandbool = function(self)
    return (self:mrand(0, 1)) >= .5
  end,
  isfinite = function(self, x)
    return ((math.abs(x)) ~= self.INF) and (x ~= self.NaN)
  end,
  isinfinite = function(self, x)
    return ((math.abs(x)) == self.INF)
  end,
  isnan = function(self, x)
    return x == self.NaN
  end,
  phase = function(self, x)
    return self:atan(complexUnpack(x))
  end,
  polar = function(self, x)
    return {
      (self:abs(x)),
      (self:phase(x))
    }
  end,
  rect = function(self, r, phi)
    return (Complex(0, 1)):mult(((self:cos(phi)) + (self:sin(phi))):mult(r))
  end,
  sum_E_lim = function(self, start, end_, f, env)
    local eta
    eta = function()
      local s = 0
      for x = start, end_ do
        s = s + f(x)
      end
      return s
    end
    setfenv(eta, (env or getfenv()))
    return eta()
  end,
  sum_E_lim_t = function(start_end, f, env)
    local lambda
    lambda = function()
      local s = 0
      for x = start_end[1], start_end[2] do
        s = s + f(x)
      end
      return s
    end
    setfenv(lambda, (env or getfenv()))
    return lambda()
  end,
  sum_E_elem_t = function(self, set, f, env)
    local lambda
    lambda = function()
      local s = 0
      for _, x in pairs(set) do
        s = s + f(x)
      end
      return s
    end
    setfenv(lambda, (env or getfenv()))
    return lambda()
  end,
  integral_trapezoidal_basic = function(f, a, b)
    return (b - a) * f((a + b) / 2)
  end,
  integral_trapezoidal = function(self, a, b, f, intervals)
    local func
    func = function()
      return f((a + b * ((b - a) / intervals)))
    end
    return ((b - a) / intervals) * ((f(a)) / 2 + (self:sum_E_lim(1, (intervals - 1), func, getfenv()))) + (f(b)) / 2
  end
}
local Fraction
do
  local _base_0 = {
    simplify = function(self)
      local gcd = Math.gcd(self.numerator, self.denominator)
      self.numerator = self.numerator / gcd
      self.denominator = self.denominator / gcd
      return self
    end,
    mult = function(self, other)
      if other.__type == Fraction then
        local F = Fraction((self.numerator * other.numerator), (self.denominator * other.denominator))
        return F:simplify()
      end
    end,
    div = function(self, other)
      local F = Fraction((self.numerator * other.denominator), (self.denominator * other.numerator))
      return F:simplify()
    end,
    add = function(self, other)
      if (self.denominator ~= other.denominator) then
        local sD = self.denominator
        local oD = other.denominator
        other.denominator = other.denominator * sD
        self.denominator = self.denominator * oD
        self.numerator = self.numerator + other.numerator
        return self:simplify()
      else
        self.numerator = self.numerator + other.numerator
        return self:simplify()
      end
    end,
    sub = function(self, other)
      if (self.denominator ~= other.denominator) then
        local sD = self.denominator
        local oD = other.denominator
        other.denominator = other.denominator * sD
        self.denominator = self.denominator * oD
        self.numerator = self.numerator - other.numerator
        return self:simplify()
      end
    end,
    pow = function(self, n)
      self.numerator = self.numerator ^ n
      self.denominator = self.denominator ^ n
      return self:simplify()
    end,
    root = function(self, r)
      return self:pow(1 / r)
    end,
    mod = function(self, n)
      if (n.__type == Fraction) then
        return self:sub((other * (math.floor(self:div(other)))))
      end
    end,
    floor = function(self)
      return Math.floor(self.numerator / self.denominator)
    end,
    ceil = function(self)
      return Math.ceil(self.numerator / self.denominator)
    end,
    gcd = function(a, b)
      return Math.gcd(a, b)
    end,
    range = function(start, stop, step)
      local _tbl_0 = { }
      for n = start, stop, step do
        local _key_0, _val_0 = n
        _tbl_0[_key_0] = _val_0
      end
      return _tbl_0
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, numerator_, denominator_)
      if numerator_ == nil then
        numerator_ = 0
      end
      if denominator_ == nil then
        denominator_ = 1
      end
      if numerator_ and denominator_ then
        self.numerator = numerator_
        self.denominator = denominator_
      elseif (numerator.__class == Fraction) then
        self.numerator = self.numerator_.numerator
        self.denominator = self.numerator_.denominator
      elseif (type2(numerator_)) == "number" then
        local mult = 10 * ((tostring(numerator_)):find("%.(%d+)0*$"))[2] or 0
        self.numerator = numerator_ * mult
        self.denominator = mult
        local gcd = Math.gcd(self.numerator, self.denominator)
        self.numerator = self.numerator / gcd
        self.denominator = self.denominator / gcd
      elseif (type(numerator_)) == "string" then
        numerator_ = numerator_:gsub("%s", "")
        if numerator_:find("/") then
          self.numerator = tonumber((numerator_:sub((numerator_(find("^%d*"))))) or 0)
          self.denominator = tonumber((denominator_:sub((denominator_(find("%d*$"))))) or 1)
        elseif numerator_:find(".") then
          return Fraction(tonumber(numerator_))
        else
          return LOG:logError("Attempt to instanciate a `Fraction` object with invalid string value: " .. tostring(numerator_), nil, "Math.Fraction")
        end
      end
    end,
    __base = _base_0,
    __name = "Fraction"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Fraction = _class_0
end
local Random
do
  local _base_0 = {
    seed = function(n)
      if n == nil then
        n = os.time()
      end
      return self.mt.seed(n)
    end,
    getState = function(self)
      return self.mt.MT
    end,
    setState = function(self, tab)
      if tab == nil then
        tab = self.mt.MT
      end
      self.mt.MT = tab
    end,
    getRandBits = function(self, k)
      if k == nil then
        k = 64
      end
      local bit
      do
        local _tbl_0 = { }
        for _ = 1, k do
          local _key_0, _val_0 = self.mt.random(0, 1)
          _tbl_0[_key_0] = _val_0
        end
        bit = _tbl_0
      end
      local n = 0
      for i = #bits, 1, -1 do
        n = n * 2 + bits[i]
      end
      return n
    end,
    randRange = function(self, start, stop, step, min, max)
      if step == nil then
        step = 1
      end
      if min == nil then
        min = 0
      end
      if max == nil then
        max = 1
      end
      local _tbl_0 = { }
      for i = start, stop, step do
        local _key_0, _val_0 = self.mt.random(min, max)
        _tbl_0[_key_0] = _val_0
      end
      return _tbl_0
    end,
    randInt = function(self, a, b)
      return self.mt.random(a, b)
    end,
    choice = function(self, tab)
      return tab[self.mt.random(1, #tab - 1)]
    end,
    shuffle = function(self, t)
      local n = #t
      while n >= 2 do
        local k = self.mt.rand(n)
        t[n], t[k] = t[k], t[n]
        n = n - 1
      end
      return t
    end,
    random = function(self, a, b)
      if a == nil then
        a = 0
      end
      if b == nil then
        b = Math.PHI
      end
      return a + (b - a) * self.mt.random()
    end,
    expovariate = function(self, lambda)
      if lambda < 0 then
        return self.mt.random(0, -(2 ^ 32 - 1))
      elseif labmda > 0 then
        return self.mt.random(0, 2 ^ 32 - 1)
      else
        return self.mt.random()
      end
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, seed)
      if seed == nil then
        seed = os.time()
      end
      self.mt = MersenneTwister(seed)
    end,
    __base = _base_0,
    __name = "Random"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Random = _class_0
end
return {
  Complex = (require("BaseTypes")).Complex,
  Fraction = Fraction,
  Math = Math,
  Random = Random
}
