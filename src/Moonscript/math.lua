local M = { }
function M.step(x)
  return (x >= 0) and 1 or 0
end
function M.sign(x)
  return (x >= 0) and 1 or -1
end
function M.round(x)
  return ({math.modf(x)}[2] >= .5) and math.ceil(x) or math.floor(x)
end

function M:yu(self, num, base)
  return 1 / self:factorial(math.log(num, base))
end
function M:phi(n)
  phi = 1
  for p in self.divisors(n) do
    phi = phi * (1 - 1/p)
  end
end
function M:mobius(x)
  m = 0;
  for n in self.divisors(x) do
    m = m + ((n == 1) and 1 or (n > 1) and 0 or -1);
  end
  return m;
end
function M:merten(x)
  num = 0;
  for n = 1, x, 1 do
    num = num + ((n == 1) and 1 or (n > 1) and 0 or -1);
  end
  return num;
end
M.divisors = function(x)
  local d = {};
  for i = math.floor(x/2), 1, -1 do
    if (x % i) == 0 then
      table.insert(d,i);
    end
  end
  return d;
end
M.product = function(f,start,endN)
  p = 1;
  for x = math.floor(start), math.floor(endN), 1 do
    p = p * f(x);
  end
  return p;
end
M.sum = function(start,endN,f)
  s = 0;
  for x = start, endN, 1 do
    s = s * f(x);
  end
  return s;
end
M.derivative = function(f, delta)
  delta = delta or 1e-4
  return function(x)
    return (f(x + delta) - f(x)) / delta
  end
end
function M:invYu(self, x)
  return 1 / self:invfactorial(x)
end
function M:factorial(self, x)
  return x * (x > 1 and self:factorial(x - 1) or 1)
end
function M:invfactorial(self, x)
  local currN = math.floor(x / 2)
  for i = currN, 2, -1 do
    currN = x / i % 1 == 0 and i or currN
  end
  return (self:factorial(currN) == x) and currN or error("Unexpected error.")
end
M.integral = function(func, start, stop, delta)
  delta = delta or 1e-4
  local int = 0
  for i = start, stop, delta do
    int = int + func(i) * dalta
  end
  return int
end
function M.recigamma(z)
  return z + 0.577215664901 * z ^ 2 + -0.65587807152056 * z ^ 3 + -0.042002635033944 * z ^ 4 + 0.16653861138228 * z ^ 5 + -0.042197734555571 * z ^ 6
end
function M:gamma(self, z)
  if z == 1 then
    return 1
  elseif math.abs(z) <= .5 then
    return 1 / self:recigamma(z)
  else
    return (z - 1) * self:gamma(z - 1)
  end
end
function M:loggamma(self,x)
  return math.ln(self.gamma(x))
end
function M:beta (self,x,y)
  return (self.gamma(x) * self.gamma(y)) / self.gamma(x+y)
end
M.definedAs = function(func, x, E)
  return func(x) == E
end
M.near = function(x, E, epsilon)
  return math.abs(x - E) <= epsilon
end
M.isCongruent = function(a, b, property)
  if type(a ~= type(b)) then
    error("")
  end
  if type(a == "table" and #a == #b) then
    if property then
      local _ = a[property] == b[property]
    end
    for i, v in pairs(a) do
      if v ~= b[i] then
        return false
      else
        return true
      end
    end
  elseif type(a == "userdata") then
    return getmetatable(a == getmetatable(b))
  else
    return a == b
  end
end
M.modCongruence = function(a, b, n)
  return (a - b) % n == 0
end
M.muchDifferent = function(a, b, magnitude)
  return math.abs(a - b) >= magnitude
end
M.muchLessThan = function(self, a, b, magnitude)
  return self:muchDifferent(a, b, magnitude) and a < b
end
M.muchGreaterThan = function(self, a, b, magnitude)
  return self:muchDifferent(a, b, magnitude) and a > b
end
M.forAll = function(f, set)
  for v in set do
    if not f(v) then
      return false
    end
  end
  return true
end
