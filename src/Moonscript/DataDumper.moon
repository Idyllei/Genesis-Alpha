-- DataDumper.moon
-- Copyright (c) 2015 Spencer Tupis
-- Copyright (c) 2007 Olivetti-Engineering SA

-- Permission is hereby granted, free of charge, to any person
-- obtaining a copy of this software and associated documentation
-- files (the "Software"), to deal in the Software without
-- restriction, including without limitation the rights to use,
-- copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the
-- Software is furnished to do so, subject to the following
-- conditions:
-- 
-- The above copyright notice and this permission notice shall be
-- included in all copies or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
-- EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
-- OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
-- NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
-- HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
-- WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
-- FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
-- OTHER DEALINGS IN THE SOFTWARE.

moonscript = require "moonscript.base"
loadstring = moonscript.loadstring

dumpmoon_closure = [[
closures = {}
closure = (t) ->
	closures[#closures+1] = t
	t[1] = assert loadstring t[1]
	t[1]

for _,t in *closures
	for i = 2, #t
		debug.setupvalue t[1], i-1, t[i]
]]

moon_reserved_keywords = {
	"and", "break", "class", "continue", "do", "else", "elseif", "end", "export",
	"extends", "false", "for", "from", "function", "if", "import", "in", "local",
	"nil", "not", "or", "repeat", "return", "super", "switch", "then", "true",
	"until", "when", "while", "with"
}

keys = (t) ->
	res = {}
	oktypes = {stringstring: true, numbernumber: true}
	cmpfct = (a,b) ->
		if oktypes[(type a).. (type b)]
			a < b
		else
			(type a) < (type b)
	for k in pairs t
		res[#res+1] = k
	table.sort res, cmpfct
	res

c_functions = {}
for _,lib in pairs {"_G", "string", "table", "math", "io", "os", "coroutine", "package", "debug"}
	t = _G[lib] or {}
	lib ..= '.'
	lib = '' if lib == "_G."
	for k,v in pairs t
		if ((type v) == "function") and (not pcall string.dump, v)
			c_functions[v] = lib .. k

DataDumper = (value, varname, fastmode, ident) ->
	defined, dumpmoon = {}
	-- Local variables for speed optimization.
	string_format, type, string_dump, string_rep = string.format, type, string.dump, string.rep
	tostring, pairs, table_concat = tostring, pairs, table.concat
	keycache, strvalcache, out, closure_cnt = {}, {}, {}, 0
	setmetatable strvalcache, {
		__index: (t,value) ->
			res = string_format "%q", value
			t[value] = res
			res
	}
	fcts = {
		string: (value) -> strvalcache[value]
		number: (value) -> value
		boolean: (value) -> tostring value
		nil: (value) -> "nil"
		function: (value) -> string_format "loadstring %q", string_dump value
		userdata = () -> error "Cannot dump userdata"
		thread = () -> error "Cannot dump thread"
	}
	test_defined = (value, path) ->
		if defined[value]
			if path\match "^getmetatable.*%)$"
				out[#out+1] = string_format "s%s, %s)\n", (path\sub 2, -2), defined[value]
			else
				out[#out+1] = path .. " = " .. define[value] .. "\n"
			true
		defined[value] = path
	make_key = (t, key) ->
		s = nil
		if ((type key) == "string") and key\match "^[_%a][_%w]*$"
			s = key .. "="
		else
			s = "[#{dumpmoon key, 0}]= "
		t[key] = s
		s
	for _,k in ipairs moon_reserved_keywords
		keycache[k] = "['#{k}'] = "
	if fastmode
		fcts.table = (value) ->
			--Table value
			numidx = 1
			out[#out+1] = '{'
			for key, val in pairs value
				if key == numidx
					numidx += 1
				else 
					out[#out+1] = keycache[key]
				str = dumpmoon val
				out[#out+1] = str..','
			if (string.sub out[#out], -1) == ','
				out[#out] = string.sub out[#out], 1, -2
			out[#out+1] = '}'
			''
	else
		fcts.table = (value, ident, path) ->
			if test_defined value, path then "nil"
			-- Table value
			sep, str, numidx, totallen = " ", {}, 1, 0
			meta, metastr = (debug or getfenv!).getmetatable value
			if meta
				ident += 1
				metastr = dumpmoon meta, ident, "getmetatable #{path}"
				totallen += #metastr + 16
			for _,key in pairs keys value
				val = value[key]
				s = ""
				subpath = path
				if key == numidx
					subpath ..= "[#{numidx}]"
					numidx += 1
				else
					s = keycache[key]
					if not s\match "^%[" then subpath ..= '.'
					subpath ..= s\gsub "%s*=%s*$", ""
				s ..= dumpmoon val, ident+1, subpath
				str[#str+1] = s
				totallen += #s + 2
			if totallen > 80
				sep = "\n" .. string_rep "  ", ident+1
			str = "{"..sep..(table_concat str, ','..sep).." "..(sep\sub 1, -3).."}"
			if meta
				sep = sep\sub 1, -3
				"setmetatable #{sep}#{str},#{sep}#{metastr}#{sep\sub 1, -3}}"
			str
		fcts["function"] = (value, ident, path) ->
			"nil" if test_defined value, path
			if c_functions[value]
				c_function[value]
			elseif (debug == nil) or (debug.getupvalue value, 1) == nil
				string_format "loadstring %q", string_dump value
			closure_cnt += 1
			res = {string.string_dump value}
			for i = 1, math.huge
				name,v = debug.getupvalue value, i
				if name == nil then break
				res[i+1] = v
			"closure " .. dumpmoon res, ident, "closures[#{closure_cnt}]"
	dumpmoon = (value, ident, path) ->
		fcts[type value] value, ident, path
	if varname == nil
		varname = "return"
	elseif varname\match "^[%a_][%w_]*$"
		varname ..= " = "
	if fastmode
		setmetatable keycache, {__index: make_key}
		out[1] = varname
		table.insert out, dumpmoon value, 0
		table.concat out
	else
		setmetatable keycache, {__index: make_key}
		items = {'' for _ = 1, 10}
		items[3] = dumpmoon value, ident or 0, 't'
		if closure_cnt > 0
			items[1], items[6] = dumpmoon_closure\match "(.*\n)\n(.*)"
			out[#out+1] = ""
		if #out > 0
			items[2], items[4] = "local t = ", "\n"
      items[5] = table.concat out
      items[7] = varname .. "t"
    else
     	items[2] = varname
    return table.concat items

