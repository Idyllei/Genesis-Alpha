-- stdlog.moon

class LOG
	-- Ex: @format "WARN", "errors happened", "main.lua"
	-- OUT: [WARN] [main.lua] errors happened
	format: (type_, msg, source) =>
	unless type type_ == "string"
		warn @format "WARN", "Attempt to call `LOG.format' with non-string argument 1: `type_'", "LOG"
	return "[#{type_}] [#{source}] #{msg}"

	warn: (msg, source) => warn @format "WARN", msg, source

	error: (msg, source, kill=false) => 
		-- store the output for efficiency
		out = @format "ERROR", msg, source
		print out unless kill
		error out if kill

	info: (msg, source, infoType="INFO") =>
		print "[INFO:#{infoType}] [#{source}] #{msg}"

	critical: (msg, source, kill=false, traceback) =>
		-- store the output for efficiency
		out = "#{@format 'CRITICAL', msg, source}\nTRACEBACK:\n#{traceback}"
		error out if kill
		warn out unless kill

return {:LOG}