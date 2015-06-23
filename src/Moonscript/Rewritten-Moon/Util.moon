-- Util.moon

__MODULES = {}

Require = (itemSeq) ->
  if is('Table', 'itemSeq')
    __MODULES\insert Require item for item in *itemSeq
  else
    __MODULES[itemSeq] = require itemSeq unless __MODULES[itemSeq]
  return __MODULES

{
  :__MODULES
}