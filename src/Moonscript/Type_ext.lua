local M = { }
M.type_and = function(val, t, fallback)
  return ((type(val)) == t) and val or fallback
end
M.type_and_f = function(f, val, t, fallback)
  return ((f(val)) == t) and val or fallback
end
return M
