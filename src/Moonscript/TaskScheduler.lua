local TaskScheduler
do
  local _base_0 = {
    add = function(self, t, task)
      if (((type(t)) == "table") or ((type(t)) == "number") or ((type(t)) == "function")) and (((type(task)) == "table") and ((type(task[2])) == "thread") or ((type(task)) == "function")) then
        tSchedule[t] = task
        if (type(t)) == "table" then
          local nStartTime = os.date(t)
          while tick() < nStartTime do
            wait(0.0625)
          end
          if (type(task[2])) == "thread" then
            return Spawn(function()
              coroutine.resume(task[2])
              while wait(0.0625) do
                if (coroutine.status(task[2])) == "dead" then
                  Logger:logDebug("Task " .. tostring(task[1]) .. " has finished.", nil, "TaskScheduler")
                  break
                end
              end
            end)
          elseif (type(task)) == "function" then
            return Spawn(task)
          end
        elseif (type(t)) == "number" then
          local nStartTime = t
          while tick() < nStartTime do
            wait(0.0625)
          end
          if (type(task[2])) == "thread" then
            return Spawn(function()
              coroutine.resume(task[2])
              while wait(0.0625) do
                if (coroutine.status(task[2])) == "dead" then
                  Logger:logDebug("Task " .. tostring(task[1]) .. " has finished.", nil, "TaskScheduler")
                  break
                end
              end
            end)
          elseif (type(task)) == "function" then
            return Spawn(task)
          end
        elseif (type(t)) == "function" then
          while not t() do
            wait(0.0625)
          end
          if (type(task[2])) == "thread" then
            return Spawn(function()
              coroutine.resume(task[2])
              while wait(0.0625) do
                if (coroutine.status(task[2])) == "dead" then
                  Logger:logDebug("Task " .. tostring(task[1]) .. " has finished.", nil, "TaskScheduler")
                  break
                end
              end
            end)
          elseif (type(task)) == "function" then
            return Spawn(task)
          end
        end
      end
    end,
    startAll = function(self)
      for t, task in pairs(self.tSchedule) do
        spawn(function()
          if (type(t)) == "table" then
            local nStartTime = os.date(t)
            while tick() < nStartTime do
              wait(0.0625)
            end
            if (type(task[2])) == "thread" then
              return Spawn(function()
                coroutine.resume(task[2])
                while wait(0.0625) do
                  if (coroutine.status(task[2])) == "dead" then
                    Logger:logDebug("Task " .. tostring(task[1]) .. " has finished.", nil, "TaskScheduler")
                    break
                  end
                end
              end)
            elseif (type(task)) == "function" then
              return Spawn(task)
            end
          elseif (type(t)) == "number" then
            local nStartTime = t
            while tick() < nStartTime do
              wait(0.0625)
            end
            if (type(task[2])) == "thread" then
              return Spawn(function()
                coroutine.resume(task[2])
                while wait(0.0625) do
                  if (coroutine.status(task[2])) == "dead" then
                    Logger:logDebug("Task " .. tostring(task[1]) .. " has finished.", nil, "TaskScheduler")
                    break
                  end
                end
              end)
            elseif (type(task)) == "function" then
              return Spawn(task)
            end
          elseif (type(t)) == "function" then
            while not t() do
              wait(0.0625)
            end
            if (type(task[2])) == "thread" then
              return Spawn(function()
                coroutine.resume(task[2])
                while wait(0.0625) do
                  if (coroutine.status(task[2])) == "dead" then
                    Logger:logDebug("Task " .. tostring(task[1]) .. " has finished.", nil, "TaskScheduler")
                    break
                  end
                end
              end)
            elseif (type(task)) == "function" then
              return Spawn(task)
            end
          end
        end)
      end
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, tSchedule, bAutoStart)
      local tNewSchedule = { }
      for t, task in pairs(tSchedule) do
        if (((type(t)) == "table") or ((type(t)) == "number") or ((type(t)) == "function")) and (((type(task)) == "table") and ((type(task[2])) == "thread") or ((type(task)) == "function")) then
          tNewSchedule[t] = task
        end
      end
      self.tSchedule = tNewSchedule
      if bAutoStart then
        for t, task in pairs(self.tSchedule) do
          Spawn(function()
            if (type(t)) == "table" then
              local nStartTime = os.date(t)
              while tick() < nStartTime do
                wait(0.0625)
              end
              if (type(task[2])) == "thread" then
                return Spawn(function()
                  coroutine.resume(task[2])
                  while wait(0.0625) do
                    if (coroutine.status(task[2])) == "dead" then
                      Logger:logDebug("Task " .. tostring(task[1]) .. " has finished.", nil, "TaskScheduler")
                      break
                    end
                  end
                end)
              elseif (type(task)) == "function" then
                return Spawn(task)
              end
            elseif (type(t)) == "number" then
              local nStartTime = t
              while tick() < nStartTime do
                wait(0.0625)
              end
              if (type(task[2])) == "thread" then
                return Spawn(function()
                  coroutine.resume(task[2])
                  while wait(0.0625) do
                    if (coroutine.status(task[2])) == "dead" then
                      Logger:logDebug("Task " .. tostring(task[1]) .. " has finished.", nil, "TaskScheduler")
                      break
                    end
                  end
                end)
              elseif (type(task)) == "function" then
                return Spawn(task)
              end
            elseif (type(t)) == "function" then
              if (type(task[2])) == "thread" then
                return Spawn(function()
                  coroutine.resume(task[2])
                  while not t() and wait(0.0625) do
                    if (coroutine.status(task[2])) == "dead" then
                      Logger:logDebug("Task " .. tostring(task[1]) .. " has finished.", nil, "TaskScheduler")
                      break
                    end
                  end
                end)
              elseif (type(task)) == "function" then
                return Spawn(task)
              end
            end
          end)
        end
      end
    end,
    __base = _base_0,
    __name = "TaskScheduler"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  TaskScheduler = _class_0
end
return TaskScheduler
