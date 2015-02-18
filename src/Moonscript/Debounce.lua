local M = { }
M.debounce = function(func)
  local isRunning = false
  return function(...)
    if not isRunning then
      isRunning = true
      func(...)
      isRunning = false
    end
  end
end
return M
