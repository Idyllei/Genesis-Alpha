-- Type_ext.moon

M = {}

--- @param val Tuple; Value to check type of and possibly return.
-- @param t String; Name of value to test for.
-- @param fallback Tuple; Fallback value to return if test is false.
-- @return val if val is of type t, otherwise fallback.
M.type_and = (val, t, fallback) ->
	((type val) == t) and val or fallback

--- @param f Function; function to give output to test given val.
-- @param val Tuple; Value to check type of and possibly return.
-- @parm t String; Name of value to test for.
-- @param fallback Tuple; Fallback value to return if test is false.
-- @return val if test is true, otherwise fallback.
M.type_and_f = (f, val, t, fallback) ->
	((f val) == t) and val or fallback

return M