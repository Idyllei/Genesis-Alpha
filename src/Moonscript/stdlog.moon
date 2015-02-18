-- stdlog.moon

--------------------------
-- Set up Nevermore Engine
--------------------------
ReplicatedStorage     = game:GetService "ReplicatedStorage"

Nevermore             = require ReplicatedStorage\WaitForChild "NevermoreEngine"
LoadCustomLibrary     = NevermoreEngine.LoadLibrary

qSystems              = LoadCustomLibrary "qSystems"

qSystems\Import getfenv 0

-- /*
--  * CircularBuffer
--  * Will serve as the default stdout if `io.stdout` is not available.
--  */
CircularBuffer = LoadCustomLibrary "CircularBuffer"

-- GetDay, GetHourFormatted, GetFormattedMinute, GetFormattedSecond
qTime = LoadCustomLibrary "qTime"
-----------------------------
-- End Nevermore Engine Setup
-----------------------------

class LOG
	-- // 512 Elements should be enough records to figure out a problem in the 
	-- // codebase.
	stdlog: CircularBuffer.CreateCircularBuffer 512
	-- D: day H: Hour M: Minute S: second v: Severity o: Message
	LOG_PATTERN: "[$D:$H:$M:$S] SVRTY:[$V] SRC:[$SOURCE]\n\t$O"
	__formatLog: (sMsg,sSeverity="INFO",nTime=os.time!, sSource = "UNKNOWN ORIGIN") ->
		-- using `torstring` creates a copy of `LOG_PATTERN` instead of a
		-- reference. It's hacky, crude, and effective.
		sLog = tostring LOG_PATTERN
		return sLog\gsub {
			D: qTime.GetDay nTime
			H: qTime.GetHourFormatted nTime
			M: qTime.GetFormattedMinute nTime
			S: qTime.GetFormattedSecond nTime
			SOURCE: sSource
			V: sSeverity\upper!
			O: sMsg
		}

	__purgeLogBuffer: =>
		tData = stdlog\GetData!
		for v in tData
			print v
		@stdLog = CircularBuffer.CreateCircularBuffer 512
		return tData

	-- Alias for `__purgeLogBuffer`
	flush: =>
		@__purgeLogBuffer!

	logInfo: (sMsg, nTime=os.time!, sSource="UNKNOWN SOURCE") =>
		out = stdlog\Add (@__formatLog sMsg, "INFO", nTime, sSource)
		if out
			print out

	logDebug: (sMsg, nTime=os.time!, sSource="UNKNOWN SOURCE") =>
		out = stdlog\add (@__formatLog sMsg, "DEBUG", nTime, sSource)
		if out
			print out

	logWarn: (sMsg, nTime=os.time!, sSource="UNKNOWN SOURCE") =>
		out = stdlog\Add (@__formatLog sMsg, "WARN", nTime, sSource)
		if out
			print out

	logException: (sMsg, nTime=os.time!, sSource="UNKNOWN SOURCE") =>
		out = stdlog\Add (@__formatLog sMsg, "EXCEPTION", nTime, sOurce)
		if out
			print out

	logExcept: @logException

	logError: (sMsg, nTime=os.time!, sSource="UNKNOWN SOURCE") =>
		out = stdlog\Add (@__formatLog sMsg, "ERROR", nTime, sSource)
		if out
			print out

	logErr: @logError

	logFatal: (sMsg, nTime=os.time!, sSource="UNKNOWN SOURCE") =>
		out = stdlog\Add (@__formatLog sMsg, "FATAL", nTime, sSource)
		if out
			print out

	logDie: (sMsg, nTime=os.time!, sSource="UNKNOWN SOURCE") =>
		pcall ->
			out = stdlog\Add (@__formatLog sMsg, "FATAL", nTime, sSource)
			-- make sure that 'out' is there to print it, otherwise pass it 
			-- silently and 
			assert not out, out

return LOG