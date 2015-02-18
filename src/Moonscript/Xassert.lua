local LOG
do
  local _obj_0 = require("stdlog")
  LOG = _obj_0.LOG
end
local type_and
do
  local _obj_0 = require("Type_ext")
  type_and = _obj_0.type_and
end
local M = { }
M.xassert = function(...)
  local t = {
    ...
  }
  local n = #t
  local _list_0
  do
    local _tbl_0 = { }
    for _index_0 = 1, #t do
      local i, item = t[_index_0]
      if i ~= n then
        local _key_0, _val_0 = item
        _tbl_0[_key_0] = _val_0
      end
    end
    _list_0 = _tbl_0
  end
  for _index_0 = 1, #_list_0 do
    local _, v = _list_0[_index_0]
    if not v then
      LOG:logError((type_and(t[-1], "string", "")), nil, "Xassert")
      _ = false
    end
  end
  return true
end
return M
