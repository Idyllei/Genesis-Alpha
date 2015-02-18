-- Xassert.moon

import LOG from require "stdlog"
import type_and from require "Type_ext"

M ={}

-- @param ... List; 1 through n-1 arguments are values to check truthiness of. n is message to error.
-- @return Tuple; Inputs if test passes or false otherwise.
M.xassert = (...) ->
	t = {...}
	n = #t
	for _,v in *{item for i,item in *t when i ~= n}
		if not v
			LOG\logError (type_and t[-1], "string", ""), nil, "Xassert"
			false
	true

return M