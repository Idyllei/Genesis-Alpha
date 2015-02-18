local ReplicatedStorage = {
  game = GetService("ReplicatedStorage")
}
local Nevermore = require(ReplicatedStorage:WaitForChild("NevermoreEngine"))
local LoadCustomLibrary = NevermoreEngine.LoadLibrary
local qSystems = LoadCustomLibrary("qSystems")
qSystems:Import(getfenv(0))
local CircularBuffer = LoadCustomLibrary("CircularBuffer")
local qTime = LoadCustomLibrary("qTime")
local LOG
do
  local _base_0 = {
    stdlog = CircularBuffer.CreateCircularBuffer(512),
    LOG_PATTERN = "[$D:$H:$M:$S] SVRTY:[$V] SRC:[$SOURCE]\n\t$O",
    __formatLog = function(sMsg, sSeverity, nTime, sSource)
      if sSeverity == nil then
        sSeverity = "INFO"
      end
      if nTime == nil then
        nTime = os.time()
      end
      if sSource == nil then
        sSource = "UNKNOWN ORIGIN"
      end
      local sLog = tostring(LOG_PATTERN)
      return sLog:gsub({
        D = qTime.GetDay(nTime),
        H = qTime.GetHourFormatted(nTime),
        M = qTime.GetFormattedMinute(nTime),
        S = qTime.GetFormattedSecond(nTime),
        SOURCE = sSource,
        V = sSeverity:upper(),
        O = sMsg
      })
    end,
    __purgeLogBuffer = function(self)
      local tData = stdlog:GetData()
      for v in tData do
        print(v)
      end
      self.stdLog = CircularBuffer.CreateCircularBuffer(512)
      return tData
    end,
    flush = function(self)
      return self:__purgeLogBuffer()
    end,
    logInfo = function(self, sMsg, nTime, sSource)
      if nTime == nil then
        nTime = os.time()
      end
      if sSource == nil then
        sSource = "UNKNOWN SOURCE"
      end
      local out = stdlog:Add((self:__formatLog(sMsg, "INFO", nTime, sSource)))
      if out then
        return print(out)
      end
    end,
    logDebug = function(self, sMsg, nTime, sSource)
      if nTime == nil then
        nTime = os.time()
      end
      if sSource == nil then
        sSource = "UNKNOWN SOURCE"
      end
      local out = stdlog:add((self:__formatLog(sMsg, "DEBUG", nTime, sSource)))
      if out then
        return print(out)
      end
    end,
    logWarn = function(self, sMsg, nTime, sSource)
      if nTime == nil then
        nTime = os.time()
      end
      if sSource == nil then
        sSource = "UNKNOWN SOURCE"
      end
      local out = stdlog:Add((self:__formatLog(sMsg, "WARN", nTime, sSource)))
      if out then
        return print(out)
      end
    end,
    logException = function(self, sMsg, nTime, sSource)
      if nTime == nil then
        nTime = os.time()
      end
      if sSource == nil then
        sSource = "UNKNOWN SOURCE"
      end
      local out = stdlog:Add((self:__formatLog(sMsg, "EXCEPTION", nTime, sOurce)))
      if out then
        return print(out)
      end
    end,
    logExcept = self.logException,
    logError = function(self, sMsg, nTime, sSource)
      if nTime == nil then
        nTime = os.time()
      end
      if sSource == nil then
        sSource = "UNKNOWN SOURCE"
      end
      local out = stdlog:Add((self:__formatLog(sMsg, "ERROR", nTime, sSource)))
      if out then
        return print(out)
      end
    end,
    logErr = self.logError,
    logFatal = function(self, sMsg, nTime, sSource)
      if nTime == nil then
        nTime = os.time()
      end
      if sSource == nil then
        sSource = "UNKNOWN SOURCE"
      end
      local out = stdlog:Add((self:__formatLog(sMsg, "FATAL", nTime, sSource)))
      if out then
        return print(out)
      end
    end,
    logDie = function(self, sMsg, nTime, sSource)
      if nTime == nil then
        nTime = os.time()
      end
      if sSource == nil then
        sSource = "UNKNOWN SOURCE"
      end
      return pcall(function()
        local out = stdlog:Add((self:__formatLog(sMsg, "FATAL", nTime, sSource)))
        return assert(not out, out)
      end)
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function() end,
    __base = _base_0,
    __name = "LOG"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  LOG = _class_0
end
return LOG
